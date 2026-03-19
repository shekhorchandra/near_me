import 'package:get/get.dart';
import '../controller/servicer_conversation_controller.dart';

class ServicerConversationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicerConversationController>(() => ServicerConversationController());
  }
}