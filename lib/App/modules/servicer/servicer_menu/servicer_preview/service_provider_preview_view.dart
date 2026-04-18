import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/common_app_bar.dart';
import '../servicer_account_edit/controller/service_provider_edit_controller.dart';

class ServiceProviderPreviewView extends StatelessWidget {
  final ServiceProviderEditController controller;

  const ServiceProviderPreviewView({
    super.key,
    required this.controller,
  });

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
              _actionBtn(Icons.chat, "Chat"),
              _actionBtn(Icons.call, "Call"),
              _actionBtn(Icons.public, "Website"),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ================= HEADER IMAGE =================
              if (controller.mediaUrls.isNotEmpty)
                Image.network(
                  controller.mediaUrls.first,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                )
              else if (controller.mediaFiles.isNotEmpty)
                Image.file(
                  controller.mediaFiles.first,
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

              const SizedBox(height: 10),

              // ================= PROFILE =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [

                    // LOGO
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: controller.logoFile.value != null
                          ? FileImage(controller.logoFile.value!)
                          : (controller.logoUrl.value.isNotEmpty
                          ? NetworkImage(controller.logoUrl.value)
                          : null) as ImageProvider?,
                      child: controller.logoFile.value == null &&
                          controller.logoUrl.value.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),

                    const SizedBox(width: 12),

                    // INFO
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            controller.nameCtrl.text,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // ================= CATEGORY NAME FIX =================
                          Text(
                            controller.getCategoryNameById(
                              controller.selectedCategoryId.value,
                            ),
                            style: const TextStyle(color: Colors.grey),
                          ),

                          const SizedBox(height: 4),

                          Row(
                            children: [
                              const Icon(Icons.schedule, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                controller.isOpen24_7.value
                                    ? "24/7"
                                    : "${controller.openingTime.value.format(context)} - ${controller.closingTime.value.format(context)}",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 20),

              // ================= ABOUT =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(controller.aboutCtrl.text),

                    const SizedBox(height: 12),

                    // ================= SERVICES (NAME FIX) =================
                    const Text(
                      'Services Offered',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: controller.selectedOfferServices.map((e) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            controller.getServiceNameById(e),
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 12),

                    // ================= MEDIA =================
                    const Text(
                      'Service Highlights',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    if (controller.mediaUrls.isNotEmpty ||
                        controller.mediaFiles.isNotEmpty)
                      SizedBox(
                        height: 100,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [

                            ...controller.mediaUrls.map((url) {
                              return _imageBox(NetworkImage(url));
                            }),

                            ...controller.mediaFiles.map((file) {
                              return _imageBox(FileImage(file));
                            }),
                          ],
                        ),
                      )
                    else
                      const Text("No media available"),

                    const SizedBox(height: 12),

                    // ================= LOCATION =================
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Container(
                      width: double.infinity,
                      height: 150,
                      color: Colors.grey.shade300,
                      child: const Center(child: Text('Map Placeholder')),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // ================= ACTION BUTTON =================
  Widget _actionBtn(IconData icon, String text) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.white),
      label: Text(text, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  // ================= IMAGE BOX =================
  Widget _imageBox(ImageProvider img) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(image: img, fit: BoxFit.cover),
      ),
    );
  }
}