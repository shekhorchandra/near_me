import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../../../../routes/app_routes.dart';
import '../../../../services/contants/api_constants.dart';
import '../../../../services/utils/helpers/HttpStatusHandler.dart';
import '../../../../services/utils/helpers/app_snackbar.dart';

class UserLoginController extends GetxController {
  final obscurePassword = true.obs;

  // final emailController = TextEditingController(text: "shekhor@gmail.com");
  // final passwordController = TextEditingController(text: "Shekhor@#123");
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;

  final box = GetStorage(); // local storage

  void initControllers() {
    // debugPrint("kDebugMode: $kDebugMode");
    if (kDebugMode) {
      emailController.text = "shekhor@gmail.com";
      passwordController.text = "Shekhor@#123";
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initControllers();
  }

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> loginUser() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      AppSnackbar.error("Email & Password required");
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(ApiConstants.user_login),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      final data = jsonDecode(response.body);

      final message = HttpStatusHandler.getMessage(
        statusCode: response.statusCode,
        apiMessage: data["message"],
      );

      if (response.statusCode == 200 && data["success"] == true) {
        // 🔥 Save Tokens
        final accessToken = data["data"]["accessToken"];
        final refreshToken = data["data"]["refreshToken"];

        await box.write("accessToken", accessToken);
        await box.write("refreshToken", refreshToken);

        // Optional: save user info
        await box.write("user", data["data"]["user"]);

        AppSnackbar.success(message);

        // Navigate
        Get.offAllNamed(AppRoutes.USER_BOTTOM_NAV);
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
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
