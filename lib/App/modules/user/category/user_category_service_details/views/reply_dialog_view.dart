import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/services/storage_service.dart';
import '../../../../services/contants/api_constants.dart';
import '../../user_category_serivce_review/controller/reviews_controller.dart';

class ReplyDialogView extends StatefulWidget {
  final String? parentId;
  final String serviceId; // Added this
  final bool isReview;

  const ReplyDialogView({
    super.key,
    required this.serviceId, // Make it required
    this.parentId,
    this.isReview = false,
  });

  @override
  State<ReplyDialogView> createState() => _ReplyDialogViewState();
}

class _ReplyDialogViewState extends State<ReplyDialogView> {
  final text = TextEditingController();
  int rating = 5;

  Future<void> submit() async {
    try {
      final dio = Dio();
      final storage = Get.find<StorageService>();
      final token = storage.accessToken;
      final userId = storage.userId;

      if (token == null || token.isEmpty) {
        Get.snackbar("Error", "Please login first");
        return;
      }

      final response = await dio.post(
        "${ApiConstants.baseUrl}/api/v1/review/create",
        data: {
          "user": userId,
          "service": widget.serviceId,
          "comment": text.text,
          if (widget.isReview) "rating": rating,
          if (widget.parentId != null) "parentReview": widget.parentId,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ✅ FORCE REFRESH REVIEWS
        if (Get.isRegistered<ReviewsController>()) {
          await Get.find<ReviewsController>().fetchReviews();
        }

        Get.back();

        Get.snackbar("Success", "Submitted successfully");
      }
    } catch (e) {
      if (e is DioException) {
        String msg =
            e.response?.data['message'] ?? "Failed to submit";

        Get.snackbar(
          "Error",
          msg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar("Error", "Unexpected error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        widget.isReview ? "Write Review" : "Write Reply",
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.isReview)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                    (i) => IconButton(
                  onPressed: () {
                    setState(() => rating = i + 1);
                  },
                  icon: Icon(
                    i < rating ? Icons.star : Icons.star_border,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

          const SizedBox(height: 12),

          TextField(
            controller: text,
            maxLines: 4,
            style: const TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              hintText: "Write here...",
              hintStyle: const TextStyle(
                color: Colors.black54,
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Colors.black,
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text(
            "Cancel",
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        ),

        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: submit,
          child: const Text("Send"),
        ),
      ],
    );
  }
}