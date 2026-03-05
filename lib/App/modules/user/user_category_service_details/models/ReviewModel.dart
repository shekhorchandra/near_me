class ReviewModel {
  final String userImage;
  final String userName;
  final String review;
  final int daysAgo;

  ReviewModel({
    required this.userImage,
    required this.userName,
    required this.review,
    required this.daysAgo,
  });
}