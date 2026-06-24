import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../data/services/GoogleAuthService.dart';
import '../../../../../data/services/auth_api_service.dart';
import '../../../../../data/services/socket_service.dart';
import '../../../../../data/services/storage_service.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/contants/api_constants.dart';
import '../../../../services/utils/helpers/app_snackbar.dart';

class UserLoginController extends GetxController {
  final obscurePassword = true.obs;

  final AuthApiService _authApiService = Get.find<AuthApiService>();

  final obscureConfirmPassword = true.obs;
  RxBool loading = false.obs;

  final StorageService _storageService = StorageService();

  // final emailController = TextEditingController();
  // final passwordController = TextEditingController();

  final emailController = TextEditingController(text: "mdmontasirrahmans7@gmail.com");
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

  void _handleException(dynamic e, StackTrace stackTrace) {
    debugPrint("Login Error: $e");
    debugPrint("StackTrace: $stackTrace");
    Get.snackbar("Error", "Something went wrong. Please try again.");
  }

  Future<void> loginWithGoogleUser() async {
    loading.value = true;

    try {
      final String? idToken =
      await GoogleAuthService.instance.signInWithGoogle();

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

      print("=========== GOOGLE LOGIN RESPONSE ===========");
      print(response.data);
      print("============================================");

      final responseData = response.data;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = responseData["data"];

        final accessToken = data?["accessToken"];
        final refreshToken = data?["refreshToken"];

        if (accessToken == null || refreshToken == null) {
          AppSnackbar.error("Token not found from server response");
          return;
        }

        await _storageService.setAccessToken(accessToken);
        await _storageService.setRefreshToken(refreshToken);
        await _storageService.write('loggedIn', true);

        Get.offAllNamed(AppRoutes.USER_BOTTOM_NAV);

        Get.snackbar("Login Successful", "");
      } else {
        final message =
            responseData?["message"] ??
                responseData?["error"] ??
                "Google login failed";

        AppSnackbar.error(message.toString());
      }
    } catch (e, st) {
      print("GOOGLE LOGIN ERROR = $e");
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
      final prettyJson = const JsonEncoder.withIndent(
        '    ',
      ).convert(data);

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
  @override
  void onClose() {
    emailController.clear();
    passwordController.clear();
    super.onClose();
  }
}
