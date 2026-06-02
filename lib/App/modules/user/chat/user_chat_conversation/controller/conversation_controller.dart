// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../../../data/services/socket_service.dart';
// import '../../../../../data/services/storage_service.dart';
// import '../../user_chat/services/ChatApiService.dart';
// import '../model/MessageModel.dart';
//
// class ConversationController extends GetxController {
//   final ChatApiService apiService = Get.find();
//
//   final StorageService storage = StorageService();
//
//   final socketService = Get.find<SocketService>();
//
//   TextEditingController messageController = TextEditingController();
//
//   final messages = <MessageModel>[].obs;
//
//   final isLoading = false.obs;
//
//   final isTyping = false.obs;
//
//   late String userId;
//   late String userName;
//
//   late String userImage;
//   late bool isOnline;
//
//   @override
//   void onInit() {
//     super.onInit();
//
//     userId = Get.arguments["userId"];
//     userName = Get.arguments["name"];
//     userImage = Get.arguments["image"] ?? "";
//     isOnline = Get.arguments["isOnline"] ?? false;
//
//     messageController.addListener(() {
//       socketService.socket.emit("typing", {"toUserId": userId});
//     });
//
//     // markMessagesAsSeen();
//     initializeSocketListeners();
//     listenForMessages();
//     fetchMessages();
//   }
//
//   /// typing event
//   void initializeSocketListeners() {
//     socketService.socket.on("typing", (data) {
//       if (data["from"] == userId) {
//         isTyping.value = true;
//
//         Future.delayed(
//           const Duration(seconds: 2),
//           () => isTyping.value = false,
//         );
//       }
//     });
//     socketService.socket.on("messages_seen", (data) {
//       print("SEEN => $data");
//       // later update message status here
//     });
//   }
//
//   ///real time msg listener
//   void listenForMessages() {
//     // socketService.socket.off("direct_message");
//     // socketService.socket.on("direct_message", (data) {
//     //   print(data);
//     //
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
//
//       print("TOKEN => $token");
//       print("USER ID => $userId");
//
//       final result = await apiService.getMessages(
//         token: token!,
//         userId: userId,
//       );
//
//       print("TOTAL MSG => ${result.length}");
//
//       messages.assignAll(result.reversed.toList());
//
//       print("AFTER ASSIGN => ${messages.length}");
//     } catch (e) {
//       print("ERROR => $e");
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   @override
//   void onClose() {
//     socketService.socket.off("direct_message");
//     socketService.socket.off("typing");
//     socketService.socket.off("messages_seen");
//
//     messageController.dispose();
//
//     super.onClose();
//   }
//
//   // send button
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
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/services/socket_service.dart';
import '../../../../../data/services/storage_service.dart';
import '../../user_chat/services/ChatApiService.dart';
import '../model/MessageModel.dart';

class ConversationController extends GetxController {
  final ChatApiService apiService = Get.find();
  final StorageService storage = StorageService();
  final SocketService socketService = Get.find<SocketService>();

  final TextEditingController messageController = TextEditingController();

  final messages = <MessageModel>[].obs;
  final isLoading = false.obs;
  final isTyping = false.obs;

  late String userId;
  late String userName;
  late String userImage;
  late bool isOnline;

  @override
  void onInit() {
    super.onInit();

    userId = Get.arguments["userId"];
    userName = Get.arguments["name"];
    userImage = Get.arguments["image"] ?? "";
    isOnline = Get.arguments["isOnline"] ?? false;

    // -----------------------------
    // 🔥 SOCKET EVENTS (CLEAN)
    // -----------------------------

    socketService.onEvent("direct_message", (data) {
      final msg = MessageModel.fromSocket(data);

      // only add if message belongs to this chat
      if (msg.senderId == userId || msg.receiverId == userId) {
        messages.insert(0, msg);
      }
    });

    socketService.onEvent("typing", (data) {
      if (data["from"] == userId) {
        isTyping.value = true;

        Future.delayed(const Duration(seconds: 2), () {
          isTyping.value = false;
        });
      }
    });

    socketService.onEvent("messages_seen", (data) {
      print("SEEN => $data");
    });

    // -----------------------------
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
    socketService.offEvent("typing");
    socketService.offEvent("messages_seen");

    messageController.dispose();
    super.onClose();
  }
}