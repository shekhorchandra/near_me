import 'dart:io';

class ServiceItem {

  String? id;

  File? imageFile;       // Local image for preview
  String title;
  String description;
  String? imageUrl;      // URL from API

  ServiceItem({
    this.id,
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
      id: json['_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image'], // ✅ FIXED HERE
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