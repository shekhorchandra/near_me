import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../services/contants/api_constants.dart';
import '../../category/user_category/controller/categories_controller.dart';
import '../../chat/user_chat/controller/chat_controller.dart';
import '../../chat/user_chat/services/ChatApiService.dart';
import '../../home/controller/home_controller.dart';
import '../../menu/user_menu_bar/controller/menu_controller.dart';
import '../controllers/bottom_nav_controller.dart';

class UserNavigationBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<Dio>(
          () => Dio(
        BaseOptions(baseUrl: ApiConstants.baseUrl),
      ),
      fenix: true,
    );

    Get.lazyPut<ChatApiService>(
          () => ChatApiService(Get.find<Dio>()),
      fenix: true,
    );

    Get.lazyPut<ChatController>(
          () => ChatController(
        apiService: Get.find<ChatApiService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<UserNavigationBarController>(
          () => UserNavigationBarController(),
      fenix: true,
    );

    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<CategoriesController>(() => CategoriesController(), fenix: true);
    Get.lazyPut<UserMenuController>(() => UserMenuController(), fenix: true);
  }
}