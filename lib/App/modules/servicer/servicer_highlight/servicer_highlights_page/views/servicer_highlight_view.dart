import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import 'package:near_me/App/core/widgets/common_app_bar.dart';
import 'package:near_me/App/routes/app_routes.dart';
import '../controller/servicer_highlight_controller.dart';

class ServiceHighlightView extends GetView<ServiceHighlightController> {
  const ServiceHighlightView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Service Highlights', showBack: false),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                const Text(
                  "Highlight Your Services",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                /// Subtitle
                const Text(
                  "Showcase up to 4 of your top services to make a strong first impression with potential customers.",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),

                const SizedBox(height: 20),

                /// Grid (4 items)
                Flexible(
                  child: GridView.builder(
                    itemCount: controller.services.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final service = controller.services[index];

                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Image / Upload Box
                            GestureDetector(
                              onTap: () => controller.pickImage(index),
                              child: Container(
                                height: 100,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade200,
                                  image: service.imageFile != null
                                      ? DecorationImage(
                                    image: FileImage(service.imageFile!),
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                ),
                                child: service.imageFile == null
                                    ? const Center(
                                  child: Icon(Icons.add_a_photo, color: Colors.grey),
                                )
                                    : null,
                              ),
                            ),

                            const SizedBox(height: 10),

                            /// Title
                            Text(service.title, style: const TextStyle(fontWeight: FontWeight.w600)),

                            const Spacer(),

                            /// Button
                            AppButton(
                              height: 30,
                              onPressed: () {
                                Get.toNamed(
                                  AppRoutes.SERVICE_HIGHLIGHTS_DETAILS,
                                  arguments: {'index': index},
                                );
                              },
                              text: 'View & Edit',
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
