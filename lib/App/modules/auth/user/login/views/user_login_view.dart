import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/social_button.dart';
import '../../../../../core/values/app_assets.dart';
import '../../../../../core/values/app_color.dart';
import '../../../../../core/values/app_text.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/common_app_bar.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../routes/app_routes.dart';
import '../controllers/user_login_controller.dart';

class UserLoginView extends GetView<UserLoginController> {
  const UserLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: " ", showBack: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          shrinkWrap: true,
          children: [
            const SizedBox(height: 40),

            // Title
            Text(
              "Welcome",
              textAlign: TextAlign.center,
              style: AppText.h1.bold.copyWith(color: AppColor.primary),
            ),

            const SizedBox(height: 6),

            // Subtitle
            Text(
              "Please enter your details to Log In",
              textAlign: TextAlign.center,
              style: AppText.body1.regular.copyWith(color: AppColor.neutral.s700),
            ),

            const SizedBox(height: 24),

            // Email TextField
            const CustomTextField(hint: "Email Address", icon: Icons.email_outlined),

            const SizedBox(height: 12),

            // Password TextField with Obscure toggle
            Obx(
              () => CustomTextField(
                hint: "Password",
                icon: Icons.lock_outline,
                obscure: controller.obscurePassword.value,
                suffix: IconButton(
                  icon: Icon(
                    controller.obscurePassword.value ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: controller.togglePassword,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Navigate to Forgot Password page
                  Get.toNamed('/user_forgot');

                },
                child: Text(
                  "Forgot Password?",
                  style: AppText.body2.semiBold.copyWith(color: AppColor.primary),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Login Button
            AppButton(text: "Log in", onPressed: () {
              Get.toNamed(AppRoutes.USER_BOTTOM_NAV);
            }),

            const SizedBox(height: 24),

            // Divider with text
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "Or continue with",
                    style: AppText.body2.regular.copyWith(color: AppColor.neutral.s600),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 24),

            // Social Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // reduce horizontal padding
              child: Row(
                children: [
                  Flexible(
                    child: SocialButton(text: "Google", iconPath: AppAssets.google),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: SocialButton(text: "Apple", iconPath: AppAssets.apple),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Login as a Service button (if needed, e.g., vendor or admin)
            AppButton(
              text: "Login as a Service",
              backgroundColor: AppColor.secondary,
              textColor: AppColor.onColor(AppColor.secondary),
              onPressed: () {
                // TODO: handle service login
              },
            ),

            const SizedBox(height: 24),

            // Sign Up RichText
            Center(
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account? ",
                  style: AppText.body2.regular.copyWith(color: AppColor.neutral.s700),
                  children: [
                    TextSpan(
                      text: "Create an account",
                      style: AppText.body2.semiBold.copyWith(color: AppColor.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed(AppRoutes.USER_SIGNUP);
                        },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
