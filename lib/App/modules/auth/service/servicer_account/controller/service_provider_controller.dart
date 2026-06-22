import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import '../../../../../data/services/storage_service.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../services/contants/api_constants.dart';
import '../models/category_model.dart';
import '../models/service_provider_model.dart';

class ServiceProviderController extends GetxController {
  final model = ServiceProviderModel().obs;

  final serviceNameController = TextEditingController();
  final contactController = TextEditingController();
  final aboutController = TextEditingController();
  final addressController = TextEditingController();
  final websiteController = TextEditingController();
  final customServiceController = TextEditingController();


  final latitude = 23.8103.obs;
  final longitude = 90.4125.obs;

  GoogleMapController? mapController;

  var categories = <Category>[].obs;
  var selectedCategoryId = ''.obs;

  var services = <Category>[].obs; // level 1
  var childServices = <Category>[].obs; // level 2

  var selectedServiceIds = <String>[].obs;
  var selectedChildServiceIds = <String>[].obs;

  RxString selectedSubCategoryId = "".obs;
  RxString selectedChildCategoryId = "".obs;

  final isLoading = false.obs;


  var is24Hours = false.obs;

  var images = <String>[].obs;
  var logo = ''.obs;

  var openingTime = TimeOfDay(hour: 9, minute: 0).obs;
  var closingTime = TimeOfDay(hour: 18, minute: 0).obs;
  var isOpen24_7 = false.obs;

  final logger = Logger();

  // Selected subscription plan
  var selectedPlan = Rx<ServiceProviderModel>(
    ServiceProviderModel(subscriptionPlan: 'Free Plan', subscriptionPrice: 0.0),
  );

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();

    fetchCategories();

    final args = Get.arguments;

