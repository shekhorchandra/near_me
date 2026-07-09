import 'package:flutter/material.dart' hide MenuController;
import 'package:get/get.dart';
import '../../../../../core/values/app_assets.dart';
import '../../../../../core/values/app_color.dart';
import '../../../../../core/values/app_text.dart';
import '../../../../../core/widgets/App_button.dart';
import '../../../../../core/widgets/common_app_bar.dart';
import '../../../../../routes/app_routes.dart';
import '../../payment_method/view/widgets/menu_item.dart';
import '../controller/servicer_menu_controller.dart';

class ServicerMenuView extends GetView<ServicerMenuController> {
  const ServicerMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Servicer Menu", showBack: false),
      body: SafeArea(
        child: Column(
          children: [
            // ===== Fixed avatar =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: controller.goToaccountedit,

                child: Container(
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
                  child: Row(
                    children: [
                      Obx(() {
                        return CircleAvatar(
                          radius: 30,
                          backgroundColor: AppColor.primary.withOpacity(0.1),
                          backgroundImage:
                              controller.companyLogo.value.isNotEmpty
                              ? NetworkImage(controller.companyLogo.value)
                              : null,
                          child: controller.companyLogo.value.isEmpty
                              ? Image.asset(
                                  AppAssets.usercat,
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.contain,
                                )
                              : null,
                        );
                      }),

                      const SizedBox(width: 12),
                      Obx(() {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.serviceName.value,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              controller.providerEmail.value,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        );
                      }),
                      const Spacer(),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: controller.review,
                child: Container(
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
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "★ Reviews",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                        "https://i.pravatar.cc/150?img=5",
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                        "https://i.pravatar.cc/150?img=6",
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                        "https://i.pravatar.cc/150?img=7",
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                        "https://i.pravatar.cc/150?img=8",
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    CircleAvatar(
                                      radius: 10,
                                      backgroundImage: NetworkImage(
                                        "https://i.pravatar.cc/150?img=9",
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // ===== Scrollable menu =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Settings", style: AppText.textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    _menuItem(
                      Icons.key,
                      "Change Password",
                      controller.changePassword,
                    ),
                    KMenuItem(
                      title: 'Payment Methods',
                      icon: Icons.credit_card_rounded,
                      onTap: () => Get.toNamed(AppRoutes.PAYMENT_METHOD),
                    ),
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
                      Icons.delete_forever,
                      "Delete Provider Account",
                      controller.deleteProviderAccount,
                    ),
                    // _menuItem(
                    //   Icons.star_rate_outlined,
                    //   "Rate the App",
                    //   controller.onRateAppTap,
                    // ),
                    // _menuItem(
                    //   Icons.share_outlined,
                    //   "Invite Friends",
                    //   controller.onInviteFriendsTap,
                    // ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: AppButton(
                        text: 'Logout',
                        onPressed: controller.serviceronLogoutTap,
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
    final isDelete = icon == Icons.delete_forever;

    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: isDelete ? Colors.red : null,
          ),
          title: Text(
            title,
            style: AppText.body2.semiBold.copyWith(
              color: isDelete ? Colors.red : null,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: isDelete ? Colors.red : null,
          ),
          onTap: onTap,
        ),
        const Divider(
          color: Color(0xFFE0E0E0),
          height: 0,
        ),
      ],
    );
  }
}
