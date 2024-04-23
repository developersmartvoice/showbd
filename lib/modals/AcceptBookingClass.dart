class AcceptBookingClass {
  String message;
  AcceptedBooking acceptedBooking;
  String senderImage;
  String senderName;
  int senderId;
  String senderConnectycubeId;
  List<RecipientDeviceToken> senderDeviceTokens;
  String recipientImage;
  String recipientName;
  int recipientId;
  String connectycubeId;

  AcceptBookingClass({
    required this.message,
    required this.acceptedBooking,
    required this.senderImage,
    required this.senderName,
    required this.senderId,
    required this.senderConnectycubeId,
    required this.senderDeviceTokens,
    required this.recipientImage,
    required this.recipientName,
    required this.recipientId,
    required this.connectycubeId,
  });

  factory AcceptBookingClass.fromJson(Map<String, dynamic> json) {
    return AcceptBookingClass(
      message: json['message'],
      acceptedBooking: AcceptedBooking.fromJson(json['accepted_booking']),
      senderImage: json['sender_image'],
      senderName: json['sender_name'],
      senderId: json['sender_id'],
      senderConnectycubeId: json['sender_connectycube_id'],
      senderDeviceTokens: List<RecipientDeviceToken>.from(
          json['sender_device_tokens']
              .map((x) => RecipientDeviceToken.fromJson(x))),
      recipientImage: json['recipient_image'],
      recipientName: json['recipient_name'],
      recipientId: json['recipient_id'],
      connectycubeId: json['connectycube_id'],
    );
  }
}

class AcceptedBooking {
  int directBookingId;
  int senderId;
  int recipientId;
  String date;
  int duration;
  String timing;
  String message;
  String updatedAt;
  String createdAt;
  int id;

  AcceptedBooking({
    required this.directBookingId,
    required this.senderId,
    required this.recipientId,
    required this.date,
    required this.duration,
    required this.timing,
    required this.message,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory AcceptedBooking.fromJson(Map<String, dynamic> json) {
    return AcceptedBooking(
      directBookingId: json['direct_booking_id'],
      senderId: json['sender_id'],
      recipientId: json['recipient_id'],
      date: json['date'],
      duration: json['duration'],
      timing: json['timing'],
      message: json['message'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      id: json['id'],
    );
  }
}

class RecipientDeviceToken {
  String token;
  String type;

  RecipientDeviceToken({
    required this.token,
    required this.type,
  });

  factory RecipientDeviceToken.fromJson(Map<String, dynamic> json) {
    return RecipientDeviceToken(
      token: json['token'],
      type: json['type'],
    );
  }
}
