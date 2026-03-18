class ServiceModel {
  final String title;
  final String image; // Asset path or network URL
  final double rating; // 0 - 5
  final double distance; // km
  final String schedule; // e.g., "Mon-Fri 9am-6pm"
  final String location; // e.g., city or area
  final String category;
  final String about;
  final String servicesOffered;
  final List<HighlightModel> highlights; // updated
  final List<String> reviews;

  ServiceModel({
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

  // Optional: factory constructor if you fetch from API
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      title: json['title'],
      image: json['image'],
      rating: (json['rating'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      schedule: json['schedule'],
      location: json['location'],
      category: json['servicer_highlight'] ?? '',
      about: json['about'] ?? '',
      servicesOffered: json['servicesOffered'] ?? '',
      highlights: (json['highlights'] as List<dynamic>?)
          ?.map((e) => HighlightModel.fromJson(e))
          .toList() ??
          [],
      reviews: List<String>.from(json['reviews'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'image': image,
    'rating': rating,
    'distance': distance,
    'schedule': schedule,
    'location': location,
    'servicer_highlight': category,
    'about': about,
    'servicesOffered': servicesOffered,
    'highlights': highlights.map((e) => e.toJson()).toList(),
    'reviews': reviews,
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
      image: json['image'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() => {
    'image': image,
    'title': title,
  };
}