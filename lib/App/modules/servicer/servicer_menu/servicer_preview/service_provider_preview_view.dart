import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
              // _actionBtn(Icons.chat, "Chat"),
              // _actionBtn(Icons.call, "Call"),
              // _actionBtn(Icons.public, "Website"),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER IMAGE SLIDER =================
              SizedBox(
                height: 220,
                child: (controller.mediaUrls.isNotEmpty ||
                    controller.mediaFiles.isNotEmpty)
                    ? PageView(
                  children: [
                    // Server images
                    ...controller.mediaUrls.map(
                          (url) => ClipRRect(
                        child: Image.network(
                          url,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // Newly selected images
                    ...controller.mediaFiles.map(
                          (file) => ClipRRect(
                        child: Image.file(
                          file,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                )
                    : Container(
                  width: double.infinity,
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Text("No Image"),
                  ),
                ),
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
                                    : null)
                                as ImageProvider?,
                      child:
                          controller.logoFile.value == null &&
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

                    // ================= SERVICE HIGHLIGHTS =================
                    const Text(
                      'Service Highlights',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (controller.mediaUrls.isNotEmpty ||
                        controller.mediaFiles.isNotEmpty)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount:
                        controller.mediaUrls.length + controller.mediaFiles.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.3,
                        ),
                        itemBuilder: (context, index) {
                          final isNetwork = index < controller.mediaUrls.length;

                          return ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: isNetwork
                                  ? Image.network(
                                controller.mediaUrls[index],
                                fit: BoxFit.cover,
                              )
                                  : Image.file(
                                controller.mediaFiles[
                                index - controller.mediaUrls.length],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      )
                    else
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Center(
                          child: Text("No service highlights available"),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // ================= LOCATION =================
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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

                            map.animateCamera(
                              CameraUpdate.newLatLng(LatLng(lat, lng)),
                            );
                          },

                          markers: {
                            Marker(
                              markerId: const MarkerId("preview_location"),
                              position: LatLng(lat, lng),
                            ),
                          },

                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                          mapToolbarEnabled: false,
                        );
                      }),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
