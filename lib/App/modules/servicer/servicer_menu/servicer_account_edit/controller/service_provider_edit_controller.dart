import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:near_me/App/modules/servicer/servicer_menu/servicer_account_edit/models/service_provider_edit_model.dart';
import '../../../servicer_highlight/servicer_highlights_page/controller/servicer_highlight_controller.dart';
import '../../../servicer_highlight/servicer_highlights_page/model/servicer_highlight_model.dart';

class ServiceProviderEditController extends GetxController {
  final model = ServiceProviderEditModel().obs;

  // Controllers
  final serviceNameController = TextEditingController();
  final contactController = TextEditingController();
  final aboutController = TextEditingController();
  final addressController = TextEditingController();
  final websiteController = TextEditingController();
  final customServiceController = TextEditingController();

  // Focus nodes
  final serviceNameFocus = FocusNode();
  final categoryFocus = FocusNode();
  final servicesFocus = FocusNode();
  final contactFocus = FocusNode();
  final aboutFocus = FocusNode();
  final addressFocus = FocusNode();
  final websiteFocus = FocusNode();

  // Editable flags
  var isServiceNameEditable = false.obs;
  var isCategoryEditable = false.obs;
  var isServicesEditable = false.obs;
  var isContactEditable = false.obs;
  var isAboutEditable = false.obs;
  var isAddressEditable = false.obs;
  var isWebsiteEditable = false.obs;

  // Categories & Services
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

  // Timings
  var openingTime = TimeOfDay(hour: 9, minute: 0).obs;
  var closingTime = TimeOfDay(hour: 18, minute: 0).obs;
  var isOpen24_7 = false.obs;

  // Images & Logo
  var images = <String>[].obs;
  var logo = ''.obs;

  // Subscription plan
  var selectedPlanName = 'Free Plan'.obs;
  var selectedPlanPrice = 0.0.obs;

  // Highlights
  var highlights = <ServiceItem>[].obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();

    initHighlights(); // Initialize default highlights

    final data = Get.arguments;

    if (data != null) {
      // If coming from PLAN selection
      if (data.name != null) {
        selectedPlanName.value = data.name ?? 'Free Plan';
        selectedPlanPrice.value = data.price ?? 0.0;
      }

      // If coming from EDIT (existing service data)
      if (data is ServiceProviderEditModel) {
        loadExistingData(data);
      }
    }
  }

  /// Initialize default highlights (up to 4)
  void initHighlights() {
    highlights.assignAll([
      ServiceItem(title: "Massage Therapy"),
      ServiceItem(title: "Home Cleaning"),
      ServiceItem(title: "AC Repair"),
      ServiceItem(title: "Plumbing"),
    ]);
  }

  // Load existing data
  void loadExistingData(ServiceProviderEditModel data) {
    serviceNameController.text = data.serviceName;
    contactController.text = data.contactNumber;
    aboutController.text = data.about;
    addressController.text = data.address;
    websiteController.text = data.website;

    selectedCategory.value = data.category;
    selectedServices.assignAll(data.selectedServices);

    images.assignAll(data.images);
    logo.value = data.logo;

    isOpen24_7.value = data.is24Hours;

    // Load highlights if present
    if (data.highlights != null && data.highlights!.isNotEmpty) {
      highlights.assignAll(data.highlights!);
    }
  }

  // Submit updated data
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
      val.is24Hours = isOpen24_7.value;
      val.highlights = highlights; // Save highlights
    });

    Get.snackbar('Success', 'Proceeding to payment');
  }

  // Category selection
  void selectCategory(String value) {
    selectedCategory.value = value;
  }

  // Service selection
  void toggleService(String service) {
    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else if (selectedServices.length < 5) {
      selectedServices.add(service);
    } else {
      Get.snackbar('Limit', 'You can select up to 5 services');
    }
  }

  // Add custom service
  void addCustomService() {
    final value = customServiceController.text.trim();
    if (value.isEmpty) return;

    if (selectedServices.length >= 5) {
      Get.snackbar('Limit', 'You can select up to 5 services');
      return;
    }

    if (!services.contains(value)) services.add(value);
    if (!selectedServices.contains(value)) selectedServices.add(value);

    customServiceController.clear();
  }

  // Pick general image (max 3)
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

  void addImage(String path) {
    if (images.length < 3) images.add(path);
  }

  void removeImage(int index) {
    images.removeAt(index);
  }



  // Pick logo
  Future<void> setLogo() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final extension = pickedFile.name.split('.').last.toLowerCase();
      final sizeInMb = file.lengthSync() / (1024 * 1024);

      if (!["jpg", "jpeg", "png"].contains(extension)) {
        Get.snackbar("Error", "Only JPG or PNG files are allowed");
        return;
      }
      if (sizeInMb > 10) {
        Get.snackbar("Error", "File size must be less than 10 MB");
        return;
      }
      logo.value = pickedFile.path;
    }
  }

  // Timings
  void setOpeningTime(TimeOfDay time) => openingTime.value = time;
  void setClosingTime(TimeOfDay time) => closingTime.value = time;
  void toggle24Hours(bool value) => isOpen24_7.value = value;

  // Pick image for a highlight
  Future<void> pickHighlightImage(int index, ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source, imageQuality: 80);
    if (pickedFile != null) {
      if (index < highlights.length) {
        highlights[index].imageFile = File(pickedFile.path);
        highlights.refresh();
      }
    }
  }
}