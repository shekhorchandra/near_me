import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:near_me/App/routes/app_routes.dart';

class UserVerifyAccountController extends GetxController {
  // OTP digits
  final otp = List.generate(4, (_) => ''.obs);

  // Focus nodes
  late List<FocusNode> focusNodes;

  // ✅ FIX: nullable email
  String? email;

  // Loading state
  var isVerifying = false.obs;

  @override
  void onInit() {
    super.onInit();

    focusNodes = List.generate(4, (_) => FocusNode());

    // ✅ FIX: get email from previous screen
    email = Get.arguments;

    print("INIT EMAIL: $email");
  }

  @override
  void onClose() {
    for (var node in focusNodes) {
      node.dispose();
    }
    super.onClose();
  }

  // Collect OTP
  String get otpCode => otp.map((e) => e.value).join();

  // ✅ VERIFY OTP
  void verifyOtp() async {
    if (email == null || email!.isEmpty) {
      Get.snackbar('Error', 'Email not found. Cannot verify OTP.');
      return;
    }

    if (otpCode.length != 4) {
      Get.snackbar('Error', 'Please enter 4-digit code');
      return;
    }

    try {
      isVerifying.value = true;

      final url = Uri.parse(
        "https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/user/verify",
      );

      print("SENDING EMAIL: $email");
      print("SENDING OTP: $otpCode");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "otp": otpCode}),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      final data = jsonDecode(response.body);

      isVerifying.value = false;

      if (response.statusCode == 200 && data["success"] == true) {
        Get.snackbar("Success", data["message"] ?? "OTP verified successfully");

        Get.offAllNamed(AppRoutes.USER_LOGIN);
      } else {
        Get.snackbar("Error", data["message"] ?? "OTP verification failed");
      }
    } catch (e) {
      isVerifying.value = false;
      Get.snackbar("Error", "Something went wrong");
      print("VERIFY OTP ERROR: $e");
    }
  }

  // ✅ RESEND OTP
  void resendOtp() {
    Get.snackbar('OTP', 'OTP has been resent');
  }

  // ✅ HANDLE OTP INPUT
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
