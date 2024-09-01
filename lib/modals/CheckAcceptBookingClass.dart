class SenderInfo {
  final String senderImage;
  final String senderName;
  final int senderId;
  final String senderConnectycubeId;
  final List<Map<String, dynamic>> senderDeviceTokens;

  SenderInfo({
    required this.senderImage,
    required this.senderName,
    required this.senderId,
    required this.senderConnectycubeId,
    required this.senderDeviceTokens,
  });

  factory SenderInfo.fromJson(Map<String, dynamic> json) {
    return SenderInfo(
      senderImage: json['sender_image'],
      senderName: json['sender_name'],
      senderId: json['sender_id'],
      senderConnectycubeId: json['sender_connectycube_id'],
      senderDeviceTokens:
          List<Map<String, dynamic>>.from(json['sender_device_tokens']),
    );
  }
}

class RecipientInfo {
  final String recipientImage;
  final String recipientName;
  final int recipientId;
  final String recipientConnectycubeId;
  final List<Map<String, dynamic>> recipientDeviceTokens;

  RecipientInfo({
    required this.recipientImage,
    required this.recipientName,
    required this.recipientId,
    required this.recipientConnectycubeId,
    required this.recipientDeviceTokens,
  });

  factory RecipientInfo.fromJson(Map<String, dynamic> json) {
    return RecipientInfo(
      recipientImage: json['recipient_image'],
      recipientName: json['recipient_name'],
      recipientId: json['recipient_id'],
      recipientConnectycubeId: json['recipient_connectycube_id'],
      recipientDeviceTokens:
          List<Map<String, dynamic>>.from(json['recipient_device_tokens']),
    );
  }
}

class ApiResponse {
  final String message;
  final bool value;
  final String? msg1;
  final SenderInfo? senderInfo;
  final RecipientInfo? recipientInfo;

  ApiResponse({
    required this.message,
    required this.value,
    this.msg1,
    this.senderInfo,
    this.recipientInfo,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      message: json['message'],
      value: json['value'],
      msg1: json['msg1'],
      senderInfo: SenderInfo.fromJson(json['sender_info']),
      recipientInfo: RecipientInfo.fromJson(json['recipient_info']),
    );
  }
}
