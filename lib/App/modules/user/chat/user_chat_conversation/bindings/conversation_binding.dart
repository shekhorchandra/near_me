import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../../servicer/servicer_chat/servicer_chat_conversation/controller/conversation_controller.dart';
import '../../user_chat/services/ChatApiService.dart';
import '../controller/conversation_controller.dart';

class ConversationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Dio>(() => Dio(), fenix: true);

    Get.lazyPut<ChatApiService>(
      () => ChatApiService(Get.find<Dio>()),
      fenix: true,
    );

    Get.lazyPut<ConversationController>(() => ConversationController());
  }
}
