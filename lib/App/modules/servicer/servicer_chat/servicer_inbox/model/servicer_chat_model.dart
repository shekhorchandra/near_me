class ServicerChatModel {
  final String name;
  final String image;
  final String lastMessage;
  final String time;
  final bool isOnline;
  final int unread;

  ServicerChatModel({
    required this.name,
    required this.image,
    required this.lastMessage,
    required this.time,
    required this.isOnline,
    required this.unread,
  });
}