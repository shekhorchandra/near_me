import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../data/services/socket_service.dart';
import '../../../../../data/services/storage_service.dart';
import '../../../../user/chat/user_chat/services/ChatApiService.dart';
import '../../../../user/chat/user_chat_conversation/model/MessageModel.dart';

class ServicerConversationController extends GetxController {
  final ChatApiService apiService = Get.find();
  final StorageService storage = Get.find<StorageService>();
  final SocketService socketService = Get.find<SocketService>();

  final ScrollController scrollController = ScrollController();

  final TextEditingController messageController = TextEditingController();

  final RxList<MessageModel> messages = <MessageModel>[].obs;

  final RxBool isLoading = false.obs;

  final RxBool isTyping = false.obs;

  late String myId;
  late String userId;

  late String userName;
  late String userImage;

  late Function(dynamic) messageListener;
  late Function(dynamic) typingListener;
  late Function(dynamic) seenListener;

  @override
  void onInit() {
    super.onInit();

    initChat();
  }

  Future<void> initChat() async {
    super.onInit();

    final args = (Get.arguments ?? {}) as Map<String, dynamic>;

    myId = storage.userId ?? "";

    userId = (args["userId"] ?? args["senderId"] ?? args["serviceId"] ?? "")
        .toString();

    userName = (args["name"] ?? "Chat").toString();

    userImage = (args["image"] ?? "").toString();

    print("=================");
    print("SERVICE CHAT");
    print("MY ID $myId");
    print("CHAT USER $userId");
    print("=================");

    registerSocketEvents();

    fetchMessages();
  }
  // @override
  // void onInit() {
  //   super.onInit();
  //
  //   final args = (Get.arguments ?? {}) as Map<String, dynamic>;
  //
  //   myId = storage.userId ?? "";
  //
  //   userId = (args["userId"] ?? args["senderId"] ?? args["serviceId"] ?? "")
  //       .toString();
  //
  //   userName = (args["name"] ?? "Chat").toString();
  //
  //   userImage = (args["image"] ?? "").toString();
  //
  //   print("=================");
  //   print("SERVICE CHAT");
  //   print("MY ID $myId");
  //   print("CHAT USER $userId");
  //   print("=================");
  //
  //   registerSocket();
  //
  //   fetchMessages();
  // }

  void registerSocketEvents() {
    messageListener = (data) {
      print("======================");
      print("🔥 DIRECT MESSAGE RECEIVED");
      print(data);
      print("======================");

      try {
        final msg = MessageModel.fromSocket(Map<String, dynamic>.from(data));

        print("MESSAGE => ${msg.text}");
        print("FROM => ${msg.senderId}");
        print("TO => ${msg.receiverId}");

        print("==========================");
        print("MY ID       => $myId");
        print("CHAT USER   => $userId");
        print("SENDER ID   => ${msg.senderId}");
        print("RECEIVER ID => ${msg.receiverId}");
        print("==========================");

        final isSameChat =
            (msg.senderId == myId && msg.receiverId == userId) ||
            (msg.senderId == userId && msg.receiverId == myId);

        if (!isSameChat) {
          print("❌ MESSAGE NOT FOR THIS CHAT");
          return;
        }

        if (!isSameChat) {
          print("❌ MESSAGE NOT FOR THIS CHAT");
          return;
        }

        final exists = messages.any((m) => m.id == msg.id);

        if (exists) {
          print("⚠ DUPLICATE MESSAGE");

          return;
        }

        messages.add(msg);

        // messages.insert(0,msg);
        print("ADDING MESSAGE TO UI");
        print(msg.text);

        messages.refresh();
        Future.delayed(const Duration(milliseconds: 100), () {
          scrollToBottom();
        });

        print("✅ TOTAL MESSAGE => ${messages.length}");
      } catch (e) {
        print("SOCKET MESSAGE ERROR => $e");
      }
    };

    socketService.onEvent("direct_message", messageListener);

    typingListener = (data) {
      print("TYPING => $data");

      if (data["from"]?.toString() == userId) {
        isTyping.value = true;

        Future.delayed(const Duration(seconds: 2), () {
          isTyping.value = false;
        });
      }
    };

    socketService.onEvent("typing", typingListener);

    seenListener = (data) {
      print("SEEN => $data");
    };

    socketService.onEvent("messages_seen", seenListener);
  }

  Future<void> fetchMessages() async {
    try {
      isLoading.value = true;

      final result = await apiService.getMessages(
        token: storage.accessToken!,
        userId: userId,
      );

      for (final msg in result) {
        final exists = messages.any((m) => m.id == msg.id);

        if (!exists) {
          messages.add(msg);
        }
      }

      messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      messages.refresh();

      Future.delayed(const Duration(milliseconds: 100), () {
        scrollToBottom();
      });
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
      await apiService.sendMessage(
        token: storage.accessToken!,

        receiverId: userId,

        text: text,
      );
    } catch (e) {
      print("SEND ERROR $e");
    }
  }

  void sendTyping() {
    socketService.emit("typing", {"toUserId": userId});
  }

  @override
  void onClose() {
    socketService.offEvent("direct_message", messageListener);

    socketService.offEvent("typing", typingListener);

    socketService.offEvent("messages_seen", seenListener);

    scrollController.dispose();

    messageController.dispose();

    super.onClose();
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,

        duration: const Duration(milliseconds: 300),

        curve: Curves.easeOut,
      );
    }
  }
}
