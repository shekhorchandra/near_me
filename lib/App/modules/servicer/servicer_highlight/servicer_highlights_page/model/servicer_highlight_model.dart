import 'dart:io';

class ServiceItem {
  File? imageFile;       // Local image for preview
  String title;
  String description;
  String? imageUrl;      // URL from API

  ServiceItem({
    this.imageFile,
    required this.title,
    this.description = "",
    this.imageUrl,
  });

  // For previewing image
  String get image => imageFile?.path ?? imageUrl ?? '';

  /// Convert JSON from API to ServiceItem
  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'], // API sends image URL
    );
  }

  /// Convert ServiceItem to JSON for API
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}