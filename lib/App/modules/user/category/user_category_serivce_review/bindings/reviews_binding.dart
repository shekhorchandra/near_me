import 'package:get/get.dart';
import '../controller/reviews_controller.dart';


class ReviewsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReviewsController>(() => ReviewsController());
  }
}
