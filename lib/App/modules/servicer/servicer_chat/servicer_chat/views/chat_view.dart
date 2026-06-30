import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/widgets/common_app_bar.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../routes/app_routes.dart';
import '../controller/chat_controller.dart';
import '../helper/TimeFormatter.dart';

class ServiceChatView extends GetView<ServiceChatController> {
  const ServiceChatView({super.key});

  Widget chatItem(chat) {
    return ListTile(
      onTap: () {
        Get.toNamed(
          AppRoutes.SERVICER_CONVERSATION,
          arguments: {
            "serviceId": chat.id,
            "name": chat.name,
            "image": chat.image,
            "isOnline": chat.isOnline ?? false,
          },
        );
      },
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage:
            chat.image.isNotEmpty
                ? NetworkImage(chat.image)
                : null,
            child:
            chat.image.isEmpty
                ? const Icon(Icons.person)
                : null,
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
          fontWeight:
          chat.unread > 0 ? FontWeight.bold : FontWeight.normal,
          color: chat.unread > 0 ? Colors.black : Colors.grey,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ServiceTimeFormatter.timeAgo(chat.time),
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
      appBar: const CommonAppBar(title: "Service Chats", showBack: false),
      body: Obx(() {
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
