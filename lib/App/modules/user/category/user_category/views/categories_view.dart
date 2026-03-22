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
      appBar: CommonAppBar(title: 'User Categories', showBack: false,),
      body: SafeArea(
        child: Column(
          children: [
        
            /// Search Bar
            Padding(
              padding: const EdgeInsets.all(12),
              child: CustomTextField(
                hint: 'Search servicer_highlight...',
                icon: Icons.search,
                onChanged: (value) => controller.searchText.value = value,
              ),
            ),
        
            /// Category List
            Expanded(
              child: Obx(() => ListView.builder(
                itemCount: controller.filteredCategories.length,
                itemBuilder: (context, index) {
                  final category = controller.filteredCategories[index];
        
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
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.USER_CATEGORY_DETAILS,
                        arguments: {
                          'id': category['id'] ?? 'trades_services',
                          'name': category['name'] ?? 'Trades & Services',
                        },
                      );
                    },
                  );
                },
              )),
            ),
          ],
        ),
      ),
    );
  }
}