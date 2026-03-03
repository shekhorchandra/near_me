import 'package:flutter/material.dart';

import '../values/app_color.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData? icon;
  final bool obscure;
  final Widget? suffix;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final int? maxLines;
  final String? errorText;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.hint,
    this.icon,
    this.obscure = false,
    this.suffix,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.onChanged,
    this.maxLength,
    this.maxLines,
    this.errorText,
    this.focusNode,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final safeMaxLines = obscure ? 1 : (maxLines ?? 1);
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscure,
      keyboardType: keyboardType,
      onChanged: onChanged,
      maxLength: maxLength,
      maxLines: safeMaxLines,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        errorText: errorText,
        prefixIcon: icon != null ? Icon(icon) : null,
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        //  Default border
        border: OutlineInputBorder(
          borderRadius: maxLines == null ? BorderRadius.circular(10) : BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.primary, width: 1),
        ),

        //  Enabled (not focused)
        enabledBorder: OutlineInputBorder(
          borderRadius: maxLines == null ? BorderRadius.circular(10) : BorderRadius.circular(10),
          borderSide: const BorderSide(
              // color: AppColor.border,
              width: 1),
        ),

        //  Focused
        focusedBorder: OutlineInputBorder(
          borderRadius: maxLines == null ? BorderRadius.circular(10) : BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColor.primary, width: 1.5),
        ),

        //  Error (optional)
        errorBorder: OutlineInputBorder(
          borderRadius: maxLines == null ? BorderRadius.circular(10) : BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: maxLines == null ? BorderRadius.circular(10) : BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}
