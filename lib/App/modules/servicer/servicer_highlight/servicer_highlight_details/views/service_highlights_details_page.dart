import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import 'package:near_me/App/core/widgets/common_app_bar.dart';
import 'package:near_me/App/core/widgets/custom_text_field.dart';
import '../controller/service_highlights_details_controller.dart';

class ServiceHighlightsDetailsView extends GetView<ServiceHightlightsDetailsController> {
  const ServiceHighlightsDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'Service Highlights Details',
      ),
      body: GetBuilder<ServiceHightlightsDetailsController>(
        builder: (controller) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16)
                    .copyWith(bottom: MediaQuery.of(context).viewPadding.bottom + 16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// IMAGE PICKER
                      GestureDetector(
                        onTap: controller.pickImage,
                        child: Obx(() {
                          return Container(
                            height: 160,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.grey.shade200,
                              image: controller.imageFile.value != null
                                  ? DecorationImage(
                                image: FileImage(
                                    controller.imageFile.value!),
                                fit: BoxFit.cover,
                              )
                                  : (controller.imageUrl.value != null &&
                                  controller.imageUrl.value!.isNotEmpty)
                                  ? DecorationImage(
                                image: NetworkImage(
                                    controller.imageUrl.value!),
                                fit: BoxFit.cover,
                              )
                                  : null,
                            ),
                            child: controller.imageFile.value == null &&
                                (controller.imageUrl.value == null ||
                                    controller.imageUrl.value!.isEmpty)
                                ? const Center(
                              child: Icon(Icons.add_a_photo, size: 40),
                            )
                                : null,
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      /// TITLE
                      const Text(
                        "Service Highlights Title",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      CustomTextField(
                        controller: controller.titleController,
                        hint: 'Enter service title',
                      ),

                      const SizedBox(height: 16),

                      /// DESCRIPTION
                      const Text(
                        "Service Highlights Description",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      CustomTextField(
                        controller: controller.descController,
                        maxLines: 8,
                        hint: 'Service Highlights Description',
                      ),

                      const SizedBox(height: 20),

                      /// BUTTONS
                      Row(
                        children: [
                          Expanded(
                            child: Obx(() {
                              return AppButton(
                                height: 40,
                                loading: controller.isDeleting.value,
                                onPressed: controller.isDeleting.value
                                    ? () {}
                                    : controller.deleteService,
                                text: 'Delete',
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                              );
                            }),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Obx(() {
                              return AppButton(
                                height: 40,
                                loading: controller.isSaving.value,
                                onPressed: controller.isSaving.value
                                    ? () {}
                                    : controller.saveService,
                                text: 'Save',
                              );
                            }),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}