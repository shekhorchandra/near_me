import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/values/app_text.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import '../../../../core/values/app_color.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                itemCount: controller.pages.length,
                onPageChanged: controller.onPageChanged,
                itemBuilder: (context, index) {
                  final page = controller.pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          page['image']!,
                          height: 395,
                          width: double.infinity,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          page['title']!,
                          textAlign: TextAlign.center,
                          style: AppText.h1.bold.copyWith(color: AppColor.primary),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          page['subtitle']!,
                          textAlign: TextAlign.center,
                          style: AppText.body1.regular.copyWith(color: AppColor.neutral.s700),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Padding for the button / loading indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Obx(() {
                return SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: controller.isLoading.value
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.primary,
                    ),
                  )
                      : AppButton(
                    onPressed: controller.nextPage,
                    text: 'Get Started',
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}