import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:near_me/App/modules/servicer/servicer_chat/servicer_inbox/controller/servicer_chat_controller.dart';
import '../../../../../core/widgets/common_app_bar.dart';
import '../../../../../core/widgets/custom_text_field.dart';
import '../../../../../routes/app_routes.dart';

class ServicerChatView extends GetView<ServicerChatController> {
  const ServicerChatView({super.key});

  Widget ServicerchatItem(chat) {
    return ListTile(
      onTap: () {
        // Navigate using GetX
        Get.toNamed(AppRoutes.SERVICER_CONVERSATION);

        // OR, if using named routes:
        // Get.toNamed(Routes.CONVERSATION, arguments: servicer_chat);
      },
      leading: Stack(
        children: [
          CircleAvatar(radius: 25, backgroundImage: NetworkImage(chat.image)),

          // Online indicator
          if (chat.isOnline)
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
      title: Text(chat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(chat.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(chat.time, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 5),
          if (chat.unread > 0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
              child: Text(
                chat.unread.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Service Chats", showBack: false),
      body: SafeArea(
        child: Column(
          children: [
            /// Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: CustomTextField(hint: 'Search Chats...'),
            ),
        
            /// Chat List
            Expanded(
              child: Obx(
                () => ListView.separated(
                  itemCount: controller.chats.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final chat = controller.chats[index];
                    return ServicerchatItem(chat);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
