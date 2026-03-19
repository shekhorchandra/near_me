import 'package:get/get.dart';
import '../controller/servicer_chat_controller.dart';

class ServicerChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicerChatController>(() => ServicerChatController());
  }
}