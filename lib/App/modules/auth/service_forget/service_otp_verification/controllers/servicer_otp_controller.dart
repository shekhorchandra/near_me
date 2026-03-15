import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../routes/app_routes.dart';

class ServicerOtpController extends GetxController {
  final isLoading = false.obs;

  final List<FocusNode> focusNodes =
  List.generate(4, (_) => FocusNode());

  final List<String> otpValues = List.generate(4, (_) => '');

  void onOtpChanged(String value, int index) {
    otpValues[index] = value;

    if (value.isNotEmpty && index < 3) {
      focusNodes[index + 1].requestFocus();
    }
  }

  void verifyOtp() async {
    final otp = otpValues.join();

    if (otp.length < 4) {
      Get.snackbar("Error", "Enter complete OTP");
      return;
    }

    isLoading.value = true;

    await Future.delayed(const Duration(seconds: 1));

    isLoading.value = false;

    Get.snackbar("Success", "OTP Verified");

    // Navigate to Reset Password page
    Get.toNamed(AppRoutes.SERVICER_RESET_PASSWORD);
  }

  void resendOtp() {
    Get.snackbar("Resent", "OTP sent again");
  }

  @override
  void onClose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}