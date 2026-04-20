import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';

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

  final serviceId = StorageService().serviceId;

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

  // ================= FETCH SERVICE =================
  Future<void> fetchService() async {
    try {
      isLoading.value = true;

      final res = await dio.get(
        "${ApiConstants.baseUrl}/api/v1/service/$serviceId",
        options: Options(
          headers: {
            "Authorization": "Bearer ${storage.accessToken}",
            "accesstoken": storage.accessToken,
          },
        ),
      );

      final data = res.data["data"];

      nameCtrl.text = data["service_name"] ?? "";
      addressCtrl.text = data["service_address"] ?? "";
      aboutCtrl.text = data["about"] ?? "";
      websiteCtrl.text = data["website_link"] ?? "";

      contactCtrl.text = normalizeBdPhone(
        data["phone"].toString().startsWith("8801")
            ? "+${data["phone"]}"
            : data["phone"].toString(),
      );

      openingCtrl.text = data["openingTime"] ?? "";
      closingCtrl.text = data["closingTime"] ?? "";

      selectedCategoryId.value = data["service_category"]?["_id"]?.toString() ?? "";

      selectedOfferServices.assignAll(
        (data["offer_services"] as List?)?.map((e) => e["_id"].toString()).toList() ?? [],
      );

      logoUrl.value = data["company_logo"] ?? "";

      if (data["openingTime"] != null) {
        final parts = data["openingTime"].split(":");
        openingTime.value = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }

      if (data["closingTime"] != null) {
        final parts = data["closingTime"].split(":");
        closingTime.value = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }

      logoUrl.value = data["company_logo"] ?? "";

      mediaUrls.assignAll(
        (data["media"] as List?)
            ?.map((e) => e.toString())
            .toSet()
            .toList() ??
            [],
      );

      mediaFiles.clear();

      update();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ================= PHONE =================
  String normalizeBdPhone(String input) {
    String phone = input.trim();
    phone = phone.replaceAll(RegExp(r'[\s-]'), '');
    phone = phone.replaceAll(RegExp(r'[^0-9+]'), '');

    if (phone.startsWith("8801") && phone.length == 13) {
      phone = "+$phone";
    }

    if (phone.startsWith("01") && phone.length == 11) {
      return phone;
    }

    if (phone.startsWith("+8801") && phone.length == 14) {
      return phone;
    }

    return phone;
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

      final phone = normalizeBdPhone(contactCtrl.text);

      final formData = FormData();

      final body = {
        "service_name": nameCtrl.text.trim(),
        "service_category": selectedCategoryId.value,
        "offer_services": selectedOfferServices.toList(),
        "phone": phone,
        "service_address": addressCtrl.text.trim(),
        "about": aboutCtrl.text.trim(),
        "website_link": websiteCtrl.text.trim(),
        "location": {
          "type": "Point",
          "coordinates": [90.4125, 23.8103],
        },
        "openingTime":
            "${openingTime.value.hour.toString().padLeft(2, '0')}:${openingTime.value.minute.toString().padLeft(2, '0')}",

        "closingTime":
            "${closingTime.value.hour.toString().padLeft(2, '0')}:${closingTime.value.minute.toString().padLeft(2, '0')}",
        "allTimeAvailability": false,
      };

      formData.fields.add(MapEntry("data", jsonEncode(body)));

      if (logoFile.value != null) {
        formData.files.add(
          MapEntry("company_logo", await MultipartFile.fromFile(logoFile.value!.path)),
        );
      }

      /// OLD SERVER IMAGES -> reupload
      for (final url in mediaUrls) {
        final response = await dio.get(
          url,
          options: Options(responseType: ResponseType.bytes),
        );

        final bytes = response.data;

        formData.files.add(
          MapEntry(
            "media",
            MultipartFile.fromBytes(
              bytes,
              filename: "old_image_${DateTime.now().millisecondsSinceEpoch}.jpg",
            ),
          ),
        );
      }

      /// NEW LOCAL IMAGES
      for (final file in mediaFiles) {
        formData.files.add(
          MapEntry(
            "media",
            await MultipartFile.fromFile(file.path),
          ),
        );
      }

      // for (final file in mediaFiles) {
      //   formData.files.add(MapEntry("media", await MultipartFile.fromFile(file.path)));
      // }

      // final res = await dio.patch(
      //   "ApiConstants.baseUrl/api/v1/service/$serviceId",
      //   data: formData,
      //   options: Options(
      //     headers: {
      //       "Authorization": "Bearer ${storage.accessToken}",
      //       "accesstoken": storage.accessToken,
      //       "Content-Type": "multipart/form-data",
      //     },
      //   ),
      // );

      final res = await dio.patch(
        "${ApiConstants.baseUrl}/api/v1/service/$serviceId",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer ${storage.accessToken}",
            "accesstoken": storage.accessToken,
          },
        ),
      );

      if (res.data["success"] == true) {
        Get.snackbar("Success", "Updated Successfully");

        mediaFiles.clear();
        logoFile.value = null;

        await fetchService();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
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
