class PreviewReplyModel {
  final String name;
  final String comment;

  PreviewReplyModel({
    required this.name,
    required this.comment,
  });

  factory PreviewReplyModel.fromJson(Map<String, dynamic> json) {
    return PreviewReplyModel(
      name: json["user"]["name"],
      comment: json["comment"],
    );
  }
}