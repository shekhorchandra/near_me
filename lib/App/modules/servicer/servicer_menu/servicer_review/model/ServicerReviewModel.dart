class ServicerReviewModel {
  final String id;
  final String userId;
  final String userName;
  final int rating;
  final String comment;
  final DateTime createdAt;
  final List<ServicerReviewReplyModel> replies;

  ServicerReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    required this.replies,
  });

  factory ServicerReviewModel.fromJson(Map<String, dynamic> json) {
    return ServicerReviewModel(
      id: json['_id'] ?? '',
      userId: json['user']?['_id'] ?? '',
      userName: json['user']?['name'] ?? 'Unknown',
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      replies: (json['replies'] as List? ?? [])
          .map((e) => ServicerReviewReplyModel.fromJson(e))
          .toList(),
    );
  }
}

class ServicerReviewReplyModel {
  final String id;
  final String userName;
  final String comment;
  final DateTime createdAt;

  ServicerReviewReplyModel({
    required this.id,
    required this.userName,
    required this.comment,
    required this.createdAt,
  });

  factory ServicerReviewReplyModel.fromJson(Map<String, dynamic> json) {
    return ServicerReviewReplyModel(
      id: json['_id'] ?? '',
      userName: json['user']?['name'] ?? 'Unknown',
      comment: json['comment'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}