import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:near_me/App/modules/user/category/user_category_service_details/models/ReviewModel.dart';
import 'package:near_me/App/modules/user/category/user_category_service_details/views/reply_dialog_view.dart';
import '../../../../../core/widgets/common_app_bar.dart';
import '../../../../../data/services/storage_service.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../servicer/servicer_chat/servicer_chat/helper/TimeFormatter.dart';
import '../../FullImageView.dart';
import '../controller/ServiceDetailsController.dart';

class ServiceDetailsView extends GetView<ServiceDetailsController> {
  const ServiceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: CommonAppBar(title: controller.title.value),

        // ================= BOTTOM BUTTONS =================
        bottomNavigationBar: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    final token = Get.find<StorageService>().accessToken;

                    if (token == null || token.isEmpty) {
                      Get.snackbar(
                        "Login Required",
                        "Please login first to start chatting",
                        snackPosition: SnackPosition.TOP,
                        duration: const Duration(seconds: 2),
                      );

                      Future.delayed(const Duration(seconds: 2), () {
                        Get.toNamed(AppRoutes.USER_LOGIN);
                      });

                      return;
                    }

                    print("providerId = ${controller.providerId.value}");
                    print("providerName = ${controller.providerName.value}");

                    if (controller.providerId.value.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Provider information is not loaded yet.",
                      );
                      return;
                    }

                    Get.toNamed(
                      AppRoutes.CONVERSATION,
                      arguments: {
                        "userId": controller.providerId.value,
                        "name": controller.providerName.value,
                        "image": controller.image.value,
                      },
                    );
                  },
                  icon: const Icon(Icons.chat, color: Colors.white),
                  label: const Text(
                    "Chat",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    final token = Get.find<StorageService>().accessToken;

                    if (token == null || token.isEmpty) {
                      Get.snackbar(
                        "Login Required",
                        "Please login first to make a call",
                        snackPosition: SnackPosition.TOP,
                      );
                      return;
                    }

                    controller.callNumber(controller.phone.value);
                  },
                  icon: const Icon(Icons.call, color: Colors.white),
                  label: const Text(
                    "Call",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    controller.openWebsite(controller.website.value);
                  },
                  icon: const Icon(Icons.public, color: Colors.white),
                  label: const Text(
                    "Website",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),

        // ================= BODY =================
        body: controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(color: Colors.black),
              )
            : RefreshIndicator(
                color: Colors.black,
                onRefresh: () async {
                  await controller.fetchServiceDetails();
                  await controller.fetchReviews();
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // ================= IMAGE CAROUSEL =================
                      SizedBox(
                        height: 220,
                        width: double.infinity,
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: controller.pageController,
                              itemCount: controller.media.length,
                              itemBuilder: (context, index) {
                                final img = controller.media[index];

                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() => FullImageView(imageUrl: img));
                                  },
                                  child: Image.network(
                                    img,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      color: Colors.grey.shade300,
                                      child: const Icon(Icons.image, size: 50),
                                    ),
                                  ),
                                );
                              },
                            ),

                            // LEFT BUTTON
                            Positioned(
                              left: 10,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.25),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      controller.pageController.previousPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),

                            // RIGHT BUTTON
                            Positioned(
                              right: 10,
                              top: 0,
                              bottom: 0,
                              child: Center(
                                child: ClipOval(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.25),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      onPressed: () {
                                        controller.pageController.nextPage(
                                          duration: const Duration(
                                            milliseconds: 300,
                                          ),
                                          curve: Curves.easeInOut,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ================= CURVED WHITE SECTION =================
                      Transform.translate(
                        offset: const Offset(0, -20),
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ================= PROFILE =================
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          () => FullImageView(
                                            imageUrl: controller.image.value,
                                          ),
                                        );
                                      },
                                      child: ClipOval(
                                        child: Image.network(
                                          controller.image.value,
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              Container(
                                                width: 60,
                                                height: 60,
                                                color: Colors.grey.shade300,
                                                child: const Icon(Icons.person),
                                              ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.title.value,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            controller.category.value,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              const Icon(Icons.star, size: 16),
                                              const SizedBox(width: 4),
                                              Text(
                                                controller.averageRating.value
                                                    .toStringAsFixed(1),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              const Icon(
                                                Icons.schedule,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              Expanded(
                                                child: Text(
                                                  controller.schedule.value,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const Divider(),

                                // ================= ABOUT =================
                                const Text(
                                  "About",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(controller.about.value),

                                const SizedBox(height: 15),

                                // ================= SERVICES =================
                                const Text(
                                  "Services Offered",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: controller.servicesOffered
                                      .map(
                                        (service) => Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(service),
                                        ),
                                      )
                                      .toList(),
                                ),

                                const SizedBox(height: 15),

                                // ================= HIGHLIGHTS =================
                                const Text(
                                  "Service Highlights",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      controller.highlightServices.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                        childAspectRatio: 1.00, // taller card
                                      ),
                                  itemBuilder: (context, index) {
                                    final item =
                                        controller.highlightServices[index];

                                    return Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // ================= IMAGE =================
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.to(
                                                  () => FullImageView(
                                                    imageUrl:
                                                        item["image"] ?? '',
                                                  ),
                                                );
                                              },
                                              child: Image.network(
                                                item["image"] ?? '',
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    Container(
                                                      color:
                                                          Colors.grey.shade300,
                                                      child: const Icon(
                                                        Icons.image,
                                                        size: 40,
                                                      ),
                                                    ),
                                              ),
                                            ),
                                          ),

                                          // ================= TEXT SECTION =================
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item["title"] ?? '',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),

                                                // const SizedBox(height: 4),
                                                //
                                                // Text(
                                                //   item["description"] ?? '',
                                                //   style: const TextStyle(
                                                //     fontSize: 12,
                                                //     color: Colors.grey,
                                                //   ),
                                                //   maxLines: 2,
                                                //   overflow: TextOverflow.ellipsis,
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                                const SizedBox(height: 15),

                                // ================= LOCATION =================
                                const Text(
                                  "Location",
                                  style: TextStyle(fontWeight: FontWeight.bold),
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

                                        // move camera to existing location once
                                        map.animateCamera(
                                          CameraUpdate.newLatLng(
                                            LatLng(lat, lng),
                                          ),
                                        );
                                      },

                                      onTap: (pos) {
                                        controller.latitude.value =
                                            pos.latitude;
                                        controller.longitude.value =
                                            pos.longitude;
                                      },

                                      markers: {
                                        Marker(
                                          markerId: const MarkerId(
                                            "service_location",
                                          ),
                                          position: LatLng(lat, lng),
                                          draggable: true,
                                          onDragEnd: (pos) {
                                            controller.latitude.value =
                                                pos.latitude;
                                            controller.longitude.value =
                                                pos.longitude;
                                          },
                                        ),
                                      },
                                    );
                                  }),
                                ),

                                const SizedBox(height: 15),

                                // ================= REVIEWS SECTION =================
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Reviews (${controller.reviews.length})",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              final isLoggedIn =
                                                  await controller.checkLogin();

                                              if (!isLoggedIn) {
                                                Get.snackbar(
                                                  "Login Required",
                                                  "Please login first to view reviews",
                                                  snackPosition:
                                                      SnackPosition.TOP,
                                                );

                                                Future.delayed(
                                                  const Duration(seconds: 2),
                                                  () {
                                                    Get.toNamed(
                                                      AppRoutes.USER_LOGIN,
                                                    );
                                                  },
                                                );

                                                return;
                                              }

                                              Get.toNamed(
                                                AppRoutes.REVIEWS,
                                                arguments: {
                                                  "serviceId":
                                                      controller.serviceId,
                                                },
                                              );
                                            },
                                            child: Text(
                                              "View all (${controller.filteredReviews.length}) >",
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      ...controller.reviews.map(
                                        (review) =>
                                            buildReviewCard(context, review),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  // --- Helper function to build the card ---
  Widget buildReviewCard(BuildContext context, ReviewModel review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  review.userName.isNotEmpty
                      ? review.userName[0].toUpperCase()
                      : "U",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      ServiceTimeFormatter.timeAgo(review.createdAt),
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              /// Rating badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 3),
                    Text(
                      review.rating.toString(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// COMMENT
          Text(
            review.comment,
            style: TextStyle(
              color: Colors.grey.shade800,
              height: 1.4,
              fontSize: 14,
            ),
          ),

          /// ACTIONS ROW
          // Row(
          //   children: [
          //     if (review.replies.isNotEmpty) _buildReplyToggle(review),
          //
          //     const Spacer(),
          //
          //     TextButton.icon(
          //       onPressed: () {
          //         Get.dialog(
          //           ReplyDialogView(
          //             serviceId: controller.serviceId,
          //             parentId: review.id,
          //             isReview: false,
          //           ),
          //         );
          //       },
          //       icon: const Icon(Icons.reply, color: Colors.black),
          //       label: const Text(
          //         "Reply",
          //         style: TextStyle(
          //           color: Colors.black,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //     ),
          //   ],
          // ),

          /// REPLIES SECTION
          _buildReplies(review),
        ],
      ),
    );
  }

  Widget _buildReplyToggle(ReviewModel review) {
    return Obx(() {
      return InkWell(
        onTap: () {
          review.isExpanded.value = !review.isExpanded.value;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            review.isExpanded.value
                ? "Hide replies"
                : "View replies (${review.replies.length})",
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ),
      );
    });
  }

  Widget _buildReplies(ReviewModel review) {
    return Obx(() {
      if (!review.isExpanded.value) return const SizedBox();

      return Column(
        children: review.replies.map((reply) {
          return Container(
            margin: const EdgeInsets.only(top: 10, left: 30),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.orange.shade100,
                      child: Text(
                        reply.userName.isNotEmpty
                            ? reply.userName[0].toUpperCase()
                            : "U",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      reply.userName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(reply.comment),
              ],
            ),
          );
        }).toList(),
      );
    });
  }
}
