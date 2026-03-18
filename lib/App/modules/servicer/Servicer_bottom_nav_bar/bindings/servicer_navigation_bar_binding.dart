import 'package:get/get.dart';

import '../../servicer_chat/controller/servicer_chat_controller.dart';
import '../../servicer_dashboard/controller/servicer_dashboard_controller.dart';
import '../../servicer_highlight/controller/servicer_highlight_controller.dart';
import '../../servicer_menu/servicer_menu_bar/controller/servicer_menu_controller.dart';
import '../controllers/servicer_bottom_nav_controller.dart';

class ServicerNavigationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicerNavigationBarController>(() => ServicerNavigationBarController());

    Get.lazyPut<ServiceDashboardController>(() => ServiceDashboardController());
    Get.lazyPut<ServiceHighlightController>(() => ServiceHighlightController());
    Get.lazyPut<ServiceChatController>(() => ServiceChatController());
    Get.lazyPut<ServicerMenuController>(() => ServicerMenuController());
  }
}