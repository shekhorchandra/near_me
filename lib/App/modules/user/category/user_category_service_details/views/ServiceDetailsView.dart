import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/modules/user/category/user_category_service_details/views/reply_dialog_view.dart';
import '../../../../../core/widgets/common_app_bar.dart';
import '../../../../../routes/app_routes.dart';

import '../../../chat/user_chat_conversation/views/conversation_view.dart';
import '../controller/ServiceDetailsController.dart';

class ServiceDetailsView extends GetView<ServiceDetailsController> {
  const ServiceDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: controller.title),
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
                label: const Text('Chat', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.call, color: Colors.white),
                label: const Text('Call', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Image
            Image.asset(controller.image, width: double.infinity, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 8),

            // Profile Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  CircleAvatar(radius: 30, backgroundImage: AssetImage(controller.image)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(controller.category, style: const TextStyle(color: Colors.grey)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, size: 16, color: Colors.black),
                            const SizedBox(width: 4),
                            Text(controller.rating.toString()),
                            const SizedBox(width: 12),
                            const Icon(Icons.schedule, size: 16),
                            const SizedBox(width: 4),
                            Text(controller.schedule),
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
                  Text(controller.about),
                  const SizedBox(height: 12),

                  // Services Offered
                  const Text(
                    'Services Offered',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.servicesOffered.map((service) {
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

                  // Highlights
                  const Text(
                    'Service Highlights',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.3, // slightly taller for text overlay
                    ),
                    itemCount: controller.highlights.length,
                    itemBuilder: (context, index) {
                      final highlight = controller.highlights[index]; // HighlightModel
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          children: [
                            // Image
                            Positioned.fill(child: Image.asset(highlight.image, fit: BoxFit.cover)),
                            // Semi-transparent overlay for text
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                color: Colors.black.withOpacity(0.5),
                                child: Text(
                                  highlight.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Location Map (placeholder)
                  const Text(
                    'Location',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    height: 150,
                    color: Colors.grey.shade300,
                    child: const Center(child: Text('Static Map Here')),
                  ),
                  const SizedBox(height: 12),

                  // Reviews
                  // Reviews
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Reviews',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          // navigate to full reviews page
                          Get.toNamed(AppRoutes.REVIEWS);
                        },
                        child: const Text('View All(45) ≫', style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),

                  ...controller.reviews.map((review) {
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: AssetImage(review.userImage),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${review.userName} • ${review.daysAgo} days ago',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),

                            const SizedBox(height: 6),

                            Text(review.review),

                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.favorite_border),
                                ),
                                IconButton(onPressed: () {}, icon: const Icon(Icons.share)),

                                const Spacer(), // pushes the next widget to the right

                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => const ReplyDialogView(),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    // backgroundColor: const Color(0xFF555555),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: const Text(
                                    'View Replies ➤',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
