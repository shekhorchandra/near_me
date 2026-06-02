// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../../data/services/socket_service.dart';
// import '../../../../../data/services/storage_service.dart';
// import '../../../../user/chat/user_chat/services/ChatApiService.dart';
// import '../../../../user/chat/user_chat_conversation/model/MessageModel.dart';
// import '../model/MessageModel.dart';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../../data/services/socket_service.dart';
// import '../../../../../data/services/storage_service.dart';
// import '../../../../user/chat/user_chat/services/ChatApiService.dart';
// import '../../../../user/chat/user_chat_conversation/model/MessageModel.dart';
//
// class ServicerConversationController extends GetxController {
//   final ChatApiService apiService = Get.find();
//   final StorageService storage = StorageService();
//   final SocketService socketService = Get.find<SocketService>();
//
//   TextEditingController messageController = TextEditingController();
//
//   final messages = <MessageModel>[].obs;
//   final isLoading = false.obs;
//   final isTyping = false.obs;
//
//   // late String serviceId;
//   late String userId;
//   late String userName;
//   late String userImage;
//   late bool isOnline;
//
//   late String myId;
//
//
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     // myId = storage.userId.toString().trim(); // NOT serviceId// ✅ SAFE FIX
//     myId = storage.userId ?? "";
//     userId = Get.arguments["serviceId"];
//     userName = Get.arguments["name"];
//     userImage = Get.arguments["image"] ?? "";
//     isOnline = Get.arguments["isOnline"] ?? false;
//
//     fetchMessages();
//     listenSocket();
//   }
//
//   void listenSocket() {
//     // socketService.socket.off("direct_message");
//
//     // socketService.socket.on("direct_message", (data) {
//     //   final msg = MessageModel.fromSocket(data);
//     //
//     //   messages.insert(0, msg);
//     // });
//   }
//
//   Future<void> fetchMessages() async {
//     try {
//       isLoading.value = true;
//
//       final token = storage.accessToken;
//       if (token == null) return;
//
//       final result = await apiService.getMessages(
//         token: token,
//         userId: userId,
//       );
//
//       messages.assignAll(result);
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   Future<void> sendMessage() async {
//     final text = messageController.text.trim();
//
//     if (text.isEmpty) return;
//
//     messageController.clear();
//
//     try {
//       final token = storage.accessToken!;
//
//       final msg = await apiService.sendMessage(
//         token: token,
//         receiverId: userId,
//         text: text,
//       );
//
//       messages.insert(0, msg);
//     } catch (e) {
//       print("SEND MESSAGE ERROR => $e");
//     }
//   }
//
//   @override
//   void onClose() {
//     socketService.socket.off("direct_message");
//     socketService.socket.off("typing");
//     messageController.dispose();
//     super.onClose();
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/services/socket_service.dart';
import '../../../../../data/services/storage_service.dart';
import '../../../../user/chat/user_chat/services/ChatApiService.dart';
import '../../../../user/chat/user_chat_conversation/model/MessageModel.dart';
import '../model/MessageModel.dart';

class ServicerConversationController extends GetxController {
  final ChatApiService apiService = Get.find();
  final StorageService storage = StorageService();
  final SocketService socketService = Get.find<SocketService>();

  final TextEditingController messageController = TextEditingController();

  final messages = <MessageModel>[].obs;
  final isLoading = false.obs;

  late String userId;
  late String userName;
  late String userImage;
  late bool isOnline;
  final isTyping = true.obs;

  late String myId;

  @override
  void onInit() {
    super.onInit();

    myId = storage.userId ?? "";

    userId = Get.arguments["serviceId"];
    userName = Get.arguments["name"];
    userImage = Get.arguments["image"] ?? "";
    isOnline = Get.arguments["isOnline"] ?? false;

    // -----------------------------
    // 🔥 SOCKET EVENTS (CLEAN)
    // -----------------------------

    socketService.onEvent("direct_message", (data) {
      final msg = MessageModel.fromSocket(data);

      // only show messages of this chat
      if (msg.senderId == userId || msg.receiverId == userId) {
        messages.insert(0, msg);
      }
    });

    fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      isLoading.value = true;

      final token = storage.accessToken!;
      final result = await apiService.getMessages(
        token: token,
        userId: userId,
      );

      messages.assignAll(result.reversed.toList());
    } catch (e) {
      print("FETCH ERROR => $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();

    try {
      final token = storage.accessToken!;

      final msg = await apiService.sendMessage(
        token: token,
        receiverId: userId,
        text: text,
      );

      messages.insert(0, msg);
    } catch (e) {
      print("SEND ERROR => $e");
    }
  }

  @override
  void onClose() {
    socketService.offEvent("direct_message");
    messageController.dispose();
    super.onClose();
  }
}