import 'package:get/get.dart';
import '../../../../user/chat/user_chat/services/ChatApiService.dart';
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

    Get.lazyPut(() => ChatApiService(dio));

    Get.lazyPut(() => ServiceChatController(apiService: Get.find()));
  }
}
