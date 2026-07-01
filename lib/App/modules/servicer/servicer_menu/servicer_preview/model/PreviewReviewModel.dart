import 'PreviewReplyModel.dart';

class PreviewReviewModel {
  final String id;
  final String name;
  final String comment;
  final int rating;

  final List<PreviewReplyModel> replies;

  PreviewReviewModel({
    required this.id,
    required this.name,
    required this.comment,
    required this.rating,
    required this.replies,
  });

  factory PreviewReviewModel.fromJson(Map<String, dynamic> json) {
    return PreviewReviewModel(
      id: json["_id"],
      name: json["user"]["name"],
      comment: json["comment"] ?? "",
      rating: json["rating"] ?? 0,
      replies: (json["replies"] as List)
          .map((e) => PreviewReplyModel.fromJson(e))
          .toList(),
    );
  }
}