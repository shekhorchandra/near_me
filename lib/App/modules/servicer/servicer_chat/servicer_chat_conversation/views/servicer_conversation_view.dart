import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/core/widgets/common_app_bar.dart';
import 'package:near_me/App/core/widgets/custom_text_field.dart';
import '../controller/servicer_conversation_controller.dart';

class ServicerConversationView extends GetView<ServicerConversationController> {
  const ServicerConversationView({super.key});

  Widget ServicermessageBubble(message) {
    bool isMe = message["isMe"];

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message["msg"], style: TextStyle(color: isMe ? Colors.white : Colors.black)),
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
          IconButton(onPressed: () {}, icon: const Icon(Icons.add, color: Colors.black,)),

          /// Emoji
          IconButton(onPressed: () {}, icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.black,)),

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
      appBar: const CommonAppBar(title: "Inbox"),
      body: SafeArea(
        child: Column(
          children: [

            /// PROFILE SECTION
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=5"),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "John Smith",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2), // light green background
                            borderRadius: BorderRadius.circular(12), // rounded corners
                          ),
                          child: const Text(
                            "Available now",
                            style: TextStyle(
                              color: Colors.green, // text color
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.info_outline)),
                ],
              ),
            ),

            const Divider(),

            /// CHAT MESSAGES
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    return ServicermessageBubble(controller.messages[index]);
                  },
                ),
              ),
            ),

            /// CHAT INPUT
            chatInput(),
          ],
        ),
      ),
    );
  }
}
