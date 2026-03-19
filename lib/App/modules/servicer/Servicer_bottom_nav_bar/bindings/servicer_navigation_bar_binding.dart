import 'package:get/get.dart';
import 'package:near_me/App/modules/servicer/servicer_chat/servicer_inbox/controller/servicer_chat_controller.dart';
import '../../servicer_dashboard/controller/servicer_dashboard_controller.dart';
import '../../servicer_highlight/servicer_highlights_page/controller/servicer_highlight_controller.dart';
import '../../servicer_menu/servicer_menu_bar/controller/servicer_menu_controller.dart';
import '../controllers/servicer_bottom_nav_controller.dart';

class ServicerNavigationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicerNavigationBarController>(() => ServicerNavigationBarController());

    Get.lazyPut<ServiceDashboardController>(() => ServiceDashboardController());
    Get.lazyPut<ServiceHighlightController>(() => ServiceHighlightController());
    Get.lazyPut<ServicerChatController>(() => ServicerChatController());
    Get.lazyPut<ServicerMenuController>(() => ServicerMenuController());
  }
}