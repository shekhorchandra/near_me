import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:near_me/App/routes/app_routes.dart';
import '../../../../services/utils/helpers/HttpStatusHandler.dart';
import '../../../../services/contants/api_constants.dart';
import '../../../../services/utils/helpers/app_snackbar.dart';

class UserSignupController extends GetxController {
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;

  // Text Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final hasMinLength = false.obs;
  final hasUppercase = false.obs;
  final hasLowercase = false.obs;
  final hasNumber = false.obs;
  final hasSpecialChar = false.obs;
  final isPasswordValid = false.obs;

  var isLoading = false.obs;

  final logger = Logger();

  @override
  void onInit() {
    super.onInit();

    passwordController.addListener(() {
      validatePassword(passwordController.text);
    });
  }

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleConfirmPassword() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  /// user register api call
  Future<void> registerUser() async {
    if (!isPasswordValid.value) {
      AppSnackbar.error("Please enter a strong password.");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      AppSnackbar.error("Passwords do not match.");
      return;
    }
    try {
      isLoading.value = true;

      final email = emailController.text.trim(); // ✅ store once

      final response = await http.post(
        Uri.parse(ApiConstants.user_register),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": nameController.text.trim(),
          "email": email,
          "password": passwordController.text.trim(),
          "role": "USER",
        }),
      );

      final data = jsonDecode(response.body);

      final message = HttpStatusHandler.getMessage(
        statusCode: response.statusCode,
        apiMessage: data["message"],
      );


      // PRETTY JSON RESPONSE
      final prettyJson = const JsonEncoder.withIndent(
        '    ',
      ).convert(data);

      // LOGGER PRINT
      logger.i(prettyJson);
      if (response.statusCode == 201 && data["success"] == true) {
        AppSnackbar.success(message);

        // ✅ PASS EMAIL HERE
        Get.toNamed(AppRoutes.USER_VERIFY_ACCOUNT, arguments: email);
      } else {
        AppSnackbar.error(message);
      }
    } catch (e) {
      AppSnackbar.error("Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  void validatePassword(String password) {
    hasMinLength.value = password.length >= 8;
    hasUppercase.value = RegExp(r'[A-Z]').hasMatch(password);
    hasLowercase.value = RegExp(r'[a-z]').hasMatch(password);
    hasNumber.value = RegExp(r'[0-9]').hasMatch(password);
    hasSpecialChar.value =
        RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=~`/\\[\]]').hasMatch(password);

    isPasswordValid.value =
        hasMinLength.value &&
            hasUppercase.value &&
            hasLowercase.value &&
            hasNumber.value &&
            hasSpecialChar.value;
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
