import 'package:get/get.dart';
import '../controller/servicer_chat_controller.dart';

class ServiceChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceChatController>(
          () => ServiceChatController(),
    );
  }
}