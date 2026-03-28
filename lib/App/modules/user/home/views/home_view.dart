import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:near_me/App/core/widgets/App_button.dart';

import '../../../../core/widgets/custom_text_field.dart';
import '../../../../routes/app_routes.dart';
import '../controller/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  LinearGradient getBadgeGradient(String type) {
    switch (type) {
      case 'Elite':
        return LinearGradient(
          colors: [Color(0xFF9F8CE2), Color(0xFF7161AA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Pro':
        return LinearGradient(
          colors: [Color(0xFFFFEA00), Color(0xFFFFA600)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'Basic':
        return LinearGradient(
          colors: [Color.fromARGB(255, 72, 248, 140), Color(0xFF4B9868)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [Colors.transparent, Colors.transparent], // Hide if no plan is enrolled
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            /// MAP (No Obx around GoogleMap!)
            Obx(
              () => GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(23.8103, 90.4125),
                  zoom: 12,
                ),
                markers: controller.markers,
                onMapCreated: (GoogleMapController map) {
                  controller.mapController = map;
                },
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
              ),
            ),

            /// TOP UI: buttons + search
            Column(
              children: [
                // Login / Register buttons
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          height: 30,
                          onPressed: () => Get.toNamed(AppRoutes.USER_LOGIN),
                          text: 'Login / Create an user account',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: AppButton(
                          height: 30,
                          onPressed: () => Get.toNamed(AppRoutes.SERVICER_LOGIN),
                          text: 'Register Service',
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔍 SEARCH BAR
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: SizedBox(
                            height: 50,
                            child: CustomTextField(
                              hint: 'Search near me services',

                              // RIGHT SIDE SEARCH BUTTON
                              suffix: IconButton(
                                icon: const Icon(Icons.search),
                                color: Colors.black,
                                onPressed: () {
                                  // your search action here
                                  print("Search clicked");
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.my_location, color: Colors.black),
                          onPressed: () {},
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_alt, color: Colors.black),
                        style: IconButton.styleFrom(backgroundColor: Colors.white),
                        onPressed: () {
                          controller.showFilterBottomSheet();
                        },
                      ),
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

                // YOUR CIRCULAR CATEGORY ROW HERE
                SizedBox(
                  height: 120,
                  child: Obx(() {
                    final categories = controller.services;
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final service = categories[index];

                        String type;
                        IconData badgeIcon;
                        Gradient badgeGradient;

                        if (service.rating >= 4.7) {
                          type = 'Elite';
                          badgeIcon = Iconsax.crown1;
                          badgeGradient = getBadgeGradient(type);
                        } else if (service.rating >= 4.3) {
                          type = 'Pro';
                          badgeIcon = Iconsax.star1;
                          badgeGradient = getBadgeGradient(type);
                        } else if (service.available) {
                          type = 'Basic';
                          badgeIcon = Iconsax.shield_security;
                          badgeGradient = getBadgeGradient(type);
                        } else {
                          type = 'Other';
                          badgeIcon = badgeIcon = Iconsax.crown;
                          badgeGradient = getBadgeGradient(type);
                        }

                        // return GestureDetector(
                        //   onTap: () => controller.focusService(service),
                        //   child: Column(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       // Image + Badge + Rating
                        //       Stack(
                        //         clipBehavior: Clip.none,
                        //         alignment: Alignment.center,
                        //         children: [
                        //           // Circle Image
                        //           Container(
                        //             width: 80,
                        //             height: 80,
                        //             decoration: BoxDecoration(
                        //               shape: BoxShape.circle,
                        //               image: DecorationImage(
                        //                 image: NetworkImage(
                        //                   "https://img.freepik.com/free-vector/top-service-badge_1284-5019.jpg",
                        //                 ),
                        //                 fit: BoxFit.cover,
                        //               ),
                        //               boxShadow: const [
                        //                 BoxShadow(
                        //                   color: Colors.black12,
                        //                   blurRadius: 6,
                        //                   offset: Offset(0, 3),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //
                        //           // Badge
                        //           Positioned(
                        //             top: 4,
                        //             left: -4,
                        //             child: Container(
                        //               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        //               decoration: BoxDecoration(
                        //                 color: badgeColor,
                        //                 borderRadius: BorderRadius.circular(10),
                        //               ),
                        //               child: Text(
                        //                 type,
                        //                 style: const TextStyle(
                        //                   color: Colors.white,
                        //                   fontSize: 8,
                        //                   fontWeight: FontWeight.bold,
                        //                 ),
                        //               ),
                        //             ),
                        //           ),
                        //
                        //           // Rating Overlay
                        //           Positioned(
                        //             bottom: 0,
                        //             child: Container(
                        //               width: 70,
                        //               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                        //               decoration: BoxDecoration(
                        //                 color: Colors.black.withOpacity(0.7),
                        //                 borderRadius: BorderRadius.circular(12),
                        //               ),
                        //               child: Row(
                        //                 mainAxisAlignment: MainAxisAlignment.center,
                        //                 children: [
                        //                   Row(
                        //                     children: List.generate(
                        //                       5, // ✅ generate 5 stars
                        //                           (i) => Icon(
                        //                         i < service.rating.floor()
                        //                             ? Icons.star
                        //                             : (i < service.rating
                        //                             ? Icons.star_half
                        //                             : Icons.star_border),
                        //                         size: 10,
                        //                         color: Colors.orange,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                   const SizedBox(width: 4),
                        //                   Text(
                        //                     service.rating.toStringAsFixed(1),
                        //                     style: const TextStyle(
                        //                       color: Colors.white,
                        //                       fontSize: 10,
                        //                       fontWeight: FontWeight.bold,
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //
                        //       const SizedBox(height: 6), // spacing between image and title
                        //
                        //       // Title below the image + rating
                        //       SizedBox(
                        //         width: 80,
                        //         child: Text(
                        //           service.title.split('(').first, // clean title
                        //           textAlign: TextAlign.center,
                        //           style: const TextStyle(
                        //             color: Colors.black87,
                        //             fontSize: 12,
                        //             fontWeight: FontWeight.w500,
                        //           ),
                        //           maxLines: 2,
                        //           overflow: TextOverflow.ellipsis,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // );

                        return GestureDetector(
                          onTap: () => controller.focusService(service),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Image + Badge + Rating
                              Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  // Circle Image
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          "https://img.freepik.com/free-vector/top-service-badge_1284-5019.jpg",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Badge
                                  Positioned(
                                    top: 4,
                                    left: -4,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      alignment: .center,
                                      decoration: BoxDecoration(
                                        gradient: badgeGradient,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        badgeIcon,
                                        size: 16,
                                        color: Colors.white, // Icon color
                                      ),
                                    ),
                                  ),

                                  // Rating Overlay
                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                      width: 30,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: List.generate(
                                                1, // 5 stars
                                                (i) => Icon(
                                                  i < service.rating.floor()
                                                      ? Icons.star
                                                      : (i < service.rating
                                                            ? Icons.star_half
                                                            : Icons.star_border),
                                                  size: 10,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              service.rating.toStringAsFixed(1),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 4),
                              // Title below the image + rating
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ), // optional padding
                                decoration: BoxDecoration(
                                  color: Colors.black, // ✅ background color
                                  borderRadius: BorderRadius.circular(
                                    6,
                                  ), // optional rounded corners
                                ),
                                child: Text(
                                  service.title.split('(').first,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
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

            /// SERVICE CARDS (PageView)
            Positioned(
              bottom: 10,
              left: 0,
              right: 50,
              child: SizedBox(
                height: 220,
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

                            const SizedBox(height: 4),

                            /// Company
                            Text(
                              "Company Name will show here", // TODO: show company name dynamically
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black54,
                              ),
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
                                      color: Colors.black,
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
      ),
    );
  }
}
