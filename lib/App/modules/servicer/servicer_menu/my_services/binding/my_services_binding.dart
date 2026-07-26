import 'package:get/get.dart';

import '../../../../../data/network/dio_client.dart';
import '../controller/my_services_controller.dart';



class MyServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyServicesController>(
          () => MyServicesController(
        dio: Get.find<DioClient>().client,
      ),
      fenix: true,
    );
  }
}