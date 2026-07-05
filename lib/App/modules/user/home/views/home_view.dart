import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../core/widgets/App_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../data/services/storage_service.dart';
import '../../../../routes/app_routes.dart';
import '../../../auth/internet/controller/internet_controller.dart';
import '../controller/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final box = GetStorage();

  LinearGradient getBadgeGradient(String type) {
    switch (type) {
      case "Elite":
        return const LinearGradient(
          colors: [Color(0xFF9F8CE2), Color(0xFF7161AA)],
        );

      case "Pro":
        return const LinearGradient(
          colors: [Color(0xFFFFEA00), Color(0xFFFFA600)],
        );

      case "Basic":
        return const LinearGradient(
          colors: [Color(0xFF48F88C), Color(0xFF4B9868)],
        );

      default:
        return const LinearGradient(
          colors: [Colors.transparent, Colors.transparent],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Obx(() {
            //   final internet = Get.find<InternetController>();
            //
            //   if (internet.isConnected.value) {
            //     return const SizedBox();
            //   }
            //
            //   return Container(
            //     width: double.infinity,
            //     color: Colors.red,
            //     padding: const EdgeInsets.all(10),
            //     child: const SafeArea(
            //       child: Text(
            //         "No Internet Connection",
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //           color: Colors.white,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //     ),
            //   );
            // }),
            /// GOOGLE MAP
            Obx(
              () => GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(23.8700, 90.4800),
                  zoom: 12,
                ),
                markers: controller.markers.value,
                circles: controller.circles.value,
                polylines: controller.polylines.value,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                onMapCreated: (map) {
                  controller.mapController = map;
                },
              ),
            ),

            /// TOP UI
            Column(
              children: [
                /// LOGIN / REGISTER
                Obx(() {
                  if (controller.isLoggedIn.value) {
                    return const SizedBox.shrink();
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            height: 34,
                            text: "Login / Create a user account",
                            onPressed: () {
                              box.write("selectedRole", "USER");
                              Get.toNamed(AppRoutes.USER_LOGIN);
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppButton(
                            height: 34,
                            text: "Login / Register a Service",
                            onPressed: () {
                              box.write("selectedRole", "PROVIDER");
                              Get.toNamed(AppRoutes.SERVICER_LOGIN);
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                /// SEARCH + FILTER
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: CustomTextField(
                            controller: controller.searchController,
                            hint: "Search near me",
                            icon: Icons.search,
                            onChanged: (value) {
                              controller.searchServices();
                            },

                            // onSubmitted: (_) {
                            //   controller.searchServices();
                            // },
                            suffix: InkWell(
                              onTap: controller.showFilterBottomSheet,
                              child: const Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Icon(Icons.tune),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 6),

                      // LOCATION BUTTON
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.my_location,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            controller.loadNearestServices();
                          },
                        ),
                      ),

                      const SizedBox(width: 6),
                      // NOTIFICATION BUTTON
                      Obx(() {
                        final unread = controller.notificationController.unreadCount.value;

                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: IconButton(
                                icon: const Icon(
                                  Icons.notifications,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  final token = StorageService().accessToken;

                                  if (token == null || token.isEmpty) {
                                    Get.snackbar(
                                      "Login Required",
                                      "Please login first.",
                                    );
                                    return;
                                  }

                                  Get.toNamed(AppRoutes.NOTIFICATIONS);
                                },
                              ),
                            ),

                            if (unread > 0)
                              Positioned(
                                right: 5,
                                top: 5,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  constraints: const BoxConstraints(
                                    minHeight: 18,
                                    minWidth: 18,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      unread > 99 ? "99+" : unread.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                /// TOP RATED BADGE SERVICES
                SizedBox(
                  height: 120,
                  child: Obx(() {
                    final list = controller.services
                        .where((e) => e.rating >= 4.0)
                        .toList();

                    if (list.isEmpty) return const SizedBox();

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final service = list[index];

                        String type;

                        if (service.rating >= 4.7) {
                          type = "Elite";
                        } else if (service.rating >= 4.0) {
                          type = "Pro";
                        } else {
                          type = "Basic";
                        }

                        return GestureDetector(
                          onTap: () =>
                              controller.focusService(service, index: index),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: getBadgeGradient(type),
                                    ),
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundImage: NetworkImage(
                                        service.image,
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.black,
                                      child: Icon(
                                        type == "Elite"
                                            ? Iconsax.crown1
                                            : Iconsax.star1,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 0,
                                    left: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 12,
                                            color: Colors.amber,
                                          ),
                                          const SizedBox(width: 2),
                                          Text(
                                            service.rating.toStringAsFixed(1),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 3),

                              SizedBox(
                                width: 90,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    service.title,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),

            /// BOTTOM SERVICE CARDS
            Positioned(
              left: 0,
              right: 0,
              bottom: 10,
              child: SizedBox(
                height: 200,
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    );
                  }

                  final services = controller.filteredServices;

                  if (services.isEmpty) {
                    return Center(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.inbox_outlined,
                                size: 80,
                                color: Colors.black,
                              ),
                              const SizedBox(height: 16),

                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: const [
                                    Text(
                                      "No Services Found",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "We couldn't find any services at the moment.\nTry again later or adjust your filters.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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

                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.SERVICE_DETAILS,
                            arguments: {"id": service.id},
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const [
                              BoxShadow(blurRadius: 10, color: Colors.black12),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                service.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Colors.orange,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(service.rating.toStringAsFixed(1)),
                                ],
                              ),

                              const SizedBox(height: 8),

                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${service.distance.toStringAsFixed(1)} miles away",
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: service.available
                                      ? Colors.green.withOpacity(.1)
                                      : Colors.red.withOpacity(.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  service.available ? "Open Now" : "Closed",
                                  style: TextStyle(
                                    color: service.available
                                        ? Colors.green
                                        : Colors.red,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              const Spacer(),

                              // SizedBox(
                              //   width: double.infinity,
                              //   child: GestureDetector(
                              //     onTap: () {
                              //
                              //     }, // prevents card tap conflict
                              //     child: AppButton(
                              //       text: "View Route",
                              //       height: 38,
                              //       onPressed: () {
                              //         controller.showRouteToService(
                              //           service.lat,
                              //           service.lng,
                              //         );
                              //       },
                              //     ),
                              //   ),
                              // ),
                              Row(
                                children: [
                                  Expanded(
                                    child: AppButton(
                                      text: "View Details",
                                      height: 38,
                                      onPressed: () {
                                        Get.toNamed(
                                          AppRoutes.SERVICE_DETAILS,
                                          arguments: {"id": service.id},
                                        );
                                      },
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: AppButton(
                                      text: "View Route",
                                      height: 38,
                                      onPressed: () {
                                        controller.showRouteToService(
                                          service.lat,
                                          service.lng,
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
