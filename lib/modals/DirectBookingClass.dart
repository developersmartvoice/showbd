// class DirectBookingClass {
//   final String message;
//   final DirectBookingData directBooking;
//   final List<DeviceToken> senderDeviceTokens;
//   final List<DeviceToken> recipientDeviceTokens;

//   DirectBookingClass({
//     required this.message,
//     required this.directBooking,
//     required this.senderDeviceTokens,
//     required this.recipientDeviceTokens,
//   });

//   factory DirectBookingClass.fromJson(Map<String, dynamic> json) {
//     return DirectBookingClass(
//       message: json['message'],
//       directBooking: DirectBookingData.fromJson(json['direct_booking']),
//       senderDeviceTokens: List<DeviceToken>.from(json['sender_device_token']
//           .map((token) => DeviceToken.fromJson(token))),
//       recipientDeviceTokens: List<DeviceToken>.from(
//           json['recipient_device_token']
//               .map((token) => DeviceToken.fromJson(token))),
//     );
//   }
// }

// class DirectBookingData {
//   final String senderId;
//   final String recipientId;
//   final String date;
//   final int duration;
//   final String timing;
//   final String message;
//   final int numPeople;
//   final String updatedAt;
//   final String createdAt;
//   final int id;

//   DirectBookingData({
//     required this.senderId,
//     required this.recipientId,
//     required this.date,
//     required this.duration,
//     required this.timing,
//     required this.message,
//     required this.numPeople,
//     required this.updatedAt,
//     required this.createdAt,
//     required this.id,
//   });

//   factory DirectBookingData.fromJson(Map<String, dynamic> json) {
//     return DirectBookingData(
//       senderId: json['sender_id'],
//       recipientId: json['recipient_id'],
//       date: json['date'],
//       duration: json['duration'],
//       timing: json['timing'],
//       message: json['message'],
//       numPeople: json['num_people'],
//       updatedAt: json['updated_at'],
//       createdAt: json['created_at'],
//       id: json['id'],
//     );
//   }
// }

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

class DirectBookingClass {
  final String message;
  final List<DeviceToken> senderDeviceTokens;
  final List<DeviceToken> recipientDeviceTokens;

  DirectBookingClass({
    required this.message,
    required this.senderDeviceTokens,
    required this.recipientDeviceTokens,
  });

  factory DirectBookingClass.fromJson(Map<String, dynamic> json) {
    return DirectBookingClass(
      message: json['message'],
      senderDeviceTokens: (json['sender_device_token'] as List<dynamic>)
          .map((token) => DeviceToken.fromJson(token))
          .toList(),
      recipientDeviceTokens: (json['recipient_device_token'] as List<dynamic>)
          .map((token) => DeviceToken.fromJson(token))
          .toList(),
    );
  }
}
