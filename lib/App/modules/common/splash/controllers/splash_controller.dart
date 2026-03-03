import 'dart:async';

import 'package:get/get.dart';
import 'package:near_me/App/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    Timer(const Duration(seconds: 2), _checkFirstLaunch);
  }

  Future<void> _checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    final first = prefs.getBool('is_first_launch') ?? true;

    if (first) {
      await prefs.setBool('is_first_launch', false);
      Get.offAllNamed(AppRoutes.ONBOARDING);
    } else {
      Get.offAllNamed(AppRoutes.ONBOARDING);
      // Get.offAllNamed(AppRoutes.USER_BOTTOM_NAV);
    }
  }
}
