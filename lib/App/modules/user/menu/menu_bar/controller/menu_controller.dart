import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../routes/app_routes.dart';
import '../../../User_bottom_nav_bar/controllers/bottom_nav_controller.dart';


class UserMenuController extends GetxController {
  late final UserNavigationBarController navController;

  Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    // Safely find nav controller after it's been registered
    navController = Get.find<UserNavigationBarController>();
  }

  // ===== Profile Image Editing =====
  void onEditProfileTap() async {
    Get.bottomSheet(
      SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                _pickImage(ImageSource.camera);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                _pickImage(ImageSource.gallery);
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile =
      await _picker.pickImage(source: source, imageQuality: 80);
      if (pickedFile != null) profileImage.value = File(pickedFile.path);
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image: $e");
    }
  }

  // ===== Navigation Functions =====
  void changePassword() => Get.toNamed(AppRoutes.CHANGE_PASSWORD);
  void goToAbout() => Get.toNamed(AppRoutes.ABOUT);
  void onAdvertiseTap() => Get.toNamed(AppRoutes.USER_LOGIN);
  void onContactUsTap() => Get.toNamed(AppRoutes.CONTACT_US);
  void onHelpSupportTap() => Get.toNamed(AppRoutes.HELP_SUPPORT);
  void onPrivacyPolicyTap() => Get.toNamed(AppRoutes.PRIVACY_POLICY);
  void onTermsTap() => Get.toNamed(AppRoutes.TERMS_CONDITION);
  void onRateAppTap() {}
  void onInviteFriendsTap() {}
  void onLogoutTap() {
    Get.deleteAll();
    Get.offAllNamed(AppRoutes.USER_LOGIN);
  }
}