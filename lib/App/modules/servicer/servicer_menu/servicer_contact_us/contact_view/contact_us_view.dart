import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/values/app_color.dart';
import '../../../../../core/values/app_text.dart';
import '../../../../../core/widgets/common_app_bar.dart';

class ServicerContactUsView extends StatelessWidget {
  const ServicerContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Contact Us"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _paragraph(
                "We’d love to hear from you!\nWhether you have questions, need assistance, or want to share feedback about “App Name”, we're here to help.",
              ),

              const SizedBox(height: 24),
              _sectionTitle("How to Reach Us"),
              const SizedBox(height: 16),

              // EMAIL CARD
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _cardHeading("Email"),
                    const SizedBox(height: 8),
                    Text(
                      "For general inquiries or support:",
                      style: AppText.body2.regular,
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _launchUrl("mailto:support@appname.com"),
                      child: Text(
                        "support@appname.com",
                        style: AppText.body2.semiBold.copyWith(
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // PHONE CARD
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _cardHeading("Phone"),
                    const SizedBox(height: 8),
                    Text(
                      "Call us during business hours:",
                      style: AppText.body2.regular,
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _launchUrl("tel:+1234567890"),
                      child: Text(
                        "+1 234 567 890",
                        style: AppText.body2.semiBold.copyWith(
                          color: AppColor.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Monday to Friday: 9:00 AM – 6:00 PM (GMT)",
                      style: AppText.label.regular,
                    ),
                  ],
                ),
              ),

              // ADDRESS CARD
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _cardHeading("Mailing Address"),
                    const SizedBox(height: 8),
                    Text(
                      "Your Company’s Mailing Address\nCity, State, ZIP Code",
                      style: AppText.body2.regular,
                    ),
                  ],
                ),
              ),

              // SOCIAL CARD
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _cardHeading("Social Media"),
                    const SizedBox(height: 8),
                    _socialItem(Icons.facebook, "Facebook", "https://facebook.com"),
                    _socialItem(Icons.alternate_email, "Twitter", "https://twitter.com"),
                    _socialItem(Icons.camera_alt, "Instagram", "https://instagram.com"),
                    _socialItem(Icons.work, "LinkedIn", "https://linkedin.com"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------- Helpers -----------------

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: AppText.h4.semiBold,
    );
  }

  Widget _cardHeading(String text) {
    return Text(
      text,
      style: AppText.h5.semiBold,
    );
  }

  Widget _paragraph(String text) {
    return Text(
      text,
      style: AppText.body2.regular,
    );
  }

  Widget _socialItem(IconData icon, String title, String url) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: AppColor.primary),
            const SizedBox(width: 12),
            Text(
              title,
              style: AppText.body2.medium.copyWith(
                color: AppColor.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}