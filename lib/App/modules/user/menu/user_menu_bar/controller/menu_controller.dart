import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../../../data/services/storage_service.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../services/contants/api_constants.dart';
import '../../../../services/utils/helpers/HttpStatusHandler.dart';
import '../../../../services/utils/helpers/app_snackbar.dart';
import '../../../User_bottom_nav_bar/controllers/bottom_nav_controller.dart';
import '../../../home/controller/home_controller.dart';


class UserMenuController extends GetxController {
  late final UserNavigationBarController navController;

  Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  RxString userName = "".obs;
  RxString profileImageUrl = "".obs;
  RxBool isEditing = false.obs;
  RxBool isUpdating = false.obs;
  final StorageService storage = Get.find();


  final TextEditingController nameController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    // Safely find nav controller after it's been registered
    navController = Get.find<UserNavigationBarController>();
    getUserProfile();
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

  Future<void> getUserProfile() async {
    try {
      final token = Get.find<StorageService>().accessToken;

      final response = await http.get(
        Uri.parse(ApiConstants.user_me),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);

        final data = body["data"];

        userName.value = data["name"] ?? "";
        profileImageUrl.value = data["picture"] ?? "";

        nameController.text = userName.value;
      } else {
        // HttpStatusHandler.handle(response);
      }
    } catch (e) {
      AppSnackbar.error(e.toString());
    }
  }

  Future<void> updateProfile() async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.accessToken;

      // User is not logged in
      if (token == null || token.isEmpty) {
        AppSnackbar.error("Please log in to update your profile.");
        Get.offAllNamed(AppRoutes.USER_LOGIN);
        return;
      }

      isUpdating.value = true;

      final request = http.MultipartRequest(
        "PATCH",
        Uri.parse(ApiConstants.user_info),
      );

      request.headers["Authorization"] = "Bearer $token";
      request.fields["name"] = nameController.text.trim();

      if (profileImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            "picture",
            profileImage.value!.path,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getUserProfile();
        profileImage.value = null;
        isEditing.value = false;

        AppSnackbar.success("Profile updated successfully");
      } else if (response.statusCode == 401) {
        await storage.clear();
        AppSnackbar.error("Your session has expired. Please log in again.");
        Get.offAllNamed(AppRoutes.USER_LOGIN);
      } else {
        final body = jsonDecode(response.body);

        AppSnackbar.error(
          body["message"] ?? "Something went wrong.",
        );
      }
    } catch (e) {
      AppSnackbar.error("Something went wrong. Please try again.");
    } finally {
      isUpdating.value = false;
    }
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


  Future<void> deleteAccount() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 28,
            ),
            const SizedBox(width: 10),
            const Text(
              "Delete Account",
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        content: const Text(
          "Are you sure you want to permanently delete your account?\n\n"
              "This action cannot be undone and all your data will be removed.",
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
          ),
        ),
        actionsPadding: const EdgeInsets.only(
          right: 16,
          bottom: 12,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Get.back(result: true),
            child: const Text(
              "Delete",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Colors.black)),
        barrierDismissible: false,
      );
      print(storage.accessToken);
      final response = await Dio().delete(
        "${ApiConstants.baseUrl}/api/v1/user/delete-me",
        options: Options(
          headers: {
            "Authorization": "Bearer ${storage.accessToken}",
          },
        ),
      );

      Get.back(); // close loader

      if (response.statusCode == 200 && response.data["success"] == true) {
        Get.snackbar(
          "Success",
          response.data["message"] ?? "Account deleted successfully",
        );

        // Clear local storage
        await StorageService().clear();

        // Navigate to login
        Get.offAllNamed(AppRoutes.USER_LOGIN);
      }
    } on DioException catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();

      Get.snackbar(
        "Error",
        e.response?.data["message"] ?? "Failed to delete account",
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();

      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> onLogoutTap() async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.accessToken;

      if (token != null && token.isNotEmpty) {
        await http.post(
          Uri.parse(ApiConstants.user_logout),
          headers: {
            "Authorization": "Bearer $token",
          },
        );
      }

      await storage.clear();
      Get.find<HomeController>().checkLoginStatus();

      AppSnackbar.success("Logged out successfully");

      Get.offAllNamed(AppRoutes.USER_LOGIN);

    } catch (e) {
      AppSnackbar.error("Logout failed");
    }
  }
}