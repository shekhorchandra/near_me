import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/routes/app_routes.dart';

import '../../../../../core/enums/user_role.dart';
import '../../../../services/auth_service.dart';
import '../../user_forget_auth_service/ForgetPasswordAuthService.dart';

class UserForgotPasswordController extends GetxController {
  final UserRole role;

  UserForgotPasswordController({this.role = UserRole.user}); // default user

  final emailController = TextEditingController();
  final isLoading = false.obs;


  void sendResetLink() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar("Error", "Enter a valid email");
      return;
    }

    isLoading.value = true;

    try {
      await ForgetAuthService.forgetPassword(email);

      Get.snackbar("Success", "OTP sent to your email");

      Get.toNamed(
        AppRoutes.USER_OTP_VERIFICATION,
        arguments: email,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString().replaceAll("Exception: ", ""));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}