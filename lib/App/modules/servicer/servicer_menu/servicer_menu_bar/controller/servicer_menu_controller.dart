import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../routes/app_routes.dart';
import '../../../Servicer_bottom_nav_bar/controllers/servicer_bottom_nav_controller.dart';


class ServicerMenuController extends GetxController {
  late final ServicerNavigationBarController navController;

  Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

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
    Get.toNamed(AppRoutes.REVIEWS);
  }
  void goToAbout() => Get.toNamed(AppRoutes.SERVICER_ABOUT);
  void onAdvertiseTap() => Get.toNamed(AppRoutes.SERVICER_LOGIN);
  void onContactUsTap() => Get.toNamed(AppRoutes.SERVICER_CONTACT_US);
  void onHelpSupportTap() => Get.toNamed(AppRoutes.SERVICER_HELP_SUPPORT);
  void onPrivacyPolicyTap() => Get.toNamed(AppRoutes.SERVICER_PRIVACY_POLICY);
  void onTermsTap() => Get.toNamed(AppRoutes.SERVICER_TERMS_CONDITION);
  void onRateAppTap() {}
  void onInviteFriendsTap() {}
  void onLogoutTap() {
    Get.deleteAll();
    Get.offAllNamed(AppRoutes.SERVICER_LOGIN);
  }
}