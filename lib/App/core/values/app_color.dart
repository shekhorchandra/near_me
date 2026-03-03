import 'package:flutter/material.dart';

@immutable
class ColorScale {
  final Color s50;
  final Color s100;
  final Color s200;
  final Color s300;
  final Color s400;
  final Color s500;
  final Color s600;
  final Color s700;
  final Color s800;
  final Color s900;
  final Color s950;

  const ColorScale({
    required this.s50,
    required this.s100,
    required this.s200,
    required this.s300,
    required this.s400,
    required this.s500,
    required this.s600,
    required this.s700,
    required this.s800,
    required this.s900,
    required this.s950,
  });

  Color get value => s500;
  Color call() => value;
}

abstract class AppColor {
  const AppColor._();

  /// Base Colors
  static const Color BG = Color(0xFFFFFFFF); // Background
  static const Color primary = Color(0xFF000000);
  static const Color secondary = Color(0xFF555555);

  /// Neutral Scale
  static const neutral = ColorScale(
    s50: Color(0xFFFAFAFA),   // Neutral/50
    s100: Color(0xFFF5F5F5),  // Neutral/100
    s200: Color(0xFFE5E5E5),  // Neutral/200
    s300: Color(0xFFD4D4D4),  // Neutral/300
    s400: Color(0xFFA3A3A3),  // Neutral/400
    s500: Color(0xFF737373),  // Neutral/500
    s600: Color(0xFF525252),  // Neutral/600
    s700: Color(0xFF404040),  // Neutral/700
    s800: Color(0xFF262626),  // Neutral/800
    s900: Color(0xFF171717),  // Neutral/900
    s950: Color(0xFF0A0A0A),  // Neutral/950
  );

  /// Status Colors
  static const Color error = Color(0xFFDF2A16);
  static const Color warning = Color(0xFFFFBD11);
  static const Color success = Color(0xFF128635);

  /// Text on Light Background
  static Color onLight = neutral.s950;

  /// Text on Dark Background
  static Color onDark = neutral.s50;

  static Color get onPrimary => onDark;
  static Color get onSecondary => onDark;
  static Color get onError => onDark;
  static Color get onSuccess => onDark;
  static Color get onWarning => onDark;

  static Color onColor(Color color) =>
      color.computeLuminance() > 0.5 ? onLight : onDark;
}

class AppColorScheme {
  AppColorScheme._();

  static final light = ColorScheme(
    brightness: Brightness.light,

    primary: AppColor.primary,
    onPrimary: AppColor.onPrimary,
    primaryContainer: AppColor.neutral.s100,
    onPrimaryContainer: AppColor.onLight,

    secondary: AppColor.secondary,
    onSecondary: AppColor.onSecondary,
    secondaryContainer: AppColor.neutral.s200,
    onSecondaryContainer: AppColor.neutral.s900,

    error: AppColor.error,
    onError: AppColor.onError,
    errorContainer: AppColor.neutral.s100,
    onErrorContainer: AppColor.onLight,

    surface: AppColor.BG,
    surfaceContainer: AppColor.neutral.s50,
    surfaceContainerHigh: AppColor.neutral.s100,
    surfaceContainerHighest: AppColor.neutral.s200,

    onSurface: AppColor.onLight,
    onSurfaceVariant: AppColor.neutral.s700,

    outline: AppColor.neutral.s300,
    outlineVariant: AppColor.neutral.s200,

    shadow: Colors.black,
    scrim: Colors.black,

    inverseSurface: AppColor.neutral.s900,
    onInverseSurface: AppColor.neutral.s50,

    inversePrimary: AppColor.neutral.s200,
  );
}
