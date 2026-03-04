library;

import 'package:flutter/material.dart';
import 'app_color.dart';

const _textScaleFactor = 1;

abstract class AppFontWeight {
  static const regular = FontWeight.w400;
  static const medium = FontWeight.w500;
  static const semiBold = FontWeight.w600;
  static const bold = FontWeight.w700;
}

class _TextStyleBuilder {
  const _TextStyleBuilder(this.fontSize, this.height);

  final double fontSize;
  final double height;

  TextStyle get regular => _build(AppFontWeight.regular);
  TextStyle get medium => _build(AppFontWeight.medium);
  TextStyle get semiBold => _build(AppFontWeight.semiBold);
  TextStyle get bold => _build(AppFontWeight.bold);

  TextStyle call() => regular;

  TextStyle _build(FontWeight weight) {
    return TextStyle(
      fontFamily: 'FontMain',
      fontSize: fontSize * _textScaleFactor,
      height: height,
      fontWeight: weight,
      color: AppColor.onLight, // Default text color from your color system
    );
  }
}

abstract class AppText {
  /// ===== TITLES =====
  static const title = _TextStyleBuilder(34, 1.2);
  static const title1 = _TextStyleBuilder(28, 1.2);

  /// ===== HEADINGS =====
  static const h0 = _TextStyleBuilder(48, 0.4); // splash screen
  static const h1 = _TextStyleBuilder(24, 1.3);
  static const h2 = _TextStyleBuilder(22, 1.3);
  static const h3 = _TextStyleBuilder(20, 1.3);
  static const h4 = _TextStyleBuilder(18, 1.4);
  static const h5 = _TextStyleBuilder(16, 1.4);


  /// ===== BODY =====
  static const body1 = _TextStyleBuilder(16, 1.5);
  static const body2 = _TextStyleBuilder(14, 1.4);

  /// ===== LABEL =====
  static const label = _TextStyleBuilder(12, 1.3);

  /// ===== MATERIAL 3 TEXT THEME =====
  static final textTheme = TextTheme(
    displayLarge: AppText.title.bold,
    displayMedium: AppText.title1.bold,
    displaySmall: AppText.h1.semiBold,

    headlineLarge: AppText.h1.semiBold,
    headlineMedium: AppText.h2.semiBold,
    headlineSmall: AppText.h5.semiBold,

    titleLarge: AppText.h4.semiBold,
    titleMedium: AppText.h5.medium,
    titleSmall: AppText.body2.medium,

    bodyLarge: AppText.body1.regular,
    bodyMedium: AppText.body2.regular,
    bodySmall: AppText.label.regular,

    labelLarge: AppText.h5.medium,
    labelMedium: AppText.body2.medium,
    labelSmall: AppText.label.medium,
  );
}