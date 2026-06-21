import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/services/storage_service.dart';
import '../../../../services/contants/api_constants.dart';
import '../model/ServicerReviewModel.dart';

class ServiceReviewController extends GetxController {
  final Dio dio = Dio();
  final StorageService storage = Get.find();

  final RxBool isLoading = false.obs;
  final RxBool isReplyLoading = false.obs;
  final RxList<ServicerReviewModel> reviews = <ServicerReviewModel>[].obs;
  final RxInt selectedRating = 0.obs;

  final String serviceId;
  late String userId;

  ServiceReviewController({required this.serviceId});

  @override
  void onInit() {
    super.onInit();

    userId = storage.userId ?? "";


    debugPrint("SERVICE ID: $serviceId");
    debugPrint("USER ID: $userId");

    if (serviceId.isEmpty) {
      debugPrint("❌ serviceId missing");
      return;
    }

    if (userId.isEmpty) {
      debugPrint("❌ userId missing");
      return;
    }

    fetchServiceReviews();
  }

  Future<void> fetchServiceReviews() async {
    try {
      isLoading.value = true;

      final res = await dio.get(
        "${ApiConstants.baseUrl}/api/v1/review/service/$serviceId",
        options: Options(
          headers: {
            "Authorization": storage.accessToken,
          },
        ),
      );

      if (res.data["success"] == true) {
        final List data = res.data["data"] ?? [];
        reviews.value =
            data.map((e) => ServicerReviewModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("Fetch service reviews error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> replyToReview({
    required String parentReviewId,
    required String comment,
  }) async {
    try {
      isReplyLoading.value = true;

      final token = storage.accessToken;

      final res = await dio.post(
        "${ApiConstants.baseUrl}/api/v1/review/create",
        data: {
          "user": userId,
          "service": serviceId,
          "comment": comment,
          "parentReview": parentReviewId,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (res.data["success"] == true) {
        Get.back();
        Get.snackbar("Success", res.data["message"] ?? "Reply added");
        await fetchServiceReviews();
      }
    } on DioException catch (e) {
      debugPrint("Reply status: ${e.response?.statusCode}");
      debugPrint("Reply response: ${e.response?.data}");

      Get.snackbar(
        "Error",
        e.response?.data["message"] ?? "Failed to reply",
      );
    } finally {
      isReplyLoading.value = false;
    }
  }

  final RxString deletingReviewId = "".obs;

  Future<void> deleteReview(String reviewId) async {
    try {
      deletingReviewId.value = reviewId;

      final token = storage.accessToken;

      final res = await dio.delete(
        "${ApiConstants.baseUrl}/api/v1/review/$reviewId",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (res.data["success"] == true) {
        Get.snackbar(
          "Success",
          res.data["message"] ?? "Review deleted successfully",
        );

        await fetchServiceReviews();
      }
    } on DioException catch (e) {
      debugPrint("Delete status: ${e.response?.statusCode}");
      debugPrint("Delete response: ${e.response?.data}");

      Get.snackbar(
        "Error",
        e.response?.data["message"] ?? "Failed to delete review",
      );
    } finally {
      deletingReviewId.value = "";
    }
  }

  int get totalReviews => reviews.length;

  int ratingCount(int rating) {
    return reviews.where((review) => review.rating == rating).length;
  }

  List<ServicerReviewModel> get filteredReviews {
    if (selectedRating.value == 0) return reviews;
    return reviews
        .where((review) => review.rating == selectedRating.value)
        .toList();
  }
}