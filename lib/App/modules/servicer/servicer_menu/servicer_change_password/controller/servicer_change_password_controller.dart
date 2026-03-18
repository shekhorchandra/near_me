import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServicerChangePasswordController extends GetxController {
  // Text controllers
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observables for password visibility
  RxBool obscureCurrentPassword = true.obs;
  RxBool obscureNewPassword = true.obs;
  RxBool obscureConfirmPassword = true.obs;

  // Loading state
  RxBool isLoading = false.obs;

  // Toggle visibility
  void toggleCurrentPassword() => obscureCurrentPassword.value = !obscureCurrentPassword.value;
  void toggleNewPassword() => obscureNewPassword.value = !obscureNewPassword.value;
  void toggleConfirmPassword() => obscureConfirmPassword.value = !obscureConfirmPassword.value;

  // Change password logic
  void changePassword() {
    if (currentPasswordController.text.isEmpty ||
        newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "New passwords do not match");
      return;
    }

    isLoading.value = true;

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.snackbar("Success", "Password changed successfully");
      currentPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();
    });
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}