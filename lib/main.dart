import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'App/core/theme/checkbox_theme.dart';
import 'App/core/values/app_strings.dart';
import 'App/data/services/storage_service.dart';
import 'App/routes/app_pages.dart';
import 'App/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //  INIT STORAGE
  final storageService = StorageService();
  await storageService.init();

  //  REGISTER IN GETX
  Get.put<StorageService>(
    storageService,
    permanent: true,
  );

  runApp(const NearMeeApp());
}

class NearMeeApp extends StatelessWidget {
  const NearMeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,

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