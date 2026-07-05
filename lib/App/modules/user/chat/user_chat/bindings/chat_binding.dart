// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
// import '../../../../services/contants/api_constants.dart';
// import '../controller/chat_controller.dart';
// import '../services/ChatApiService.dart';
//
// class ChatBinding extends Bindings {
//   @override
//   void dependencies() {
//     print("ChatBinding executed");
//
//     Get.lazyPut<Dio>(
//           () => Dio(BaseOptions(baseUrl: ApiConstants.baseUrl)),
//     );
//
//     Get.lazyPut<ChatApiService>(
//           () => ChatApiService(Get.find()),
//     );
//
//     Get.lazyPut<ChatController>(
//           () => ChatController(apiService: Get.find()),
//     );
//   }
// }