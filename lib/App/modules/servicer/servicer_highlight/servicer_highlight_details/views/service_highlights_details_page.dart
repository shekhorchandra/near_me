import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import 'package:near_me/App/core/widgets/common_app_bar.dart';
import 'package:near_me/App/core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/skeleton_loader.dart';
import '../controller/service_highlights_details_controller.dart';

class ServiceHighlightsDetailsView extends GetView<ServiceHightlightsDetailsController> {
  const ServiceHighlightsDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Service Highlights Details'),
      body: Obx(() {
        if (controller.isLoading.value) {
          return RefreshIndicator(
            color: Colors.black,
            onRefresh: controller.fetchSingleHighlight,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLoader.card(),
            
                  const SizedBox(height: 20),
            
                  SkeletonLoader.listTile(),
                  const SizedBox(height: 16),
                  SkeletonLoader.listTile(),
            
                  const SizedBox(height: 20),
                  SkeletonLoader.grid(itemCount: 2),
                ],
              ),
            ),
          );
        }

        return RefreshIndicator(
          color: Colors.black,
          onRefresh: controller.fetchSingleHighlight,
          child: _buildContent(controller),
        );
      }),
    );
  }

  Widget _buildContent(ServiceHightlightsDetailsController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ).copyWith(
            bottom: MediaQuery.of(context).viewPadding.bottom + 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE
              GestureDetector(
                onTap: controller.pickImage,
                child: Obx(() {
                  return Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade200,
                      image: controller.imageFile.value != null
                          ? DecorationImage(
                              image: FileImage(controller.imageFile.value!),
                              fit: BoxFit.cover,
                            )
                          : (controller.imageUrl.value != null &&
                                controller.imageUrl.value!.isNotEmpty)
                          ? DecorationImage(
                              image: NetworkImage(controller.imageUrl.value!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child:
                        controller.imageFile.value == null &&
                            (controller.imageUrl.value == null ||
                                controller.imageUrl.value!.isEmpty)
                        ? const Center(child: Icon(Icons.add_a_photo))
                        : null,
                  );
                }),
              ),

              const SizedBox(height: 20),

              CustomTextField(controller: controller.titleController, hint: 'Enter service title'),

              const SizedBox(height: 16),

              CustomTextField(
                controller: controller.descController,
                maxLines: 8,
                hint: 'Description',
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => AppButton(
                        loading: controller.isDeleting.value,
                        onPressed: controller.isDeleting.value ? () {} : controller.deleteService,
                        text: 'Delete',
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Obx(
                      () => AppButton(
                        loading: controller.isSaving.value,
                        onPressed: controller.isSaving.value ? () {} : controller.saveService,
                        text: 'Save',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
