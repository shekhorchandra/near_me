import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:near_me/App/routes/app_routes.dart';

import '../../../../services/contants/api_constants.dart';

class ServicerVerifyAccountController extends GetxController {
  // OTP digits
  final otp = List.generate(4, (_) => ''.obs);

  // Focus nodes for each OTP field
  late List<FocusNode> focusNodes;

  // Loading state for verify button
  var isVerifying = false.obs;

  // User email (dynamic)
  late String email;
  final logger = Logger();


  @override
  void onInit() {
    super.onInit();
    focusNodes = List.generate(4, (_) => FocusNode());

    // Safe way to get email
    email = Get.arguments != null ? Get.arguments['email'] ?? '' : '';

    if (email.isEmpty) {
      print("WARNING: No email passed to OTP screen!");
    } else {
      print("EMAIL RECEIVED: $email");
    }
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
  void verifyOtp() async {
    if (email.isEmpty) {
      Get.snackbar('Error', 'Email not found. Cannot verify OTP.');
      return;
    }

    if (otpCode.length < 4) {
      Get.snackbar('Error', 'Please enter 4-digit code');
      return;
    }

    try {
      isVerifying.value = true;

      // final url = Uri.parse(
      //   "https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/user/verify",
      // );

      final url = Uri.parse(ApiConstants.userAccountVerify);

      print("SENDING OTP: $otpCode");
      print("SENDING EMAIL: $email");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "email": email,
          "otp": otpCode,
        }),
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RESPONSE BODY: ${response.body}");

      final data = jsonDecode(response.body);



      // PRETTY JSON RESPONSE
      final prettyJson = const JsonEncoder.withIndent(
        '    ',
      ).convert(data);

      // LOGGER PRINT
      logger.i(prettyJson);

      isVerifying.value = false;

      if (response.statusCode == 200 && data["success"] == true) {
        Get.snackbar(
          "Success",
          data["message"] ?? "OTP verified successfully",
        );
        Get.offAllNamed(AppRoutes.SERVICE_CHOOSE_PLAN);
      } else {
        Get.snackbar(
          "Error",
          data["message"] ?? "OTP verification failed",
        );
      }
    } catch (e) {
      isVerifying.value = false;
      Get.snackbar("Error", "Something went wrong");
      print("VERIFY OTP ERROR: $e");
    }
  }

  // Resend OTP
  void resendOtp() {
    // TODO: implement resend API
    Get.snackbar('OTP', 'OTP has been resent');
  }

  // Handle OTP input change
  void onOtpChanged(String value, int index) {
    if (value.isNotEmpty) {
      // Always take the last character in case user pasted more than 1
      otp[index].value = value[value.length - 1];

      // Move to next field if exists
      if (index < otp.length - 1) {
        focusNodes[index + 1].requestFocus();
      }
    } else {
      otp[index].value = '';

      // Move back to previous field if exists
      if (index > 0) {
        focusNodes[index - 1].requestFocus();
      }
    }
  }
}