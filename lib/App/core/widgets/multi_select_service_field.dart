import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/App_button.dart';
import 'package:near_me/App/core/widgets/custom_text_field.dart';

class MultiSelectServiceField<T> extends StatelessWidget {
  final String title;
  final String hint;
  final IconData icon;

  final List<T> items;
  final List<String> selectedIds;

  final String Function(T) getId;
  final String Function(T) getName;

  final Function(String id) onToggle;

  final TextEditingController customController;
  final VoidCallback onAddCustom;

  const MultiSelectServiceField({
    super.key,
    required this.title,
    required this.hint,
    required this.icon,
    required this.items,
    required this.selectedIds,
    required this.getId,
    required this.getName,
    required this.onToggle,
    required this.customController,
    required this.onAddCustom,
  });

  void _openSheet(BuildContext context) {
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
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),

              Expanded(
                child: ListView(
                  children: items.map((item) {
                    final id = getId(item);
                    final name = getName(item);
                    final isSelected = selectedIds.contains(id);

                    return CheckboxListTile(
                      value: isSelected,
                      title: Text(name),
                      onChanged: (_) => onToggle(id),
                    );
                  }).toList(),
                ),
              ),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: customController,
                      hint: "Add custom service",
                    ),
                  ),
                  const SizedBox(width: 8),
                  AppButton(
                    width: 60,
                    height: 40,
                    onPressed: onAddCustom,
                    text: "Add",
                  ),
                ],
              ),

              const SizedBox(height: 10),

              AppButton(
                onPressed: () => Get.back(),
                text: "Done",
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedNames = items
        .where((e) => selectedIds.contains(getId(e)))
        .map(getName)
        .join(', ');

    return GestureDetector(
      onTap: () => _openSheet(context),
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            hintText: selectedIds.isEmpty ? hint : selectedNames,
            prefixIcon: Icon(icon),
            suffixIcon: const Icon(Icons.keyboard_arrow_down),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}