    if (args != null) {
      selectedPlan.update((val) {
        if (val != null) {
          val.planId = args["planId"]; // 🔥 REQUIRED
          val.subscriptionPlan = args["name"] ?? '';
          val.subscriptionPrice =
              double.tryParse(args["price"].toString()) ?? 0;
        }
      });
    } else {
      logger.e("Plan arguments is null");
    }
  }

  Future<void> fetchCategories() async {
    try {
      // final response = await http.get(
      //   Uri.parse("https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/category/tree"),
      // );

      final response = await http.get(Uri.parse(ApiConstants.categoryTree));

      final data = jsonDecode(response.body);

      // PRETTY JSON RESPONSE
      final prettyJson = const JsonEncoder.withIndent('    ').convert(data);

      // LOGGER PRINT
      logger.i(prettyJson);

      if (data['success']) {
        categories.value = List.from(
          data['data'],
        ).map((e) => Category.fromJson(e)).toList();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load categories");
    }
  }

  void selectCategory(Category category) {
    selectedCategoryId.value = category.id;

    // ✅ Level 1 services
    services.value = category.children;

    // ✅ Clear child services initially
    childServices.clear();

    selectedServiceIds.clear();
    selectedChildServiceIds.clear();
  }

  void toggleService(String id) {
    if (selectedServiceIds.contains(id)) {
      selectedServiceIds.remove(id);

      // ✅ REMOVE sub category id if unselected
      if (selectedSubCategoryId.value == id) {
        selectedSubCategoryId.value = "";
      }

      childServices.clear();
    } else {
      if (selectedServiceIds.length < 5) {
        selectedServiceIds.add(id);

        // ✅ SET selected sub category
        selectedSubCategoryId.value = id;

        final selectedService = services.firstWhere((s) => s.id == id);

        childServices.clear();

        for (var serviceId in selectedServiceIds) {
          final service = services.firstWhere((s) => s.id == serviceId);
          childServices.addAll(service.children);
        }
      } else {
        Get.snackbar('Limit', 'Max 5 services');
      }
    }
  }

  void toggleChildService(String id) {
    if (selectedChildServiceIds.contains(id)) {
      selectedChildServiceIds.remove(id);

      // ✅ REMOVE child category id if unselected
      if (selectedChildCategoryId.value == id) {
        selectedChildCategoryId.value = "";
      }
    } else {
      if (selectedChildServiceIds.length < 5) {
        selectedChildServiceIds.add(id);

        // ✅ SET child category id
        selectedChildCategoryId.value = id;
      } else {
        Get.snackbar('Limit', 'Max 5 child services');
      }
    }
  }

  void toggle24Hours(bool value) {
    is24Hours.value = value;
  }

  void addImage(String path) {
    if (images.length < 3) {
      images.add(path);
    } else {
      Get.snackbar('Limit', 'Max 3 images allowed');
    }
  }

  void removeImage(int index) {
    images.removeAt(index);
  }

  // Pick image from camera or gallery

  List<Category> getAllServices(Category category) {
    List<Category> result = [];

    for (var child in category.children) {
      result.add(child);

      // recursive (VERY IMPORTANT)
      result.addAll(getAllServices(child));
    }

    return result;
  }

  Future<void> submitService() async {
    try {
      final token = StorageService().accessToken;
      if (token == null || token.isEmpty) return;

      final plan = selectedPlan.value;

      // ✅ correct validation
      if (plan.planId.isEmpty) {
        Get.snackbar("Error", "Plan ID is missing");
        return;
      }

      // ✅ ADD THIS VALIDATION BLOCK HERE
      if (selectedSubCategoryId.value.isEmpty) {
        Get.snackbar("Error", "Please select sub category");
        return;
      }

      if (selectedChildCategoryId.value.isEmpty) {
        Get.snackbar("Error", "Please select child category");
        return;
      }

      // ----------------- JSON PAYLOAD -----------------
      final payload = {
        "planId": plan.planId,
        "service_name": serviceNameController.text.trim(),
        "service_category": selectedCategoryId.value,

        // ✅ ADD THESE TWO FIELDS
        "service_subCategory": selectedSubCategoryId.value,
        "service_childCategory": selectedChildCategoryId.value,

        "offer_services": selectedServiceIds.toList(),
        "phone": contactController.text.replaceAll('+', '').trim(),
        "service_address": addressController.text.trim(),
        "about": aboutController.text.trim(),
        "website_link": websiteController.text.trim(),
        "openingTime":
        "${openingTime.value.hour.toString().padLeft(2, '0')}:${openingTime.value.minute.toString().padLeft(2, '0')}",
        "closingTime":
        "${closingTime.value.hour.toString().padLeft(2, '0')}:${closingTime.value.minute.toString().padLeft(2, '0')}",
        "allTimeAvailability": isOpen24_7.value,
        "location": {
          "type": "Point",
          "coordinates": [
            longitude.value, // longitude first
            latitude.value,  // latitude second
          ],
          "address": addressController.text.trim(),
        },
      };

      print("------------ JSON PAYLOAD ------------");
      print(jsonEncode(payload));
      print("-------------------------------------");

      print("SUB:----------------------------------- ${selectedSubCategoryId.value}");
      print("CHILD:-----------------------------------  ${selectedChildCategoryId.value}");

      // ----------------- MULTIPART REQUEST -----------------
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.createService),
      );

      // AUTH HEADER
      request.headers['Authorization'] = token.startsWith("Bearer ")
          ? token
          : 'Bearer $token';

      // ✅ FIX: PLAN ID SENT SEPARATELY (THIS FIXES YOUR ERROR)

      // JSON payload
      request.fields['data'] = jsonEncode(payload);

      // ----------------- LOGO -----------------
      if (logo.value.isNotEmpty) {
        final logoFile = File(logo.value);

        request.files.add(
          await http.MultipartFile.fromPath('company_logo', logoFile.path),
        );
      } else {
        Get.snackbar("Error", "Company logo is required");
        return;
      }

      // ----------------- MEDIA -----------------
      for (var imgPath in images) {
        final imgFile = File(imgPath);

        request.files.add(
          await http.MultipartFile.fromPath('media', imgFile.path),
        );
      }

      // ----------------- DEBUG -----------------
      print("------------ MULTIPART FIELDS ------------");
      request.fields.forEach((key, value) => print("$key: $value"));

      request.files.forEach(
        (file) => print("Field: ${file.field}, Filename: ${file.filename}"),
      );
      print("-----------------------------------------");

      // ----------------- SEND -----------------
      final response = await request.send();
      final body = await response.stream.bytesToString();

      print("STATUS: ${response.statusCode}");
      print("BODY: $body");

      final responseJson = body.isNotEmpty ? jsonDecode(body) : {};

      final prettyJson = const JsonEncoder.withIndent(
        '  ',
      ).convert(responseJson);
      logger.i(prettyJson);

      if (response.statusCode == 201 && responseJson['success'] == true) {
        Get.snackbar("Success", "Service created successfully");
        Get.offAllNamed(AppRoutes.SERVICER_BOTTOM_NAV);
      } else {
        Get.snackbar("Error", responseJson['message'] ?? "Unknown error");
      }
    } catch (e) {
      print("🔥 SUBMIT ERROR: $e");
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      if (images.length < 3) {
        images.add(pickedFile.path);
      } else {
        Get.snackbar("Limit", "You can upload up to 3 images only");
      }
    }
  }

  void setOpeningTime(TimeOfDay time) {
    openingTime.value = time;
  }

  void setClosingTime(TimeOfDay time) {
    closingTime.value = time;
  }

  Future<void> setLogo() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80, // compress
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final extension = pickedFile.name.split('.').last.toLowerCase();
      final sizeInMb = file.lengthSync() / (1024 * 1024);

      if (extension != "jpg" && extension != "jpeg" && extension != "png") {
        Get.snackbar("Error", "Only JPG or PNG files are allowed");
        return;
      }

      if (sizeInMb > 10) {
        Get.snackbar("Error", "File size must be less than 10 MB");
        return;
      }

      logo.value = pickedFile.path;
    }

    /// Set subscription plan
    void setPlan(String planName, double price, String planId) {
      selectedPlan.update((p) {
        if (p != null) {
          p.planId = planId; // 🔥 IMPORTANT
          p.subscriptionPlan = planName;
          p.subscriptionPrice = price;
        }
      });
    }
  }
}
