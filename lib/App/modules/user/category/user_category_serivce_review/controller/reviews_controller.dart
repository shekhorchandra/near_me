import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/services/storage_service.dart';
import '../../../../services/contants/api_constants.dart';
import '../../user_category_service_details/models/ReviewModel.dart';

class ReviewsController extends GetxController {
  final Dio dio = Dio();
  final StorageService storage = Get.find();

  RxBool isLoading = false.obs;
  RxInt selectedTab = 0.obs;

  late String serviceId;
  String userId = "";

  RxList<ReviewModel> reviews = <ReviewModel>[].obs;

  bool get isLoggedIn {
    final token = storage.accessToken?.trim();
    return token != null && token.isNotEmpty;
  }

  final tabs = ["All", "★★★★★", "★★★★", "★★★", "★★", "★"];
  final isPreview = false.obs;

  RxBool isCheckingUser = false.obs;
  RxMap<String, dynamic> currentUser = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;

    serviceId = args?["serviceId"] ?? "";
    isPreview.value = args?["preview"] ?? false;

    if (serviceId.isEmpty) {
      debugPrint("❌ serviceId is missing from navigation");
      return;
    }
    getCurrentUser();
    fetchReviews();
  }

  Future<void> getCurrentUser() async {
    try {
      final token = storage.accessToken;

      if (token == null || token.isEmpty) {
        userId = "";
        return;
      }

      final response = await dio.get(
        "${ApiConstants.baseUrl}/api/v1/user/me",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.data["success"] == true) {
        currentUser.value = response.data["data"];
        userId = response.data["data"]["_id"] ?? "";
      }
    } catch (e) {
      userId = "";
      debugPrint("Current user error: $e");
    }
  }

  /// delete review
  Future<void> deleteReview(String reviewId) async {
    try {
      final storage = Get.find<StorageService>();
      final token = storage.accessToken;

      final dio = Dio();

      await dio.delete(
        "${ApiConstants.baseUrl}/api/v1/review/$reviewId",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      Get.snackbar(
        "Success",
        "Review deleted successfully",
      );

      await fetchReviews();
    } on DioException catch (e) {
      Get.snackbar(
        "Error",
        e.response?.data["message"] ??
            "Failed to delete review",
      );
    }
  }

  /// get all reviews
  Future<void> fetchReviews() async {
    try {
      isLoading.value = true;

      final res = await dio.get(
        "${ApiConstants.baseUrl}/api/v1/review/service/$serviceId",
        options: Options(headers: {"Authorization": storage.accessToken}),
      );

      if (res.data["success"] == true) {
        final List data = res.data["data"];

        reviews.value = data.map((e) => ReviewModel.fromJson(e)).toList();
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// create review
  Future<void> createReview({
    required String comment,
    int? rating,
    String? parentReview,
  }) async {
    final token = storage.accessToken;

    if (token == null || token.isEmpty) {
      Get.snackbar(
        "Login Required",
        "Please login first",
      );
      return;
    }
    print("Token: ${storage.accessToken}");
    print("Is Empty: ${storage.accessToken?.isEmpty}");
    print("Is Null: ${storage.accessToken == null}");

    try {
      await dio.post(
        "${ApiConstants.baseUrl}/api/v1/review/create",
        data: {
          "service": serviceId,
          "comment": comment,
          if (rating != null) "rating": rating,
          if (parentReview != null) "parentReview": parentReview,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      await fetchReviews();
      Get.back();
      Get.snackbar("Success", "Review submitted");
    } on DioException catch (e) {
      Get.snackbar(
        "Error",
        e.response?.data["message"] ?? "Failed to submit review",
      );
    }
  }

  void changeTab(int index) {
    selectedTab.value = index;
  }

  List<ReviewModel> get filteredReviews {
    if (selectedTab.value == 0) return reviews;

    int rating = 6 - selectedTab.value;

    return reviews.where((e) => e.rating == rating).toList();
  }

  int get totalReviews => reviews.length;

  Map<int, int> get ratingCount {
    Map<int, int> map = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

    for (var item in reviews) {
      map[item.rating] = map[item.rating]! + 1;
    }

    return map;
  }
}
