import 'package:flutter/material.dart';
import '../values/app_color.dart';

class CustomDropdownField extends StatelessWidget {
  final String hint;
  final List<DropdownMenuItem<String>> items;
  final String? value;
  final void Function(String?)? onChanged;
  final IconData? icon;

  const CustomDropdownField({
    super.key,
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      items: items,

      // ✅ FIX
      isExpanded: true,
      icon: const Icon(Icons.keyboard_arrow_down),

      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColor.primary,
            width: 1,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 1),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColor.primary,
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
      ),

      // ✅ Long selected text fix
      selectedItemBuilder: (context) {
        return items.map((item) {
          return Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.value == null ? '' : _getText(item.child),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          );
        }).toList();
      },
    );
  }

  String _getText(Widget child) {
    if (child is Text) {
      return child.data ?? '';
    }
    return '';
  }
}