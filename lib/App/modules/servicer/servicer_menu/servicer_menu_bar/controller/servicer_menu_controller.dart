import 'dart:convert';
import 'dart:developer';
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
import '../../../Servicer_bottom_nav_bar/controllers/servicer_bottom_nav_controller.dart';

class ServicerMenuController extends GetxController {
  late final ServicerNavigationBarController navController;
  final box = GetStorage();
  final StorageService storage = Get.find();
  // final StorageService storage = StorageService();

  final serviceName = ''.obs;
  final providerEmail = ''.obs;
  final isLoading = false.obs;
  final companyLogo = ''.obs;

  Rx<File?> profileImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  String get serviceId => box.read("serviceId") ?? "";

  @override
  void onInit() {
    super.onInit();
    // Safely find nav controller after it's been registered
    navController = Get.find<ServicerNavigationBarController>();

    fetchServiceProfile();
  }

  // ===== Navigation Functions =====
  void changePassword() => Get.toNamed(AppRoutes.SERVICER_CHANGE_PASSWORD);
  void onLoginTap() {
    Get.offAllNamed(AppRoutes.USER_LOGIN);
  }

  void goToaccountedit() {
    // Get.toNamed(AppRoutes.SERVICE_PROVIDER_ACCOUNT_EDIT);
    Get.toNamed(AppRoutes.MY_SERVICES);
  }

  void review() {
    if (serviceId.isEmpty) {
      AppSnackbar.error("Service ID not found");
      return;
    }

    Get.toNamed(AppRoutes.manageReviews, arguments: serviceId);
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

  Future<void> deleteProviderAccount() async {
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
        Get.offAllNamed(AppRoutes.SERVICER_LOGIN);
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



  Future<void> fetchServiceProfile() async {
    try {
      isLoading.value = true;

      final String? serviceId = storage.serviceId;
      final String? token = storage.accessToken;

      log("Stored Service ID: $serviceId");
      log("Token available: ${token?.isNotEmpty == true}");

      if (serviceId == null || serviceId.trim().isEmpty) {
        AppSnackbar.error(
          "Service ID not found. Please create a service first.",
        );
        return;
      }

      if (token == null || token.trim().isEmpty) {
        AppSnackbar.error(
          "Access token not found. Please log in again.",
        );
        return;
      }

      final Uri url = Uri.parse(
        "${ApiConstants.baseUrl}/api/v1/service/$serviceId",
      );

      log("Request URL: $url");

      final http.Response response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      log("Status code: ${response.statusCode}");
      log("Response body: ${response.body}");

      final dynamic decodedResponse = jsonDecode(response.body);

      if (decodedResponse is! Map<String, dynamic>) {
        AppSnackbar.error("Invalid server response");
        return;
      }

      final Map<String, dynamic> responseData = decodedResponse;

      if (response.statusCode == 200 &&
          responseData["success"] == true) {
        final dynamic serviceData = responseData["data"];

        if (serviceData is! Map<String, dynamic>) {
          AppSnackbar.error("Service data not found");
          return;
        }

        companyLogo.value =
            serviceData["company_logo"]?.toString() ?? "";

        serviceName.value =
            serviceData["service_name"]?.toString() ?? "";

        final dynamic provider = serviceData["provider"];

        if (provider is Map<String, dynamic>) {
          providerEmail.value =
              provider["email"]?.toString() ?? "";
        } else {
          providerEmail.value = "";
        }

        log("Loaded service name: ${serviceName.value}");
        log("Loaded company logo: ${companyLogo.value}");
        log("Loaded provider email: ${providerEmail.value}");
      } else {
        AppSnackbar.error(
          responseData["message"]?.toString() ??
              "Failed to load service profile",
        );
      }
    } on FormatException catch (error, stackTrace) {
      log("JSON parsing error: $error");
      log(stackTrace.toString());

      AppSnackbar.error("Invalid response from server");
    } catch (error, stackTrace) {
      log("fetchServiceProfile error: $error");
      log(stackTrace.toString());

      AppSnackbar.error("Unable to load service profile");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> serviceronLogoutTap() async {
    try {
      final box = GetStorage();
      final token = box.read("accessToken");

      final response = await http.post(
        Uri.parse(ApiConstants.user_logout),
        headers: {"Authorization": "Bearer $token"},
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
