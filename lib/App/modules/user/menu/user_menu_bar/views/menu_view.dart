

import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';

import '../../../../../core/values/app_color.dart';
import '../../../../../core/values/app_text.dart';
import '../../../../../core/widgets/App_button.dart';
import '../../../../../core/widgets/common_app_bar.dart';
import '../controller/menu_controller.dart';

class MenuView extends GetView<UserMenuController> {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Menu", showBack: false),
      body: Column(
        children: [
          // ===== Fixed avatar =====
          const SizedBox(height: 16),
          Center(
            child: Obx(() => Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: controller.profileImage.value != null
                      ? FileImage(controller.profileImage.value!)
                      : const NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmWDpF64gI24qp2wTAPnj_oA0QJZp7WFYvSw&s")
                  as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: controller.onEditProfileTap,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColor.primary,
                      child: const Icon(Icons.camera_alt,
                          size: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            )),
          ),
          const SizedBox(height: 24),
          // ===== Scrollable menu =====
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Settings", style: AppText.textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  _menuItem(Icons.key, "Change Password", controller.changePassword),
                  _menuItem(Icons.info_outline, "About Us", controller.goToAbout),
                  _menuItem(Icons.contact_support_outlined, "Contact Us", controller.onContactUsTap),
                  _menuItem(Icons.emergency, "Help & Support", controller.onHelpSupportTap),
                  const SizedBox(height: 24),
                  _menuItem(Icons.privacy_tip_outlined, "Privacy Policy", controller.onPrivacyPolicyTap),
                  _menuItem(Icons.description_outlined, "Terms & Condition", controller.onTermsTap),
                  _menuItem(Icons.star_rate_outlined, "Rate the App", controller.onRateAppTap),
                  _menuItem(Icons.share_outlined, "Invite Friends", controller.onInviteFriendsTap),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: AppButton(
                      text: 'Logout',
                      onPressed: controller.onLogoutTap,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, color: AppColor.neutral.s400),
          title: Text(title, style: AppText.textTheme.titleSmall),
          trailing: const Icon(Icons.arrow_forward_ios, size: 12),
          onTap: onTap,
        ),
        const Divider(height: 0, thickness: 0.1),
      ],
    );
  }
}