class ChatModel {
  final String id;
  final String userId;
  final String name;
  final String image;
  final String lastMessage;
  final String time;
  final int unread;
  final bool isOnline;

  ChatModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.image,
    required this.lastMessage,
    required this.time,
    required this.unread,
    this.isOnline = false,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final lastMsg = json['lastMessage'];

    return ChatModel(
      id: json['_id'] ?? '',
      userId: json['user']?['_id'] ?? '',
      name: json['user']?['name'] ?? 'Unknown',
      image: json['user']?['image'] ??
          'https://i.pravatar.cc/150?img=1',
      lastMessage: lastMsg?['message']?['text'] ?? '',
      time: lastMsg?['createdAt'] ?? '',
      unread: json['unreadCount'] ?? 0,
      isOnline: false,
    );
  }
}