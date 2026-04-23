/// =============================
/// UPDATED HomeServiceModel.dart
/// =============================
import 'dart:convert';

class HomeServiceModel {
  final String id;
  final String title;
  final String image;
  final double rating;
  final double distance;
  final bool available;
  final double lat;
  final double lng;
  final String category;

  HomeServiceModel({
    required this.id,
    required this.title,
    required this.image,
    required this.rating,
    required this.distance,
    required this.available,
    required this.lat,
    required this.lng,
    required this.category,
  });

  factory HomeServiceModel.fromMap(Map<String, dynamic> map) {
    final coordinates = map["coordinates"] ?? [];

    return HomeServiceModel(
      id: map["_id"] ?? "",
      title: map["service_name"] ?? "",
      image: map["company_logo"] ?? "",
      rating: (map["averageRating"] ?? 0).toDouble(),
      distance: (map["distanceInMiles"] ?? 0).toDouble(),
      available: map["isAvailableNow"] ?? false,
      lat: coordinates.length > 1 ? coordinates[1].toDouble() : 0.0,
      lng: coordinates.isNotEmpty ? coordinates[0].toDouble() : 0.0,
      category: "Service",
    );
  }

  String toJson() => json.encode({});
}