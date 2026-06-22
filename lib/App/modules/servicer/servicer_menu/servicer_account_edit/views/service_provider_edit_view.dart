import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../servicer_preview/service_provider_preview_view.dart';
import '../controller/service_provider_edit_controller.dart';
import '../../../../../core/widgets/App_button.dart';
import '../../../../../core/widgets/SectionLabelWithEdit.dart';
import '../../../../../core/widgets/common_app_bar.dart';
import '../../../../../core/widgets/custom_dropdown_field.dart';
import '../../../../../core/widgets/custom_text_field.dart';

class ServiceProviderEditView extends GetView<ServiceProviderEditController> {
  const ServiceProviderEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Edit Service Provider Account',
        showBack: true,
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ================= PREVIEW BUTTON
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    text: "Preview as User",
                    icon: Icons.remove_red_eye,
                    onPressed: () {
                      Get.to(
                        () =>
                            ServiceProviderPreviewView(controller: controller),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Service Details",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                /// ================= SERVICE NAME
                SectionLabelWithEdit(
                  title: "Service Name",
                  onEdit: () {
                    controller.serviceNameFocus.requestFocus();
                  },
                ),
                CustomTextField(
                  controller: controller.nameCtrl,
                  focusNode: controller.serviceNameFocus,
                  hint: "Enter Service Name",
                  icon: Icons.miscellaneous_services,
                ),

                const SizedBox(height: 12),

                /// ================= CATEGORY
                const Text(
                  "Category",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),

                Obx(() {
                  final categories = controller.categoryTree;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomDropdownField(
                        hint: "Select Category",
                        value: controller.selectedCategoryId.value.isEmpty
                            ? null
                            : controller.selectedCategoryId.value,
                        items: categories.map((e) {
                          return DropdownMenuItem(
                            value: e.id,
                            child: Text(e.name),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            controller.selectCategory(val);
                          }
                        },
                        icon: Icons.category,
                      ),

                      const SizedBox(height: 12),

                      /// ================= OFFER SERVICES UNDER CATEGORY
                      const Text(
                        "Sub Category",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.categoryTree
                            .where(
                              (cat) =>
                                  cat.id == controller.selectedCategoryId.value,
                            )
                            .expand((cat) => cat.children)
                            .map((service) {
                              final selected = controller.selectedOfferServices
                                  .contains(service.id);

                              return FilterChip(
                                label: Text(service.name),
                                selected: selected,
                                // onSelected: (_) =>
                                //     controller.toggleService(service.id),
                                onSelected: null,
                              );
                            })
                            .toList(),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 12),

                /// ================= OFFER SERVICES
                const Text(
                  "Child Category",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 8),

                Obx(() {
                  final services = controller.categoryTree
                      .expand((e) => e.children)
                      .expand((e) => e.children)
                      .toList();

                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: services.map((e) {
                      final selected = controller.selectedOfferServices
                          .contains(e.id);

                      return FilterChip(
                        label: Text(e.name),
                        selected: selected,
                        // onSelected: (_) => controller.toggleService(e.id),
                        onSelected: null,
                      );
                    }).toList(),
                  );
                }),

                const SizedBox(height: 12),

                /// ================= CONTACT
                SectionLabelWithEdit(
                  title: "Contact Number",
                  onEdit: () {
                    controller.contactFocus.requestFocus();
                  },
                ),
                CustomTextField(
                  controller: controller.contactCtrl,
                  focusNode: controller.contactFocus,
                  hint: "Enter Contact Number",
                  icon: Icons.call,
                ),

                const SizedBox(height: 12),

                /// ================= ABOUT
                SectionLabelWithEdit(
                  title: "About",
                  onEdit: () {
                    controller.aboutFocus.requestFocus();
                  },
                ),
                CustomTextField(
                  controller: controller.aboutCtrl,
                  focusNode: controller.aboutFocus,
                  hint: "About service",
                  maxLines: 4,
                ),

                const SizedBox(height: 12),

                /// ================= ADDRESS
                SectionLabelWithEdit(
                  title: "Address",
                  onEdit: () {
                    controller.addressFocus.requestFocus();
                  },
                ),
                CustomTextField(
                  controller: controller.addressCtrl,
                  focusNode: controller.addressFocus,
                  hint: "Address",
                  maxLines: 2,
                ),

                const SizedBox(height: 12),

                /// ================= WEBSITE
                SectionLabelWithEdit(
                  title: "Website",
                  onEdit: () {
                    controller.websiteFocus.requestFocus();
                  },
                ),
                CustomTextField(
                  controller: controller.websiteCtrl,
                  focusNode: controller.websiteFocus,
                  hint: "Website link",
                  icon: Icons.link,
                ),

                const SizedBox(height: 12),

                /// ================= LOCATION
                const Text(
                  "Location",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 200,
                  child: Obx(() {
                    final lat = controller.latitude.value;
                    final lng = controller.longitude.value;

                    return GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(lat, lng),
                        zoom: 16,
                      ),

                      onMapCreated: (map) {
                        controller.mapController = map;

                        // move camera to existing location once
                        map.animateCamera(
                          CameraUpdate.newLatLng(LatLng(lat, lng)),
                        );
                      },

                      onTap: (pos) {
                        controller.latitude.value = pos.latitude;
                        controller.longitude.value = pos.longitude;
                      },

                      markers: {
                        Marker(
                          markerId: const MarkerId("service_location"),
                          position: LatLng(lat, lng),
                          draggable: true,
                          onDragEnd: (pos) {
                            controller.latitude.value = pos.latitude;
                            controller.longitude.value = pos.longitude;
                          },
                        ),
                      },
                    );
                  }),
                ),

                const SizedBox(height: 12),

                /// ================= MEDIA =================
                const Text(
                  "Media (Max 3)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Obx(() {
                  final totalImages =
                      controller.mediaUrls.length +
                      controller.mediaFiles.length;

                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      /// ================= SERVER IMAGES =================
                      ...controller.mediaUrls.asMap().entries.map((entry) {
                        final index = entry.key;
                        final url = entry.value;

                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                url,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),

                            /// REMOVE OLD IMAGE
                            Positioned(
                              top: 5,
                              right: 5,
                              child: InkWell(
                                onTap: () => controller.removeApiMedia(index),
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

                      /// ================= NEW PICKED IMAGES =================
                      ...controller.mediaFiles.asMap().entries.map((entry) {
                        final index = entry.key;
                        final file = entry.value;

                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                file,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),

                            /// REMOVE NEW IMAGE
                            Positioned(
                              top: 5,
                              right: 5,
                              child: InkWell(
                                onTap: () => controller.removeMedia(index),
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
                      if (totalImages < 3)
                        InkWell(
                          onTap: controller.pickMedia,
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: const Icon(Icons.add_a_photo),
                          ),
                        ),
                    ],
                  );
                }),
                const SizedBox(height: 12),

                /// ================= LOGO
                const Text(
                  "Logo (JPEG or PNG max 10 MB)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Obx(() {
                  final file = controller.logoFile.value;

                  return Row(
                    children: [
                      DottedBorder(
                        child: GestureDetector(
                          onTap: controller.pickLogo,
                          child: Container(
                            height: 90,
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: file != null
                                ? Image.file(file, fit: BoxFit.cover)
                                : (controller.logoUrl.value.isNotEmpty
                                      ? Image.network(
                                          controller.logoUrl.value,
                                          fit: BoxFit.cover,
                                        )
                                      : const Icon(Icons.add)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          text: "Edit Logo",
                          icon: Icons.edit,
                          onPressed: controller.pickLogo,
                        ),
                      ),
                    ],
                  );
                }),

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
                                if (picked != null)
                                  controller.setOpeningTime(picked);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
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
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
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

                const SizedBox(height: 20),

                /// ================= UPDATE BUTTON
                Obx(() {
                  return controller.isUpdating.value
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: AppButton(
                            text: "Update Service",
                            icon: Icons.update,
                            onPressed: controller.updateService,
                          ),
                        );
                }),

                const SizedBox(height: 20),
              ],
            ),
          );
        }),
      ),
    );
  }
}
