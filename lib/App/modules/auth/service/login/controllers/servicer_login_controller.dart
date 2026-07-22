import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../data/network/dio_client.dart';
import '../../../../../data/services/GoogleAuthService.dart';
import '../../../../../data/services/auth_api_service.dart';
import '../../../../../data/services/socket_service.dart';
import '../../../../../data/services/storage_service.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/contants/api_constants.dart';
import '../../../../services/utils/helpers/app_snackbar.dart';

class ServicerLoginController extends GetxController {
  final obscurePassword = true.obs;

  final obscureConfirmPassword = true.obs;
  RxBool loading = false.obs;
  final AuthApiService _authApiService = Get.find<AuthApiService>();
  final StorageService _storageService = StorageService();

  final emailController = TextEditingController(
    text: "shekhorchandrasaha@gmail.com",
  );
  final passwordController = TextEditingController(text: "Test@#123");

  // final emailController = TextEditingController();
  // final passwordController = TextEditingController();

  final isLoading = false.obs;

  late final selectedRole;

  final authService = AuthService();

  final logger = Logger();

  @override
  void onInit() {
    super.onInit();
    selectedRole = StorageService().read("selectedRole");
  }

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> loginProvider() async {
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

      const encoder = JsonEncoder.withIndent('  ');
      print(encoder.convert(result));

      final responseData = result["data"];

      // PRETTY JSON RESPONSE
      final prettyJson = const JsonEncoder.withIndent(
        '    ',
      ).convert(responseData);

      // LOGGER PRINT
      logger.i(prettyJson);

      if (result["statusCode"] == 200 && responseData["success"]) {
        final data = responseData["data"];

        // ✅ SAFE TOKEN EXTRACTION
        final accessToken =
            data?["accessToken"] ?? data?["token"]?["accessToken"];

        final refreshToken =
            data?["refreshToken"] ?? data?["token"]?["refreshToken"];

        final role = data?["user"]?["role"];
        // final serviceId = data?["user"]?["service"];

        final isVerified = data?["user"]?["isVerified"] ?? false;
        final hasService = data?["user"]?["hasService"] ?? false;

        if (accessToken == null) {
          AppSnackbar.error("Token not found");
          return;
        }

        // Clear previous session
        await _storageService.clear();

        // Save tokens
        await _storageService.setAccessToken(accessToken);
        await _storageService.setRefreshToken(refreshToken ?? "");
        await _storageService.setUserId(data?["user"]?["_id"] ?? "");

        // Verify storage
        print("========== TOKEN CHECK ==========");
        print("Access Token = ${_storageService.accessToken}");
        print("Refresh Token = ${_storageService.refreshToken}");

        // Wait briefly
        await Future.delayed(const Duration(milliseconds: 200));

        // Get Firebase token
        final fcmToken = await FirebaseMessaging.instance.getToken();

        print("========== FCM TOKEN ==========");
        print(fcmToken);

        // Update backend only if token exists
        if (fcmToken != null && fcmToken.isNotEmpty) {
          print("Calling updateFcmToken()");
          print("Current Access Token: ${_storageService.accessToken}");

          await updateFcmToken(fcmToken);
        }

        // if (!Get.isRegistered<SocketService>()) {
        //   await Get.putAsync(
        //         () => SocketService().connect(serviceId),
        //     permanent: true,
        //   );
        // }

        final userId = data?["user"]?["_id"];
        final serviceId = data?["user"]?["service"];

        await _storageService.setUserId(userId ?? "");
        await _storageService.setServiceId(serviceId ?? "");

        if (Get.isRegistered<SocketService>()) {
          await Get.delete<SocketService>();
        }

        await Get.putAsync(
          () => SocketService().connect(userId ?? ""),
          permanent: true,
        );

        print("✅ SAVED TOKEN: $accessToken");
        print("✅ STORED TOKEN: ${_storageService.accessToken}");

        // ✅ ROLE CHECK
        if (selectedRole == "PROVIDER" && role != "PROVIDER") {
          AppSnackbar.error("Wrong panel login");
          return;
        }

        if (role == "PROVIDER") {
          AppSnackbar.success(responseData["message"]);

          if (isVerified == true) {
            if (hasService == true) {
              // ✅ Verified + has service → Dashboard
              Get.offAllNamed(AppRoutes.SERVICER_BOTTOM_NAV);
            } else {
              // ❗ Verified but no service → Choose plan
              Get.offAllNamed(
                AppRoutes.SERVICE_CHOOSE_PLAN,
                arguments: {"email": emailController.text.trim()},
              );
            }
          } else {
            // ❗ Not verified → Choose plan (or verify page)
            Get.offAllNamed(
              AppRoutes.SERVICER_VERIFY_ACCOUNT,
              arguments: {"email": emailController.text.trim()},
            );
          }
        } else {
          AppSnackbar.error("Not a provider account");
        }
      } else {
        AppSnackbar.error(responseData["message"] ?? "Login failed");
      }
    } catch (e) {
      print("LOGIN ERROR: $e");
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

  /// In app
  Future<void> loginWithGoogleProvider() async {
    isLoading.value = true;

    try {
      final String? idToken = await GoogleAuthService.instance
          .signInWithGoogle();

      if (idToken == null || idToken.isEmpty) {
        AppSnackbar.error("Google login cancelled or failed");
        return;
      }

      final response = await _authApiService.googleAuthentication(
        idToken: idToken,
        role: "provider",
      );

      if (response == null) {
        AppSnackbar.error("No response from server");
        return;
      }

      print("=========== PROVIDER GOOGLE LOGIN RESPONSE ===========");
      print(response.data);
      print("=====================================================");

      final responseData = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
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
        final userRole = user?["role"]?.toString();

        final isVerified = user?["isVerified"] ?? false;
        final hasService = user?["hasService"] ?? false;
        final serviceId = user?["service"]?.toString();

        if (accessToken == null || accessToken.toString().isEmpty) {
          AppSnackbar.error("Access token not found");
          return;
        }

        if (userRole != "PROVIDER") {
          AppSnackbar.error("Not a provider account");
          return;
        }

        await _storageService.clear();

        await _storageService.setAccessToken(accessToken.toString());
        await _storageService.setRefreshToken(refreshToken?.toString() ?? "");
        await _storageService.setUserId(userId ?? "");
        await _storageService.setServiceId(serviceId ?? "");
        await _storageService.write("loggedIn", true);

        await Future.delayed(const Duration(milliseconds: 300));

        final fcmToken = await FirebaseMessaging.instance.getToken();

        print("FCM TOKEN => $fcmToken");

        if (fcmToken != null && fcmToken.isNotEmpty) {
          await updateFcmToken(fcmToken);
        }

        if (userId != null && userId.isNotEmpty) {
          if (Get.isRegistered<SocketService>()) {
            await Get.delete<SocketService>();
          }

          await Get.putAsync(
            () => SocketService().connect(userId),
            permanent: true,
          );
        }

        AppSnackbar.success(responseData["message"] ?? "Login successful");

        if (isVerified == true) {
          if (hasService == true) {
            Get.offAllNamed(AppRoutes.SERVICER_BOTTOM_NAV);
          } else {
            Get.offAllNamed(
              AppRoutes.SERVICE_CHOOSE_PLAN,
              arguments: {
                "email": user?["email"] ?? emailController.text.trim(),
              },
            );
          }
        } else {
          Get.offAllNamed(
            AppRoutes.SERVICER_VERIFY_ACCOUNT,
            arguments: {"email": user?["email"] ?? emailController.text.trim()},
          );
        }
      } else {
        final message =
            responseData?["message"] ??
            responseData?["error"] ??
            "Google login failed";

        AppSnackbar.error(message.toString());
      }
    } catch (e, st) {
      print("PROVIDER GOOGLE LOGIN ERROR = $e");
      print(st);

      AppSnackbar.error("Something went wrong during Google login");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
