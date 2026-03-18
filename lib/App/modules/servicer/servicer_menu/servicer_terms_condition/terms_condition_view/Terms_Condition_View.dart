import 'package:flutter/material.dart';
import '../../../../../core/values/app_color.dart';
import '../../../../../core/values/app_text.dart';
import '../../../../../core/widgets/common_app_bar.dart';

class ServicerTermsConditionView extends StatelessWidget {
  const ServicerTermsConditionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Terms & Condition"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _paragraph(
                "By using App Name, you agree to comply with these Terms & Conditions. "
                    "You must be at least [age] years old to use the app and are responsible "
                    "for the security of your account information.",
              ),

              const SizedBox(height: 16),

              _paragraph(
                "The app allows users to browse and collect coupons for third-party "
                    "merchants, but App Name is not responsible for any transactions, "
                    "services, or issues related to merchant offers. Coupons are subject "
                    "to merchant terms and must be redeemed accordingly.",
              ),

              const SizedBox(height: 16),

              _paragraph(
                "We reserve the right to suspend or terminate your access if you "
                    "violate these terms or engage in unlawful activity. App Name is "
                    "not liable for any damages arising from the use of the app, "
                    "including errors, omissions, or failure to fulfill deals.",
              ),

              const SizedBox(height: 16),

              _paragraph(
                "Any disputes with merchants should be addressed directly with them. "
                    "For details on how we handle your personal data, please read our "
                    "Privacy Policy.",
              ),

              const SizedBox(height: 16),

              _paragraph(
                "By using the app, you accept these terms and any future modifications.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- Text Widget ----------
  Widget _paragraph(String text) {
    return Text(
      text,
      style: AppText.body2.regular,
      textAlign: TextAlign.justify,

    );
  }
}