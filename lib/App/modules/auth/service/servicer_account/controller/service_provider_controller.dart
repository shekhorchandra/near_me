import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
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

  var categories = <Category>[].obs;
  var selectedCategoryId = ''.obs;

  var services = <Category>[].obs;        // level 1
  var childServices = <Category>[].obs;   // level 2

  var selectedServiceIds = <String>[].obs;
  var selectedChildServiceIds = <String>[].obs;


  var is24Hours = false.obs;

  var images = <String>[].obs;
  var logo = ''.obs;

  var openingTime = TimeOfDay(hour: 9, minute: 0).obs;
  var closingTime = TimeOfDay(hour: 18, minute: 0).obs;
  var isOpen24_7 = false.obs;

  // Selected subscription plan
  var selectedPlan = Rx<ServiceProviderModel>(
    ServiceProviderModel(subscriptionPlan: 'Free Plan', subscriptionPrice: 0.0),
  );


  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();

    fetchCategories();

    final plan = Get.arguments;
    if (plan != null) {
      selectedPlan.update((val) {
        val!.subscriptionPlan = plan.name;
        val.subscriptionPrice = double.tryParse(plan.price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
      });
    }
  }


  Future<void> fetchCategories() async {
    try {
      final response = await http.get(
        Uri.parse("https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/category/tree"),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        categories.value = List.from(data['data'])
            .map((e) => Category.fromJson(e))
            .toList();
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
      childServices.clear(); // remove child if unselected
    } else {
      if (selectedServiceIds.length < 5) {
        selectedServiceIds.add(id);

        // 🔥 find selected service
        final selectedService =
        services.firstWhere((s) => s.id == id);

        // 🔥 load its children (LEVEL 2)
        childServices.clear();

        for (var id in selectedServiceIds) {
          final service = services.firstWhere((s) => s.id == id);
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
    } else {
      if (selectedChildServiceIds.length < 5) {
        selectedChildServiceIds.add(id);
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


  Future<void> submit() async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("https://nonrudimentarily-holey-richard.ngrok-free.dev/api/v1/service/create"),
      );

      request.fields['service_name'] = serviceNameController.text;
      request.fields['service_category'] = selectedCategoryId.value;
      request.fields['phone'] = contactController.text;
      request.fields['service_address'] = addressController.text;
      request.fields['about'] = aboutController.text;
      request.fields['website_link'] = websiteController.text;

      request.fields['openingTime'] =
      "${openingTime.value.hour}:${openingTime.value.minute}";
      request.fields['closingTime'] =
      "${closingTime.value.hour}:${closingTime.value.minute}";

      request.fields['allTimeAvailability'] =
          isOpen24_7.value.toString();

      // 🔥 location (IMPORTANT FORMAT)
      request.fields['location[type]'] = 'Point';
      request.fields['location[coordinates][0]'] = '90.4125';
      request.fields['location[coordinates][1]'] = '23.8103';

      // 🔥 offer services array
      for (int i = 0; i < selectedServiceIds.length; i++) {
        request.fields['offer_services[$i]'] = selectedServiceIds[i];
      }

      // 🔥 logo
      if (logo.value.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('company_logo', logo.value),
        );
      }

      // 🔥 media images
      for (var img in images) {
        request.files.add(
          await http.MultipartFile.fromPath('media', img),
        );
      }

      var response = await request.send();

      if (response.statusCode == 201) {
        Get.snackbar("Success", "Service created successfully");
      } else {
        Get.snackbar("Error", "Failed to create service");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 80);

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
      final extension = pickedFile.name
          .split('.')
          .last
          .toLowerCase();
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
    void setPlan(String planName, double price) {
      selectedPlan.update((p) {
        if (p != null) {
          p.subscriptionPlan = planName;
          p.subscriptionPrice = price;
        }
      });
    }
  }
}
