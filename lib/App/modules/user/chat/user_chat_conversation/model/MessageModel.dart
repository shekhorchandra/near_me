class MessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;
  final String text;
  final String image;
  final String status;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.text,
    required this.image,
    required this.status,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id']?.toString() ?? '',

      senderId: json['sender'] is Map
          ? json['sender']['_id']?.toString() ?? ''
          : json['sender']?.toString() ?? '',

      senderName: json['sender'] is Map
          ? json['sender']['name']?.toString() ?? ''
          : '',

      receiverId: json['receiver'] is Map
          ? json['receiver']['_id']?.toString() ?? ''
          : json['receiver']?.toString() ?? '',

      receiverName: json['receiver'] is Map
          ? json['receiver']['name']?.toString() ?? ''
          : '',

      text: json['message']?['text']?.toString() ?? '',
      image: json['message']?['image']?.toString() ?? '',
      status: json['status']?.toString() ?? 'SENT',

      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ) ??
          DateTime.now(),
    );
  }

  /// Socket Message Parser
  factory MessageModel.fromSocket(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id']?.toString() ?? '',

      senderId: json['sender'] is Map
          ? json['sender']['_id']?.toString() ?? ''
          : json['sender']?.toString() ??
          json['senderId']?.toString() ??
          '',

      senderName: json['sender'] is Map
          ? json['sender']['name']?.toString() ?? ''
          : json['senderName']?.toString() ?? '',

      receiverId: json['receiver'] is Map
          ? json['receiver']['_id']?.toString() ?? ''
          : json['receiver']?.toString() ??
          json['receiverId']?.toString() ??
          '',

      receiverName: json['receiver'] is Map
          ? json['receiver']['name']?.toString() ?? ''
          : json['receiverName']?.toString() ?? '',

      text: json['message'] is Map
          ? json['message']['text']?.toString() ?? ''
          : json['text']?.toString() ?? '',

      image: json['message'] is Map
          ? json['message']['image']?.toString() ?? ''
          : json['image']?.toString() ?? '',

      status: json['status']?.toString() ?? 'SENT',

      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ) ??
          DateTime.now(),
    );
  }
}