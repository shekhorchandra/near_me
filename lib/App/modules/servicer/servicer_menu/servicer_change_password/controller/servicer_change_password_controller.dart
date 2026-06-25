import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/services/storage_service.dart';
import '../../../../services/contants/api_constants.dart';

class ServicerChangePasswordController extends GetxController {
  final Dio dio = Dio();
  final StorageService storage = StorageService();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RxBool obscureCurrentPassword = true.obs;
  RxBool obscureNewPassword = true.obs;
  RxBool obscureConfirmPassword = true.obs;

  RxBool isLoading = false.obs;

  void toggleCurrentPassword() =>
      obscureCurrentPassword.value = !obscureCurrentPassword.value;

  void toggleNewPassword() =>
      obscureNewPassword.value = !obscureNewPassword.value;

  void toggleConfirmPassword() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;

  Future<void> changePassword() async {
    if (currentPasswordController.text.trim().isEmpty ||
        newPasswordController.text.trim().isEmpty ||
        confirmPasswordController.text.trim().isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (newPasswordController.text.trim() !=
        confirmPasswordController.text.trim()) {
      Get.snackbar(
        "Error",
        "New passwords do not match",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await dio.post(
        "${ApiConstants.baseUrl}/api/v1/auth/change-password",
        data: {
          "oldPassword": currentPasswordController.text.trim(),
          "newPassword": newPasswordController.text.trim(),
        },
        options: Options(
          headers: {
            "Authorization": "Bearer ${storage.accessToken}",
          },
        ),
      );

      print("STATUS: ${response.statusCode}");
      print("DATA: ${response.data}");

      if (response.statusCode == 200 &&
          response.data["success"] == true) {
        Get.snackbar(
          "Success",
          response.data["message"] ?? "Password has been changed",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

        await Future.delayed(const Duration(seconds: 2));

        Get.back();
      }
    } on DioException catch (e) {
      Get.snackbar(
        "Error",
        e.response?.data["message"] ??
            "Failed to change password",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}