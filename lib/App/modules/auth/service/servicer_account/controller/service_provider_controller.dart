import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/service_provider_model.dart';

class ServiceProviderController extends GetxController {
  final model = ServiceProviderModel().obs;

  final serviceNameController = TextEditingController();
  final contactController = TextEditingController();
  final aboutController = TextEditingController();
  final addressController = TextEditingController();
  final websiteController = TextEditingController();

  var categories = ['Cleaning', 'Plumbing', 'Electrical', 'Beauty'].obs;
  var services = [
    'Home Cleaning',
    'AC Repair',
    'Hair Cut',
    'Makeup',
    'Plumbing Fix',
    'Wiring'
  ].obs;

  var selectedCategory = ''.obs;
  var selectedServices = <String>[].obs;

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

    final plan = Get.arguments;
    if (plan != null) {
      model.update((val) {
        val!.subscriptionPlan = plan.name;
      });
    }
  }

  void selectCategory(String value) {
    selectedCategory.value = value;
  }

  void toggleService(String service) {
    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else {
      if (selectedServices.length < 5) {
        selectedServices.add(service);
      } else {
        Get.snackbar('Limit', 'You can select up to 5 services');
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

  void submit() {
    model.update((val) {
      val!.serviceName = serviceNameController.text;
      val.category = selectedCategory.value;
      val.selectedServices = selectedServices;
      val.contactNumber = contactController.text;
      val.about = aboutController.text;
      val.address = addressController.text;
      val.website = websiteController.text;
      val.images = images;
      val.logo = logo.value;
      val.is24Hours = is24Hours.value;
    });

    Get.snackbar('Success', 'Proceeding to payment');
  }

  // Pick image from camera or gallery
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
