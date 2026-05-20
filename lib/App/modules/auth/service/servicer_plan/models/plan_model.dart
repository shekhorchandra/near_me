import 'dart:convert';

import 'package:flutter/material.dart';

class Plan {
  final String id;
  final String name;
  final double price;
  final String interval;
  final List<String> features;
  final Color color;

  Plan({
    required this.id,
    required this.name,
    required this.price,
    required this.interval,
    required this.features,
    required this.color,
  });

  factory Plan.fromApi(Map<String, dynamic> json) {
    final features = json['features'];

    List<String> featureList = [];

    // Convert backend features → UI text
    featureList.add(
      "Max Photos: ${features['maxPhotos'] == -1 ? 'Unlimited' : features['maxPhotos']}",
    );
    featureList.add(
      "Services: ${features['maxOfferServices'] == -1 ? 'Unlimited' : features['maxOfferServices']}",
    );
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
      price: (json['price'] as num).toDouble(),
      interval: json['interval'],
      features: featureList,
      color: _getColor(json['name']),
    );
  }

  String get displayPrice {
    return "£$price / $interval";
  }

  // Keep your design colors same
  static Color _getColor(String name) {
    switch (name) {
      case "free":
        return const Color(0xFF3612FF);
      case "basic":
        return const Color(0xFF61FD9D);
      case "pro":
        return const Color(0xFFFFA600);
      case "elite":
        return const Color(0xFF7161AA);
      default:
        return Colors.grey;
    }
  }
}
