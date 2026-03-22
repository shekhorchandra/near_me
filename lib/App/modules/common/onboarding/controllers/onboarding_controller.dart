import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  final currentPage = 0.obs;
  var isLoading = false.obs;

  final pages = [
    {
      "title": "Find Services Near You",
      "subtitle":
      "Discover trusted vendors around you instantly with our map—first experience",
      "image": "assets/images/onboarding.png",
    },
  ];

  void nextPage() async {
    isLoading.value = true;

    if (currentPage.value < pages.length - 1) {
      await pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      isLoading.value = false; // stop loading after page animation
    } else {
      // Optional: show loading until navigation completes
      await Future.delayed(const Duration(milliseconds: 200));
      isLoading.value = false;

      Get.offNamed(AppRoutes.USER_BOTTOM_NAV);
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }
}
