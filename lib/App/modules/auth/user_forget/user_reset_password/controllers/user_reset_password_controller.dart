import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../routes/app_routes.dart';
import '../../user_forget_auth_service/ForgetPasswordAuthService.dart';

class UserResetPasswordController extends GetxController {

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isLoading = false.obs;

  // Obscure toggle observables
  var obscureNewPassword = true.obs;
  var obscureConfirmPassword = true.obs;

  void toggleNewPassword() {
    obscureNewPassword.value = !obscureNewPassword.value;
  }

  void toggleConfirmPassword() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  void resetPassword() async {
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters");
      return;
    }

    isLoading.value = true;

    try {
      // 🔥 GET TOKEN FROM OTP SCREEN
      final token = Get.arguments as String;

      await ResetPasswordService.resetPassword(
        token: token,
        newPassword: newPassword,
      );

      Get.snackbar("Success", "Password reset successfully");

      // Go to login
      Get.offAllNamed(AppRoutes.USER_LOGIN);
    } catch (e) {
      Get.snackbar("Error", e.toString().replaceAll("Exception: ", ""));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}