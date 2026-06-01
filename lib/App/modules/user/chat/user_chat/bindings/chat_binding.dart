import 'package:get/get.dart';
import '../controller/chat_controller.dart';
import 'package:dio/dio.dart';

import '../services/ChatApiService.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    final dio = Dio(BaseOptions(baseUrl: "https://your-base-url.com"));

    Get.lazyPut(() => ChatApiService(dio));

    Get.lazyPut(
          () => ChatController(apiService: Get.find()),
    );
  }
}