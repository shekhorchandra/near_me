import 'package:flutter/material.dart';

class Plan {
  final String id;
  final String name;
  final String price;
  final List<String> features;
  final Color color;

  Plan({
    required this.id,
    required this.name,
    required this.price,
    required this.features,
    required this.color,
  });

  factory Plan.fromApi(Map<String, dynamic> json) {
    final features = json['features'];

    List<String> featureList = [];

    // Convert backend features → UI text
    featureList.add("Max Photos: ${features['maxPhotos'] == -1 ? 'Unlimited' : features['maxPhotos']}");
    featureList.add("Services: ${features['maxOfferServices'] == -1 ? 'Unlimited' : features['maxOfferServices']}");
    featureList.add("Badge: ${features['badgeType']}");
    featureList.add("Analytics: ${features['analyticsType']}");

    if (features['canReplyToReviews'] == true) {
      featureList.add("Can reply to reviews");
    }
    if (features['isHomepageFeaturedEligible'] == true) {
      featureList.add("Homepage featured");
    }
    if (features['hasHighlightedProfileBorder'] == true) {
      featureList.add("Highlighted profile");
    }

    return Plan(
      id: json['_id'] ?? json['id'],
      name: json['title'],
      price: "£${json['price']} / ${json['interval']}",
      features: featureList,
      color: _getColor(json['name']),
    );
  }

  // Keep your design colors same
  static Color _getColor(String name) {
    switch (name) {
      case "free":
        return const Color(0xFF6B9AF4);
      case "basic":
        return const Color(0xFF2132F3);
      case "pro":
        return Colors.green;
      case "elite":
        return Colors.orangeAccent;
      default:
        return Colors.grey;
    }
  }
}