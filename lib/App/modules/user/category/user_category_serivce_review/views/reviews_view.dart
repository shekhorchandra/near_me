import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/common_app_bar.dart';
import '../../../../servicer/servicer_chat/servicer_chat/helper/TimeFormatter.dart';
import '../../user_category_service_details/models/ReviewModel.dart';
import '../../user_category_service_details/views/reply_dialog_view.dart';
import '../controller/reviews_controller.dart';

class ReviewsView extends GetView<ReviewsController> {
  const ReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReviewsController>();
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background for contrast
      appBar: CommonAppBar(title: 'Reviews'),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        label: const Text("Write Review"),
        icon: const Icon(Icons.rate_review),
        onPressed: () {
          Get.dialog(
            ReplyDialogView(serviceId: controller.serviceId, isReview: true),
          );
        },
      ),

      body: Obx(() {
        if (controller.isLoading.value)
          return const Center(child: CircularProgressIndicator());
        if (controller.filteredReviews.isEmpty)
          return const Center(child: Text("No Reviews Found"));

        return Column(
          children: [
            // View All Header Row (Matching the design)

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.filteredReviews.length,
                itemBuilder: (_, i) {
                  return ReviewCard(
                    item: controller.filteredReviews[i],
                    serviceId: controller.serviceId, // Pass down to card
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

class ReviewCard extends StatefulWidget {
  final ReviewModel item;
  final String serviceId;
  final double left;

  const ReviewCard({
    super.key,
    required this.item,
    required this.serviceId,
    this.left = 0,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool showReplies = false;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReviewsController>();

    final item = widget.item;
    debugPrint("Review: ${item.comment}");
    debugPrint("Replies count: ${item.replies.length}");

    for (final r in item.replies) {
      debugPrint("Reply: ${r.comment}");
    }

    return Container(
      margin: EdgeInsets.only(left: widget.left, top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER: Avatar | Name & Time & Stars
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          ServiceTimeFormatter.timeAgo(item.createdAt),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < item.rating ? Icons.star : Icons.star_border,
                          size: 16,
                          color: Colors.amber,
                        );
                      }),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      item.comment,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        height: 1.4,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          /// FOOTER: Likes | Reply | View Replies Button
          Row(
            children: [
              /// DARK "VIEW REPLIES" BUTTON
              if (item.replies.isNotEmpty)
                InkWell(
                  onTap: () {
                    setState(() {
                      showReplies = !showReplies;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      showReplies
                          ? "Hide replies"
                          : "View replies (${item.replies.length})",
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ),

              const Spacer(),

              /// REPLY BUTTON
              InkWell(
                onTap: () {
                  Get.dialog(
                    ReplyDialogView(
                      parentId: item.id,
                      serviceId: widget.serviceId,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.reply_outlined, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        "${item.replies.length}",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              /// DELETE BUTTON
              if (item.userId == controller.userId)
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    Get.defaultDialog(
                      title: "Delete Review",
                      middleText: "Are you sure?",
                      onConfirm: () async {
                        Get.back();
                        await controller.deleteReview(item.id);
                      },
                    );
                  },
                ),
            ],
          ),

          /// SHOW REPLIES
          if (showReplies)
            Column(
              children: item.replies.map((reply) {
                return Container(
                  margin: const EdgeInsets.only(left: 20, top: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reply.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(reply.comment),
                          ],
                        ),
                      ),

                      if (reply.userId == controller.userId)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () async {
                            Get.defaultDialog(
                              title: "Delete Reply",
                              middleText: "Delete this reply?",
                              textCancel: "Cancel",
                              textConfirm: "Delete",
                              confirmTextColor: Colors.white,
                              onConfirm: () async {
                                Get.back();
                                await controller.deleteReview(reply.id);
                              },
                            );
                          },
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
