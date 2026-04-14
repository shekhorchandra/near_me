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
            // ✅ EMPTY STATE
            if (controller.services.isEmpty) {
              return Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                      SizedBox(height: 10),
                      Text(
                        "No Service Highlights",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Add highlights to showcase your services",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }

            // ✅ GRID (when data exists)
            return Flexible(
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
                        /// Image
                        Container(
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
                                : (service.imageUrl != null &&
                                service.imageUrl!.isNotEmpty)
                                ? DecorationImage(
                              image: NetworkImage(service.imageUrl!),
                              fit: BoxFit.cover,
                            )
                                : null,
                          ),
                          child: service.imageFile == null &&
                              (service.imageUrl == null ||
                                  service.imageUrl!.isEmpty)
                              ? const Center(
                            child: Icon(Icons.add_a_photo, color: Colors.grey),
                          )
                              : null,
                        ),

                        const SizedBox(height: 10),

                        Text(service.title,
                            style: const TextStyle(fontWeight: FontWeight.w600)),

                        const Spacer(),

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
            );
          }),
        ),
      ),
    );
  }
}
