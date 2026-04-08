import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../../routes/app_routes.dart';
import '../../../../services/contants/api_constants.dart';
import '../../../../services/utils/helpers/HttpStatusHandler.dart';
import '../../../../services/utils/helpers/app_snackbar.dart';

class ServicerSignupController extends GetxController {
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  var isLoading = false.obs;

  final servicernameController = TextEditingController();
  final serviceremailController = TextEditingController();
  final servicerpasswordController = TextEditingController();
  final servicerconfirmPasswordController = TextEditingController();

  void togglePassword() => obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPassword() => obscureConfirmPassword.value = !obscureConfirmPassword.value;

  /// user register api call
  Future<void> registerProvider() async {
    final name = servicernameController.text.trim();
    final email = serviceremailController.text.trim();
    final password = servicerpasswordController.text.trim();
    final confirmPassword = servicerconfirmPasswordController.text.trim();
    final role = "PROVIDER";

    // ✅ Validate fields before sending
    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      return AppSnackbar.error("All fields are required");
    }
    if (password != confirmPassword) {
      return AppSnackbar.error("Passwords do not match");
    }

    isLoading.value = true;

    try {
      final body = jsonEncode({
        "name": name,
        "email": email,
        "password": password,
        "role": role,
      });

      print("Request body: $body"); // debug

      final response = await http.post(
        Uri.parse(ApiConstants.user_register),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      final data = jsonDecode(response.body);
      final message = HttpStatusHandler.getMessage(
        statusCode: response.statusCode,
        apiMessage: data["message"],
      );

      if (response.statusCode == 201 && data["success"] == true) {
        AppSnackbar.success(message);
        // Get.toNamed(AppRoutes.SERVICER_VERIFY_ACCOUNT);
        Get.toNamed(AppRoutes.SERVICER_LOGIN);
      } else {
        AppSnackbar.error(message);
      }
    } catch (e) {
      print("Exception: $e");
      AppSnackbar.error("Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    servicernameController.dispose();
    serviceremailController.dispose();
    servicerpasswordController.dispose();
    servicerconfirmPasswordController.dispose();
    super.onClose();
  }
}