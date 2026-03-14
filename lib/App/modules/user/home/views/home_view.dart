import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../routes/app_routes.dart';
import '../controller/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// MAP (No Obx around GoogleMap!)
          GoogleMap(

            initialCameraPosition: const CameraPosition(target: LatLng(23.8103, 90.4125), zoom: 13),
            markers: controller.markers, // RxSet works directly
            onMapCreated: (GoogleMapController map) {

              controller.mapController = map;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),

          /// TOP UI: buttons + search
          SafeArea(
            child: Column(
              children: [
                // Login / Register buttons
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          height: 30,
                          onPressed: () {
                            Get.toNamed(AppRoutes.USER_LOGIN);
                          },
                          text: 'Login / Sign Up',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButton(height: 30, onPressed: () {}, text: 'Register Service'),
                      ),
                    ],
                  ),
                ),

                // Search bar + location + notification
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const CustomTextField(hint: 'Search services...'),
                        ),
                      ),

                      IconButton(
                        icon: const Icon(Icons.filter_alt, color: Colors.black),
                        style: IconButton.styleFrom(backgroundColor: Colors.white),
                        onPressed: () {
                          Get.bottomSheet(
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// TITLE
                                  const Center(
                                    child: Text(
                                      "Filter Services",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  /// RATING TITLE
                                  const Text(
                                    "Rating",
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),

                                  Obx(
                                    () => Slider(
                                      value: controller.selectedRating.value,
                                      min: 0,
                                      max: 5,
                                      divisions: 5,
                                      activeColor: Colors.black,
                                      label: controller.selectedRating.value.toString(),
                                      onChanged: (value) {
                                        controller.selectedRating.value = value;
                                      },
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  /// RADIUS TITLE
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      /// Label + value
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Radius",
                                            style: TextStyle(fontWeight: FontWeight.w600),
                                          ),
                                          Obx(
                                            () => Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 6,
                                                vertical: 2,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200, // subtle background
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                "${controller.selectedRadius.value.toStringAsFixed(0)} km",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 6),

                                      /// Slider
                                      Obx(
                                        () => Slider(
                                          value: controller.selectedRadius.value.clamp(
                                            1,
                                            50,
                                          ), // safe clamp
                                          min: 1,
                                          max: 50,
                                          divisions: 49,
                                          activeColor: Colors.black,
                                          label:
                                              "${controller.selectedRadius.value.toStringAsFixed(0)} km",
                                          onChanged: (value) {
                                            controller.selectedRadius.value = value;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 15),

                                  /// CATEGORY TITLE
                                  const Text(
                                    "Category",
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),

                                  const SizedBox(height: 10),

                                  /// CATEGORY CHIPS
                                  Obx(
                                    () => Wrap(
                                      spacing: 10,
                                      runSpacing: 10,
                                      children:
                                          [
                                            "Car Wash",
                                            "Bike Repair",
                                            "Auto Service",
                                            "Cleaning",
                                          ].map((category) {
                                            final selected = controller.selectedCategories.contains(
                                              category,
                                            );

                                            return GestureDetector(
                                              onTap: () {
                                                if (selected) {
                                                  controller.selectedCategories.remove(category);
                                                } else {
                                                  controller.selectedCategories.add(category);
                                                }
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: selected
                                                      ? Colors.black
                                                      : Colors.grey.shade200,
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  category,
                                                  style: TextStyle(
                                                    color: selected ? Colors.white : Colors.black,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  ),

                                  const SizedBox(height: 25),

                                  /// BUTTONS
                                  Row(
                                    children: [
                                      /// CLEAR BUTTON
                                      Expanded(
                                        child: AppButton(
                                          onPressed: () {
                                            onPressed:
                                            () {
                                              controller.selectedRating.value = 0;
                                              controller.selectedRadius.value = 10;
                                              controller.selectedCategories.clear();
                                              controller.applyFilters();
                                              Get.back();
                                            };
                                          },
                                          text: 'Clear',
                                        ),
                                      ),

                                      const SizedBox(width: 10),

                                      /// APPLY BUTTON
                                      Expanded(
                                        child: AppButton(
                                          onPressed: () {
                                            controller.applyFilters();
                                            Get.back();
                                          },
                                          text: 'Apply Filters',
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.my_location, color: Colors.black),
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.notifications, color: Colors.black),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// SERVICE CARDS (PageView)
          Positioned(
            bottom: 10,
            left: 0,
            right: 50,
            child: SizedBox(
              height: 200,
              child: Obx(() {
                final services = controller.filteredServices.isNotEmpty
                    ? controller.filteredServices
                    : controller.services;

                if (services.isEmpty) {
                  return const Center(
                    child: Text(
                      "No services found",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  );
                }

                return PageView.builder(
                  controller: controller.pageController,
                  itemCount: services.length,
                  onPageChanged: (index) {
                    controller.focusService(services[index]);
                  },
                  itemBuilder: (context, index) {
                    final service = services[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(blurRadius: 10, color: Colors.black12, offset: Offset(0, 3)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// TITLE
                          Text(
                            service.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 8),

                          /// RATING
                          Row(
                            children: [
                              Row(
                                children: List.generate(
                                  5,
                                  (i) => Icon(
                                    i < service.rating.round() ? Icons.star : Icons.star_border,
                                    size: 16,
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                service.rating.toStringAsFixed(1),
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          /// DISTANCE
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                "${service.distance.toStringAsFixed(1)} km away",
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// STATUS
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: service.available
                                  ? Colors.green.withOpacity(0.15)
                                  : Colors.red.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              service.available ? "Available" : "Closed",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: service.available ? Colors.green : Colors.red,
                              ),
                            ),
                          ),

                          const Spacer(),

                          /// BUTTON
                          SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              height: 38,
                              text: "View Details",
                              onPressed: () {
                                controller.openService(service);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
