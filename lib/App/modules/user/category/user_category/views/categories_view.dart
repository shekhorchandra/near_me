/// ===============================
/// categories_view.dart
/// ===============================
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/common_app_bar.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../routes/app_routes.dart';
import '../controller/categories_controller.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: 'User Categories',
        showBack: false,
      ),
      body: SafeArea(
        child: Column(
          children: [

            /// SEARCH
            Padding(
              padding: const EdgeInsets.all(12),
              child: CustomTextField(
                hint: 'Search categories...',
                icon: Icons.search,
                onChanged: (value) {
                  controller.searchText.value = value;

                  /// API Search
                  controller.fetchCategories(keyword: value);
                },
              ),
            ),

            /// LIST
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (controller.categories.isEmpty) {
                  return const Center(
                    child: Text("No Categories Found"),
                  );
                }

                return ListView.builder(
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category =
                    controller.categories[index];

                    return ListTile(
                      leading: SizedBox(
                        width: 60,
                        height: 60,
                        child: Image.asset(
                          category["image"]!,
                          fit: BoxFit.contain,
                        ),
                      ),
                      title: Text(
                        category["name"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.USER_CATEGORY_DETAILS,
                          arguments: {
                            "id": category["id"],
                            "name": category["name"],
                          },
                        );
                      },
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}