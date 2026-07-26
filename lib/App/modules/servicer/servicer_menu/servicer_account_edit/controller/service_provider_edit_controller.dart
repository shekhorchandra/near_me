import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../../../../../data/services/storage_service.dart';
import '../../../../services/contants/api_constants.dart';
import '../models/category_model.dart';

class ServiceProviderEditController extends GetxController {
  final Dio dio = Dio();
  final picker = ImagePicker();
  final storage = StorageService();

  final isLoading = false.obs;
  final isUpdating = false.obs;

  final openingTime = TimeOfDay(hour: 9, minute: 0).obs;
  final closingTime = TimeOfDay(hour: 21, minute: 0).obs;
  final isOpen24_7 = false.obs;

  final nameCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final aboutCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();
  final openingCtrl = TextEditingController();
  final closingCtrl = TextEditingController();

  final categoryTree = <Category>[].obs;

  final selectedCategoryId = ''.obs;
  final selectedOfferServices = <String>[].obs;

  final logoUrl = ''.obs;
  final mediaUrls = <String>[].obs;

  final address = ''.obs;

  final logoFile = Rxn<File>();
  final mediaFiles = <File>[].obs;
  RxString location = ''.obs;

  final selectedAddress = ''.obs;

  RxString selectedSubCategoryId = "".obs;
  RxString selectedChildCategoryId = "".obs;

  final logger = Logger();
  final latitude = 23.8103.obs;
  final longitude = 90.4125.obs;

  final RxString serviceId = ''.obs;

  GoogleMapController? mapController;

  bool _isValidMongoId(String value) {
    return RegExp(
      r'^[a-fA-F0-9]{24}$',
    ).hasMatch(value.trim());
  }

  @override
  void onInit() {
    super.onInit();

    _readArguments();

    if (serviceId.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Service ID not found",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    loadAll();
  }

  Future<void> loadAll() async {
    await fetchCategoryTree();
    await fetchService();
  }

  void _readArguments() {
    final dynamic arguments = Get.arguments;

    if (arguments is Map) {
      serviceId.value =
          arguments["serviceId"]?.toString().trim() ?? "";
    } else if (arguments is String) {
      serviceId.value = arguments.trim();
    }

    logger.i(
      "SELECTED SERVICE ID => ${serviceId.value}",
    );
  }

  ///
  Future<void> getAddressFromLatLng(double lat, double lng) async {
    final placemarks = await placemarkFromCoordinates(lat, lng);

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;

      selectedAddress.value =
          "${place.street}, ${place.locality}, ${place.country}";

      addressCtrl.text = selectedAddress.value;
    }
  }

