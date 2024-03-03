// This class is for getRecipients API response

class ChatResponseR {
  bool? success;
  String? message;
  List<ChatDataR>? dataForChat;

  List<Details>? dataForShow;

  ChatResponseR({
    this.success,
    this.message,
    this.dataForChat,
    this.dataForShow,
  });

  factory ChatResponseR.fromJson(Map<String, dynamic> json) {
    return ChatResponseR(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      dataForChat: (json['data_for_chat'] as List<dynamic>?)
          ?.map((e) => ChatDataR.fromJson(e as Map<String, dynamic>))
          .toList(),
      dataForShow: (json['data_for_show'] as List<dynamic>?)
          ?.map((e) => Details.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ChatDataR {
  String? name;
  dynamic uid;
  String? connectycubeUserId;
  List<DeviceToken>? deviceToken;
  String? recipientImage;
  String? senderImage;

  ChatDataR({
    this.name,
    this.uid,
    this.connectycubeUserId,
    this.deviceToken,
    this.recipientImage,
    this.senderImage,
  });

  factory ChatDataR.fromJson(Map<String, dynamic> json) {
    return ChatDataR(
      name: json['name'] as String?,
      uid: json['uid'],
      connectycubeUserId: json['connectycube_user_id'] as String?,
      deviceToken: (json['device_token'] as List<dynamic>?)
          ?.map((e) => DeviceToken.fromJson(e as Map<String, dynamic>))
          .toList(),
      recipientImage: json['recipient_image'] as String?,
      senderImage: json['sender_image'] as String?,
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
      token: json['token'] as String?,
      type: json['type'] as String?,
    );
  }
}

class Details {
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
  String? senderName;

  Details({
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
    this.senderName,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      id: json['id'] as int?,
      tripId: json['trip_id'] as int?,
      senderId: json['sender_id'] as int?,
      recipientId: json['recipient_id'] as int?,
      date: json['date'] as String?,
      duration: json['duration'] as int?,
      timing: json['timing'] as String?,
      message: json['message'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      isRecipientApproved: json['is_recipient_approved'] as int?,
      senderName: json['sender_name'] as String?,
    );
  }
}
