import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/widgets/common_app_bar.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../routes/app_routes.dart';
import '../controller/chat_controller.dart';
import '../helper/TimeFormatter.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  Widget chatItem(chat) {
    return ListTile(
      onTap: () {
        Get.toNamed(
          AppRoutes.CONVERSATION,
          arguments: {
            "userId": chat.userId,
            "name": chat.name,
            "image": chat.image,
          },
        );
      },
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: chat.image.isNotEmpty
                ? NetworkImage(chat.image)
                : null,
            child: chat.image.isEmpty ? const Icon(Icons.person) : null,
          ),

          // Online indicator
          if (controller.isUserOnline(chat.id))
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        chat.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        chat.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: chat.unread > 0 ? FontWeight.bold : FontWeight.normal,
          color: chat.unread > 0 ? Colors.black : Colors.grey,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            TimeFormatter.timeAgo(chat.time),
            style: const TextStyle(fontSize: 12),
          ),
          // const SizedBox(height: 5),
          // if (chat.unread > 0)
          //   Container(
          //     padding: const EdgeInsets.all(6),
          //     decoration: const BoxDecoration(
          //       color: Colors.red,
          //       shape: BoxShape.circle,
          //     ),
          //     child: Text(
          //       chat.unread.toString(),
          //       style: const TextStyle(color: Colors.white, fontSize: 12),
          //     ),
          //   ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Chats", showBack: false),
      body: Obx(() {
        if (controller.isLoginRequired.value) {
          return const Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.chat_bubble_outline, size: 70, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "Login Required",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Please sign in to access your chats and start messaging.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CustomTextField(hint: 'Search Chats...'),
            ),

            Expanded(
              child: RefreshIndicator(
                color: Colors.black,
                onRefresh: () async {
                  await controller.fetchChats();
                },
                child: controller.chats.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: const [
                          SizedBox(height: 250),
                          Center(child: Text("No Chats Found")),
                        ],
                      )
                    : ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: controller.chats.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final chat = controller.chats[index];
                          return chatItem(chat);
                        },
                      ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
