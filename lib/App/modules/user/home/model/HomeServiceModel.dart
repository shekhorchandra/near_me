// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class HomeServiceModel {
  final int id;
  final String title;
  final String image;
  final int rating;
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

  HomeServiceModel copyWith({
    int? id,
    String? title,
    String? image,
    double? rating,
    double? distance,
    bool? available,
    double? lat,
    double? lng,
    String? category,
  }) {
    return HomeServiceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      rating: rating!.toInt(),
      distance: distance ?? this.distance,
      available: available ?? this.available,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'image': image,
      'rating': rating,
      'distance': distance,
      'available': available,
      'lat': lat,
      'lng': lng,
      'category': category,
    };
  }

  factory HomeServiceModel.fromMap(Map<String, dynamic> map) {
    return HomeServiceModel(
      id: map['id'] as int,
      title: map['title'] as String,
      image: map['image'] as String,
      rating: map['rating'] as int,
      distance: map['distance'] as double,
      available: map['available'] as bool,
      lat: map['lat'] as double,
      lng: map['lng'] as double,
      category: map['category'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory HomeServiceModel.fromJson(String source) =>
      HomeServiceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'HomeServiceModel(id: $id, title: $title, image: $image, rating: $rating, distance: $distance, available: $available, lat: $lat, lng: $lng, category: $category)';
  }

  @override
  bool operator ==(covariant HomeServiceModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.image == image &&
        other.rating == rating &&
        other.distance == distance &&
        other.available == available &&
        other.lat == lat &&
        other.lng == lng &&
        other.category == category;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        image.hashCode ^
        rating.hashCode ^
        distance.hashCode ^
        available.hashCode ^
        lat.hashCode ^
        lng.hashCode ^
        category.hashCode;
  }
}
