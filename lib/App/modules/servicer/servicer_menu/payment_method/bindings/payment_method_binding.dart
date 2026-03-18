
import 'package:get/get.dart';
import 'package:near_me/App/modules/servicer/servicer_menu/payment_method/controller/payment_method_controller.dart';


class PaymentMethodBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentMethodController>(() => PaymentMethodController());
  }
}
