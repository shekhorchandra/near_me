import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:near_me/App/routes/app_routes.dart';

class UserVerifyAccountController extends GetxController {
  // OTP digits
  final otp = List.generate(4, (_) => ''.obs);

  // Focus nodes for each OTP field
  late List<FocusNode> focusNodes;

  // User email (dynamic)
  late String email;

  // Loading state for verify button
  var isVerifying = false.obs;

  @override
  void onInit() {
    super.onInit();
    focusNodes = List.generate(4, (_) => FocusNode());
  }

  @override
  void onClose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }

  // Collect OTP as string
  String get otpCode => otp.map((e) => e.value).join();

  // Verify OTP action
  // void verifyOtp() async {
  //   if (otpCode.length < 4) {
  //     Get.snackbar('Error', 'Please enter 4-digit code');
  //     return;
  //   }
  //
  //   isVerifying.value = true;
  //   await Future.delayed(const Duration(seconds: 2)); // simulate API
  //   isVerifying.value = false;
  //
  //   // TODO: Navigate to next page
  //   Get.offAllNamed(AppRoutes.USER_LOGIN);
  // }

  void userverifyOtp() async {
    if (email.isEmpty) {
      Get.snackbar('Error', 'Email not found. Cannot verify OTP.');
      return;
    }

    final otp = otpCode.trim();

    if (otp.length != 4) {
      Get.snackbar('Error', 'Please enter valid 4-digit code');
      return;
    }

    try {
      isVerifying.value = true;

      final url = Uri.parse(
        "https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/user/verify",
      );

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email.trim(),
          "otp": otp,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        Get.snackbar("Success", data["message"] ?? "OTP verified");

        Get.offAllNamed(AppRoutes.USER_LOGIN);
      } else {
        Get.snackbar("Error", data["message"] ?? "OTP verification failed");
      }
    } catch (e) {
      Get.snackbar("Error", "Network error or server issue");
      print("VERIFY OTP ERROR: $e");
    } finally {
      isVerifying.value = false;
    }
  }

  // Resend OTP
  void resendOtp() {
    // TODO: call API to resend code
    // Get.snackbar('OTP', 'OTP has been resent');
  }

  // Handle input change
  void onOtpChanged(String value, int index) {
    otp[index].value = value;
    if (value.isNotEmpty && index < 3) {
      focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }
}