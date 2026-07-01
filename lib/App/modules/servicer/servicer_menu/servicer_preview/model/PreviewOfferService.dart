class PreviewOfferService {
  final String id;
  final String name;

  PreviewOfferService({
    required this.id,
    required this.name,
  });

  factory PreviewOfferService.fromJson(Map<String, dynamic> json) {
    return PreviewOfferService(
      id: json["_id"],
      name: json["name"],
    );
  }
}