import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/common_app_bar.dart';

import '../controller/ServicerReviewController.dart';
import '../model/ServicerReviewModel.dart';

class ManageReviewsScreen extends StatelessWidget {
  ManageReviewsScreen({super.key});

  final ServiceReviewController controller =
  Get.find<ServiceReviewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: 'Manage Reviews',
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          color: Colors.black,
          onRefresh: () async {
            await controller.fetchServiceReviews(); // Your API method
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _ratingSummary(controller),
              const SizedBox(height: 16),
              _ratingFilters(controller),
              const SizedBox(height: 12),
          
              if (controller.filteredReviews.isEmpty)
                const Center(child: Text("No reviews found")),
          
              ...controller.filteredReviews.map(
                    (review) => _reviewCard(context, review, controller),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showReplyBottomSheet(
    BuildContext context,
    ServicerReviewModel review,
    ServiceReviewController controller,
  ) {
    final TextEditingController replyController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Handle Bar
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Reply to Review",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: replyController,
              maxLines: 4,
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: "Write your reply...",
                hintStyle: const TextStyle(
                  color: Colors.black54,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Colors.black,
                    width: 1.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Obx(() {
              return SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: controller.isReplyLoading.value
                      ? null
                      : () {
                    final comment = replyController.text.trim();

                    if (comment.isEmpty) {
                      Get.snackbar(
                        "Error",
                        "Please write a reply",
                      );
                      return;
                    }

                    controller.replyToReview(
                      parentReviewId: review.id,
                      comment: comment,
                    );
                  },
                  child: controller.isReplyLoading.value
                      ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    "Submit Reply",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 8),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _ratingSummary(ServiceReviewController controller) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffFAFAFA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Reviews (${controller.totalReviews})",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),

          for (int i = 5; i >= 1; i--)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 95,
                    child: Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: 17,
                          color: index < i
                              ? Colors.black
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: controller.totalReviews == 0
                          ? 0
                          : controller.ratingCount(i) / controller.totalReviews,
                      minHeight: 4,
                      backgroundColor: Colors.grey.shade300,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "(${controller.ratingCount(i)})",
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _ratingFilters(ServiceReviewController controller) {
    final filters = [0, 5, 4, 3, 2, 1];

    return Obx(() {
      return Row(
        children: filters.map((rating) {
          final selected = controller.selectedRating.value == rating;

          return GestureDetector(
            onTap: () => controller.selectedRating.value = rating,
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.star,
                    size: 16,
                    color: selected ? Colors.white : Colors.grey,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    rating == 0 ? "All" : rating.toString(),
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }

  Widget _reviewCard(
    BuildContext context,
    ServicerReviewModel review,
    ServiceReviewController controller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 22, child: Icon(Icons.person)),
              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: 16,
                          color: index < review.rating
                              ? Colors.orange
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                _timeAgo(review.createdAt),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),

              const SizedBox(width: 6),
            ],
          ),

          const SizedBox(height: 10),

          Text(review.comment, style: const TextStyle(fontSize: 13)),

          if (review.replies.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...review.replies.map(
                  (reply) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "You replied: ${reply.comment}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),

                    Obx(() {
                      final isDeleting =
                          controller.deletingReviewId.value == reply.id;

                      return IconButton(
                        onPressed: isDeleting
                            ? null
                            : () {
                          _showDeleteConfirmation(
                            controller,
                            reply.id,
                          );
                        },
                        icon: isDeleting
                            ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                            : const Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Colors.red,
                        ),
                      );
                    })
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              height: 34,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showReplyBottomSheet(context, review, controller);
                },
                icon: const Icon(Icons.reply, size: 16),
                label: const Text("Reply"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inDays > 0) return "${diff.inDays} days ago";
    if (diff.inHours > 0) return "${diff.inHours} hours ago";
    if (diff.inMinutes > 0) return "${diff.inMinutes} minutes ago";
    return "Just now";
  }

  void _showDeleteConfirmation(
      ServiceReviewController controller,
      String reviewId,
      ) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: const Text(
          "Delete Reply",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          "Are you sure you want to delete this reply? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteReview(reviewId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
