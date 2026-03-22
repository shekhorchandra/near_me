import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/widgets/App_button.dart';
import '../../../../../core/widgets/SectionLabelWithEdit.dart';
import '../../../../../core/widgets/common_app_bar.dart';
import '../../../../../core/widgets/custom_dropdown_field.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/multiple_selected_dropdown.dart';
import '../../../../../routes/app_routes.dart';
import '../../servicer_preview/service_provider_preview_view.dart';
import '../controller/service_provider_edit_controller.dart';

class ServiceProviderEditView extends GetView<ServiceProviderEditController> {
  const ServiceProviderEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Edit Service Provider Account', showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: "Preview as User",
                  icon: Icons.remove_red_eye,
                  onPressed: () {
                    Get.to(() => ServiceProviderPreviewView(controller: controller));
                  },
                ),
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
                  SectionLabelWithEdit(
                    title: "Service Name",
                    onEdit: () {
                      controller.isServiceNameEditable.value = true;
                      controller.serviceNameFocus.requestFocus(); // <-- focus properly
                    },
                  ),

                  const SizedBox(height: 6),

                  Obx(
                        () => CustomTextField(
                      controller: controller.serviceNameController,
                      focusNode: controller.serviceNameFocus,
                      hint: 'Enter Your Service Name',
                      icon: Icons.miscellaneous_services,
                      readOnly: !controller.isServiceNameEditable.value, // <-- use readOnly
                    ),
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
                      value: controller.selectedCategory.value.isEmpty
                          ? null
                          : controller.selectedCategory.value,
                      items: controller.categories,
                      onChanged: (val) => controller.selectCategory(val ?? ''),
                      icon: Icons.control_point_duplicate,
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

                  MultiSelectDropdownField(
                    hint: "Select up to 5 services",
                    icon: Icons.design_services,
                    controller: controller, // ServiceProviderEditController
                  ),
                ],
              ),

              const SizedBox(height: 12),


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabelWithEdit(
                    title: "Contact Number",
                    onEdit: () {
                      controller.isContactEditable.value = true;
                      controller.contactFocus.requestFocus();
                    },
                  ),

                  const SizedBox(height: 6),

                  Obx(() => CustomTextField(
                    controller: controller.contactController,
                    focusNode: controller.contactFocus,
                    hint: 'Enter Your Contact Number',
                    icon: Icons.call,
                    readOnly: !controller.isContactEditable.value, // toggle edit

                  )),
                ],
              ),
              const SizedBox(height: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabelWithEdit(
                    title: "About Section",
                    onEdit: () {
                      controller.isAboutEditable.value = true;
                      controller.aboutFocus.requestFocus();
                    },
                  ),

                  const SizedBox(height: 6),

                  Obx(() => CustomTextField(
                    controller: controller.aboutController,
                    focusNode: controller.aboutFocus,
                    maxLines: 5,
                    maxLength: 500,
                    hint: 'Tell us about you or your services',
                    readOnly: !controller.isAboutEditable.value, // toggle edit
                  )),
                ],
              ),

              const SizedBox(height: 6),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabelWithEdit(
                    title: "Address",
                    onEdit: () {
                      controller.isAddressEditable.value = true;
                      controller.addressFocus.requestFocus();
                    },
                  ),

                  const SizedBox(height: 6),

                  Obx(() => CustomTextField(
                    controller: controller.addressController,
                    focusNode: controller.addressFocus,
                    maxLines: 2,
                    hint: 'Your Address',
                    readOnly: !controller.isAddressEditable.value, // toggle edit

                  )),
                ],
              ),

              const SizedBox(height: 12),


              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionLabelWithEdit(
                    title: "Website (Optional)",
                    onEdit: () {
                      controller.isWebsiteEditable.value = true;
                      controller.websiteFocus.requestFocus();
                    },
                  ),

                  const SizedBox(height: 6),

                  Obx(() => CustomTextField(
                    controller: controller.websiteController,
                    focusNode: controller.websiteFocus,
                    hint: 'Website link',
                    icon: Icons.link,
                    readOnly: !controller.isWebsiteEditable.value, // toggle edit
                  )),
                ],
              ),

              const SizedBox(height: 12),

              const Text("Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey.shade300,
                child: const Center(child: Text("Map Placeholder")),
              ),

              const SizedBox(height: 12),

              const Text(
                "Edit Media (Max 3 Images)",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),

              Obx(
                () => Column(
                  children: [
                    // Uploaded images
                    ...controller.images.map((img) {
                      final index = controller.images.indexOf(img);
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(File(img)),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => controller.removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 18),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),

                    const SizedBox(height: 10),

                    // Full width upload icon
                    GestureDetector(
                      onTap: () {
                        Get.bottomSheet(
                          SafeArea(
                            child: Container(
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
                                ],
                              ),
                            ),
                          ),
                          isScrollControlled: true, // allows full-height bottom sheet if keyboard opens
                        );
                      },
                      child: Container(
                        width: double.infinity, // full width
                        height: 100,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: const Icon(Icons.add_a_photo, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              const Text("Logo for your service", style: TextStyle(fontWeight: FontWeight.bold)),
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
                                  child: Image.file(File(controller.logo.value), fit: BoxFit.cover),
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
                                      child: const Icon(Icons.add, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Edit Logo",
                                      style: TextStyle(color: Colors.grey, fontSize: 12),
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
                              onPressed: () => controller.setLogo(), // your file picker
                              text: 'Edit Logo',
                              icon: Icons.edit,
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
                "Edit Set Opening & Closing Time",
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
                              if (picked != null) controller.setOpeningTime(picked);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                controller.openingTime.value.format(Get.context!),
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
                              if (picked != null) controller.setClosingTime(picked);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                controller.closingTime.value.format(Get.context!),
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
                            onChanged: (val) => controller.isOpen24_7.value = val ?? false,
                          ),
                        ),
                        const Text("Mark if your service is available 24/7"),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // --- Service Highlights Section ---
              const Text(
                "Service Highlights",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Obx(() => GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.highlights.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final highlight = controller.highlights[index];
                  return GestureDetector(
                    onTap: () {
                      // Open bottom sheet to pick image
                      Get.bottomSheet(
                        SafeArea(
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(16),
                            child: Wrap(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text("Camera"),
                                  onTap: () {
                                    Get.back();
                                    controller.pickHighlightImage(index, ImageSource.camera);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.photo_library),
                                  title: const Text("Gallery"),
                                  onTap: () {
                                    Get.back();
                                    controller.pickHighlightImage(index, ImageSource.gallery);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        isScrollControlled: true, // allows full-height bottom sheet if keyboard opens
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Image Box
                          Container(
                            height: 110,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                              color: Colors.grey.shade200,
                              image: highlight.imageFile != null
                                  ? DecorationImage(
                                image: FileImage(highlight.imageFile!),
                                fit: BoxFit.cover,
                              )
                                  : null,
                            ),
                            child: highlight.imageFile == null
                                ? const Center(child: Icon(Icons.add_a_photo, color: Colors.grey, size: 30))
                                : null,
                          ),
                          const SizedBox(height: 8),
                          // Title
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              highlight.title,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Optional Description
                          if (highlight.description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                highlight.description,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              )),
              const SizedBox(height: 20),

            ],
          ),
        ),
      ),
    );
  }
}
