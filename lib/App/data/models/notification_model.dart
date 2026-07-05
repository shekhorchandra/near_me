enum NotificationType {
  CHAT,
  SHOP,
  PROMOTE,
  REMINDER,
  PAYMENT,
  SYSTEM,
}

class NotificationModel {
  String? sId;
  String? user;
  String? title;
  String? description;
  NotificationType? type;
  bool? isRead;
  NotificationData? data;
  String? createdAt;
  String? updatedAt;

  NotificationModel({
    this.sId,
    this.user,
    this.title,
    this.description,
    this.type,
    this.isRead,
    this.data,
    this.createdAt,
    this.updatedAt,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    sId = json["_id"]?.toString();
    user = json["user"]?.toString();
    title = json["title"]?.toString();
    description = json["description"]?.toString();

    type = NotificationType.values.firstWhere(
          (e) => e.name == json["type"],
      orElse: () => NotificationType.SYSTEM,
    );

    isRead = json["isRead"] ?? false;

    if (json["data"] is Map<String, dynamic>) {
      data = NotificationData.fromJson(json["data"]);
    }

    createdAt = json["createdAt"]?.toString();
    updatedAt = json["updatedAt"]?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": sId,
      "user": user,
      "title": title,
      "description": description,
      "type": type?.name,
      "isRead": isRead,
      "data": data?.toJson(),
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  DateTime get dateTime =>
      createdAt != null ? DateTime.parse(createdAt!) : DateTime.now();
}

class NotificationData {
  String? senderId;
  String? message;

  NotificationData({
    this.senderId,
    this.message,
  });

  NotificationData.fromJson(Map<String, dynamic> json) {
    senderId = json["senderId"]?.toString();
    message = json["message"]?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      "senderId": senderId,
      "message": message,
    };
  }
}