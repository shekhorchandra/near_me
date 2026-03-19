import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import 'package:near_me/App/modules/auth/service/servicer_account/controller/service_provider_controller.dart';
import '../values/app_color.dart';


class MultiSelectDropdownField extends StatelessWidget {
  final String hint;
  final IconData? icon;

  const MultiSelectDropdownField({
    super.key,
    required this.hint,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceProviderController>();

    return Obx(() {
      return GestureDetector(
        onTap: () {
          _showMultiSelectDialog(context, controller);
        },
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: controller.selectedServices.isEmpty
                  ? hint
                  : controller.selectedServices.join(', '),

              prefixIcon: icon != null ? Icon(icon) : null,
              suffixIcon: const Icon(Icons.keyboard_arrow_down),

              contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 20),

              // SAME DESIGN
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

  void _showMultiSelectDialog(
      BuildContext context, ServiceProviderController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Obx(() => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Select Services (Max 5)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ...controller.services.map((service) {
              final isSelected =
              controller.selectedServices.contains(service);

              return CheckboxListTile(
                value: isSelected,
                title: Text(service),
                onChanged: (_) {
                  controller.toggleService(service);
                },
              );
            }).toList(),

            const SizedBox(height: 10),

            AppButton(
              onPressed: () => Get.back(),
              text: 'Done',
            ),

            const SizedBox(height: 40),
          ],
        )),
      ),
    );
  }
}