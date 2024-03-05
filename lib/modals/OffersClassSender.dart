class OffersClassSender {
  bool success;
  String message;
  List<ChatDataSender> dataForChat;
  List<ChatShowDataSender> dataForShow;

  OffersClassSender({
    required this.success,
    required this.message,
    required this.dataForChat,
    required this.dataForShow,
  });

  factory OffersClassSender.fromJson(Map<String, dynamic> json) {
    return OffersClassSender(
      success: json['success'],
      message: json['message'],
      dataForChat: List<ChatDataSender>.from(
          json['data_for_chat'].map((x) => ChatDataSender.fromJson(x))),
      dataForShow: List<ChatShowDataSender>.from(
          json['data_for_show'].map((x) => ChatShowDataSender.fromJson(x))),
    );
  }
}

class ChatDataSender {
  String name;
  int uid;
  String connectycubeUserId;
  List<DeviceToken> deviceToken;
  String recipientImage;
  String senderImage;

  ChatDataSender({
    required this.name,
    required this.uid,
    required this.connectycubeUserId,
    required this.deviceToken,
    required this.recipientImage,
    required this.senderImage,
  });

  factory ChatDataSender.fromJson(Map<String, dynamic> json) {
    return ChatDataSender(
      name: json['name'],
      uid: json['uid'],
      connectycubeUserId: json['connectycube_user_id'],
      deviceToken: List<DeviceToken>.from(
          json['device_token'].map((x) => DeviceToken.fromJson(x))),
      recipientImage: json['recipient_image'],
      senderImage: json['sender_image'],
    );
  }
}

class DeviceToken {
  String token;
  String type;

  DeviceToken({
    required this.token,
    required this.type,
  });

  factory DeviceToken.fromJson(Map<String, dynamic> json) {
    return DeviceToken(
      token: json['token'],
      type: json['type'],
    );
  }
}

class ChatShowDataSender {
  int id;
  int tripId;
  int senderId;
  int recipientId;
  String date;
  int duration;
  String timing;
  String message;
  String createdAt;
  String updatedAt;
  int isRecipientApproved;
  String recipientName;
  String? Destination;

  ChatShowDataSender({
    required this.id,
    required this.tripId,
    required this.senderId,
    required this.recipientId,
    required this.date,
    required this.duration,
    required this.timing,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
    required this.isRecipientApproved,
    required this.recipientName,
    required this.Destination,
  });

  factory ChatShowDataSender.fromJson(Map<String, dynamic> json) {
    return ChatShowDataSender(
      id: json['id'],
      tripId: json['trip_id'],
      senderId: json['sender_id'],
      recipientId: json['recipient_id'],
      date: json['date'],
      duration: json['duration'],
      timing: json['timing'],
      message: json['message'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isRecipientApproved: json['is_recipient_approved'],
      recipientName: json['recipient_name'],
      Destination: json['destination'],
    );
  }
}
