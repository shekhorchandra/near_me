import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final currentPage = 0.obs;

  final pages = [
    {
      "title": "Find Services Near You",
      "subtitle":
      "Discover trusted vendors around you instantly with our map—first experience",
      "image": "assets/images/onboarding.png",
    },
  ];

  void nextPage() {
    if (currentPage.value < pages.length - 1) {
      pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Get.offNamed(AppRoutes.USER_BOTTOM_NAV);
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }
}
