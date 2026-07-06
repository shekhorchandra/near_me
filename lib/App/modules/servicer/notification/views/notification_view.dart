import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../core/widgets/common_app_bar.dart';
import '../../../../data/models/notification_model.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: 'Notifications'),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.notifications.isEmpty) {
          return _buildShimmerList();
        }

        if (controller.notifications.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: controller.refreshNotifications,
          child: ListView.separated(
            controller: controller.scrollController,
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: controller.notifications.length +
                (controller.isLoading.value ? 1 : 0),
            separatorBuilder: (_, __) => const Divider(
              height: 1,
              indent: 70,
              color: Color(0xFFEDF2F7),
            ),
            itemBuilder: (context, index) {
              if (index == controller.notifications.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }

              final notification = controller.notifications[index];

              return Dismissible(
                key: ValueKey(notification.sId),
                direction: DismissDirection.endToStart,

                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),

                onDismissed: (_) {
                  controller.deleteNotification(notification.sId!);
                },

                child: _NotificationTile(
                  notification: notification,
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListTile(
          leading: const CircleAvatar(
            backgroundColor: Colors.white,
          ),
          title: Container(
            height: 12,
            color: Colors.white,
          ),
          subtitle: Container(
            height: 10,
            margin: const EdgeInsets.only(top: 8),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 100,
            color: Colors.blueGrey[100],
          ),
          const SizedBox(height: 16),
          const Text(
            "Inbox is empty",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  const _NotificationTile({
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    final typeData = _getTypeDetails(notification.type);

    return ListTile(
      onTap: () async {
        if (notification.isRead == false) {
          await controller.markSeen(notification.sId!);
        }

        if (notification.type == NotificationType.CHAT) {
          Get.toNamed(
            AppRoutes.CONVERSATION,
            arguments: {
              "userId": notification.data?.senderId,
              "name": notification.data?.senderName,
              "image": notification.data?.image,
              "isOnline": false,
            },
          );
        }
      },
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      leading: Stack(
        children: [
          CircleAvatar(
            backgroundColor: typeData.color.withOpacity(.15),
            child: Icon(
              typeData.icon,
              color: typeData.color,
            ),
          ),

          if (notification.isRead == false)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),

      title: Row(
        children: [
          Expanded(
            child: Text(
              notification.title ?? "",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: notification.isRead == false
                    ? FontWeight.bold
                    : FontWeight.w500,
              ),
            ),
          ),

          Text(
            timeago.format(
              DateTime.parse(notification.createdAt!),
            ),
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),

      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),

          Text(
            notification.description ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 4),

          Text(
            DateFormat('MMM dd, yyyy • hh:mm a').format(
              DateTime.parse(notification.createdAt!),
            ),
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  _TypeDetails _getTypeDetails(NotificationType? type) {
    switch (type) {
      case NotificationType.SHOP:
        return _TypeDetails(
          Icons.shopping_bag_outlined,
          Colors.orange,
        );

      case NotificationType.PROMOTE:
        return _TypeDetails(
          Icons.campaign_outlined,
          Colors.purple,
        );

      case NotificationType.REMINDER:
        return _TypeDetails(
          Icons.alarm,
          Colors.blue,
        );

      case NotificationType.PAYMENT:
        return _TypeDetails(
          Icons.account_balance_wallet_outlined,
          Colors.green,
        );

      case NotificationType.SYSTEM:
      default:
        return _TypeDetails(
          Icons.settings,
          Colors.blueGrey,
        );
    }
  }
}

class _TypeDetails {
  final IconData icon;
  final Color color;

  _TypeDetails(this.icon, this.color);
}