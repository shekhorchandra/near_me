class PreviewHighlightService {
  final String title;
  final String image;
  final String description;

  PreviewHighlightService({
    required this.title,
    required this.image,
    required this.description,
  });

  factory PreviewHighlightService.fromJson(Map<String, dynamic> json) {
    return PreviewHighlightService(
      title: json["title"] ?? "",
      image: json["image"] ?? "",
      description: json["description"] ?? "",
    );
  }
}