import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../routes/app_routes.dart';

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

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;

    Get.snackbar("Success", "Password reset successfully");

    // Go to User Login (STATIC)
    Get.offAllNamed(AppRoutes.USER_LOGIN);
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}