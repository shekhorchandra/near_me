import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../services/contants/api_constants.dart';
import '../../../../services/utils/helpers/HttpStatusHandler.dart';
import '../../../../services/utils/helpers/app_snackbar.dart';
import '../../../Servicer_bottom_nav_bar/controllers/servicer_bottom_nav_controller.dart';


class ServicerMenuController extends GetxController {
  late final ServicerNavigationBarController navController;
  final box = GetStorage();

  Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  String get serviceId => box.read("serviceId") ?? "";

  @override
  void onInit() {
    super.onInit();
    // Safely find nav controller after it's been registered
    navController = Get.find<ServicerNavigationBarController>();
  }

  // ===== Navigation Functions =====
  void changePassword() => Get.toNamed(AppRoutes.SERVICER_CHANGE_PASSWORD);
  void onLoginTap() {
    Get.offAllNamed(AppRoutes.USER_LOGIN);
  }

  void goToaccountedit() {
    Get.toNamed(AppRoutes.SERVICE_PROVIDER_ACCOUNT_EDIT);
  }

  void review() {
    if (serviceId.isEmpty) {
      AppSnackbar.error("Service ID not found");
      return;
    }

    Get.toNamed(
      AppRoutes.manageReviews,
      arguments: serviceId,
    );
  }
  void goToAbout() => Get.toNamed(AppRoutes.SERVICER_ABOUT);
  void onAdvertiseTap() => Get.toNamed(AppRoutes.SERVICER_LOGIN);
  void onContactUsTap() => Get.toNamed(AppRoutes.SERVICER_CONTACT_US);
  void onHelpSupportTap() => Get.toNamed(AppRoutes.SERVICER_HELP_SUPPORT);
  void onPrivacyPolicyTap() => Get.toNamed(AppRoutes.SERVICER_PRIVACY_POLICY);
  void onTermsTap() => Get.toNamed(AppRoutes.SERVICER_TERMS_CONDITION);
  void onRateAppTap() {}
  void onInviteFriendsTap() {}
  // void onLogoutTap() {
  //   Get.deleteAll();
  //   Get.offAllNamed(AppRoutes.SERVICER_LOGIN);
  // }

  Future<void> serviceronLogoutTap() async {
    try {
      final box = GetStorage();
      final token = box.read("accessToken");

      final response = await http.post(
        Uri.parse(ApiConstants.user_logout),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      final message = HttpStatusHandler.getMessage(
        statusCode: response.statusCode,
        apiMessage: data["message"],
      );

      await box.erase();
      Get.deleteAll();

      AppSnackbar.success(message);
      Get.offAllNamed(AppRoutes.USER_LOGIN);
    } catch (e) {
      AppSnackbar.error("Logout failed");
    }
  }
}