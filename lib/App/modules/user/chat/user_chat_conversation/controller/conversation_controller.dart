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

    final args = (Get.arguments ?? {}) as Map<String, dynamic>;

    print("ARGS => $args");

    final myId = storage.userId ?? "";

    userId = (args["userId"] ?? args["serviceId"] ?? args["senderId"] ?? "")
        .toString();

    userName = (args["name"] ?? args["title"] ?? "Chat").toString();

    userImage = (args["image"] ?? "").toString();
    //
    isOnline = args["isOnline"] ?? false;

    print("MY ID = $myId");
    print("OTHER USER = $userId");

    socketService.offEvent("direct_message");

    socketService.onEvent("direct_message", (data) {
      final msg = MessageModel.fromSocket(data);

      if ((msg.senderId == myId && msg.receiverId == userId) ||
          (msg.senderId == userId && msg.receiverId == myId)) {
        if (!messages.any((m) => m.id == msg.id)) {
          messages.insert(0, msg);
        }
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

    fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      isLoading.value = true;

      final token = storage.accessToken!;
      final result = await apiService.getMessages(token: token, userId: userId);

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
    socketService.offEvent("typing");
    socketService.offEvent("messages_seen");

    messageController.dispose();
    super.onClose();
  }
}
