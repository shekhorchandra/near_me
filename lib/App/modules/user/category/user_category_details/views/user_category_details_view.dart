import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import 'package:near_me/App/core/widgets/common_app_bar.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../routes/app_routes.dart';
import '../../user_category_service_details/models/ReviewModel.dart';
import '../controller/user_category_details_controller.dart';

class UserCategoryDetailsView extends GetView<UserCategoryDetailsController> {
  const UserCategoryDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;

    final categoryName = args != null && args['name'] != null
        ? args['name'] as String
        : 'Category Details';

    return Scaffold(
      appBar: CommonAppBar(title: categoryName),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              /// SEARCH
              CustomTextField(
                hint: 'Search services...',
                icon: Icons.search,
                onChanged: (value) {
                  controller.searchText.value = value;
                  controller.fetchServicesByCategory(); // ✅ call API
                },
              ),

              ///  dropdown
              Row(
                children: [
                  /// ⭐ Rating
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: controller.selectedRating.value,
                      items: ['Rating', 'All', '5', '4+', '3+']
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e, overflow: TextOverflow.ellipsis),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        controller.selectedRating.value = v!;
                        controller.applyFilters();
                      },
                    ),
                  ),

                  const SizedBox(width: 6),

                  /// 📍 Radius
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: controller.selectedRadius.value,
                      items: ['Radius', 'All', '1 mile', '5 mile', '10 mile']
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e, overflow: TextOverflow.ellipsis),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        controller.selectedRadius.value = v!;
                        controller.applyFilters();
                      },
                    ),
                  ),

                  const SizedBox(width: 6),

                  /// 🟢 Availability
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: controller.selectedAvailability.value,
                      items: ['Availability', 'All', 'Available', 'Busy']
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e, overflow: TextOverflow.ellipsis),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        controller.selectedAvailability.value = v!;
                        controller.applyFilters();
                      },
                    ),
                  ),
                ],
              ),

              /// MAIN BODY
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// LEFT COLUMN (TREE)
                    Container(
                      width: MediaQuery.of(context).size.width * 0.35,
                      color: Colors.white,
                      child: Obx(() {
                        if (controller.isLoadingTree.value) {
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.black),
                          );
                        }

                        final tree = controller.categoryTree.value;

                        if (tree == null ||
                            (tree['children'] == null) ||
                            (tree['children'] as List).isEmpty) {
                          return const SizedBox.shrink();
                        }

                        return SingleChildScrollView(child: buildCategoryTree(tree));
                      }),
                    ),

                    const SizedBox(width: 8),

                    /// RIGHT COLUMN (SERVICES)
                    Expanded(
                      child: Column(
                        children: [
                          /// SERVICES LIST
                          Expanded(
                            child: Obx(() {
                              if (controller.isLoadingServices.value) {
                                return const Center(
                                  child: CircularProgressIndicator(color: Colors.black),
                                );
                              }

                              if (controller.services.isEmpty) {
                                return const Center(child: Text("No Services Found"));
                              }

                              return ListView.builder(
                                itemCount: controller.services.length,
                                itemBuilder: (context, index) {
                                  final service = controller.services[index];

                                  return Card(
                                    margin: const EdgeInsets.symmetric(vertical: 4),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            service.image,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Image.asset(
                                                "assets/images/placeholder.jpg",
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),

                                          const SizedBox(height: 8),

                                          Text(
                                            service.title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          InfoRow(
                                            icon: Icons.star,
                                            text: service.rating.toString(),
                                          ),

                                          InfoRow(
                                            icon: Icons.location_on,
                                            text: "${service.distance} miles",
                                          ),

                                          InfoRow(icon: Icons.schedule, text: service.schedule),

                                          InfoRow(
                                            icon: Icons.location_city,
                                            text: service.location,
                                          ),

                                          const SizedBox(height: 10),

                                          /// VIEW DETAILS BUTTON
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: AppButton(
                                              width: double.infinity,
                                              height: 32,
                                              text: "View Details",
                                              onPressed: () {
                                                Get.toNamed(
                                                  AppRoutes.SERVICE_DETAILS,
                                                  arguments: {
                                                    "id": service.id,
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// RECURSIVE CATEGORY TREE

  Widget buildCategoryTree(Map<String, dynamic> node, {int level = 0}) {
    final children = (node['children'] as List?) ?? [];
    final id = node['_id'] ?? '';
    final name = node['name'] ?? '';

    /// ❌ SKIP LEVEL 0 (DO NOT SHOW)
    if (level == 0) {
      return Column(
        children: children
            .map<Widget>(
              (child) => buildCategoryTree(
                child,
                level: 1, // start from level 1
              ),
            )
            .toList(),
      );
    }

    /// ONLY LEVEL 2 IS SELECTABLE
    final isSelectable = level == 2;

    final isSelected = controller.selectedCategoryIds.contains(id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// NODE ROW
        Padding(
          padding: EdgeInsets.only(left: (level - 1) * 14.0),
          child: Row(
            children: [
              /// CHECKBOX ONLY FOR LEVEL 2
              if (isSelectable)
                Checkbox(value: isSelected, onChanged: (_) => controller.toggleCategory(id))
              else
                const SizedBox(width: 24),

              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontWeight: level == 1 ? FontWeight.bold : FontWeight.normal,
                    color: isSelectable ? Colors.black : Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
        ),

        /// CHILDREN
        if (children.isNotEmpty)
          Column(
            children: children
                .map<Widget>((child) => buildCategoryTree(child, level: level + 1))
                .toList(),
          ),
      ],
    );
  }
}

/// INFO ROW

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12),
        const SizedBox(width: 4),
        Expanded(
          child: Text(text, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
        ),
      ],
    );
  }
}
