import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../values/app_color.dart';
import '../values/app_text.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? titleColor;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.onBack,
    this.actions,
    this.backgroundColor,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColor.BG;
    final fgColor = AppColor.onColor(bgColor);

    return AppBar(
      backgroundColor: bgColor,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,

      leading: showBack
          ? IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: iconColor ?? fgColor,
          size: 20,
        ),
        onPressed: onBack ?? () => Get.back(),
      )
          : null,

      title: Text(
        title,
        style: AppText.h4
            .semiBold
            .copyWith(color: titleColor ?? fgColor),
      ),

      iconTheme: IconThemeData(
        color: iconColor ?? fgColor,
      ),

      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}