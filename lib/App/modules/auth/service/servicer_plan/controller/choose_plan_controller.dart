import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/plan_model.dart';

class ChoosePlanController extends GetxController {
  var selectedPlan = Rxn<Plan>();

  final List<Plan> plans = [
    Plan(
      name: "Free Plan",
      price: "£0 / month",
      features: [
        "Basic profile",
        "Maximum 3 photos",
        "Appears below paid listings",
        "No badge",
        "Limited to 1 service category"
      ],
      color: Color(0xFF6B9AF4),

    ),
    Plan(
      name: "Basic Plan",
      price: "£9.99 / month",
      features: [
        "Listed above free listing",
        "10 photos",
        "“Active Provider” badge",
        "Basic analytics",
        "Up to 3 categories"
      ],
      color: Color(0xFF2132F3)
    ),
    Plan(
      name: "Pro Plan",
      price: "£19.99 / month",
      features: [
        "Listed above Basic Plan",
        "20 photos",
        "“Pro Provider” badge",
        "Advanced analytics",
        "Up to 5 categories"
      ],
      color: Colors.green,
    ),
    Plan(
      name: "Elite Plan",
      price: "£49.99 / month",
      features: [
        "Top of all listings",
        "Unlimited photos",
        "“Elite Provider” badge",
        "Full analytics",
        "Unlimited categories"
      ],
      color: Colors.orangeAccent,
    ),
  ];

  void selectPlan(Plan plan) {
    selectedPlan.value = plan;
  }
}