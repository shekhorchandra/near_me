import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../../services/contants/api_constants.dart';
import '../../../user/chat/user_chat/services/ChatApiService.dart';
import '../../notification/controllers/notification_controller.dart';
import '../../servicer_chat/servicer_chat/controller/chat_controller.dart';
import '../../servicer_chat/servicer_chat/services/ChatApiService.dart';
import '../../servicer_dashboard/controller/servicer_dashboard_controller.dart';
import '../../servicer_highlight/servicer_highlights_page/controller/servicer_highlight_controller.dart';
import '../../servicer_menu/servicer_menu_bar/controller/servicer_menu_controller.dart';
import '../controllers/servicer_bottom_nav_controller.dart';

class ServicerNavigationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicerNavigationBarController>(
      () => ServicerNavigationBarController(),
    );

    Get.lazyPut<NotificationController>(
      () => NotificationController(),
      fenix: true,
    );

    Get.lazyPut<ServiceDashboardController>(() => ServiceDashboardController());

    Get.lazyPut<ServicerNavigationBarController>(
      () => ServicerNavigationBarController(),
    );

    Get.lazyPut<ServiceDashboardController>(() => ServiceDashboardController());
    Get.lazyPut<ServiceHighlightController>(() => ServiceHighlightController());
    // Get.lazyPut<ServiceChatController>(() => ServiceChatController(apiService: null));

    /// ✅ 1. Register Dio
    Get.lazyPut<Dio>(
      () => Dio(
        BaseOptions(
          // baseUrl: "https://uncried-unpreventible-declan.ngrok-free.dev",
          baseUrl: ApiConstants.baseUrl,
        ),
      ),
    );

    /// ✅ 2. Register API Service
    Get.lazyPut<ChatApiService>(() => ChatApiService(Get.find<Dio>()));

    /// ✅ 3. Inject into Controller
    Get.lazyPut<ServiceChatController>(
      () => ServiceChatController(apiService: Get.find<ChatApiService>()),
    );

    Get.lazyPut<ServicerMenuController>(() => ServicerMenuController());
  }
}
