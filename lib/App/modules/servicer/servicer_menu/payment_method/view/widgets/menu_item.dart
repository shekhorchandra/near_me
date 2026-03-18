
import 'package:flutter/material.dart';

import '../../../../../../core/values/app_color.dart';
import '../../../../../../core/values/app_text.dart';

class KMenuItem extends StatelessWidget {
  const KMenuItem({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.showDivider = true,
  });

  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          // dense: true,
          leading: Icon(icon),
          title: Text(title, style: AppText.body2.semiBold),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
          onTap: onTap,
        ),
        if (showDivider) Divider(color: Color(0xFFE0E0E0), height: 0),
      ],
    );
  }
}
