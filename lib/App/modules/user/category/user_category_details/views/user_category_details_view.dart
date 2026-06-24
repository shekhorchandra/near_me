import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import 'package:near_me/App/core/widgets/common_app_bar.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/skeleton_loader.dart';
import '../../../../../routes/app_routes.dart';
import '../../FullImageView.dart';
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
      endDrawer: Drawer(
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoadingTree.value) {
              return SkeletonLoader.list(itemCount: 6);
            }

            final tree = controller.categoryTree.value;

            if (tree == null ||
                tree.isEmpty ||
                tree['children'] == null ||
                (tree['children'] as List).isEmpty) {
              return const Center(child: Text("No Categories Found"));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: buildCategoryTree(tree),
            );
          }),
        ),
      ),
      appBar: CommonAppBar(title: categoryName, showBack: true),
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

              const SizedBox(height: 10),

              /// DROPDOWN
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 140,
                      child: DropdownButtonFormField<String>(
                        value: controller.selectedRating.value,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        items: const ['Rating', 'All', '5', '4+', '3+']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) {
                          controller.selectedRating.value = v!;
                          controller.applyFilters();
                        },
                      ),
                    ),

                    const SizedBox(width: 8),

                    SizedBox(
                      width: 140,
                      child: DropdownButtonFormField<String>(
                        value: controller.selectedRadius.value,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        items: const ['Radius', 'All', '1 mile', '5 mile', '10 mile']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) {
                          controller.selectedRadius.value = v!;
                          controller.applyFilters();
                        },
                      ),
                    ),

                    const SizedBox(width: 8),

                    SizedBox(
                      width: 140,
                      child: DropdownButtonFormField<String>(
                        value: controller.selectedAvailability.value,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        items: const ['Availability', 'All', 'Available', 'Busy']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (v) {
                          controller.selectedAvailability.value = v!;
                          controller.applyFilters();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// LEFT TREE CARD
                    // Expanded(
                    //   flex: 35,
                    //   child: Container(
                    //     padding: const EdgeInsets.all(4),
                    //     child: Obx(() {
                    //       ///  FIRST SHOW LOADING
                    //       if (controller.isLoadingTree.value) {
                    //         return SkeletonLoader.list(itemCount: 6);
                    //       }
                    //
                    //       final tree = controller.categoryTree.value;
                    //
                    //       ///  EMPTY STATE
                    //       if (tree == null ||
                    //           tree.isEmpty ||
                    //           tree['children'] == null ||
                    //           (tree['children'] as List).isEmpty) {
                    //         return const Center(
                    //           child: Text("No Categories Found"),
                    //         );
                    //       }
                    //
                    //       ///  DATA
                    //       return SingleChildScrollView(
                    //         child: buildCategoryTree(tree),
                    //       );
                    //     }),
                    //   ),
                    // ),
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
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: SkeletonLoader.card(height: 180),
                                );
                              },
                            );
                          }

                          /// ✅ EMPTY STATE
                          if (controller.services.isEmpty) {
                            return const Center(
                              child: Text("No Services Found"),
                            );
                          }

                          /// ✅ DATA
                          // return ListView.builder(
                          //   itemCount: controller.services.length,
                          //   itemBuilder: (context, index) {
                          //     final service = controller.services[index];
                          //
                          //     return Card(
                          //       elevation: 2,
                          //       color: Colors.white,
                          //       margin: const EdgeInsets.symmetric(vertical: 4),
                          //       child: Padding(
                          //         padding: const EdgeInsets.all(12),
                          //         child: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           children: [
                          //             AspectRatio(
                          //               aspectRatio: 16 / 9,
                          //               child: ClipRRect(
                          //                 borderRadius: const BorderRadius.only(
                          //                   topLeft: Radius.circular(16),
                          //                   topRight: Radius.circular(16),
                          //                 ),
                          //                 child: Image.network(
                          //                   service.image,
                          //                   width: double.infinity,
                          //                   fit: BoxFit.cover,
                          //                 ),
                          //               ),
                          //             ),
                          //
                          //             const SizedBox(height: 8),
                          //
                          //             Text(
                          //               service.title,
                          //               style: const TextStyle(
                          //                 fontSize: 16,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //
                          //             InfoRow(
                          //               icon: Icons.star,
                          //               text: service.rating.toString(),
                          //             ),
                          //
                          //             InfoRow(
                          //               icon: Icons.location_on,
                          //               text: "${service.distance} miles",
                          //             ),
                          //
                          //             InfoRow(
                          //               icon: Icons.schedule,
                          //               text: service.schedule,
                          //             ),
                          //
                          //             InfoRow(
                          //               icon: Icons.location_city,
                          //               text: service.location,
                          //             ),
                          //
                          //             const SizedBox(height: 10),
                          //
                          //             AppButton(
                          //               width: double.infinity,
                          //               height: 32,
                          //               text: "View Details",
                          //               onPressed: () {
                          //                 Get.toNamed(
                          //                   AppRoutes.SERVICE_DETAILS,
                          //                   arguments: {"id": service.id},
                          //                 );
                          //               },
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // );

                          return ListView.builder(
                            itemCount: controller.services.length,
                            itemBuilder: (context, index) {
                              final service = controller.services[index];

                              return Card(
                                color: Colors.white,
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            topRight: Radius.circular(16),
                                          ),
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.to(() => FullImageView(imageUrl: service.image));
                                            },
                                            child: Image.network(
                                              service.image,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              errorBuilder: (context, error, stackTrace) {
                                                return ClipRRect(
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(16),
                                                    topRight: Radius.circular(16),
                                                  ),
                                                  child: Image.asset(
                                                    "assets/images/placeholder2.jpg",
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),

                                      Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    service.title,
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),

                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Icon(
                                                        Icons.star,
                                                        color: Colors.black,
                                                        size: 14,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        service.rating
                                                            .toString(),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 12),

                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  color: Colors.red,
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Text(
                                                    "${service.distance} miles away",
                                                  ),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 8),

                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.access_time,
                                                  color: Colors.blue,
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Text(service.schedule),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 8),

                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_city,
                                                  color: Colors.green,
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Text(service.location),
                                                ),
                                              ],
                                            ),

                                            const SizedBox(height: 16),

                                            SizedBox(
                                              width: double.infinity,
                                              child: AppButton(
                                                height: 42,
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


  Widget _filterDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 22,
          ),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
          selectedItemBuilder: (context) {
            return items.map((e) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  e,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList();
          },
          items: items.map((e) {
            return DropdownMenuItem<String>(
              value: e,
              child: Text(
                e,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget buildCategoryTree(
    Map<String, dynamic> node, {
    int level = 0,
    String? parentId,
  }) {
    final children = (node['children'] as List?) ?? [];
    final id = node['_id'] ?? '';
    final name = node['name'] ?? '';

    // Skip root
    if (level == 0) {
      return Column(
        children: children
            .map<Widget>((child) => buildCategoryTree(child, level: 1))
            .toList(),
      );
    }

    final isSelectable = level == 2;
    final isSelected = controller.selectedCategoryIds.contains(id);

    if (children.isNotEmpty) {
      return Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: Theme(
          data: Theme.of(
            Get.context!,
          ).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.only(left: 12.0 * level, right: 12),
            childrenPadding: const EdgeInsets.only(bottom: 8),

            // leading: Icon(
            //   Icons.folder_outlined,
            //   color: Colors.black,
            // ),
            title: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: level == 1 ? 16 : 15,
              ),
            ),

            trailing: isSelectable
                ? Checkbox(
                    value: isSelected,
                    onChanged: (_) {
                      controller.selectedSubCategoryId.value = parentId ?? "";
                      controller.selectedChildCategoryId.value = id;
                      controller.toggleCategory(id);
                      Navigator.of(Get.context!).pop(); // Close drawer
                    },
                  )
                : null,

            children: children
                .map<Widget>(
                  (child) =>
                      buildCategoryTree(child, level: level + 1, parentId: id),
                )
                .toList(),
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 20.0 * level, right: 12),

        leading: const Icon(Icons.arrow_right, size: 18, color: Colors.grey),

        title: Text(name, style: const TextStyle(fontSize: 14)),

        trailing: isSelectable
            ? Checkbox(
                value: isSelected,
                onChanged: (_) {
                  controller.selectedSubCategoryId.value = parentId ?? "";
                  controller.selectedChildCategoryId.value = id;
                  controller.toggleCategory(id);

                  Navigator.of(Get.context!).pop(); // Close drawer
                },
              )
            : null,
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
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
