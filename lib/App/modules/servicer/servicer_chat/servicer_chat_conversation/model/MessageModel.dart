class ServicerMessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String receiverId;
  final String receiverName;
  final String text;
  final String createdAt;
  final String status;

  ServicerMessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.receiverId,
    required this.receiverName,
    required this.text,
    required this.createdAt,
    required this.status,
  });

  factory ServicerMessageModel.fromJson(Map<String, dynamic> json) {
    return ServicerMessageModel(
      id: json['_id'] ?? '',
      senderId: json['sender']?['_id'] ?? '',
      senderName: json['sender']?['name'] ?? '',
      receiverId: json['receiver']?['_id'] ?? '',
      receiverName: json['receiver']?['name'] ?? '',
      text: json['message']?['text'] ?? '',
      createdAt: json['createdAt'] ?? '',
      status: json['status'] ?? '',
    );
  }
}