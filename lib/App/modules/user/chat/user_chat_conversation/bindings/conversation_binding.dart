import 'package:get/get.dart';
import '../../../../servicer/servicer_chat/servicer_chat_conversation/controller/conversation_controller.dart';
import '../controller/conversation_controller.dart';

class ConversationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConversationController>(() => ConversationController());
  }
}