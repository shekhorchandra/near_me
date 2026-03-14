import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/routes/app_routes.dart';

enum UserRole { user, service }

class UserForgotPasswordController extends GetxController {
  final UserRole role;

  UserForgotPasswordController({this.role = UserRole.user}); // default user

  final emailController = TextEditingController();
  final isLoading = false.obs;

  void sendResetLink() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return;
    }

    isLoading.value = true;

    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
      Get.snackbar("Success", "OTP sent to your email");
      // Navigate to OTP verify page
      Get.toNamed(AppRoutes.OTP_VERIFICATION);
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}