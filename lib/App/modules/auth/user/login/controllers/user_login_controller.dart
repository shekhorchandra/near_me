import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../data/services/storage_service.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/contants/api_constants.dart';
import '../../../../services/utils/helpers/app_snackbar.dart';

class UserLoginController extends GetxController {
  final obscurePassword = true.obs;

  final obscureConfirmPassword = true.obs;
  RxBool loading = false.obs;

  final StorageService _storageService = StorageService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;

  final authService = AuthService();
  final box = GetStorage();

  void initControllers() {
    if (kDebugMode) {
      emailController.text = "shekhorchandrasaha@gmail.com";
      passwordController.text = "Tonoy@#123";
    }
  }

  @override
  void onInit() {
    super.onInit();
    initControllers();
  }

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  void _handleException(dynamic e, StackTrace stackTrace) {
    debugPrint("Login Error: $e");
    debugPrint("StackTrace: $stackTrace");
    Get.snackbar("Error", "Something went wrong. Please try again.");
  }

  Future<void> loginWithGoogleUserDeepLink() async {
    loading.value = true;

    final AppLinks appLinks = AppLinks();
    StreamSubscription<Uri>? sub;

    try {
      // Step 1: Listen for deep link callback
      sub = appLinks.uriLinkStream.listen((Uri uri) async {
        if (uri.scheme == "Nearme" && uri.path == "/auth/google") {
          final accessToken = uri.queryParameters['access'];
          final refreshToken = uri.queryParameters['refresh'];
          final role = uri.queryParameters['role'];

          if (accessToken != null && refreshToken != null) {
            if (role != "USER") {
              AppSnackbar.error("Not a user account");
              return;
            }
            _storageService.setAccessToken(accessToken);
            _storageService.setRefreshToken(refreshToken);

            // _storeUserId();

            // Register FCM and Device
            //
            // bool fcmRegistered = await _registerFCM();
            //

            // if (!fcmRegistered) {
            //
            //   Get.snackbar('Error', 'An error occurred while initializing notifications!');
            //   return;
            // }

            //
            // bool deviceRegistered = await _registerDevice(data);
            //

            // if (!deviceRegistered) {
            //
            //   Get.snackbar('Error', 'An error occurred while registering the device.');
            //   return;
            // }

            _storageService.write('loggedIn', true);

            Get.offAllNamed(AppRoutes.USER_BOTTOM_NAV);

            // isVerifiedOrIsShopCreated();

            Get.snackbar("Login Successful", "");
          } else {
            Get.snackbar("Error", "Failed to get token from Google login");
          }

          await sub?.cancel();
        }
      });

      // Step 2: Open browser with your API
      final url = Uri.parse('${ApiConstants.baseUrl}/auth/google?role=USER');

      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        Get.snackbar("Error", "Could not launch login URL");
        return;
      }
    } catch (e, st) {
      _handleException(e, st);
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

      print("FULL LOGIN RESPONSE:------------------------------------------ $result");

      final data = result["data"];
      final message = data["message"];
      final role = data["data"]?["user"]?["role"];

      if (result["statusCode"] == 200 && data["success"]) {
        // 🔥 Role validation
        if (role == "USER") {
          AppSnackbar.success(message);
          Get.offAllNamed(AppRoutes.USER_BOTTOM_NAV);
        } else {
          AppSnackbar.error("Please login from correct panel");
        }
      } else {
        AppSnackbar.error(message);
      }
    } catch (e) {
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
