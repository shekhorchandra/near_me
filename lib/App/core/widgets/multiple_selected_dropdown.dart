import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import 'package:near_me/App/core/widgets/custom_text_field.dart';
import 'package:near_me/App/modules/auth/service/servicer_account/controller/service_provider_controller.dart';
import '../../modules/auth/service/servicer_account/models/category_model.dart';
import '../values/app_color.dart';

class MultiSelectDropdownField extends StatelessWidget {
  final String hint;
  final IconData? icon;
  final bool isChild;

  final ServiceProviderController controller;

  const MultiSelectDropdownField({
    super.key,
    required this.hint,
    this.icon,
    required this.controller,
    this.isChild = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // ✅ choose correct list
      final list = isChild
          ? controller.childServices
          : controller.services;

      final selectedIds = isChild
          ? controller.selectedChildServiceIds
          : controller.selectedServiceIds;

      // ✅ selected names
      final selectedNames = list
          .where((s) => selectedIds.contains(s.id))
          .map((e) => e.name)
          .join(', ');

      return GestureDetector(
        onTap: () {
          _showMultiSelectDialog(context);
        },
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: selectedIds.isEmpty ? hint : selectedNames,

              prefixIcon: icon != null ? Icon(icon) : null,
              suffixIcon: const Icon(Icons.keyboard_arrow_down),

              contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                const BorderSide(color: AppColor.primary, width: 1),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 1),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                    color: AppColor.primary, width: 1.5),
              ),
            ),
          ),
        ),
      );
    });
  }

  void _showMultiSelectDialog(BuildContext context) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          height: Get.height * 0.75,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Text(
                isChild
                    ? "Select Child Services (Max 5)"
                    : "Select Services (Max 5)",
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              /// ✅ SERVICE LIST
              Expanded(
                child: Obx(() {
                  // 🔥 FIX: dynamic list based on type
                  final list = isChild
                      ? controller.childServices
                      : controller.services;

                  // 🔥 FIX: dynamic selected ids
                  final selectedIds = isChild
                      ? controller.selectedChildServiceIds
                      : controller.selectedServiceIds;

                  return ListView(
                    children: [
                      ...list.map((service) {
                        final isSelected =
                        selectedIds.contains(service.id);

                        return CheckboxListTile(
                          value: isSelected,
                          title: Text(service.name),
                          onChanged: (_) {
                            if (isChild) {
                              controller.toggleChildService(service.id);
                            } else {
                              controller.toggleService(service.id);
                            }
                          },
                        );
                      }).toList(),

                      const SizedBox(height: 10),

                      /// ✅ CUSTOM SERVICE ADD
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller:
                              controller.customServiceController,
                              hint: isChild
                                  ? 'Add child service'
                                  : 'Add service',
                            ),
                          ),
                          const SizedBox(width: 8),
                          AppButton(
                            width: 60,
                            height: 40,
                            onPressed: () {
                              final value = controller
                                  .customServiceController.text
                                  .trim();

                              if (value.isEmpty) return;

                              // 🔥 LIMIT CHECK
                              if (selectedIds.length >= 5) {
                                Get.snackbar(
                                    'Limit', 'Max 5 allowed');
                                return;
                              }

                              final customId =
                              DateTime.now().toString();

                              final newCategory = Category(
                                id: customId,
                                name: value,
                                children: [],
                              );

                              if (isChild) {
                                controller.childServices.add(newCategory);
                                controller.selectedChildServiceIds
                                    .add(customId);
                              } else {
                                controller.services.add(newCategory);
                                controller.selectedServiceIds
                                    .add(customId);
                              }

                              controller.customServiceController.clear();
                            },
                            text: 'Add',
                          ),
                        ],
                      ),
                    ],
                  );
                }),
              ),

              /// ✅ DONE BUTTON
              AppButton(
                onPressed: () => Get.back(),
                text: 'Done',
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}