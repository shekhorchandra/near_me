import 'package:get/get.dart';
import '../../home/controller/home_controller.dart';
import '../../category/controller/categories_controller.dart';
import '../../chat/controller/chat_controller.dart';
import '../../menu/menu_bar/controller/menu_controller.dart';
import '../controllers/bottom_nav_controller.dart';

class UserNavigationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserNavigationBarController>(() => UserNavigationBarController());

    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CategoriesController>(() => CategoriesController());
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<UserMenuController>(() => UserMenuController());
  }
}