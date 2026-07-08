import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/custom_text_field.dart';
import '../../../../../core/widgets/skeleton_loader.dart';
import '../../../../../data/services/storage_service.dart';
import '../controller/conversation_controller.dart';
import '../model/MessageModel.dart';

class ConversationView extends GetView<ConversationController> {
  const ConversationView({super.key});

  // Widget messageBubble(message) {
  //   final myId = StorageService().userId;
  //   final bool isMe = message.senderId == myId;
  //
  //   return Align(
  //     alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
  //       padding: const EdgeInsets.all(12),
  //       decoration: BoxDecoration(
  //         color: isMe ? Colors.black : Colors.grey.shade200,
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Text(
  //         message.text,
  //         style: TextStyle(color: isMe ? Colors.white : Colors.black),
  //       ),
  //     ),
  //   );
  // }

  Widget messageBubble(MessageModel message, String myId) {
    final senderId = message.senderId?.trim();
    final isMe = senderId == myId.trim();

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.black : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.text ?? "",
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget chatInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          /// Attach file/image
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add, color: Colors.black),
          ),

          /// Emoji
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.emoji_emotions_outlined,
              color: Colors.black,
            ),
          ),

          /// Chat box
          Expanded(
            child: CustomTextField(
              controller: controller.messageController,
              hint: "Type message...",
            ),
          ),

          /// Send button
          IconButton(
            onPressed: controller.sendMessage,
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF555555), // background color
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send,
                color: Colors.white, // icon color
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        /// ✅ SKELETON LOADER
        if (controller.isLoading.value) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SkeletonLoader.list(itemCount: 8),
          );
        }

        return SafeArea(
          child: Column(
            children: [
              /// PROFILE SECTION
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    ),

                    CircleAvatar(
                      radius: 25,
                      backgroundImage: controller.userImage.isNotEmpty
                          ? NetworkImage(controller.userImage)
                          : null,
                      child: controller.userImage.isEmpty
                          ? const Icon(Icons.person)
                          : null,
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          Obx(() {
                            final online = controller.socketService.onlineUsers
                                .contains(controller.userId);

                            return Text(
                              online ? "Online" : "Offline",
                              style: TextStyle(
                                color: online ? Colors.green : Colors.grey,
                                fontSize: 12,
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.info_outline),
                    ),
                  ],
                ),
              ),

              const Divider(),

              /// CHAT MESSAGES
              // Expanded(
              //   child: Obx(() {
              //     return ListView.builder(
              //       reverse: true,
              //       padding: const EdgeInsets.symmetric(vertical: 8),
              //       itemCount: controller.messages.length,
              //       itemBuilder: (context, index) {
              //         return messageBubble(controller.messages[index]);
              //       },
              //     );
              //   }),
              // ),
              Expanded(
                child: Obx(() {
                  final messages = controller.messages;

                  return ListView.builder(
                    controller: controller.scrollController,

                    padding: const EdgeInsets.symmetric(vertical: 8),

                    itemCount: messages.length,

                    itemBuilder: (context, index) {
                      final message = messages[index];

                      final isMe =
                          message.senderId.toString().trim() ==
                          controller.myId.trim();

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,

                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 12,
                          ),

                          padding: const EdgeInsets.all(12),

                          decoration: BoxDecoration(
                            color: isMe ? Colors.black : Colors.grey.shade200,

                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: Text(
                            message.text ?? "",

                            style: TextStyle(
                              color: isMe ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),

              /// CHAT INPUT
              chatInput(),
            ],
          ),
        );
      }),
    );
  }
}
