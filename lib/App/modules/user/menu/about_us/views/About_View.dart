import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/values/app_text.dart';
import '../../../../../core/widgets/common_app_bar.dart';
import '../controllers/about_controller.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "About Us"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _paragraph(
                "Welcome to App Name, your go-to platform for discovering the best local deals, exclusive offers, and exciting experiences! Our mission is to bring you the best discounts and unique opportunities tailored specifically to your interests and location.",
              ),

              _paragraph(
                "At App Name, we believe that saving money should be simple and rewarding. Whether you're looking for a delicious meal at your favorite restaurant, a relaxing spa day, or an adventure-packed experience, we've got you covered.",
              ),

              const SizedBox(height: 8),
              _section("Our Vision"),

              _paragraph(
                "To revolutionize how people discover and enjoy local deals by providing an intuitive, user-friendly platform that connects consumers with businesses offering valuable experiences and services.",
              ),

              const SizedBox(height: 8),
              _section("What We Offer"),

              _bullet(
                "Exclusive Deals",
                "Save on dining, wellness, fitness, and entertainment with exclusive offers from top-rated merchants.",
              ),

              _bullet(
                "Personalized Recommendations",
                "Browse curated deals based on your preferences and location.",
              ),

              _bullet(
                "Seamless Redemption",
                "Redeem deals easily through QR codes or manual codes at participating merchants.",
              ),

              _bullet(
                "Loyalty & Rewards",
                "Earn rewards for every deal you redeem with our loyalty program.",
              ),

              const SizedBox(height: 8),
              _section("Our Promise"),

              _paragraph(
                "We are committed to delivering a seamless experience where discovering great deals is easy and rewarding. We work closely with local businesses to ensure every offer provides real value.",
              ),

              _paragraph(
                "Thank you for choosing App Name. We are excited to help you discover, redeem, and enjoy the best local deals near you.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------- UI Helpers -----------------

  Widget _section(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppText.h4.semiBold, // Clean heading style
      ),
    );
  }

  Widget _paragraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        text,
        style: AppText.body2.regular,
        textAlign: TextAlign.justify,
      ),
    );
  }

  Widget _bullet(String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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