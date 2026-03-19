import 'package:flutter/material.dart';

class Plan {
  final String name;
  final String price;
  final List<String> features;
  final Color color; // Add color

  Plan({
    required this.name,
    required this.price,
    required this.features,
    required this.color,
  });
}