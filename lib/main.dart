import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'App/core/theme/checkbox_theme.dart';
import 'App/modules/user/bottom_nav_bar/controllers/bottom_nav_controller.dart';
import 'App/routes/app_pages.dart';
import 'App/routes/app_routes.dart';

void main() async {
  Get.put(UserNavigationBarController());
  runApp(const NearMeeApp());
}

class NearMeeApp extends StatelessWidget {
  const NearMeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // title: AppStrings.appName,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        checkboxTheme: checkboxTheme,
        fontFamily: 'FontMain',
      ),
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.pages,
    );
  }
}

