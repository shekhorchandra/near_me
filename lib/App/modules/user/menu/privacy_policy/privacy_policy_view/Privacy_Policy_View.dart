import 'package:flutter/material.dart';
import '../../../../../core/values/app_color.dart';
import '../../../../../core/values/app_text.dart';
import '../../../../../core/widgets/common_app_bar.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Privacy Policy"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              _paragraph(
                "At App Name, we value your privacy and are committed to protecting your personal information. By using the app, you agree to the collection, use, and sharing of your personal data as outlined in this policy.",
              ),

              const SizedBox(height: 16),

              _paragraph(
                "We collect data such as your name, email address, location, and transaction details to provide personalized deals, manage your account, and improve our services.",
              ),

              const SizedBox(height: 16),

              _paragraph(
                "We may share your information with trusted third-party service providers who assist us in operating the app and delivering services. These providers are obligated not to disclose or use your information for any other purpose.",
              ),

              const SizedBox(height: 16),

              _paragraph(
                "We implement security measures to protect your data; however, we cannot guarantee complete security due to the nature of internet communication.",
              ),

              const SizedBox(height: 16),

              _paragraph(
                "You can access, update, or delete your personal information through your account settings. By continuing to use App Name, you consent to the collection and processing of your data in accordance with this policy.",
              ),

              const SizedBox(height: 16),

              RichText(
                text: TextSpan(
                  style: AppText.body2.regular,
                  children: [
                    const TextSpan(
                      text:
                      "For more detailed information on how we protect your privacy, please contact us at ",
                    ),
                    TextSpan(
                      text: "support@appname.com",
                      style: AppText.body2.semiBold.copyWith(
                        color: AppColor.primary,
                      ),
                    ),
                    const TextSpan(text: "."),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              _paragraph(
                "We reserve the right to update this Privacy Policy at any time. Any changes will be posted on this page.",
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