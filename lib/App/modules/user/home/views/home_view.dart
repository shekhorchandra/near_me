import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../routes/app_routes.dart';
import '../controller/home_controller.dart';
import '../model/HomeServiceModel.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// MAP (No Obx around GoogleMap!)
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(23.8103, 90.4125),
              zoom: 13,
            ),
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
                        child: AppButton(
                          height: 30,
                          onPressed: () {},
                          text: 'Register Service',
                        ),
                      )
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
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const CustomTextField(
                            hint: 'Search services...',
                          ),
                        ),
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
            bottom: 20,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 200,
              child: Obx(() {
                final services = controller.services;

                if (services.isEmpty) {
                  return const SizedBox();
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
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 6,
                            color: Colors.black12,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// Service Icon + Title
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  service.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          /// Rating Stars
                          Row(
                            children: [
                              Row(
                                children: List.generate(
                                  5,
                                      (i) => Icon(
                                    i < service.rating.round()
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(service.rating.toString()),
                            ],
                          ),

                          const SizedBox(height: 6),

                          /// Distance
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text("${service.distance} km away"),
                            ],
                          ),

                          const SizedBox(height: 8),

                          /// Availability Badge
                          Container(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: service.available
                                  ? Colors.green.withOpacity(0.15)
                                  : Colors.red.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              service.available ? "Available" : "Closed",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: service.available
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),

                          const Spacer(),

                          /// Button
                          Align(
                            alignment: Alignment.bottomRight,
                            child: AppButton(
                              height: 40,
                              onPressed: () => controller.openService(service),
                              text: 'View Details',
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