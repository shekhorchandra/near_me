import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../category/user_category/controller/categories_controller.dart';
import '../../chat/user_chat/controller/chat_controller.dart';
import '../../chat/user_chat/services/ChatApiService.dart';
import '../../home/controller/home_controller.dart';
import '../../menu/user_menu_bar/controller/menu_controller.dart';
import '../controllers/bottom_nav_controller.dart';

class UserNavigationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserNavigationBarController>(
      () => UserNavigationBarController(),
    );

    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CategoriesController>(() => CategoriesController());

    /// ✅ 1. Register Dio
    Get.lazyPut<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: "https://uncried-unpreventible-declan.ngrok-free.dev",
        ),
      ),
    );

    /// ✅ 2. Register API Service
    Get.lazyPut<ChatApiService>(() => ChatApiService(Get.find<Dio>()));

    /// ✅ 3. Inject into Controller
    Get.lazyPut<ChatController>(
      () => ChatController(apiService: Get.find<ChatApiService>()),
    );

    Get.lazyPut<UserMenuController>(() => UserMenuController());
  }
}
