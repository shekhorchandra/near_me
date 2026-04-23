import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/modules/user/category/user_category_service_details/models/ReviewModel.dart';
import 'package:near_me/App/modules/user/category/user_category_service_details/views/reply_dialog_view.dart';
import '../../../../../core/widgets/common_app_bar.dart';
import '../../../../../routes/app_routes.dart';
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
                    Get.toNamed(AppRoutes.CONVERSATION);
                  },
                  icon: const Icon(Icons.chat, color: Colors.white),
                  label: const Text("Chat", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    controller.callNumber(controller.phone.value);
                  },
                  icon: const Icon(Icons.call, color: Colors.white),
                  label: const Text("Call", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                ),

                ElevatedButton.icon(
                  onPressed: () {
                    controller.openWebsite(controller.website.value);
                  },
                  icon: const Icon(Icons.public, color: Colors.white),
                  label: const Text("Website", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                ),
              ],
            ),
          ),
        ),

        // ================= BODY =================
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator(color: Colors.black))
            : SingleChildScrollView(
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

                              return Image.network(
                                img,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.image, size: 50),
                                ),
                              );
                            },
                          ),

                          // LEFT BUTTON
                          Positioned(
                            left: 5,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                                onPressed: () {
                                  controller.pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              ),
                            ),
                          ),

                          // RIGHT BUTTON
                          Positioned(
                            right: 5,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: IconButton(
                                icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                                onPressed: () {
                                  controller.pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
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
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(controller.image.value),
                                  ),
                                  const SizedBox(width: 12),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          children: [
                                            const Icon(Icons.star, size: 16),
                                            const SizedBox(width: 4),
                                            Text(controller.rating.value.toString()),
                                            const SizedBox(width: 12),
                                            const Icon(Icons.schedule, size: 16),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                controller.schedule.value,
                                                overflow: TextOverflow.ellipsis,
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
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),
                              Text(controller.about.value),

                              const SizedBox(height: 15),

                              // ================= SERVICES =================
                              const Text(
                                "Services Offered",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                                          borderRadius: BorderRadius.circular(20),
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
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),

                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.highlightServices.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 1.00, // taller card
                                ),
                                itemBuilder: (context, index) {
                                  final item = controller.highlightServices[index];

                                  return Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // ================= IMAGE =================
                                        Expanded(
                                          child: Image.network(
                                            item["image"] ?? '',
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Container(
                                              color: Colors.grey.shade300,
                                              child: const Icon(Icons.image, size: 40),
                                            ),
                                          ),
                                        ),

                                        // ================= TEXT SECTION =================
                                        Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item["title"] ?? '',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
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
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5),

                              Container(
                                width: double.infinity,
                                height: 150,
                                color: Colors.grey.shade300,
                                child: Center(child: Text(controller.location.value)),
                              ),

                              const SizedBox(height: 15),

                              // ================= REVIEWS SECTION =================
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Reviews (${controller.reviews.length})",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // View All Logic
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                "View all (${controller.reviews.length})",
                                                style: TextStyle(color: Colors.grey[600]),
                                              ),
                                              const Icon(
                                                Icons.chevron_right,
                                                size: 20,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    ...controller.reviews.map(
                                      (review) => buildReviewCard(context, review),
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
    );
  }

  // --- Helper function to build the card ---
  Widget buildReviewCard(BuildContext context, dynamic review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, Time, Stars
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150',
                ), // Replace with review.userImage
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: review.userName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            children: const [
                              TextSpan(
                                text: " (You)",
                                style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          "2 days ago", // Replace with review.createdAt
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < 5 ? Icons.star : Icons.star_border, // Use review.rating
                          color: Colors.amber,
                          size: 18,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Review Text
          Text(
            review.comment,
            style: TextStyle(color: Colors.grey[800], fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 16),

          // Footer: Like, Reply, View Replies
          Row(
            children: [
              // Like Icon
              const Icon(Icons.favorite_border, size: 20, color: Colors.black87),
              const SizedBox(width: 5),
              const Text("124", style: TextStyle(fontSize: 13)), // Replace with review.likes
              const SizedBox(width: 20),

              // Reply Icon
              const Icon(Icons.reply_outlined, size: 20, color: Colors.black87),
              const SizedBox(width: 5),
              const Text("01", style: TextStyle(fontSize: 13)), // Replace with review.repliesCount

              const Spacer(),

              // View Replies Button
              InkWell(
                onTap: () {
                  // Open replies or show dialog
                  showDialog(
                    context: context,
                    builder: (_) => ReplyDialogView(
                        serviceId: controller.serviceId, // Pass the real ID
                        parentId: review.id,
                        isReview: false
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    children: [
                      Text("View replies", style: TextStyle(color: Colors.white, fontSize: 12)),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right, color: Colors.white, size: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
