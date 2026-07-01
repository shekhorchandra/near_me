import 'package:get/get.dart';

import '../controller/ServicePreviewController.dart';
import '../view/PreviewServicePreviewProvider.dart';
import '../view/ServicePreviewProvider.dart';

class ServicePreviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServicePreviewProvider>(() => ServicePreviewProvider());

    Get.lazyPut<ServicePreviewController>(
      () => ServicePreviewController(Get.find()),
    );
  }
}
