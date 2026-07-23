import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import '../../../../../data/services/storage_service.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../servicer/servicer_menu/servicer_menu_bar/controller/servicer_menu_controller.dart';
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
  final searchController = TextEditingController();

  final FocusNode locationFocusNode = FocusNode();
  final FocusNode websiteFocusNode = FocusNode();
  final FocusNode locationSearchFocus = FocusNode();

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
  final selectedAddress = ''.obs;

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
  @override
  void onInit() {
    super.onInit();

    getAddressFromLatLng(latitude.value, longitude.value);

    fetchCategories();

    final dynamic receivedArguments = Get.arguments;

    if (receivedArguments is! Map) {
      logger.e("Plan arguments are null or invalid");
      return;
    }

    final Map<String, dynamic> args = Map<String, dynamic>.from(
      receivedArguments,
    );

    final String planId = args["planId"]?.toString() ?? '';

    final String planName =
        args["planName"]?.toString() ?? args["name"]?.toString() ?? '';

    final String formattedPlanCost = args["planCost"]?.toString() ?? '';

    final double subscriptionPrice =
        (args["rawPrice"] as num?)?.toDouble() ??
        double.tryParse(args["price"]?.toString() ?? '') ??
        0.0;

    final String currencyCode = args["currencyCode"]?.toString() ?? '';

    selectedPlan.update((plan) {
      if (plan == null) return;

      plan.planId = planId;
      plan.subscriptionPlan = planName;
      plan.subscriptionPrice = subscriptionPrice;

      // Add these fields to your model only if they exist:
      // plan.formattedPrice = formattedPlanCost;
      // plan.currencyCode = currencyCode;
    });

    logger.i("Plan ID: $planId");
    logger.i("Plan name: $planName");
    logger.i("Plan cost: $formattedPlanCost");
    logger.i("Raw price: $subscriptionPrice");
    logger.i("Currency: $currencyCode");
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

  /// dragable adress
  Future<void> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        final address =
            "${place.street}, "
            "${place.subLocality}, "
            "${place.locality}, "
            "${place.administrativeArea}, "
            "${place.country}";

        selectedAddress.value = address;

        // Optional: update your text field
        addressController.text = address;
      }
    } catch (e) {
      print(e);
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
    if (isLoading.value) return;
    try {
      isLoading.value = true;

      final storage = StorageService();
      final token = storage.accessToken;

      if (token == null || token.trim().isEmpty) {
        Get.snackbar("Error", "Access token not found");
        return;
      }

      final plan = selectedPlan.value;

      if (plan.planId.isEmpty) {
        Get.snackbar("Error", "Plan ID is missing");
        return;
      }

      if (selectedCategoryId.value.isEmpty) {
        Get.snackbar("Error", "Please select category");
        return;
      }

      if (selectedSubCategoryId.value.isEmpty) {
        Get.snackbar("Error", "Please select sub category");
        return;
      }

      if (selectedChildCategoryId.value.isEmpty) {
        Get.snackbar("Error", "Please select child category");
        return;
      }

      if (serviceNameController.text.trim().isEmpty) {
        Get.snackbar("Error", "Service name is required");
        return;
      }

      if (logo.value.isEmpty) {
        Get.snackbar("Error", "Company logo is required");
        return;
      }

      final payload = {
        "planId": plan.planId,
        "service_name": serviceNameController.text.trim(),
        "service_category": selectedCategoryId.value,
        "service_subCategory": selectedSubCategoryId.value,
        "service_childCategory": selectedChildCategoryId.value,
        "offer_services": selectedServiceIds.toList(),
        "phone": contactController.text.replaceAll('+', '').trim(),
        "service_address": addressController.text.trim(),
        "about": aboutController.text.trim(),
        "website_link": websiteController.text.trim(),
        "openingTime":
            "${openingTime.value.hour.toString().padLeft(2, '0')}:"
            "${openingTime.value.minute.toString().padLeft(2, '0')}",
        "closingTime":
            "${closingTime.value.hour.toString().padLeft(2, '0')}:"
            "${closingTime.value.minute.toString().padLeft(2, '0')}",
        "allTimeAvailability": isOpen24_7.value,
        "location": {
          "type": "Point",
          "coordinates": [longitude.value, latitude.value],
          "address": addressController.text.trim(),
        },
      };

      logger.i("Create service payload: ${jsonEncode(payload)}");

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.createService),
      );

      request.headers['Authorization'] = token.startsWith("Bearer ")
          ? token
          : "Bearer $token";

      request.headers['Accept'] = "application/json";

      request.fields['data'] = jsonEncode(payload);

      final logoFile = File(logo.value);

      if (!await logoFile.exists()) {
        Get.snackbar("Error", "Selected logo file was not found");
        return;
      }

      request.files.add(
        await http.MultipartFile.fromPath('company_logo', logoFile.path),
      );

      for (final imgPath in images) {
        final imgFile = File(imgPath);

        if (await imgFile.exists()) {
          request.files.add(
            await http.MultipartFile.fromPath('media', imgFile.path),
          );
        }
      }

      final response = await request.send();
      final body = await response.stream.bytesToString();

      logger.i("Create status: ${response.statusCode}");
      logger.i("Create response: $body");

      if (body.trim().isEmpty) {
        Get.snackbar("Error", "Empty response from server");
        return;
      }

      final dynamic decodedResponse = jsonDecode(body);

      if (decodedResponse is! Map<String, dynamic>) {
        Get.snackbar("Error", "Invalid response from server");
        return;
      }

      final Map<String, dynamic> responseJson = decodedResponse;

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          responseJson['success'] == true) {
        final dynamic responseData = responseJson['data'];

        if (responseData is! Map<String, dynamic>) {
          Get.snackbar("Error", "Invalid service response");
          return;
        }

        String serviceId = responseData['serviceId']?.toString().trim() ?? '';

        // Fallback to data.service._id
        if (serviceId.isEmpty) {
          final dynamic service = responseData['service'];

          if (service is Map<String, dynamic>) {
            serviceId = service['_id']?.toString().trim() ?? '';
          }
        }

        if (serviceId.isEmpty) {
          logger.e("Service ID missing: $responseJson");

          Get.snackbar("Error", "Service ID was not returned");
          return;
        }

        final StorageService storage = StorageService();

        // Save before navigating.
        await storage.setServiceId(serviceId);

        final String? savedId = storage.serviceId;

        logger.i("Created Service ID: $serviceId");
        logger.i("Stored Service ID: $savedId");

        if (savedId == null || savedId.isEmpty) {
          Get.snackbar("Error", "Service ID could not be saved");
          return;
        }

        // Refresh the existing menu controller if it was created earlier.
        if (Get.isRegistered<ServicerMenuController>()) {
          await Get.find<ServicerMenuController>().fetchServiceProfile();
        }

        Get.snackbar("Success", "Service created successfully");

        Get.offAllNamed(
          AppRoutes.SERVICER_BOTTOM_NAV,
          arguments: {"serviceId": serviceId},
        );
      } else {
        Get.snackbar(
          "Error",
          responseJson['message']?.toString() ?? "Failed to create service",
        );
      }
    } on FormatException catch (error) {
      logger.e("JSON error: $error");
      Get.snackbar("Error", "Invalid server response");
    } catch (error, stackTrace) {
      logger.e("Submit service error", error: error, stackTrace: stackTrace);

      Get.snackbar("Error", error.toString());
    } finally {
      isLoading.value = false;
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
      imageQuality: 80,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final extension = pickedFile.name.split('.').last.toLowerCase();
      final sizeInMb = file.lengthSync() / (1024 * 1024);

      if (extension != 'jpg' && extension != 'jpeg' && extension != 'png') {
        Get.snackbar('Error', 'Only JPG or PNG files are allowed');
        return;
      }

      if (sizeInMb > 10) {
        Get.snackbar('Error', 'File size must be less than 10 MB');
        return;
      }

      logo.value = pickedFile.path;
    }
  }

  // OUTSIDE setLogo()
  void setPlan(String planName, double price, String planId) {
    selectedPlan.update((p) {
      if (p != null) {
        p.planId = planId;
        p.subscriptionPlan = planName;
        p.subscriptionPrice = price;
      }
    });
  }

  @override
  void onClose() {
    locationFocusNode.dispose();
    websiteFocusNode.dispose();
    locationSearchFocus.dispose();

    searchController.dispose();
    serviceNameController.dispose();
    contactController.dispose();
    aboutController.dispose();
    addressController.dispose();
    websiteController.dispose();
    customServiceController.dispose();

    super.onClose();
  }
}
