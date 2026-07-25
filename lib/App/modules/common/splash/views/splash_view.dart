import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/values/app_assets.dart';
import 'package:near_me/App/core/values/app_color.dart';
import 'package:near_me/App/core/values/app_text.dart';
import 'package:near_me/App/modules/common/splash/controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(AppAssets.splash, width: 250, height: 250),
              const SizedBox(height: 30), // spacing between image and text
              Center(
                child: Text(
                  'Find local expert you can trust',
                  style: AppText.h0.bold.copyWith(
                    fontSize: 24,
                    color: AppColor.primary, // your primary color
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
