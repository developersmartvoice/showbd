// This class is for getSendOffers API response

class ChatResponse {
  bool? success;
  String? message;
  List<ChatData>? dataForChat;
  List<Details>? dataForShow;

  ChatResponse({
    this.success,
    this.message,
    this.dataForChat,
    this.dataForShow,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      dataForChat: (json['data_for_chat'] as List<dynamic>?)
          ?.map((e) => ChatData.fromJson(e as Map<String, dynamic>))
          .toList(),
      dataForShow: (json['data_for_show'] as List<dynamic>?)
          ?.map((e) => Details.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ChatData {
  String? name;
  int? uid;
  String? connectycubeUserId;
  List<DeviceToken>? deviceToken;
  String? recipientImage;
  String? senderImage;

  ChatData({
    this.name,
    this.uid,
    this.connectycubeUserId,
    this.deviceToken,
    this.recipientImage,
    this.senderImage,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      name: json['name'] as String?,
      uid: json['uid'] as int?,
      connectycubeUserId: json['connectycube_user_id'] as String?,
      deviceToken: (json['device_token'] as List<dynamic>?)
          ?.map((e) => DeviceToken.fromJson(e as Map<String, dynamic>))
          .toList(),
      recipientImage: json['recipient_image'] as String?,
      senderImage: json['sender_image'] as String?,
    );
  }

  get role => null;
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
  String? senderName;
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
  // String? senderName;

  Details({
    this.senderName,
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
    // this.senderName,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      senderName: json['sender_name'] as String?,
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
      // senderName: json['sender_name'] as String?,
    );
  }
}











// class ChatData {
//   bool? success;
//   String? message;
//   DataForChat? dataForChat;
//   DataForShow? dataForShow;

//   ChatData({
//     this.success,
//     this.message,
//     this.dataForChat,
//     this.dataForShow,
//   });

//   factory ChatData.fromJson(Map<String, dynamic> json) {
//     return ChatData(
//       success: json['success'],
//       message: json['message'],
//       dataForChat: DataForChat.fromJson(json['data_for_chat']),
//       dataForShow: DataForShow.fromJson(json['data_for_show']),
//     );
//   }
// }

// class DataForChat {
//   String? name;
//   int? uid;
//   String? connectycubeUserId;
//   List<DeviceToken>? deviceToken;
//   String? recipientImage;
//   String? senderImage;

//   DataForChat({
//     this.name,
//     this.uid,
//     this.connectycubeUserId,
//     this.deviceToken,
//     this.recipientImage,
//     this.senderImage,
//   });

//   factory DataForChat.fromJson(Map<String, dynamic> json) {
//     return DataForChat(
//       name: json['name'],
//       uid: json['uid'],
//       connectycubeUserId: json['connectycube_user_id'],
//       deviceToken: List<DeviceToken>.from(
//           json['device_token'].map((x) => DeviceToken.fromJson(x))),
//       recipientImage: json['recipient_image'],
//       senderImage: json['sender_image'],
//     );
//   }
// }

// class DeviceToken {
//   String? token;
//   String? type;

//   DeviceToken({
//     this.token,
//     this.type,
//   });

//   factory DeviceToken.fromJson(Map<String, dynamic> json) {
//     return DeviceToken(
//       token: json['token'],
//       type: json['type'],
//     );
//   }
// }

// class DataForShow {
//   int? id;
//   int? tripId;
//   int? senderId;
//   int? recipientId;
//   String? date;
//   int? duration;
//   String? timing;
//   String? message;
//   String? createdAt;
//   String? updatedAt;
//   int? isRecipientApproved;

//   DataForShow({
//     this.id,
//     this.tripId,
//     this.senderId,
//     this.recipientId,
//     this.date,
//     this.duration,
//     this.timing,
//     this.message,
//     this.createdAt,
//     this.updatedAt,
//     this.isRecipientApproved,
//   });

//   factory DataForShow.fromJson(Map<String, dynamic> json) {
//     return DataForShow(
//       id: json['id'],
//       tripId: json['trip_id'],
//       senderId: json['sender_id'],
//       recipientId: json['recipient_id'],
//       date: json['date'],
//       duration: json['duration'],
//       timing: json['timing'],
//       message: json['message'],
//       createdAt: json['created_at'],
//       updatedAt: json['updated_at'],
//       isRecipientApproved: json['is_recipient_approved'],
//     );
//   }
// }

// class ChatResponse {
//   bool? success;
//   String? message;
//   List<ChatResult>? results;

//   ChatResponse({
//     this.success,
//     this.message,
//     this.results,
//   });

//   factory ChatResponse.fromJson(Map<String, dynamic> json) {
//     return ChatResponse(
//       success: json['success'] as bool?,
//       message: json['message'] as String?,
//       results: (json['results'] as List<dynamic>?)
//           ?.map((e) => ChatResult.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }
// }

// class ChatResult {
//   ChatData? data;

//   ChatResult({this.data});

//   factory ChatResult.fromJson(Map<String, dynamic> json) {
//     return ChatResult(
//       data: ChatData.fromJson(json['data'] as Map<String, dynamic>),
//     );
//   }
// }

// class ChatData {
//   String? role;
//   String? name;
//   String? uid;
//   String? connectycubeUserId;
//   List<DeviceToken>? deviceToken;
//   String? recipientImage;
//   String? senderImage;
//   Details? details;

//   ChatData({
//     this.role,
//     this.name,
//     this.uid,
//     this.connectycubeUserId,
//     this.deviceToken,
//     this.recipientImage,
//     this.senderImage,
//     this.details,
//   });

//   factory ChatData.fromJson(Map<String, dynamic> json) {
//     return ChatData(
//       role: json['role'] as String?,
//       name: json['name'] as String?,
//       uid: json['uid'] as String?,
//       connectycubeUserId: json['connectycube_user_id'] as String?,
//       deviceToken: (json['device_token'] as List<dynamic>?)
//           ?.map((e) => DeviceToken.fromJson(e as Map<String, dynamic>))
//           .toList(),
//       recipientImage: json['recipient_image'] as String?,
//       senderImage: json['sender_image'] as String?,
//       details: Details.fromJson(json['details'] as Map<String, dynamic>),
//     );
//   }
// }

// class DeviceToken {
//   String? token;
//   String? type;

//   DeviceToken({
//     this.token,
//     this.type,
//   });

//   factory DeviceToken.fromJson(Map<String, dynamic> json) {
//     return DeviceToken(
//       token: json['token'] as String?,
//       type: json['type'] as String?,
//     );
//   }
// }

// class Details {
//   int? id;
//   int? tripId;
//   int? senderId;
//   int? recipientId;
//   String? date;
//   int? duration;
//   String? timing;
//   String? message;
//   String? createdAt;
//   String? updatedAt;
//   int? isRecipientApproved;

//   Details({
//     this.id,
//     this.tripId,
//     this.senderId,
//     this.recipientId,
//     this.date,
//     this.duration,
//     this.timing,
//     this.message,
//     this.createdAt,
//     this.updatedAt,
//     this.isRecipientApproved,
//   });

//   factory Details.fromJson(Map<String, dynamic> json) {
//     return Details(
//       id: json['id'] as int?,
//       tripId: json['trip_id'] as int?,
//       senderId: json['sender_id'] as int?,
//       recipientId: json['recipient_id'] as int?,
//       date: json['date'] as String?,
//       duration: json['duration'] as int?,
//       timing: json['timing'] as String?,
//       message: json['message'] as String?,
//       createdAt: json['created_at'] as String?,
//       updatedAt: json['updated_at'] as String?,
//       isRecipientApproved: json['is_recipient_approved'] as int?,
//     );
//   }
// }
