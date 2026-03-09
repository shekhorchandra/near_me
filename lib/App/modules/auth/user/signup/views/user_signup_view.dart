import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/values/app_assets.dart';
import '../../../../../core/values/app_color.dart';
import '../../../../../core/values/app_text.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/common_app_bar.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/social_button.dart';
import '../../../../../routes/app_routes.dart';
import '../controllers/user_signup_controller.dart';

class UserSignupView extends GetView<UserSignupController> {
  const UserSignupView({super.key});

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
              "Create New Account",
              textAlign: TextAlign.center,
              style: AppText.h2.bold.copyWith(color: AppColor.primary),
            ),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              "Please enter your details to Create an account",
              textAlign: TextAlign.center,
              style: AppText.body1.regular.copyWith(color: AppColor.neutral.s700),
            ),

            const SizedBox(height: 24),

            // User Name
            const CustomTextField(
              hint: "User Name",
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 12),

            // Email
            const CustomTextField(
              hint: "Email Address",
              icon: Icons.email_outlined,
            ),

            const SizedBox(height: 12),

            // Password
            Obx(
                  () => CustomTextField(
                hint: "Set Password",
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

            const SizedBox(height: 12),

            // Confirm Password
            Obx(
                  () => CustomTextField(
                hint: "Confirm Password",
                icon: Icons.lock_outline,
                obscure: controller.obscureConfirmPassword.value,
                suffix: IconButton(
                  icon: Icon(
                    controller.obscureConfirmPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: controller.toggleConfirmPassword,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Sign Up Button
            AppButton(
              text: "Create an account",
              onPressed: () {
                // Navigate to Verify Account after sign up
                Get.toNamed(AppRoutes.USER_VERIFY_ACCOUNT);
              },
            ),

            const SizedBox(height: 24),

            // Divider with text
            Row(
              children: [
                const Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    "Or continue with",
                    style: AppText.body2.medium.copyWith(color: AppColor.neutral.s600),
                  ),
                ),
                const Expanded(child: Divider(thickness: 1)),
              ],
            ),

            const SizedBox(height: 24),

            // Social Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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

            // Already have account
            Center(
              child: RichText(
                text: TextSpan(
                  text: "Already have an account? ",
                  style: AppText.body2.regular.copyWith(color: AppColor.neutral.s700),
                  children: [
                    TextSpan(
                      text: "Log In",
                      style: AppText.body2.semiBold.copyWith(color: AppColor.primary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed(AppRoutes.USER_LOGIN);
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