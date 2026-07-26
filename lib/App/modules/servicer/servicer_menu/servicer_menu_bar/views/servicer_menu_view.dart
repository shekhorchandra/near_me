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
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.serviceName.value.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        }

        return RefreshIndicator(
          color: AppColor.primary,
          onRefresh: controller.fetchServiceProfile,
          child: SafeArea(
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              children: [
                // ================= Profile Card =================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
                            final String logo = controller.companyLogo.value
                                .trim();

                            return CircleAvatar(
                              radius: 30,
                              backgroundColor: AppColor.primary.withOpacity(0.1),
                              child: ClipOval(
                                child: Image.asset(
                                  AppAssets.usercat,
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }),
                          const SizedBox(width: 12),

                          // Prevents long name/email overflow.
                          Expanded(
                            child: Obx(() {
                              final String email =
                              controller.providerEmail.value.trim();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "All Created Service List",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    email.isNotEmpty
                                        ? email
                                        : "View all your created services",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),

                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ================= Reviews Card =================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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
                          const Expanded(
                            child: Text(
                              "★ Reviews",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const _ReviewAvatars(),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_ios, size: 16),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ================= Settings =================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Settings",
                    style: AppText.textTheme.headlineSmall,
                  ),
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _menuItem(
                        Icons.key,
                        "Change Password",
                        controller.changePassword,
                      ),
                      KMenuItem(
                        title: "Payment Methods",
                        icon: Icons.credit_card_rounded,
                        onTap: () {
                          Get.toNamed(AppRoutes.PAYMENT_METHOD);
                        },
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

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: AppButton(
                          text: "Logout",
                          onPressed: controller.serviceronLogoutTap,
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    final isDelete = icon == Icons.delete_forever;

    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: isDelete ? Colors.red : null),
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
        const Divider(color: Color(0xFFE0E0E0), height: 0),
      ],
    );
  }
}

class _ReviewAvatars extends StatelessWidget {
  const _ReviewAvatars();

  @override
  Widget build(BuildContext context) {
    const images = [
      "https://i.pravatar.cc/150?img=5",
      "https://i.pravatar.cc/150?img=6",
      "https://i.pravatar.cc/150?img=7",
      "https://i.pravatar.cc/150?img=8",
      "https://i.pravatar.cc/150?img=9",
    ];

    return SizedBox(
      width: 76,
      height: 24,
      child: Stack(
        children: List.generate(images.length, (index) {
          return Positioned(
            left: index * 13,
            child: CircleAvatar(
              radius: 11,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 9.5,
                backgroundImage: NetworkImage(images[index]),
              ),
            ),
          );
        }),
      ),
    );
  }
}
