import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AppSnackbar {
  static void success(String message) {
    Get.snackbar(
      "Success",
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  static void error(String message) {
    Get.snackbar(
      "Error",
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}