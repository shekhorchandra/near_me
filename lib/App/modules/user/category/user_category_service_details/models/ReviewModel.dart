import 'package:get/get.dart';

class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String comment;
  final int rating;
  final String createdAt;
  final List<ReviewModel> replies;

  /// ✅ reactive expand state
  final RxBool isExpanded = false.obs;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.createdAt,
    required this.replies,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json["_id"] ?? '',
      userId: json["user"]?["_id"] ?? '',
      userName: json["user"]?["name"] ?? 'User',
      comment: json["comment"] ?? '',
      rating: json["rating"] ?? 0,
      createdAt: json["createdAt"] ?? '',
      replies: json["replies"] == null
          ? []
          : (json["replies"] as List)
          .map((e) => ReviewModel.fromJson(e))
          .toList(),
    );
  }
}