import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import 'package:near_me/App/core/widgets/common_app_bar.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/skeleton_loader.dart'; // ✅ ADD
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
                  controller.fetchServicesByCategory();
                },
              ),

              /// DROPDOWN
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: controller.selectedRating.value,
                      items: [
                        'Rating',
                        'All',
                        '5',
                        '4+',
                        '3+',
                      ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) {
                        controller.selectedRating.value = v!;
                        controller.applyFilters();
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: controller.selectedRadius.value,
                      items: [
                        'Radius',
                        'All',
                        '1 mile',
                        '5 mile',
                        '10 mile',
                      ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) {
                        controller.selectedRadius.value = v!;
                        controller.applyFilters();
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: controller.selectedAvailability.value,
                      items: [
                        'Availability',
                        'All',
                        'Available',
                        'Busy',
                      ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                      onChanged: (v) {
                        controller.selectedAvailability.value = v!;
                        controller.applyFilters();
                      },
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// LEFT TREE CARD
                    Expanded(
                      flex: 35,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: Obx(() {
                          ///  FIRST SHOW LOADING
                          if (controller.isLoadingTree.value) {
                            return SkeletonLoader.list(itemCount: 6);
                          }

                          final tree = controller.categoryTree.value;

                          ///  EMPTY STATE
                          if (tree == null ||
                              tree.isEmpty ||
                              tree['children'] == null ||
                              (tree['children'] as List).isEmpty) {
                            return const Center(child: Text("No Categories Found"));
                          }

                          ///  DATA
                          return SingleChildScrollView(child: buildCategoryTree(tree));
                        }),
                      ),
                    ),

                    const SizedBox(width: 2),

                    /// RIGHT SERVICES CARD
                    Expanded(
                      flex: 65,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Obx(() {
                          /// ✅ FIRST SHOW LOADING
                          if (controller.isLoadingServices.value) {
                            return ListView.builder(
                              itemCount: 5,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: SkeletonLoader.card(height: 180),
                                );
                              },
                            );
                          }

                          /// ✅ EMPTY STATE
                          if (controller.services.isEmpty) {
                            return const Center(child: Text("No Services Found"));
                          }

                          /// ✅ DATA
                          return ListView.builder(
                            itemCount: controller.services.length,
                            itemBuilder: (context, index) {
                              final service = controller.services[index];

                              return Card(
                                elevation: 2,
                                color: Colors.white,
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
                                            "assets/images/placeholder2.jpg",
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

                                      InfoRow(icon: Icons.star, text: service.rating.toString()),

                                      InfoRow(
                                        icon: Icons.location_on,
                                        text: "${service.distance} miles",
                                      ),

                                      InfoRow(icon: Icons.schedule, text: service.schedule),

                                      InfoRow(icon: Icons.location_city, text: service.location),

                                      const SizedBox(height: 10),

                                      AppButton(
                                        width: double.infinity,
                                        height: 32,
                                        text: "View Details",
                                        onPressed: () {
                                          Get.toNamed(
                                            AppRoutes.SERVICE_DETAILS,
                                            arguments: {"id": service.id},
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
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

  Widget buildCategoryTree(Map<String, dynamic> node, {int level = 0}) {
    final children = (node['children'] as List?) ?? [];
    final id = node['_id'] ?? '';
    final name = node['name'] ?? '';

    /// Skip root level
    if (level == 0) {
      return Column(
        children: children.map<Widget>((child) => buildCategoryTree(child, level: 1)).toList(),
      );
    }

    final isSelectable = level == 2;
    final isSelected = controller.selectedCategoryIds.contains(id);

    /// If node has children -> expandable
    if (children.isNotEmpty) {
      return ExpansionTile(
        tilePadding: EdgeInsets.only(left: (level - 1) * 12, right: 8),
        childrenPadding: EdgeInsets.zero,
        title: Row(
          children: [
            if (isSelectable)
              Checkbox(value: isSelected, onChanged: (_) => controller.toggleCategory(id))
            else
              const SizedBox(width: 24),

            Expanded(
              child: Text(
                name,
                style: TextStyle(fontWeight: level == 1 ? FontWeight.bold : FontWeight.normal),
              ),
            ),
          ],
        ),
        children: children
            .map<Widget>((child) => buildCategoryTree(child, level: level + 1))
            .toList(),
      );
    }

    /// If no children -> normal row
    return Padding(
      padding: EdgeInsets.only(left: (level - 1) * 12, right: 8),
      child: Row(
        children: [
          if (isSelectable)
            Checkbox(value: isSelected, onChanged: (_) => controller.toggleCategory(id))
          else
            const SizedBox(width: 24),

          Expanded(
            child: Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(name)),
          ),
        ],
      ),
    );
  }
}

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
