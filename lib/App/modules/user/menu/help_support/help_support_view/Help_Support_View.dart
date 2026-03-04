import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/values/app_color.dart';
import '../../../../../core/values/app_text.dart';
import '../../../../../core/widgets/common_app_bar.dart';

class HelpSupportView extends StatelessWidget {
  const HelpSupportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Help & Support"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _paragraph(
                "We are here to assist you with any questions or issues you may have while using App Name. Below are the available support options:",
              ),

              const SizedBox(height: 24),
              _sectionTitle("Need Assistance?"),
              const SizedBox(height: 12),

              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _paragraph(
                      "If you have any questions or need support, you can reach us through:",
                    ),
                    const SizedBox(height: 12),

                    _contactItem(
                      icon: Icons.email,
                      title: "Email Support",
                      value: "support@appname.com",
                      url: "mailto:support@appname.com",
                    ),

                    _contactItem(
                      icon: Icons.phone,
                      title: "Phone Support",
                      value: "+1 234 567 890\nMon–Fri: 9:00 AM – 6:00 PM (GMT)",
                      url: "tel:+1234567890",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              _sectionTitle("Report an Issue"),
              const SizedBox(height: 12),

              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _paragraph(
                      "If you're experiencing a technical issue, please contact us:",
                    ),
                    const SizedBox(height: 12),

                    _contactItem(
                      icon: Icons.email,
                      title: "Email",
                      value: "support@appname.com",
                      url: "mailto:support@appname.com",
                    ),

                    _contactItem(
                      icon: Icons.phone,
                      title: "Phone",
                      value: "Contact us directly for immediate assistance",
                      url: "tel:+1234567890",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              _sectionTitle("Troubleshooting Tips"),
              const SizedBox(height: 12),

              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _paragraph(
                      "Before contacting support, try the following:",
                    ),
                    const SizedBox(height: 10),

                    _bullet("Check for Updates", "Make sure you have the latest version installed."),
                    _bullet("Restart the App", "Close and reopen the app."),
                    _bullet("Check Your Connection", "Ensure your internet connection is stable."),
                    _bullet("Clear Cache", "Try clearing cache from app settings if applicable."),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              _sectionTitle("Feedback & Suggestions"),
              const SizedBox(height: 12),

              _card(
                child: _contactItem(
                  icon: Icons.feedback,
                  title: "Send your suggestions",
                  value: "feedback@appname.com",
                  url: "mailto:feedback@appname.com",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Helpers ----------------

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

  Widget _paragraph(String text) {
    return Text(
      text,
      style: AppText.body2.regular,
    );
  }

  Widget _contactItem({
    required IconData icon,
    required String title,
    required String value,
    required String url,
  }) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColor.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppText.body2.semiBold,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: AppText.body2.medium.copyWith(
                      color: AppColor.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bullet(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: AppText.body2.semiBold),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$title: ",
                style: AppText.body2.semiBold,
                children: [
                  TextSpan(
                    text: desc,
                    style: AppText.body2.regular,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}