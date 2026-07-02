import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import 'package:near_me/App/core/widgets/common_app_bar.dart';
import 'package:near_me/App/core/widgets/custom_text_field.dart';
import 'package:near_me/App/modules/auth/service/servicer_account/controller/service_provider_controller.dart';
import '../../../../../core/widgets/custom_dropdown_field.dart';
import '../../../../../core/widgets/multiple_selected_dropdown.dart';

class ServiceProviderView extends GetView<ServiceProviderController> {
  const ServiceProviderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Service Provider Account', showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create Service Provider Account",
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              const Text(
                "Start earning by offering services near you.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),

              const SizedBox(height: 20),

              const Text(
                "Service Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Service Name",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),

                  CustomTextField(
                    controller: controller.serviceNameController,
                    hint: 'Enter Your Service Name',
                    icon: Icons.miscellaneous_services,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Category",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),

                  Obx(
                    () => CustomDropdownField(
                      hint: "Select Category",
                      value: controller.selectedCategoryId.value.isEmpty
                          ? null
                          : controller.selectedCategoryId.value,
                      items: controller.categories
                          .map(
                            (e) => DropdownMenuItem(
                              value: e.id,
                              child: Text(e.name),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        final selected = controller.categories.firstWhere(
                          (e) => e.id == val,
                        );
                        controller.selectCategory(selected);
                      },
                      icon: Icons.category,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Services You Offer (Max 5)",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),

                  // const MultiSelectDropdownField(
                  //   hint: "Select up to 5 services",
                  //   icon: Icons.design_services,
                  // ),
                  MultiSelectDropdownField(
                    hint: "Select up to 5 services",
                    icon: Icons.design_services,
                    controller: controller, // ServiceProviderController
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Child Services You Offer (Max 5)",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),

                  MultiSelectDropdownField(
                    hint: "Select child services",
                    icon: Icons.design_services,
                    controller: controller,
                    isChild: true, // 👈 important
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Contact Number",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),

                  CustomTextField(
                    controller: controller.contactController,
                    hint: 'Your Contact Number',
                    icon: Icons.call,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "About Section",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),

                  CustomTextField(
                    controller: controller.aboutController,
                    maxLines: 5,
                    maxLength: 50,
                    hint: 'Tell us about you or your services',
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Website (Optional)",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),

                  CustomTextField(
                    controller: controller.websiteController,
                    hint: 'Example: https://www.airbnb.com/',
                    icon: Icons.link,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const Text(
                "Location",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),

              const SizedBox(height: 6),

              /// location
              SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    Obx(
                      () => GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            controller.latitude.value,
                            controller.longitude.value,
                          ),
                          zoom: 15,
                        ),

                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,

                        scrollGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                        rotateGesturesEnabled: true,
                        tiltGesturesEnabled: true,

                        gestureRecognizers:
                            <Factory<OneSequenceGestureRecognizer>>{
                              Factory<OneSequenceGestureRecognizer>(
                                () => EagerGestureRecognizer(),
                              ),
                            },

                        onMapCreated: (GoogleMapController mapController) {
                          controller.mapController = mapController;
                        },

                        onTap: (LatLng position) async {
                          controller.latitude.value = position.latitude;
                          controller.longitude.value = position.longitude;

                          await controller.getAddressFromLatLng(
                            position.latitude,
                            position.longitude,
                          );

                          controller.mapController?.animateCamera(
                            CameraUpdate.newLatLng(position),
                          );
                        },

                        markers: {
                          Marker(
                            markerId: const MarkerId("service_location"),
                            position: LatLng(
                              controller.latitude.value,
                              controller.longitude.value,
                            ),
                            draggable: true,
                            infoWindow: InfoWindow(
                              title: controller.serviceNameController.text,
                              snippet: controller.selectedAddress.value,
                            ),
                            onDragEnd: (LatLng value) async {
                              controller.latitude.value = value.latitude;
                              controller.longitude.value = value.longitude;

                              await controller.getAddressFromLatLng(
                                value.latitude,
                                value.longitude,
                              );

                              controller.mapController?.animateCamera(
                                CameraUpdate.newLatLng(value),
                              );
                            },
                          ),
                        },
                      ),
                    ),

                    Positioned(
                      top: 10,
                      left: 10,
                      right: 60,
                      child: GooglePlaceAutoCompleteTextField(
                        textEditingController: controller.searchController,
                        googleAPIKey: dotenv.env['GOOGLE_MAPS_API_KEY']!,

                        inputDecoration: InputDecoration(
                          hintText: "Search location",
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),

                        debounceTime: 600,
                        isLatLngRequired: true,

                        itemClick: (prediction) {
                          controller.searchController.text =
                              prediction.description!;
                        },

                        getPlaceDetailWithLatLng: (prediction) async {
                          final lat = double.parse(prediction.lat!);
                          final lng = double.parse(prediction.lng!);

                          controller.latitude.value = lat;
                          controller.longitude.value = lng;

                          controller.selectedAddress.value =
                              prediction.description!;
                          controller.addressController.text =
                              prediction.description!;

                          controller.mapController?.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(lat, lng),
                                zoom: 16,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Obx(
                () => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Address: ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        controller.selectedAddress.value,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Address",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),

                  CustomTextField(
                    controller: controller.addressController,
                    hint: 'Your Address',
                    icon: Icons.book,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              const Text(
                "Media (Max 3 Images)",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Obx(() {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    /// ================= UPLOADED IMAGES =================
                    ...controller.images.asMap().entries.map((entry) {
                      final index = entry.key;
                      final img = entry.value;

                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(img),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),

                          /// REMOVE BUTTON
                          Positioned(
                            top: 5,
                            right: 5,
                            child: GestureDetector(
                              onTap: () => controller.removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),

                    /// ================= ADD BUTTON =================
                    if (controller.images.length < 3)
                      GestureDetector(
                        onTap: () {
                          Get.bottomSheet(
                            Container(
                              color: Colors.white,
                              padding: const EdgeInsets.all(16),
                              child: Wrap(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text("Camera"),
                                    onTap: () {
                                      Get.back();
                                      controller.pickImage(ImageSource.camera);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text("Gallery"),
                                    onTap: () {
                                      Get.back();
                                      controller.pickImage(ImageSource.gallery);
                                    },
                                  ),
                                  const SizedBox(height: 100),
                                ],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: const Icon(
                            Icons.add_a_photo,
                            color: Colors.black,
                          ),
                        ),
                      ),
                  ],
                );
              }),

              const SizedBox(height: 12),

              const Text(
                "Logo for your service",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),

              Obx(
                () => Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Logo picker with dotted border
                    DottedBorder(
                      child: GestureDetector(
                        onTap: () => controller.setLogo(), // your pick logic
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: controller.logo.value.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(controller.logo.value),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Upload Logo",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),

                    // Instructions + upload button
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "JPEG or PNG, max 10 MB",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 40,
                            width: double.infinity,
                            child: AppButton(
                              onPressed: () =>
                                  controller.setLogo(), // your file picker
                              text: 'Upload Logo',
                              icon: Icons.upload_file,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Set Opening & Closing Time",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 6),

              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Opening time
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              TimeOfDay? picked = await showTimePicker(
                                context: Get.context!,
                                initialTime: controller.openingTime.value,
                              );
                              if (picked != null)
                                controller.setOpeningTime(picked);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                controller.openingTime.value.format(
                                  Get.context!,
                                ),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Closing time
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              TimeOfDay? picked = await showTimePicker(
                                context: Get.context!,
                                initialTime: controller.closingTime.value,
                              );
                              if (picked != null)
                                controller.setClosingTime(picked);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                controller.closingTime.value.format(
                                  Get.context!,
                                ),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // 24/7 checkbox
                    Row(
                      children: [
                        Obx(
                          () => Checkbox(
                            value: controller.isOpen24_7.value,
                            onChanged: (val) =>
                                controller.isOpen24_7.value = val ?? false,
                          ),
                        ),
                        const Text("Mark if your service is available 24/7"),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                "Subscription Plan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),

              const SizedBox(height: 6),

              Text(
                "You have selected the £${controller.selectedPlan.value.subscriptionPrice.toStringAsFixed(2)}/month Plan. You can continue using the platform with this plan or upgrade anytime for additional features.",
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),

              const SizedBox(height: 12),

              Obx(
                () => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.selectedPlan.value.subscriptionPlan,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "£${controller.selectedPlan.value.subscriptionPrice.toStringAsFixed(2)}/month",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.check_circle, color: Colors.green),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              AppButton(
                onPressed: controller.submitService,
                loading: controller.isLoading.value,
                text: 'Continue to Payment',
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
