import 'package:flutter/material.dart';
import '../values/app_color.dart'; // Only your project's AppColor

final checkboxTheme = CheckboxThemeData(
  checkColor: MaterialStateProperty.all(AppColor.BG), // white checkmark
  fillColor: MaterialStateProperty.resolveWith<Color>((states) {
    if (states.contains(MaterialState.selected)) {
      return AppColor.primary;
    }
    return AppColor.BG; // unchecked background
  }),
  side: BorderSide(color: AppColor.neutral.s400), // optional border
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4),
  ),
);