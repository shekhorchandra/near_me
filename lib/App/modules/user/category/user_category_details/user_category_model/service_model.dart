class ServiceModel {
  final String id; // ✅ ADD THIS
  final String title;
  final String image;
  final double rating;
  final double distance;
  final String schedule;
  final String location;
  final String category;
  final String about;
  final String servicesOffered;
  final List<HighlightModel> highlights;
  final List<String> reviews;

  ServiceModel({
    required this.id, // ✅ ADD THIS

    required this.title,
    required this.image,
    required this.rating,
    required this.distance,
    required this.schedule,
    required this.location,
    required this.category,
    required this.about,
    required this.servicesOffered,
    required this.highlights,
    required this.reviews,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] ?? '',

      title: json['service_name'] ?? '',
      image: json['company_logo'] ?? '',

      rating: (json['averageRating'] ?? 0).toDouble(),
      distance: (json['distanceInMiles'] ?? 0).toDouble(),

      schedule:
      "${json['openingTime'] ?? ''} - ${json['closingTime'] ?? ''}",

      location: json['service_address'] ?? '',

      category: json['servicer_highlight'] ?? '',
      about: json['about'] ?? '',
      servicesOffered: json['servicesOffered'] ?? '',

      highlights:
      (json['highlights'] as List<dynamic>?)
          ?.map((e) => HighlightModel.fromJson(e))
          .toList() ??
          [],

      reviews: List<String>.from(json['reviews'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,

    "service_name": title,
    "company_logo": image,
    "averageRating": rating,
    "distanceInMiles": distance,

    "service_address": location,

    "category": category,
    "about": about,
    "servicesOffered": servicesOffered,

    "highlights": highlights.map((e) => e.toJson()).toList(),
    "reviews": reviews,
  };
}

class HighlightModel {
  final String image;
  final String title;

  HighlightModel({
    required this.image,
    required this.title,
  });

  factory HighlightModel.fromJson(Map<String, dynamic> json) {
    return HighlightModel(
      image: json['image'] ?? '',
      title: json['title'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "image": image,
    "title": title,
  };
}