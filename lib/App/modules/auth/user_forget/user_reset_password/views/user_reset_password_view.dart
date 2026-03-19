import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/widgets/App_button.dart';
import '../../../../../core/widgets/common_app_bar.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../controllers/user_reset_password_controller.dart';

class UserResetPasswordView extends GetView<UserResetPasswordController> {
  const UserResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Create New Password for User"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              const SizedBox(height: 10),
        
              // Title
              const Text(
                "Create New Password",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
        
        
              // Subtitle
              const Text(
                "Create new password for your account",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
        
              const SizedBox(height: 32),
        
              Obx(
                    () => CustomTextField(
                  controller: controller.newPasswordController,
                  hint: "New Password",
                  icon: Icons.key,
                  obscure: controller.obscureNewPassword.value,
                  suffix: IconButton(
                    icon: Icon(
                      controller.obscureNewPassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: controller.toggleNewPassword,
                  ),
                ),
              ),
        
              const SizedBox(height: 16),
        
              Obx(
                    () => CustomTextField(
                  controller: controller.confirmPasswordController,
                  hint: "Confirm Password",
                  icon: Icons.key,
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
        
              const SizedBox(height: 24),
        
              Obx(
                    () => AppButton(
                  text: controller.isLoading.value
                      ? "Resetting..."
                      : "Reset Password",
                  loading: controller.isLoading.value,
                  onPressed: controller.resetPassword,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}