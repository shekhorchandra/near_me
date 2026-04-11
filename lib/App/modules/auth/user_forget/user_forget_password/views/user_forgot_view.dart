import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/enums/user_role.dart';
import '../../../../../core/widgets/App_button.dart';
import '../../../../../core/widgets/common_app_bar.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/values/app_color.dart';
import '../../../../../core/values/app_text.dart';
import '../../../../../routes/app_routes.dart';
import '../controllers/user_forgot_controller.dart';

class UserForgotPasswordView extends GetView<UserForgotPasswordController> {
  const UserForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final isUser = controller.role == UserRole.user;

    return Scaffold(
      appBar: CommonAppBar(title: isUser ? "User Forgot Password" : "Service Forgot Password"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView(
            children: [
              const SizedBox(height: 40),
        
              Text(
                isUser ? "User Forgot Password?" : "Service Forgot Password?",
                style: AppText.h2.bold.copyWith(color: Colors.black),
              ),
        
              const SizedBox(height: 6),
        
              Text(
                "Enter the email associated with your account",
                style: AppText.body2.regular.copyWith(color: AppColor.neutral.s600),
              ),
        
              const SizedBox(height: 32),
        
              Text(
                "Email Address",
                style: AppText.body1.medium.copyWith(color: AppColor.neutral.s700),
              ),
        
              const SizedBox(height: 16),
        
              CustomTextField(
                controller: controller.emailController,
                hint: "Email Address",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
        
              const SizedBox(height: 24),
        
              Obx(
                () => AppButton(
                  text: controller.isLoading.value ? "Sending..." : "Send OTP",
                  loading: controller.isLoading.value,
                  onPressed: controller.sendResetLink,
                ),
              ),
        
              const SizedBox(height: 40),
        
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Remember your password? ",
                    style: AppText.body2.regular.copyWith(color: AppColor.neutral.s600),
                    children: [
                      TextSpan(
                        text: "Log In",
                        style: AppText.body2.semiBold.copyWith(color: AppColor.primary),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.toNamed(isUser ? AppRoutes.USER_LOGIN : AppRoutes.SERVICER_LOGIN);
                          },
                      ),
                    ],
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
