import 'package:get/get.dart';
import '../controller/chat_controller.dart';
import 'package:dio/dio.dart';

import '../services/ChatApiService.dart';

class ServiceChatBinding extends Bindings {
  @override
  void dependencies() {
    final dio = Dio(
      BaseOptions(
        baseUrl: "https://uncried-unpreventible-declan.ngrok-free.dev",
      ),
    );

    Get.lazyPut(() => ServiceChatApiService(dio));

    Get.lazyPut(() => ServiceChatController(apiService: Get.find()));
  }
}
