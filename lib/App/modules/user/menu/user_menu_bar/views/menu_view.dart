import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';

import '../../../../../core/values/app_color.dart';
import '../../../../../core/values/app_text.dart';
import '../../../../../core/widgets/App_button.dart';
import '../../../../../core/widgets/common_app_bar.dart';
import '../../../../../data/services/storage_service.dart';
import '../../../../../routes/app_routes.dart';
import '../controller/menu_controller.dart';

class MenuView extends GetView<UserMenuController> {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final isLoggedIn =
        Get.find<StorageService>().accessToken?.isNotEmpty == true;
    return Scaffold(
      appBar: const CommonAppBar(title: "Menu", showBack: false),
      body: SafeArea(
        child: Column(
          children: [
            // ===== Fixed avatar =====
            Column(
              children: [
                /// Profile Image
                Obx(
                      () => Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundImage: controller.profileImage.value != null
                            ? FileImage(controller.profileImage.value!)
                            : controller.profileImageUrl.value.isNotEmpty
                            ? NetworkImage(controller.profileImageUrl.value)
                            : const NetworkImage(
                          "https://img.favpng.com/20/11/12/computer-icons-user-profile-png-favpng-0UAKKCpRRsMj5NaiELzw1pV7L.jpg",
                        ) as ImageProvider,
                      ),

                      InkWell(
                        onTap: controller.onEditProfileTap,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: AppColor.primary,
                          child: const Icon(
                            Icons.camera_alt,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),



                /// Name + Edit + Save
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: Obx(
                              () => TextField(
                            controller: controller.nameController,
                            enabled: controller.isEditing.value,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Your Name",
                            ),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      /// Edit Icon
                      Obx(
                            () => IconButton(
                          onPressed: () {
                            controller.isEditing.toggle();
                          },
                          icon: Icon(
                            controller.isEditing.value
                                ? Icons.close
                                : Icons.edit,
                          ),
                        ),
                      ),

                      /// Save Icon
                      Obx(
                            () => controller.isUpdating.value
                            ? const SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: Colors.black,
                          ),
                        )
                            : IconButton(
                          onPressed: controller.updateProfile,
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                    _menuItem(Icons.key, "Change Password", () {
                      final token = Get.find<StorageService>().accessToken;

                      if (token == null || token.isEmpty) {
                        Get.snackbar(
                          "Login Required",
                          "Please login first to change your password",
                          snackPosition: SnackPosition.TOP,
                        );
                        return;
                      }
                      controller.changePassword();
                    }),
                    _menuItem(
                      Icons.info_outline,
                      "About Us",
                      controller.goToAbout,
                    ),
                    _menuItem(
                      Icons.contact_support_outlined,
                      "Contact Us",
                      controller.onContactUsTap,
                    ),
                    _menuItem(
                      Icons.emergency,
                      "Help & Support",
                      controller.onHelpSupportTap,
                    ),
                    const SizedBox(height: 24),
                    _menuItem(
                      Icons.privacy_tip_outlined,
                      "Privacy Policy",
                      controller.onPrivacyPolicyTap,
                    ),
                    _menuItem(
                      Icons.description_outlined,
                      "Terms & Condition",
                      controller.onTermsTap,
                    ),
                    _menuItem(
                      Icons.star_rate_outlined,
                      "Rate the App",
                      controller.onRateAppTap,
                    ),
                    _menuItem(
                      Icons.share_outlined,
                      "Invite Friends",
                      controller.onInviteFriendsTap,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: AppButton(
                          text: isLoggedIn ? 'Logout' : 'Login',
                          onPressed: () async {
                            if (!isLoggedIn) {
                              Get.toNamed(AppRoutes.USER_LOGIN);
                              return;
                            }

                            await controller.onLogoutTap();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
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
