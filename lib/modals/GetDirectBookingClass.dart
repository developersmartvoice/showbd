class DirectBookingClass {
  int? status;
  String? message;
  List<DirectBooking>? directBookings;

  DirectBookingClass({this.status, this.message, this.directBookings});

  DirectBookingClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['direct_bookings'] != null) {
      directBookings = <DirectBooking>[];
      json['direct_bookings'].forEach((v) {
        directBookings!.add(DirectBooking.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (directBookings != null) {
      data['direct_bookings'] = directBookings!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class DirectBooking {
  int? bookingId;
  String? senderName;
  int? senderId;
  String? senderImage;
  String? date;
  String? timing;
  int? numPeople;
  String? message;
  int? duration;

  DirectBooking({
    this.bookingId,
    this.senderName,
    this.senderId,
    this.senderImage,
    this.date,
    this.timing,
    this.numPeople,
    this.message,
    this.duration,
  });

  DirectBooking.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    senderName = json['sender_name'];
    senderId = json['sender_id'];
    senderImage = json['sender_image'];
    date = json['date'];
    timing = json['timing'];
    numPeople = json['num_people'];
    message = json['message'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['booking_id'] = bookingId;
    data['sender_name'] = senderName;
    data['sender_id'] = senderId;
    data['sender_image'] = senderImage;
    data['date'] = date;
    data['timing'] = timing;
    data['num_people'] = numPeople;
    data['message'] = message;
    data['duration'] = duration;
    return data;
  }
}