  // ================= CATEGORY TREE =================
  Future<void> fetchCategoryTree() async {
    try {
      // final res = await dio.get(
      //   "https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/category/tree",
      //   options: Options(headers: {"accesstoken": storage.accessToken}),
      // );
      final res = await dio.get(
        ApiConstants.categoryTree,
        options: Options(headers: {"accesstoken": storage.accessToken}),
      );

      final data = res.data['data'] as List;

      // PRETTY JSON RESPONSE
      final prettyJson = const JsonEncoder.withIndent('    ').convert(data);

      // LOGGER PRINT
      logger.i(prettyJson);
      categoryTree.value = data.map((e) => Category.fromJson(e)).toList();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // ================= SELECT =================
  void selectCategory(String id) {
    selectedCategoryId.value = id;
  }

  void setOpeningTime(TimeOfDay time) {
    openingTime.value = time;
  }

  void setClosingTime(TimeOfDay time) {
    closingTime.value = time;
  }

  void toggleService(String id) {
    if (selectedOfferServices.contains(id)) {
      selectedOfferServices.remove(id);
    } else {
      selectedOfferServices.add(id);
    }
  }

  // ================= IMAGE =================
  Future<void> pickLogo() async {
    final x = await picker.pickImage(source: ImageSource.gallery);
    if (x != null) {
      logoFile.value = File(x.path); // ✅ FIX
    }
  }

  Future<void> pickMedia() async {
    final total = mediaUrls.length + mediaFiles.length;

    if (total >= 3) {
      Get.snackbar("Limit", "Maximum 3 images allowed");
      return;
    }

    final x = await picker.pickImage(source: ImageSource.gallery);

    if (x != null) {
      mediaFiles.add(File(x.path));
    }
  }

  void removeMedia(int index) {
    mediaFiles.removeAt(index);
  }

  void removeApiMedia(int index) {
    if (index >= 0 && index < mediaUrls.length) {
      mediaUrls.removeAt(index);
    }
  }

  // ================= PHONE =================

  Future<void> fetchService() async {
    final String currentServiceId = serviceId.value.trim();

    if (currentServiceId.isEmpty) {
      Get.snackbar(
        "Error",
        "Service ID not found",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;

      final res = await dio.get(
        "${ApiConstants.baseUrl}/api/v1/service/$currentServiceId",
        options: Options(
          headers: {
            "Authorization": "Bearer ${storage.accessToken}",
            "accesstoken": storage.accessToken,
          },
        ),
      );

      logger.i("FETCH SELECTED SERVICE => ${res.data}");

      if (res.data is! Map) {
        throw Exception("Invalid API response");
      }

      final responseData = Map<String, dynamic>.from(
        res.data as Map,
      );

      if (responseData["success"] != true) {
        throw Exception(
          responseData["message"]?.toString() ??
              "Failed to fetch service",
        );
      }

      final dynamic rawService = responseData["data"];

      if (rawService is! Map) {
        throw Exception("Service data not found");
      }

      final data = Map<String, dynamic>.from(rawService);

      // Store selected ID only for compatibility.
      await storage.setServiceId(currentServiceId);

      serviceId.value =
          data["_id"]?.toString() ?? currentServiceId;

      nameCtrl.text =
          data["service_name"]?.toString() ?? "";

      addressCtrl.text =
          data["service_address"]?.toString() ?? "";

      aboutCtrl.text =
          data["about"]?.toString() ?? "";

      websiteCtrl.text =
          data["website_link"]?.toString() ?? "";

      address.value =
          data["service_address"]?.toString() ?? "";

      selectedAddress.value = address.value;

      final String rawPhone =
          data["phone"]?.toString() ?? "";

      contactCtrl.text = normalizeBdPhone(
        rawPhone.startsWith("8801")
            ? "+$rawPhone"
            : rawPhone,
      );

      selectedCategoryId.value = _extractId(
        data["service_category"],
      );

      selectedSubCategoryId.value = _extractId(
        data["service_subCategory"],
      );

      selectedChildCategoryId.value = _extractId(
        data["service_childCategory"],
      );

      final dynamic rawOfferServices =
      data["offer_services"];

      if (rawOfferServices is List) {
        final List<String> offerServiceIds =
        rawOfferServices
            .map<String>(
              (dynamic item) => _extractId(item),
        )
            .where(
              (String id) => id.trim().isNotEmpty,
        )
            .toSet()
            .toList();

        selectedOfferServices.assignAll(
          offerServiceIds,
        );
      } else {
        selectedOfferServices.clear();
      }

      logoUrl.value =
          data["company_logo"]?.toString() ?? "";

      final dynamic rawMedia = data["media"];

      if (rawMedia is List) {
        mediaUrls.assignAll(
          rawMedia
              .map((item) => item.toString())
              .where((url) => url.isNotEmpty)
              .toSet()
              .toList(),
        );
      } else {
        mediaUrls.clear();
      }

      isOpen24_7.value =
          data["allTimeAvailability"] == true;

      _setTimeFromApi(
        data["openingTime"]?.toString(),
        isOpening: true,
      );

      _setTimeFromApi(
        data["closingTime"]?.toString(),
        isOpening: false,
      );

      final dynamic locationData = data["location"];

      if (locationData is Map) {
        final dynamic coordinates =
        locationData["coordinates"];

        if (coordinates is List &&
            coordinates.length >= 2) {
          longitude.value =
              (coordinates[0] as num).toDouble();

          latitude.value =
              (coordinates[1] as num).toDouble();
        }
      }

      mediaFiles.clear();
      logoFile.value = null;

      update();
    } on DioException catch (error) {
      logger.e(
        "FETCH SERVICE DIO ERROR => "
            "${error.response?.data}",
      );

      final dynamic errorData =
          error.response?.data;

      String message = "Failed to fetch service";

      if (errorData is Map &&
          errorData["message"] != null) {
        message = errorData["message"].toString();
      }

      Get.snackbar(
        "Error",
        message,
        snackPosition: SnackPosition.TOP,
      );
    } catch (error, stackTrace) {
      logger.e(
        "FETCH SERVICE ERROR => $error",
        stackTrace: stackTrace,
      );

      Get.snackbar(
        "Error",
        error
            .toString()
            .replaceFirst("Exception: ", ""),
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String normalizeBdPhone(String input) {
    String phone = input.trim();

    // remove spaces, dashes, brackets
    phone = phone.replaceAll(RegExp(r'[\s-]'), '');

    // convert 8801XXXXXXXXX → +8801XXXXXXXXX
    if (RegExp(r'^8801[3-9]\d{8}$').hasMatch(phone)) {
      return '+$phone';
    }

    return phone;
  }

  bool isValidBdPhone(String phone) {
    return RegExp(r'^(\+8801|01)[3-9]\d{8}$').hasMatch(phone);
  }

  String getServiceNameById(String id) {
    for (final cat in categoryTree) {
      for (final child in cat.children) {
        for (final sub in child.children) {
          if (sub.id == id) {
            return sub.name;
          }
        }
      }
    }
    return "Unknown";
  }

  String getCategoryNameById(String id) {
    if (id.isEmpty) return "";

    for (final parent in categoryTree) {
      if (parent.id == id) return parent.name;

      for (final child1 in parent.children) {
        if (child1.id == id) return child1.name;

        for (final child2 in child1.children) {
          if (child2.id == id) return child2.name;
        }
      }
    }

    return id; // fallback if not found
  }

  // ================= UPDATE SERVICE =================
  Future<void> updateService() async {
    if (isUpdating.value) return;

    try {
      isUpdating.value = true;

      // Use the service selected from the service list.
      final String currentServiceId = serviceId.value.trim();

      logger.i("UPDATING SERVICE ID => $currentServiceId");

      if (currentServiceId.isEmpty) {
        Get.snackbar(
          "Error",
          "Service ID not found",
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      final String serviceName = nameCtrl.text.trim();
      final String phone = normalizeBdPhone(
        contactCtrl.text,
      );
      final String serviceAddress =
      addressCtrl.text.trim();

      if (serviceName.isEmpty) {
        Get.snackbar(
          "Error",
          "Service name is required",
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      if (selectedCategoryId.value.trim().isEmpty) {
        Get.snackbar(
          "Error",
          "Please select a category",
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      if (!isValidBdPhone(phone)) {
        Get.snackbar(
          "Error",
          "Invalid Bangladeshi number. Use 01XXXXXXXXX or +8801XXXXXXXXX",
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      if (serviceAddress.isEmpty) {
        Get.snackbar(
          "Error",
          "Service address is required",
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      final List<String> cleanOfferServices =
      selectedOfferServices
          .where((id) => id.trim().isNotEmpty)
          .toSet()
          .toList();

      final Map<String, dynamic> body = {
        "service_name": serviceName,
        "service_category":
        selectedCategoryId.value.trim(),

        // Include these when your backend supports them.
        if (selectedSubCategoryId.value.trim().isNotEmpty)
          "service_subCategory":
          selectedSubCategoryId.value.trim(),

        if (selectedChildCategoryId.value.trim().isNotEmpty)
          "service_childCategory":
          selectedChildCategoryId.value.trim(),

        "offer_services": cleanOfferServices,
        "phone": phone,
        "service_address": serviceAddress,
        "about": aboutCtrl.text.trim(),
        "website_link": websiteCtrl.text.trim(),
        "location": {
          "type": "Point",
          "coordinates": [
            longitude.value,
            latitude.value,
          ],
          "address": serviceAddress,
        },
        "openingTime": _formatTime(
          openingTime.value,
        ),
        "closingTime": _formatTime(
          closingTime.value,
        ),
        "allTimeAvailability":
        isOpen24_7.value,
      };

      logger.i(
        "UPDATE BODY => ${jsonEncode(body)}",
      );

      final FormData formData = FormData();

      formData.fields.add(
        MapEntry(
          "data",
          jsonEncode(body),
        ),
      );

      // Add newly selected logo.
      final File? selectedLogo = logoFile.value;

      if (selectedLogo != null) {
        formData.files.add(
          MapEntry(
            "company_logo",
            await MultipartFile.fromFile(
              selectedLogo.path,
              filename: selectedLogo.path.split("/").last,
            ),
          ),
        );
      }

      /*
     * Preserve existing media.
     *
     * Your backend appears to expect existing images as uploaded files.
     * Therefore, the existing network images are downloaded and attached.
     */
      for (int index = 0;
      index < mediaUrls.length;
      index++) {
        final String url = mediaUrls[index].trim();

        if (url.isEmpty) continue;

        try {
          final response = await dio.get<List<int>>(
            url,
            options: Options(
              responseType: ResponseType.bytes,
            ),
          );

          final bytes = response.data;

          if (bytes == null || bytes.isEmpty) {
            continue;
          }

          formData.files.add(
            MapEntry(
              "media",
              MultipartFile.fromBytes(
                bytes,
                filename:
                "existing_media_${index + 1}.jpg",
              ),
            ),
          );
        } catch (error) {
          logger.w(
            "Unable to preserve media: $url, error: $error",
          );
        }
      }

      // Add newly selected media.
      for (final File file in mediaFiles) {
        formData.files.add(
          MapEntry(
            "media",
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split("/").last,
            ),
          ),
        );
      }

      final response = await dio.patch(
        "${ApiConstants.baseUrl}/api/v1/service/$currentServiceId",
        data: formData,
        options: Options(
          headers: {
            "Authorization":
            "Bearer ${storage.accessToken}",
            "accesstoken": storage.accessToken,
          },
          contentType: "multipart/form-data",
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
      );

      logger.i(
        "UPDATE RESPONSE => "
            "${const JsonEncoder.withIndent('  ').convert(response.data)}",
      );

      final dynamic responseData = response.data;

      final bool isSuccess =
          response.statusCode == 200 &&
              responseData is Map &&
              responseData["success"] == true;

      if (isSuccess) {
        mediaFiles.clear();
        logoFile.value = null;

        Get.snackbar(
          "Success",
          responseData["message"]?.toString() ??
              "Service updated successfully",
          snackPosition: SnackPosition.TOP,
        );

        // Return to My Services and refresh its list.
        Get.back(result: true);
        return;
      }

      String errorMessage = "Update failed";

      if (responseData is Map &&
          responseData["message"] != null) {
        errorMessage =
            responseData["message"].toString();
      }

      Get.snackbar(
        "Error",
        errorMessage,
        snackPosition: SnackPosition.TOP,
      );
    } on DioException catch (error) {
      logger.e(
        "UPDATE DIO ERROR => ${error.response?.data}",
      );

      String message =
          "Unable to update the service";

      final dynamic errorData =
          error.response?.data;

      if (errorData is Map &&
          errorData["message"] != null) {
        message = errorData["message"].toString();
      } else if (error.type ==
          DioExceptionType.connectionError) {
        message = "Please check your internet connection";
      } else if (error.type ==
          DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type ==
              DioExceptionType.receiveTimeout) {
        message =
        "The request timed out. Please try again";
      }

      Get.snackbar(
        "Error",
        message,
        snackPosition: SnackPosition.TOP,
      );
    } catch (error, stackTrace) {
      logger.e(
        "UPDATE ERROR => $error",
        stackTrace: stackTrace,
      );

      Get.snackbar(
        "Error",
        "Something went wrong while updating the service",
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isUpdating.value = false;
    }
  }

  // ================= ADDED (FOR YOUR VIEW ONLY) =================
  // Focus Nodes
  final serviceNameFocus = FocusNode();
  final contactFocus = FocusNode();
  final addressFocus = FocusNode();
  final aboutFocus = FocusNode();
  final websiteFocus = FocusNode();

  // Edit toggles
  final isServiceNameEditable = false.obs;
  final isContactEditable = false.obs;
  final isAddressEditable = false.obs;
  final isAboutEditable = false.obs;
  final isWebsiteEditable = false.obs;

  @override
  void onClose() {
    serviceNameFocus.dispose();
    contactFocus.dispose();
    addressFocus.dispose();
    aboutFocus.dispose();
    websiteFocus.dispose();

    nameCtrl.dispose();
    contactCtrl.dispose();
    addressCtrl.dispose();
    aboutCtrl.dispose();
    websiteCtrl.dispose();
    openingCtrl.dispose();
    closingCtrl.dispose();

    super.onClose();
  }

  String _extractId(dynamic value) {
    if (value == null) {
      return "";
    }

    if (value is Map) {
      return value["_id"]?.toString() ??
          value["id"]?.toString() ??
          "";
    }

    return value.toString();
  }

  void _setTimeFromApi(
      String? value, {
        required bool isOpening,
      }) {
    if (value == null || value.trim().isEmpty) {
      return;
    }

    final parts = value.split(":");

    if (parts.length < 2) {
      return;
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null) {
      return;
    }

    final time = TimeOfDay(
      hour: hour,
      minute: minute,
    );

    if (isOpening) {
      openingTime.value = time;
    } else {
      closingTime.value = time;
    }
  }

  String _formatTime(TimeOfDay time) {
    final String hour =
    time.hour.toString().padLeft(2, "0");

    final String minute =
    time.minute.toString().padLeft(2, "0");

    return "$hour:$minute";
  }
}
