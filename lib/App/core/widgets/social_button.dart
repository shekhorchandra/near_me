import 'package:flutter/material.dart';

import '../values/app_color.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final String iconPath; // changed to asset path
  final VoidCallback onPressed;

  const SocialButton({super.key, required this.text, required this.iconPath, required this.onPressed, });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        side: const BorderSide(color: Colors.grey, width: 0), // White border
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, width: 24, height: 24),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColor.primary),
          ),
        ],
      ),
    );
  }
}
