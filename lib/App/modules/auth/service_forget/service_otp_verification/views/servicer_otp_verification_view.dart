import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/values/app_assets.dart';
import '../../../../../core/values/app_color.dart';
import '../../../../../core/values/app_text.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/common_app_bar.dart';
import '../controllers/servicer_otp_controller.dart';

class ServicerOtpVerificationView extends GetView<ServicerOtpController> {
  const ServicerOtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        backgroundColor: Colors.white,
        title: "Service Account Verify OTP",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            // Image
            Image.asset(
              AppAssets.verifyAccount, // reuse same image
              height: 300,
              width: double.infinity,
            ),

            const SizedBox(height: 20),

            // Subtitle
            Text(
              'Enter the 4-digit code sent to your email',
              textAlign: TextAlign.center,
              style: AppText.body1.regular
                  .copyWith(color: AppColor.neutral.s700),
            ),

            const SizedBox(height: 24),

            // OTP Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  width: 50,
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  child: TextField(
                    focusNode: controller.focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    onChanged: (value) =>
                        controller.onOtpChanged(value, index),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                        BorderSide(color: AppColor.neutral.s300),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            // Verify Button
            Obx(
                  () => AppButton(
                text: controller.isLoading.value
                    ? 'Verifying...'
                    : 'Verify',
                loading: controller.isLoading.value,
                onPressed: controller.verifyOtp,
              ),
            ),

            const SizedBox(height: 16),

            // Resend OTP
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Don't receive the code? ",
                style: AppText.body2.regular
                    .copyWith(color: AppColor.neutral.s600),
                children: [
                  TextSpan(
                    text: "Resend",
                    style: AppText.body2.semiBold
                        .copyWith(color: AppColor.primary),
                    recognizer: TapGestureRecognizer()
                      ..onTap = controller.resendOtp,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}