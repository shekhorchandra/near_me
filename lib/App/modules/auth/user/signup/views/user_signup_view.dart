import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/values/app_assets.dart';
import '../../../../../core/values/app_color.dart';
import '../../../../../core/values/app_text.dart';
import '../../../../../core/widgets/PasswordRule.dart';
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
      body: SafeArea(
        child: Padding(
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
              CustomTextField(
                hint: "User Name",
                icon: Icons.person_outline,
                controller: controller.nameController, // name
              ),

              const SizedBox(height: 12),

              // Email
              CustomTextField(
                hint: "Email Address",
                icon: Icons.email_outlined,
                controller: controller.emailController, //email
              ),

              const SizedBox(height: 12),

              // Password
              Obx(
                () => CustomTextField(
                  hint: "Set Password",
                  icon: Icons.lock_outline,
                  controller: controller.passwordController, //set password
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
                  controller: controller.confirmPasswordController, // confirm password
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

              const SizedBox(height: 10),

              Obx(
                    () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    PasswordRule(
                      title: "At least 8 characters",
                      valid: controller.hasMinLength.value,
                    ),

                    PasswordRule(
                      title: "Contains an uppercase letter",
                      valid: controller.hasUppercase.value,
                    ),

                    PasswordRule(
                      title: "Contains a lowercase letter",
                      valid: controller.hasLowercase.value,
                    ),

                    PasswordRule(
                      title: "Contains a number",
                      valid: controller.hasNumber.value,
                    ),

                    PasswordRule(
                      title: "Contains a special character",
                      valid: controller.hasSpecialChar.value,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Sign Up Button
              Obx(
                () => AppButton(
                  text: "Create an account",
                  loading: controller.isLoading.value,
                  onPressed: () async {
                    await controller.registerUser();
                  },
                ),
              ),

              const SizedBox(height: 20),

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

              const SizedBox(height: 20),

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
                      child: SocialButton(
                        text: "Google",
                        iconPath: AppAssets.google,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: SocialButton(
                        text: "Apple",
                        iconPath: AppAssets.apple,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              AppButton(
                text: "Register as a Service",
                backgroundColor: AppColor.secondary,
                textColor: AppColor.onColor(AppColor.secondary),
                onPressed: () {
                  // TODO: handle service login
                  Get.toNamed(AppRoutes.SERVICER_SIGNUP);
                },
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}


