import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import '../../../../../data/network/dio_client.dart';
import '../../../../../data/services/GoogleAuthService.dart';
import '../../../../../data/services/auth_api_service.dart';
import '../../../../../data/services/socket_service.dart';
import '../../../../../data/services/storage_service.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/contants/api_constants.dart';
import '../../../../services/utils/helpers/app_snackbar.dart';
import '../../../../user/home/controller/home_controller.dart';

class UserLoginController extends GetxController {
  final obscurePassword = true.obs;

  final AuthApiService _authApiService = Get.find<AuthApiService>();

  final obscureConfirmPassword = true.obs;
  RxBool loading = false.obs;

  final StorageService _storageService = StorageService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // final emailController = TextEditingController(
  //   text: "shekhorsaha058@gmail.com",
  // );
  // final passwordController = TextEditingController(text: "Test1234@");

  final isLoading = false.obs;

  final authService = AuthService();
  final box = GetStorage();

  final logger = Logger();

  // void initControllers() {
  //   if (kDebugMode) {
  //     emailController.text = "mdmontasirrahmans7@gmail.com";
  //     passwordController.text = "Test1234@";
  //   }
  // }

  @override
  void onInit() {
    super.onInit();
    // initControllers();
  }

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> loginWithGoogleUser() async {
    loading.value = true;

    try {
      final String? idToken = await GoogleAuthService.instance
          .signInWithGoogle();

      if (idToken == null || idToken.isEmpty) {
        AppSnackbar.error("Google login cancelled or failed");
        return;
      }

      final response = await _authApiService.googleAuthentication(
        idToken: idToken,
        role: "user",
      );

      if (response == null) {
        AppSnackbar.error("No response from server");
        return;
      }

      print("=========== GOOGLE USER RESPONSE ===========");
      print(response.data);
      print("============================================");

      final responseData = response.data;

      if (response.statusCode != 200 && response.statusCode != 201) {
        AppSnackbar.error(responseData["message"] ?? "Google login failed");

        return;
      }

      if (responseData["success"] != true) {
        AppSnackbar.error(responseData["message"] ?? "Google login failed");

        return;
      }

      final data = responseData["data"];

      final accessToken =
          data?["accessToken"] ?? data?["token"]?["accessToken"];

      final refreshToken =
          data?["refreshToken"] ?? data?["token"]?["refreshToken"];

      final user = data?["user"];

      final userId = user?["_id"]?.toString();

      final role = user?["role"]?.toString();

      if (accessToken == null || accessToken.toString().isEmpty) {
        AppSnackbar.error("Access token not found");

        return;
      }

      if (role != "USER") {
        AppSnackbar.error("Please login from user panel");

        return;
      }

      // ==============================
      // CLEAR OLD SESSION
      // ==============================

      await _storageService.clear();

      // ==============================
      // SAVE AUTH DATA
      // ==============================

      await _storageService.setAccessToken(accessToken.toString());

      await _storageService.setRefreshToken(refreshToken?.toString() ?? "");

      await _storageService.setUserId(userId ?? "");

      await _storageService.write("loggedIn", true);

      print("ACCESS TOKEN => ${_storageService.accessToken}");

      print("USER ID => ${_storageService.userId}");

      // ==============================
      // UPDATE FCM TOKEN
      // ==============================

      await Future.delayed(const Duration(milliseconds: 300));

      final fcmToken = await FirebaseMessaging.instance.getToken();

      print("FCM TOKEN => $fcmToken");

      if (fcmToken != null && fcmToken.isNotEmpty) {
        await updateFcmToken(fcmToken);
      }

      // ==============================
      // CONNECT SOCKET
      // ==============================

      if (userId != null && userId.isNotEmpty) {
        if (Get.isRegistered<SocketService>()) {
          await Get.delete<SocketService>();
        }

        await Get.putAsync(
          () => SocketService().connect(userId),
          permanent: true,
        );
      }

      // ==============================
      // UPDATE HOME STATE
      // ==============================

      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().checkLoginStatus();
      }

      AppSnackbar.success(responseData["message"] ?? "Login Successful");

      Get.offAllNamed(AppRoutes.USER_BOTTOM_NAV);
    } catch (e, st) {
      print("GOOGLE USER LOGIN ERROR => $e");

      print(st);

      AppSnackbar.error("Something went wrong during Google login");
    } finally {
      loading.value = false;
    }
  }

  Future<void> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      AppSnackbar.error("Email & Password required");
      return;
    }

    try {
      isLoading.value = true;

      final result = await authService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final data = result["data"];

      // PRETTY JSON RESPONSE
      final prettyJson = const JsonEncoder.withIndent('    ').convert(data);

      // LOGGER PRINT
      logger.i(prettyJson);

      final message = data["message"];
      final loginData = data["data"];

      final role = loginData?["user"]?["role"];
      final accessToken = loginData?["accessToken"];
      final refreshToken = loginData?["refreshToken"];
      final userId = loginData?["user"]?["_id"];

      if (result["statusCode"] == 200 && data["success"]) {
        if (role == "USER") {
          final storage = Get.find<StorageService>();

          // await storage.setAccessToken(accessToken);
          // await storage.setRefreshToken(refreshToken);
          // await storage.setUserId(userId);
          //
          // AppSnackbar.success(message);
          //
          // Get.offAllNamed(AppRoutes.USER_BOTTOM_NAV);

          await storage.setAccessToken(accessToken);
          await storage.setRefreshToken(refreshToken);
          await storage.setUserId(userId);

          // Wait a little so Dio reads the latest token
          await Future.delayed(const Duration(milliseconds: 200));

          final fcmToken = await FirebaseMessaging.instance.getToken();

          print("========== FCM TOKEN ==========");
          print(fcmToken);

          if (fcmToken != null && fcmToken.isNotEmpty) {
            await updateFcmToken(fcmToken);
          }

          /// Update HomeController login state
          if (Get.isRegistered<HomeController>()) {
            Get.find<HomeController>().checkLoginStatus();
          }

          /// CONNECT SOCKET
          if (Get.isRegistered<SocketService>()) {
            await Get.delete<SocketService>();
          }

          await Get.putAsync(
            () => SocketService().connect(userId),
            permanent: true,
          );

          AppSnackbar.success(message);

          Get.offAllNamed(AppRoutes.USER_BOTTOM_NAV);
        } else {
          AppSnackbar.error("Please login from correct panel");
        }
      } else {
        AppSnackbar.error(message);
      }
    } catch (e) {
      print("ERROR: $e");

      AppSnackbar.error("Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateFcmToken(String token) async {
    try {
      print("========== UPDATE FCM ==========");
      print("Access Token => ${StorageService().accessToken}");
      print("FCM Token => $token");

      final dioClient = Get.find<DioClient>();

      final response = await dioClient.client.patch(
        ApiConstants.update_fcm,
        data: {"fcmToken": token},
      );

      print("========== UPDATE SUCCESS ==========");
      print(response.data);
    } catch (e) {
      print("========== UPDATE ERROR ==========");
      print(e);
    }
  }

  @override
  void onClose() {
    emailController.clear();
    passwordController.clear();
    super.onClose();
  }
}
