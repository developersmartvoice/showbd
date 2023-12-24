class TripsClass {
  int? status;
  String? msg;
  List<Trip>? data;

  TripsClass({this.status, this.msg, this.data});

  TripsClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Trip>[];
      json['data'].forEach((v) {
        data!.add(new Trip.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Trip {
  int? id;
  int? guideId;
  String? destination;
  String? startDate;
  String? endDate;
  int? duration;
  int? peopleQuantity;
  String? type;
  String? createdAt;
  String? updatedAt;

  Trip({
    this.id,
    this.guideId,
    this.destination,
    this.startDate,
    this.endDate,
    this.duration,
    this.peopleQuantity,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  Trip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    guideId = json['guide_id'];
    destination = json['destination'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    duration = json['duration'];
    peopleQuantity = json['people_quantity'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['guide_id'] = this.guideId;
    data['destination'] = this.destination;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['duration'] = this.duration;
    data['people_quantity'] = this.peopleQuantity;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;

    return data;
  }
}
