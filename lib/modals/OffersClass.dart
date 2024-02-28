class ChatData {
  bool? success;
  String? message;
  DataForChat? dataForChat;
  DataForShow? dataForShow;

  ChatData({
    this.success,
    this.message,
    this.dataForChat,
    this.dataForShow,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      success: json['success'],
      message: json['message'],
      dataForChat: DataForChat.fromJson(json['data_for_chat']),
      dataForShow: DataForShow.fromJson(json['data_for_show']),
    );
  }
}

class DataForChat {
  String? name;
  int? uid;
  String? connectycubeUserId;
  List<DeviceToken>? deviceToken;
  String? recipientImage;
  String? senderImage;

  DataForChat({
    this.name,
    this.uid,
    this.connectycubeUserId,
    this.deviceToken,
    this.recipientImage,
    this.senderImage,
  });

  factory DataForChat.fromJson(Map<String, dynamic> json) {
    return DataForChat(
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
  String? token;
  String? type;

  DeviceToken({
    this.token,
    this.type,
  });

  factory DeviceToken.fromJson(Map<String, dynamic> json) {
    return DeviceToken(
      token: json['token'],
      type: json['type'],
    );
  }
}

class DataForShow {
  int? id;
  int? tripId;
  int? senderId;
  int? recipientId;
  String? date;
  int? duration;
  String? timing;
  String? message;
  String? createdAt;
  String? updatedAt;
  int? isRecipientApproved;

  DataForShow({
    this.id,
    this.tripId,
    this.senderId,
    this.recipientId,
    this.date,
    this.duration,
    this.timing,
    this.message,
    this.createdAt,
    this.updatedAt,
    this.isRecipientApproved,
  });

  factory DataForShow.fromJson(Map<String, dynamic> json) {
    return DataForShow(
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
    );
  }
}
