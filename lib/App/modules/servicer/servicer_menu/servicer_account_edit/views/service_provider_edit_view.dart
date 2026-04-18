// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../../../../core/widgets/SectionLabelWithEdit.dart';
// import '../../../../../core/widgets/common_app_bar.dart';
// import '../../../../../core/widgets/custom_dropdown_field.dart';
// import '../../../../../core/widgets/custom_text_field.dart';
// import '../../../../../core/widgets/multi_select_service_field.dart';
// import '../../../../auth/service/servicer_account/models/category_model.dart';
// import '../controller/service_provider_edit_controller.dart';
//
// class ServiceProviderEditView extends GetView<ServiceProviderEditController> {
//   const ServiceProviderEditView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CommonAppBar(
//         title: 'Edit Service Provider Account',
//         showBack: true,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//
//               // ================= SERVICE NAME
//               SectionLabelWithEdit(
//                 title: "Service Name",
//                 onEdit: () {
//                   controller.isServiceNameEditable.value = true;
//                   controller.serviceNameFocus.requestFocus();
//                 },
//               ),
//               Obx(() => CustomTextField(
//                 controller: controller.serviceNameController,
//                 focusNode: controller.serviceNameFocus,
//                 hint: "Enter Service Name",
//                 readOnly: !controller.isServiceNameEditable.value,
//                 icon: Icons.miscellaneous_services,
//               )),
//
//               const SizedBox(height: 12),
//               // ================= CATEGORY (FIXED)
//               Obx(() {
//                 return CustomDropdownField(
//                   hint: "Select Category",
//                   value: controller.selectedCategory.value?.id,
//                   items: controller.categories
//                       .map((e) => DropdownMenuItem(
//                     value: e.id,
//                     child: Text(e.name),
//                   ))
//                       .toList(),
//                   onChanged: (val) {
//                     if (val != null) {
//                       controller.selectedCategory.value =
//                           controller.categories.firstWhereOrNull((e) => e.id == val);
//                       controller.selectedCategoryId.value = val;
//                     }
//                   },
//                   icon: Icons.category,
//                 );
//               }),
//
//               const SizedBox(height: 12),
//
//               // ================= SERVICES
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Services You Offer (Max 5)",
//                     style: TextStyle(fontWeight: FontWeight.w500),
//                   ),
//                   const SizedBox(height: 6),
//
//                   MultiSelectServiceField<Category>(
//                     title: "Services",
//                     hint: "Select up to 5 services",
//                     icon: Icons.design_services,
//                     items: controller.services, // RxList already reactive
//                     selectedIds: controller.selectedServiceIds,
//                     getId: (e) => e.id,
//                     getName: (e) => e.name,
//                     onToggle: controller.toggleService,
//                     customController: controller.customServiceController,
//                     onAddCustom: controller.addCustomService,
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 12),
//
//               // ================= CONTACT
//               SectionLabelWithEdit(
//                 title: "Contact Number",
//                 onEdit: () {
//                   controller.isContactEditable.value = true;
//                   controller.contactFocus.requestFocus();
//                 },
//               ),
//               Obx(() => CustomTextField(
//                 controller: controller.contactController,
//                 focusNode: controller.contactFocus,
//                 hint: "Enter Contact Number",
//                 readOnly: !controller.isContactEditable.value,
//                 icon: Icons.call,
//               )),
//
//               const SizedBox(height: 12),
//
//               // ================= ABOUT
//               SectionLabelWithEdit(
//                 title: "About Section",
//                 onEdit: () {
//                   controller.isAboutEditable.value = true;
//                   controller.aboutFocus.requestFocus();
//                 },
//               ),
//               Obx(() => CustomTextField(
//                 controller: controller.aboutController,
//                 focusNode: controller.aboutFocus,
//                 maxLines: 4,
//                 hint: "Tell about your service",
//                 readOnly: !controller.isAboutEditable.value,
//               )),
//
//               const SizedBox(height: 12),
//
//               // ================= ADDRESS
//               SectionLabelWithEdit(
//                 title: "Address",
//                 onEdit: () {
//                   controller.isAddressEditable.value = true;
//                   controller.addressFocus.requestFocus();
//                 },
//               ),
//               Obx(() => CustomTextField(
//                 controller: controller.addressController,
//                 focusNode: controller.addressFocus,
//                 maxLines: 2,
//                 hint: "Your Address",
//                 readOnly: !controller.isAddressEditable.value,
//               )),
//
//               const SizedBox(height: 12),
//
//               // ================= WEBSITE
//               SectionLabelWithEdit(
//                 title: "Website (Optional)",
//                 onEdit: () {
//                   controller.isWebsiteEditable.value = true;
//                   controller.websiteFocus.requestFocus();
//                 },
//               ),
//               Obx(() => CustomTextField(
//                 controller: controller.websiteController,
//                 focusNode: controller.websiteFocus,
//                 hint: "Website link",
//                 icon: Icons.link,
//                 readOnly: !controller.isWebsiteEditable.value,
//               )),
//
//               const SizedBox(height: 20),
//
//               // ================= MEDIA
//               const Text(
//                 "Media (Max 3 Images)",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//
//               Obx(() {
//                 final images = controller.images;
//
//                 return Column(
//                   children: [
//                     for (int index = 0; index < images.length; index++)
//                       Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(10),
//                             child: SizedBox(
//                               height: 150,
//                               width: double.infinity,
//                               child: buildImage(images[index]),
//                             ),
//                           ),
//                           Positioned(
//                             right: 4,
//                             top: 4,
//                             child: GestureDetector(
//                               // onTap: () => controller.removeImage(index),
//                               child: const Icon(Icons.close, color: Colors.white),
//                             ),
//                           ),
//                         ],
//                       ),
//                   ],
//                 );
//               }),
//
//               const SizedBox(height: 20),
//
//               // ================= LOGO
//               const Text(
//                 "Logo",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//
//               Obx(() {
//                 return GestureDetector(
//                   // onTap: controller.setLogo,
//                   child: Container(
//                     height: 100,
//                     width: 100,
//                     margin: const EdgeInsets.only(top: 8),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: controller.logo.value.isEmpty
//                         ? const Icon(Icons.add)
//                         : buildImage(controller.logo.value),
//                   ),
//                 );
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// Widget buildImage(String path) {
//   if (path.startsWith('http')) {
//     return Image.network(path, fit: BoxFit.cover);
//   } else {
//     return Image.file(File(path), fit: BoxFit.cover);
//   }
// }
// ================= correct =================
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controller/service_provider_edit_controller.dart';
// import '../models/category_model.dart';
//
// class ServiceProviderEditView
//     extends GetView<ServiceProviderEditController> {
//   const ServiceProviderEditView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Service")),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//
//               // ================= TEXT FIELDS =================
//               TextField(controller: controller.nameCtrl),
//               TextField(controller: controller.contactCtrl),
//               TextField(controller: controller.addressCtrl),
//               TextField(controller: controller.aboutCtrl),
//               TextField(controller: controller.websiteCtrl),
//               TextField(controller: controller.openingCtrl),
//               TextField(controller: controller.closingCtrl),
//
//               const SizedBox(height: 20),
//
//               // ================= CATEGORY TREE =================
//               buildTree(controller.categoryTree),
//
//               const SizedBox(height: 20),
//
//               // ================= OFFER SERVICES (LEVEL 2 ONLY) =================
//               Obx(() {
//                 final level2Services = controller.categoryTree
//                     .expand((lvl0) => lvl0.children)
//                     .expand((lvl1) => lvl1.children)
//                     .toList();
//
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: level2Services.map((e) {
//                     return CheckboxListTile(
//                       value: controller.selectedOfferServices.contains(e.id),
//                       title: Text(e.name),
//                       onChanged: (_) => controller.toggleService(e.id),
//                     );
//                   }).toList(),
//                 );
//               }),
//
//               const SizedBox(height: 20),
//
//               // ================= LOGO =================
//               Obx(() {
//                 if (controller.logoFile != null) {
//                   return Image.file(controller.logoFile!, height: 100);
//                 }
//
//                 if (controller.logoUrl.value.isNotEmpty) {
//                   return Image.network(controller.logoUrl.value, height: 100);
//                 }
//
//                 return const Icon(Icons.image, size: 80);
//               }),
//
//               ElevatedButton(
//                 onPressed: controller.pickLogo,
//                 child: const Text("Pick Logo"),
//               ),
//
//               const SizedBox(height: 20),
//
//               // ================= MEDIA (SHOW ALL FROM API + NEW) =================
//               Obx(() {
//                 return Wrap(
//                   spacing: 8,
//                   runSpacing: 8,
//                   children: [
//                     // existing media from API
//                     ...controller.mediaUrls.map(
//                           (url) => Stack(
//                         children: [
//                           Image.network(url,
//                               height: 80, width: 80, fit: BoxFit.cover),
//                         ],
//                       ),
//                     ),
//
//                     // newly picked media
//                     ...controller.mediaFiles.asMap().entries.map(
//                           (e) => Stack(
//                         children: [
//                           Image.file(e.value,
//                               height: 80, width: 80, fit: BoxFit.cover),
//                           Positioned(
//                             right: 0,
//                             child: GestureDetector(
//                               onTap: () => controller.removeMedia(e.key),
//                               child: const Icon(Icons.close,
//                                   color: Colors.red),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               }),
//
//               ElevatedButton(
//                 onPressed: controller.pickMedia,
//                 child: const Text("Add Media"),
//               ),
//
//               const SizedBox(height: 20),
//
//               // ================= UPDATE =================
//               Obx(() => controller.isUpdating.value
//                   ? const CircularProgressIndicator()
//                   : ElevatedButton(
//                 onPressed: controller.updateService,
//                 child: const Text("Update"),
//               )),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }
//
// // ================= CATEGORY TREE (FIXED 3 LEVEL) =================
// Widget buildTree(List<Category> nodes) {
//   final controller = Get.find<ServiceProviderEditController>();
//
//   return Column(
//     children: nodes.map((lvl0) {
//       return ExpansionTile(
//         title: Text(lvl0.name),
//         children: lvl0.children.map((lvl1) {
//           return ExpansionTile(
//             title: Text(lvl1.name),
//             children: lvl1.children.map((lvl2) {
//               return CheckboxListTile(
//                 value: controller.selectedCategoryId.value == lvl2.id,
//                 title: Text(lvl2.name),
//                 onChanged: (_) =>
//                     controller.selectCategory(lvl2.id),
//               );
//             }).toList(),
//           );
//         }).toList(),
//       );
//     }).toList(),
//   );
// }
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
      appBar: CommonAppBar(title: 'Edit Service Provider Account', showBack: true),
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
                const Text("Category", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 6),

                Obx(() {
                  final categories = controller.categoryTree;

                  return CustomDropdownField(
                    hint: "Select Category",
                    value: controller.selectedCategoryId.value.isEmpty
                        ? null
                        : controller.selectedCategoryId.value,
                    items: categories.map((e) {
                      return DropdownMenuItem(value: e.id, child: Text(e.name));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        controller.selectCategory(val);
                      }
                    },
                    icon: Icons.category,
                  );
                }),

                const SizedBox(height: 12),

                /// ================= OFFER SERVICES
                const Text(
                  "Services You Offer",
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
                      final selected = controller.selectedOfferServices.contains(e.id);

                      return FilterChip(
                        label: Text(e.name),
                        selected: selected,
                        onSelected: (_) => controller.toggleService(e.id),
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
                const Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Text("Map Placeholder")),
                ),

                const SizedBox(height: 12),

                /// ================= MEDIA (API + LOCAL)
                const Text("Media (Max 3)", style: TextStyle(fontWeight: FontWeight.bold)),

                const SizedBox(height: 10),

                Obx(() {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      /// API IMAGES
                      ...controller.mediaUrls.map((url) {
                        return Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
                          ),
                        );
                      }),

                      /// LOCAL IMAGES
                      ...controller.mediaFiles.asMap().entries.map((entry) {
                        final index = entry.key;
                        final file = entry.value;

                        return Stack(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              right: 5,
                              top: 5,
                              child: GestureDetector(
                                onTap: () => controller.removeMedia(index),
                                child: const Icon(Icons.close, color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      }),

                      /// ADD BUTTON
                      GestureDetector(
                        onTap: controller.pickMedia,
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
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
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                            child: file != null
                                ? Image.file(file, fit: BoxFit.cover)
                                : (controller.logoUrl.value.isNotEmpty
                                      ? Image.network(controller.logoUrl.value, fit: BoxFit.cover)
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
