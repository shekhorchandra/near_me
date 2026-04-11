import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../routes/app_routes.dart';
import '../../user_forget_auth_service/ForgetPasswordAuthService.dart';

class UserOtpController extends GetxController {
  final isLoading = false.obs;

  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  final List<String> otpValues = List.generate(6, (_) => '');

  void onOtpChanged(String value, int index) {
    otpValues[index] = value;

    // move next
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    }

    // move back if empty
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  void verifyOtp() async {
    final otp = otpValues.join();

    // ✅ FIXED: 6 digit check
    if (otp.length != 6) {
      Get.snackbar("Error", "Enter complete 6-digit OTP");
      return;
    }

    isLoading.value = true;

    try {
      final email = Get.arguments as String;

      final token = await OtpAuthService.verifyOtp(
        email: email,
        otp: otp,
      );

      Get.snackbar("Success", "OTP Verified");

      Get.toNamed(
        AppRoutes.USER_RESET_PASSWORD,
        arguments: token,
      );
    } catch (e) {
      Get.snackbar("Error", e.toString().replaceAll("Exception: ", ""));
    } finally {
      isLoading.value = false;
    }
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
