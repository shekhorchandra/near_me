import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/common_app_bar.dart';
import '../servicer_account_edit/controller/service_provider_edit_controller.dart';

class ServiceProviderPreviewView extends StatelessWidget {
  final ServiceProviderEditController controller;

  const ServiceProviderPreviewView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Preview as User', showBack: true),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  // implement chat navigation if needed
                },
                icon: const Icon(Icons.chat, color: Colors.white),
                label: const Text('Chat', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // implement call functionality
                },
                icon: const Icon(Icons.call, color: Colors.white),
                label: const Text('Call', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // implement website open
                },
                icon: const Icon(Icons.public, color: Colors.white),
                label: const Text('Website', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Header Image (first uploaded image or placeholder)
            if (controller.images.isNotEmpty)
              Image.file(
                File(controller.images[0]),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              )
            else
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey.shade300,
                child: const Center(child: Text("No Image")),
              ),

            const SizedBox(height: 8),

            // Profile Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: controller.logo.value.isNotEmpty
                        ? FileImage(File(controller.logo.value))
                        : null,
                    child: controller.logo.value.isEmpty
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.serviceNameController.text,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(controller.selectedCategory.value, style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 16),
                            const SizedBox(width: 4),
                            Text(controller.isOpen24_7.value
                                ? "24/7"
                                : "${controller.openingTime.value.format(context)} - ${controller.closingTime.value.format(context)}"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 20),

            // About Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('About', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(controller.aboutController.text),
                  const SizedBox(height: 12),

                  // Services Offered
                  const Text('Services Offered', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.selectedServices.map((service) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.miscellaneous_services, size: 16),
                            const SizedBox(width: 6),
                            Text(service, style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),

                  // Highlights Section
                  if (controller.highlights.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Service Highlights', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.highlights.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.0,
                            ),
                            itemBuilder: (context, index) {
                              final highlight = controller.highlights[index];
                              return Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Image box
                                    Container(
                                      height: 120,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade200,
                                        image: highlight.imageFile != null
                                            ? DecorationImage(
                                          image: FileImage(highlight.imageFile!),
                                          fit: BoxFit.cover,
                                        )
                                            : null,
                                      ),
                                      child: highlight.imageFile == null
                                          ? const Center(
                                        child: Icon(Icons.add_a_photo, color: Colors.grey),
                                      )
                                          : null,
                                    ),
                                    const SizedBox(height: 8),
                                    // Title
                                    Text(highlight.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    // Description
                                    if (highlight.description.isNotEmpty)
                                      Text(
                                        highlight.description,
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),

                  // Location Map
                  const Text('Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    height: 150,
                    color: Colors.grey.shade300,
                    child: const Center(child: Text('Static Map Here')),
                  ),
                  const SizedBox(height: 12),

                  // // Reviews (optional, can show mock or empty)
                  // const Text('Reviews', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  // const SizedBox(height: 4),
                  // const Text('No reviews yet'), // You can connect your review list here
                  // const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }
}