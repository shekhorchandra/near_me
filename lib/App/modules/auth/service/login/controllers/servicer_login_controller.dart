import 'dart:async';
import 'dart:convert';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../../../data/services/storage_service.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../services/auth_service.dart';
import '../../../../services/contants/api_constants.dart';
import '../../../../services/utils/helpers/app_snackbar.dart';

class ServicerLoginController extends GetxController {
  final obscurePassword = true.obs;

  final obscureConfirmPassword = true.obs;
  RxBool loading = false.obs;

  final StorageService _storageService = StorageService();

  final emailController = TextEditingController(text: "shekhorsaha058@gmail.com");
  final passwordController = TextEditingController(text: "Tonoy@#123");

  final isLoading = false.obs;

  late final selectedRole;

  final authService = AuthService();

  @override
  void onInit() {
    super.onInit();
    selectedRole = StorageService().read("selectedRole");
  }

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  void _handleException(dynamic e, StackTrace stackTrace) {
    debugPrint("Login Error: $e");
    debugPrint("StackTrace: $stackTrace");
    Get.snackbar("Error", "Something went wrong. Please try again.");
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

      print("FULL LOGIN RESPONSE:------------------------------------------ $result");

      final responseData = result["data"];

      if (result["statusCode"] == 200 && responseData["success"]) {
        final data = responseData["data"];

        // ✅ SAFE TOKEN EXTRACTION
        final accessToken = data?["accessToken"] ?? data?["token"]?["accessToken"];

        final refreshToken = data?["refreshToken"] ?? data?["token"]?["refreshToken"];

        final role = data?["user"]?["role"];

        final isVerified = data?["user"]?["isVerified"] ?? false;
        final hasService = data?["user"]?["hasService"] ?? false;

        if (accessToken == null) {
          AppSnackbar.error("Token not found");
          return;
        }

        // 🔥 CLEAR OLD TOKEN FIRST
        await _storageService.clear();

        // 🔥 SAVE NEW TOKEN
        await _storageService.setAccessToken(accessToken);
        await _storageService.setRefreshToken(refreshToken ?? "");

        print("✅ SAVED TOKEN: $accessToken");
        print("✅ STORED TOKEN: ${StorageService().accessToken}");

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

  /// using url
  Future<void> loginWithGoogleProviderDeepLink() async {
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
            if (role != "PROVIDER") {
              AppSnackbar.error("Not a provider account");
              return;
            }
            await _storageService.setAccessToken(accessToken);
            await _storageService.setRefreshToken(refreshToken);

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
            Get.offAllNamed(AppRoutes.SERVICER_BOTTOM_NAV);

            // isVerifiedOrIsShopCreated();

            Get.snackbar("Login Successful", "");
          } else {
            Get.snackbar("Error", "Failed to get token from Google login");
          }

          await sub?.cancel();
        }
      });

      // Step 2: Open browser with your API
      final url = Uri.parse('${ApiConstants.baseUrl}/auth/google?role=PROVIDER');

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

  /// In app

  // Future<void> loginWithGoogle({required String role}) async {
  //   try {
  //     isLoading.value = true;
  //
  //     final GoogleSignIn googleSignIn = GoogleSignIn();
  //
  //     final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  //
  //     if (googleUser == null) {
  //       AppSnackbar.error("Login cancelled");
  //       return;
  //     }
  //
  //     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  //
  //     final idToken = googleAuth.idToken;
  //
  //     // 🔥 Send token to backend
  //     final response = await http.post(
  //       // Uri.parse(ApiConstants.google_login),
  //       Uri.parse('${ApiConstants.baseUrl}/auth/google?role=PROVIDER'),
  //
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({
  //         "idToken": idToken,
  //         "role": role, // 🔥 IMPORTANT
  //       }),
  //     );
  //
  //     final data = jsonDecode(response.body);
  //
  //     if (response.statusCode == 200 && data["success"]) {
  //       final accessToken = data["data"]["accessToken"];
  //       final refreshToken = data["data"]["refreshToken"];
  //       final userRole = data["data"]["user"]["role"];
  //
  //       await box.write("accessToken", accessToken);
  //       await box.write("refreshToken", refreshToken);
  //       await box.write("role", userRole);
  //
  //       // 🔥 ROLE BASE NAVIGATION
  //       if (userRole == "USER") {
  //         Get.offAllNamed(AppRoutes.USER_BOTTOM_NAV);
  //       } else if (userRole == "PROVIDER") {
  //         Get.offAllNamed(AppRoutes.SERVICER_BOTTOM_NAV);
  //       } else {
  //         AppSnackbar.error("Unknown role");
  //       }
  //     } else {
  //       AppSnackbar.error(data["message"]);
  //     }
  //   } catch (e) {
  //     AppSnackbar.error("Google login failed");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
