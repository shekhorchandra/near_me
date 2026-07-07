
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
  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, dynamic>;

    myId = storage.userId ?? "";

    // Works for both normal chat and notification
    userId = (args["serviceId"] ?? args["senderId"] ?? "").toString();
    userName = (args["name"] ?? "").toString();
    userImage = (args["image"] ?? "").toString();
    isOnline = args["isOnline"] ?? false;

    // -----------------------------
    // 🔥 SOCKET EVENTS (CLEAN)
    // -----------------------------

    socketService.offEvent("direct_message");

    socketService.onEvent("direct_message", (data) {
      final msg = MessageModel.fromSocket(data);

      final myId = storage.userId ?? "";

      if ((msg.senderId == myId && msg.receiverId == userId) ||
          (msg.senderId == userId && msg.receiverId == myId)) {
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

      await apiService.sendMessage(
        token: token,
        receiverId: userId,
        text: text,
      );

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