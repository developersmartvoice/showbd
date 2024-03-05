class OffersClassReceiver {
  final bool success;
  final String message;
  final List<ChatData> dataForChat;
  final List<ChatShowData> dataForShow;

  OffersClassReceiver({
    required this.success,
    required this.message,
    required this.dataForChat,
    required this.dataForShow,
  });

  factory OffersClassReceiver.fromJson(Map<String, dynamic> json) {
    List<dynamic> chatDataList = json['data_for_chat'];
    List<dynamic> chatShowDataList = json['data_for_show'];

    return OffersClassReceiver(
      success: json['success'],
      message: json['message'],
      dataForChat: chatDataList.map((data) => ChatData.fromJson(data)).toList(),
      dataForShow:
          chatShowDataList.map((data) => ChatShowData.fromJson(data)).toList(),
    );
  }
}

class ChatData {
  final String name;
  final int uid;
  final String connectycubeUserId;
  final List<DeviceToken> deviceToken;
  final String recipientImage;
  final String senderImage;

  ChatData({
    required this.name,
    required this.uid,
    required this.connectycubeUserId,
    required this.deviceToken,
    required this.recipientImage,
    required this.senderImage,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    List<dynamic> deviceTokenList = json['device_token'];

    return ChatData(
      name: json['name'],
      uid: json['uid'],
      connectycubeUserId: json['connectycube_user_id'],
      deviceToken:
          deviceTokenList.map((data) => DeviceToken.fromJson(data)).toList(),
      recipientImage: json['recipient_image'],
      senderImage: json['sender_image'],
    );
  }
}

class DeviceToken {
  final String token;
  final String type;

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

class ChatShowData {
  final int id;
  final int tripId;
  final int senderId;
  final int recipientId;
  final String date;
  final int duration;
  final String timing;
  final String message;
  final String createdAt;
  final String updatedAt;
  final int isRecipientApproved;
  final String senderName;
  final String? destination;

  ChatShowData({
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
    required this.senderName,
    required this.destination,
  });

  factory ChatShowData.fromJson(Map<String, dynamic> json) {
    return ChatShowData(
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
      senderName: json['sender_name'],
      destination: json['destination'],
    );
  }
}
