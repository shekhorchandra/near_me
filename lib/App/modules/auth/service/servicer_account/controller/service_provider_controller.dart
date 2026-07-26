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
  final StorageService storage = StorageService();
  final model = ServiceProviderModel().obs;

  final RxBool isAdditionalService = false.obs;

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
  void onInit() {
    super.onInit();

    getAddressFromLatLng(
      latitude.value,
      longitude.value,
    );

    fetchCategories();

    _readRouteArguments();
  }

  Future<void> _readRouteArguments() async {
    final dynamic receivedArguments = Get.arguments;

    final Map<String, dynamic> args =
    receivedArguments is Map
        ? Map<String, dynamic>.from(
      receivedArguments,
    )
        : <String, dynamic>{};

    final String source =
        args["source"]?.toString().trim() ?? "";

    final String mode =
        args["mode"]?.toString().trim() ?? "";

    isAdditionalService.value =
        source == "my-services" ||
            mode == "additional-service";

    final String argumentPlanId =
        args["planId"]?.toString().trim() ?? "";

    final String storedPlanId =
        storage.planId?.trim() ?? "";

    String resolvedPlanId = "";

    if (_isValidMongoId(argumentPlanId)) {
      resolvedPlanId = argumentPlanId;
    } else if (_isValidMongoId(storedPlanId)) {
      resolvedPlanId = storedPlanId;
    }

    final String argumentPlanName =
        args["planName"]?.toString().trim() ??
            args["name"]?.toString().trim() ??
            "";

    final String resolvedPlanName =
    argumentPlanName.isNotEmpty
        ? argumentPlanName
        : selectedPlan.value.subscriptionPlan.trim();

    final double subscriptionPrice =
        _parseDouble(args["rawPrice"]) ??
            _parseDouble(args["price"]) ??
            selectedPlan.value.subscriptionPrice;

    selectedPlan.update((plan) {
      if (plan == null) return;

      plan.planId = resolvedPlanId;
      plan.subscriptionPlan =
          resolvedPlanName;
      plan.subscriptionPrice =
          subscriptionPrice;
    });

    if (resolvedPlanId.isNotEmpty) {
      await storage.setPlanId(
        resolvedPlanId,
      );
    } else {
      // Remove previously stored values such as elite_plan.
      await storage.remove("planId");
    }

    logger.i(
      "Additional service: ${isAdditionalService.value}",
    );
    logger.i("Argument plan ID: $argumentPlanId");
    logger.i("Stored plan ID: $storedPlanId");
    logger.i("Resolved plan ID: $resolvedPlanId");
    logger.i("Plan name: $resolvedPlanName");
  }

  double? _parseDouble(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
      value?.toString() ?? "",
    );
  }


  String get normalizedPlanName {
    return selectedPlan.value.subscriptionPlan
        .trim()
        .toLowerCase()
        .replaceAll(" plan", "");
  }

  int get maxImageLimit {
    switch (normalizedPlanName) {
      case "elite":
      case "pro":
        return 10;

      case "basic":
        return 5;

      case "free":
      default:
        return 3;
    }
  }

  bool get canAddMoreImages {
    return images.length < maxImageLimit;
  }

  int get remainingImageCount {
    final remaining = maxImageLimit - images.length;

    return remaining < 0 ? 0 : remaining;
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
    if (images.length >= maxImageLimit) {
      Get.snackbar(
        "Image Limit Reached",
        "Your ${selectedPlan.value.subscriptionPlan} allows up to "
            "$maxImageLimit images.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    images.add(path);
  }

  void removeImage(int index) {
    if (index < 0 || index >= images.length) return;

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

      // final storage = StorageService();
      final token = storage.accessToken;

      if (token == null || token.trim().isEmpty) {
        Get.snackbar("Error", "Access token not found");
        return;
      }

      final plan = selectedPlan.value;


      final String selectedPlanId =
      plan.planId.trim();

      final String storedPlanId =
          storage.planId?.trim() ?? "";

      String currentPlanId = "";

      if (_isValidMongoId(selectedPlanId)) {
        currentPlanId = selectedPlanId;
      } else if (_isValidMongoId(storedPlanId)) {
        currentPlanId = storedPlanId;
      }

      logger.i(
        "Selected plan ID: $selectedPlanId",
      );
      logger.i(
        "Stored plan ID: $storedPlanId",
      );
      logger.i(
        "Submitting plan ID: $currentPlanId",
      );

      if (currentPlanId.isEmpty) {
        Get.snackbar(
          "Error",
          "A valid active plan ID was not found.",
          snackPosition: SnackPosition.TOP,
        );
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

      if (images.length > maxImageLimit) {
        Get.snackbar(
          "Image Limit Exceeded",
          "Your ${selectedPlan.value.subscriptionPlan} allows only "
              "$maxImageLimit images.",
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      final payload = {
        "planId": currentPlanId,
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

        String serviceId = '';

        if (responseData is Map) {
          serviceId =
              responseData['serviceId']?.toString().trim() ?? '';

          if (serviceId.isEmpty) {
            final dynamic service = responseData['service'];

            if (service is Map) {
              serviceId =
                  service['_id']?.toString().trim() ?? '';
            }
          }
        }

        logger.i('Created Service ID: $serviceId');

        // Additional service flow
        if (isAdditionalService.value) {
          Get.snackbar(
            'Success',
            responseJson['message']?.toString() ??
                'New service created successfully',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            margin: const EdgeInsets.all(12),
            duration: const Duration(seconds: 3),
            icon: const Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
          );

          Get.back(result: true);
          return;
        }

        // First service flow
        if (serviceId.isEmpty) {
          Get.snackbar(
            'Error',
            'Service ID was not returned',
            snackPosition: SnackPosition.TOP,
          );
          return;
        }

        await storage.setServiceId(serviceId);

        if (Get.isRegistered<ServicerMenuController>()) {
          await Get.find<ServicerMenuController>()
              .fetchServiceProfile();
        }

        Get.snackbar(
          'Success',
          responseJson['message']?.toString() ??
              'Service created successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
          icon: const Icon(
            Icons.check_circle,
            color: Colors.white,
          ),
        );

        Get.offAllNamed(
          AppRoutes.SERVICER_BOTTOM_NAV,
          arguments: {
            'serviceId': serviceId,
          },
        );
      } else {
        Get.snackbar(
          'Error',
          responseJson['message']?.toString() ??
              'Failed to create service',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
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
    if (!canAddMoreImages) {
      Get.snackbar(
        "Image Limit Reached",
        "Your ${selectedPlan.value.subscriptionPlan} allows up to "
            "$maxImageLimit images.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile == null) return;

    if (images.length >= maxImageLimit) {
      Get.snackbar(
        "Image Limit Reached",
        "You can upload up to $maxImageLimit images only.",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    images.add(pickedFile.path);
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
  Future<void> setPlan(
      String planName,
      double price,
      String planId,
      ) async {
    final String cleanPlanId =
    planId.trim();

    final bool validPlanId =
    RegExp(r'^[a-fA-F0-9]{24}$')
        .hasMatch(cleanPlanId);

    if (!validPlanId) {
      logger.e(
        "Invalid backend plan ID: $cleanPlanId",
      );

      Get.snackbar(
        "Error",
        "A valid plan ID was not received",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    selectedPlan.update((plan) {
      if (plan == null) return;

      plan.planId = cleanPlanId;
      plan.subscriptionPlan = planName;
      plan.subscriptionPrice = price;
    });

    await storage.setPlanId(cleanPlanId);

    logger.i(
      "Saved active plan ID: $cleanPlanId",
    );
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

  bool _isValidMongoId(String value) {
    return RegExp(
      r'^[a-fA-F0-9]{24}$',
    ).hasMatch(value.trim());
  }
}
