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

  // final emailController = TextEditingController();
  // final passwordController = TextEditingController();

  final emailController = TextEditingController(
    text: "mdmontasirrahmans7@gmail.com",
  );
  final passwordController = TextEditingController(text: "Test1234@");

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

      final idToken =
      await GoogleAuthService.instance.signInWithGoogle();

      if (idToken == null || idToken.isEmpty) {
        AppSnackbar.error("Google login failed");
        return;
      }


      final response =
      await _authApiService.googleAuthentication(
        idToken: idToken,
        role: "user",
      );


      print("GOOGLE STATUS ===== ${response?.statusCode}");
      print("GOOGLE BODY ===== ${response?.data}");


      if (response == null) {
        AppSnackbar.error("No response");
        return;
      }


      if (response.statusCode != 200 &&
          response.statusCode != 201) {

        AppSnackbar.error(
          response.data["message"] ??
              "Google login failed",
        );

        return;
      }


      final loginData = response.data["data"];


      final accessToken =
      loginData["accessToken"];

      final refreshToken =
      loginData["refreshToken"];

      final user =
      loginData["user"];


      if(accessToken == null ||
          refreshToken == null) {

        AppSnackbar.error(
          "Token missing",
        );

        return;
      }


      // SAVE FIRST
      await _storageService.setAccessToken(
        accessToken,
      );

      await _storageService.setRefreshToken(
        refreshToken,
      );


      if(user != null){
        await _storageService.setUserId(
          user["_id"],
        );
      }


      // VERIFY STORAGE
      print(
          "SAVED TOKEN ===== ${_storageService.accessToken}"
      );


      // UPDATE FCM AFTER TOKEN EXISTS
      final fcmToken =
      await FirebaseMessaging.instance.getToken();


      if(fcmToken != null &&
          fcmToken.isNotEmpty){

        await updateFcmToken(
          fcmToken,
        );
      }


      await Future.delayed(
        const Duration(milliseconds: 300),
      );


      await _storageService.setAccessToken(accessToken);
      await _storageService.setRefreshToken(refreshToken);

      print(
          "ACCESS TOKEN SAVED => ${_storageService.accessToken}"
      );

      await Future.delayed(
          const Duration(milliseconds: 300)
      );

      Get.offAllNamed(
          AppRoutes.USER_BOTTOM_NAV
      );


      AppSnackbar.success(
        "Login Successful",
      );


    } catch(e,st){

      print("GOOGLE LOGIN ERROR $e");
      print(st);

      AppSnackbar.error(
        "Something went wrong",
      );

    } finally {

      loading.value=false;

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
          if (!Get.isRegistered<SocketService>()) {
            await Get.putAsync(
              () => SocketService().connect(userId),
              permanent: true,
            );
          }

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

      final response = await DioClient().client.patch(
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
