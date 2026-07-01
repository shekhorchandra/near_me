import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

  final logoFile = Rxn<File>();
  final mediaFiles = <File>[].obs;

  RxString selectedSubCategoryId = "".obs;
  RxString selectedChildCategoryId = "".obs;

  final logger = Logger();
  final latitude = 23.8103.obs;
  final longitude = 90.4125.obs;

  final RxString serviceId = ''.obs;

  GoogleMapController? mapController;

  @override
  void onInit() {
    super.onInit();
    loadAll();
  }

  Future<void> loadAll() async {
    await fetchCategoryTree();
    await fetchService();
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
    try {
      isLoading.value = true;

      final res = await dio.get(
        "${ApiConstants.baseUrl}/api/v1/service/my-service",
        options: Options(
          headers: {
            "Authorization": "Bearer ${storage.accessToken}",
            "accesstoken": storage.accessToken,
          },
        ),
      );

      logger.i("FETCH SERVICE => ${res.data}");

      final data = res.data["data"];
      if (data["location"] != null &&
          data["location"]["coordinates"] != null) {

        final coordinates = data["location"]["coordinates"];

        longitude.value = (coordinates[0] as num).toDouble();
        latitude.value = (coordinates[1] as num).toDouble();

      }

      // ✅ SAVE SERVICE ID
      // IMPORTANT
      await storage.setServiceId(data["_id"]);

      serviceId.value = data["_id"] ?? "";

      nameCtrl.text = data["service_name"] ?? "";
      addressCtrl.text = data["service_address"] ?? "";
      aboutCtrl.text = data["about"] ?? "";
      websiteCtrl.text = data["website_link"] ?? "";

      contactCtrl.text = normalizeBdPhone(
        data["phone"].toString().startsWith("8801")
            ? "+${data["phone"]}"
            : data["phone"].toString(),
      );

      selectedCategoryId.value =
          data["service_category"]?["_id"]?.toString() ?? "";

      selectedOfferServices.assignAll(
        (data["offer_services"] as List?)
                ?.map((e) => e["_id"].toString())
                .toList() ??
            [],
      );

      logoUrl.value = data["company_logo"] ?? "";

      mediaUrls.assignAll(
        (data["media"] as List?)?.map((e) => e.toString()).toSet().toList() ??
            [],
      );

      // opening time
      if (data["openingTime"] != null) {
        final parts = data["openingTime"].split(":");

        openingTime.value = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }

      // closing time
      if (data["closingTime"] != null) {
        final parts = data["closingTime"].split(":");

        closingTime.value = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }

      mediaFiles.clear();

      update();
    } catch (e) {
      logger.e("FETCH SERVICE ERROR => $e");
      Get.snackbar("Error", "Failed to fetch service");
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
    try {
      isUpdating.value = true;

      // ✅ ALWAYS GET FRESH SERVICE ID
      final currentServiceId = storage.serviceId;

      logger.i("SERVICE ID => $currentServiceId");

      if (currentServiceId == null || currentServiceId.isEmpty) {
        Get.snackbar("Error", "Service ID not found");
        return;
      }

      // ✅ normalize first
      final phone = normalizeBdPhone(contactCtrl.text);

      logger.i("PHONE AFTER NORMALIZE => $phone");

      // ✅ validate properly
      if (!isValidBdPhone(phone)) {
        Get.snackbar(
          "Error",
          "Invalid Bangladeshi number. Use 01XXXXXXXXX or +8801XXXXXXXXX",
        );
        return;
      }

      // ✅ remove duplicates
      final cleanOfferServices = selectedOfferServices.toSet().toList();

      final body = {
        "service_name": nameCtrl.text.trim(),
        "service_category": selectedCategoryId.value,
        "offer_services": cleanOfferServices,
        "phone": phone,
        "service_address": addressCtrl.text.trim(),
        "about": aboutCtrl.text.trim(),
        "website_link": websiteCtrl.text.trim(),
        "location": {
          "type": "Point",
          "coordinates": [longitude.value, latitude.value],
        },
        "openingTime":
            "${openingTime.value.hour.toString().padLeft(2, '0')}:${openingTime.value.minute.toString().padLeft(2, '0')}",

        "closingTime":
            "${closingTime.value.hour.toString().padLeft(2, '0')}:${closingTime.value.minute.toString().padLeft(2, '0')}",

        "allTimeAvailability": false,
      };

      logger.i("UPDATE BODY => ${jsonEncode(body)}");

      final formData = FormData();

      formData.fields.add(MapEntry("data", jsonEncode(body)));

      // ✅ logo
      if (logoFile.value != null) {
        formData.files.add(
          MapEntry(
            "company_logo",
            await MultipartFile.fromFile(logoFile.value!.path),
          ),
        );
      }

      // ✅ old images
      for (final url in mediaUrls) {
        try {
          final response = await dio.get(
            url,
            options: Options(responseType: ResponseType.bytes),
          );

          formData.files.add(
            MapEntry(
              "media",
              MultipartFile.fromBytes(
                response.data,
                filename: "old_${DateTime.now().millisecondsSinceEpoch}.jpg",
              ),
            ),
          );
        } catch (e) {
          logger.w("Skipping image => $url");
        }
      }

      // ✅ new images
      for (final file in mediaFiles) {
        formData.files.add(
          MapEntry("media", await MultipartFile.fromFile(file.path)),
        );
      }

      // ✅ PATCH API
      final res = await dio.patch(
        "${ApiConstants.baseUrl}/api/v1/service/$currentServiceId",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer ${storage.accessToken}",
            "accesstoken": storage.accessToken,
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final prettyJson = const JsonEncoder.withIndent('    ').convert(res.data);

      logger.i(prettyJson);

      if (res.statusCode == 200 && res.data["success"] == true) {
        Get.snackbar("Success", "Updated Successfully");

        mediaFiles.clear();
        logoFile.value = null;

        await fetchService();
      } else {
        Get.snackbar("Error", res.data["message"] ?? "Update failed");
      }
    } catch (e) {
      logger.e("UPDATE ERROR => $e");

      Get.snackbar("Error", "Something went wrong");
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
}
