// class SendOfferClass {
//   int? status;
//   String? msg;
//   List<NotifiedGuides>? data;

//   SendOfferClass({this.status, this.msg, this.data});

//   SendOfferClass.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     msg = json['msg'];
//     if (json['data'] != null) {
//       data = <NotifiedGuides>[];
//       json['data'].forEach((v) {
//         data!.add(new NotifiedGuides.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['msg'] = this.msg;
//     if (this.data != null) {
//       data['data'] = this.data!.map((e) => e.toJson()).toList();
//     }
//     return data;
//   }
// }

// class NotifiedGuides {
//   final String? imageURL;
//   final String? destination;
//   final String? start_date;
//   final String? end_date;
//   final int? id;
//   final int? guide_id;
//   final int? people_quantity;
//   final String? gender;
//   final String? duration;

//   NotifiedGuides({
//     this.imageURL,
//     this.destination,
//     this.start_date,
//     this.end_date,
//     this.id,
//     this.guide_id,
//     this.people_quantity,
//     this.gender,
//     this.duration,
//   });

//   factory NotifiedGuides.fromJson(Map<String, dynamic> json) {
//     return NotifiedGuides(
//       imageURL: json['imageURL'],
//       destination: json['destination'],
//       id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
//       guide_id: json['guide_id'] != null ? int.tryParse(json['guide_id'].toString()) : null,
//       people_quantity: json['people_quantity'] != null ? int.tryParse(json['people_quantity'].toString()) : null,
//       start_date: json['start_date']?.toString(), // Convert to String
//       end_date: json['end_date']?.toString(),     // Convert to String
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'imageURL': imageURL,
//       'destination': destination,
//       'start_date': start_date,
//       'end_date': end_date,
//       'id': id,
//       'guide_id': guide_id,
//       'people_quantity': people_quantity,
//       'gender': gender,
//       'duration': duration,
//     };
//   }
// }

class SendOfferClass {
  int? status;
  String? msg;
  List<NotifiedGuides>? notifiedGuides;
  int? tripCount;

  SendOfferClass({this.status, this.msg, this.notifiedGuides, this.tripCount});

  SendOfferClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['notified_guides'] != null) {
      notifiedGuides = <NotifiedGuides>[];
      json['notified_guides'].forEach((v) {
        notifiedGuides!.add(NotifiedGuides.fromJson(v));
      });
    }
    tripCount = json['trip_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    if (notifiedGuides != null) {
      data['notified_guides'] = notifiedGuides!.map((e) => e.toJson()).toList();
    }
    data['trip_count'] = tripCount;
    return data;
  }
}

class NotifiedGuides {
  final String? imageURL;
  final String? name;
  final String? destination;
  final String? start_date;
  final String? end_date;
  final int? id;
  final int? guide_id;
  final int? people_quantity;
  final String? gender;
  final String? duration;

  NotifiedGuides({
    this.imageURL,
    this.name,
    this.destination,
    this.start_date,
    this.end_date,
    this.id,
    this.guide_id,
    this.people_quantity,
    this.gender,
    this.duration,
  });

  factory NotifiedGuides.fromJson(Map<String, dynamic> json) {
    return NotifiedGuides(
      imageURL: json['image'],
      name: json['name'],
      destination: json['destination'],
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      guide_id: json['guide_id'] != null
          ? int.tryParse(json['guide_id'].toString())
          : null,
      people_quantity: json['people_quantity'] != null
          ? int.tryParse(json['people_quantity'].toString())
          : null,
      start_date: json['start_date']?.toString(), // Convert to String
      end_date: json['end_date']?.toString(), // Convert to String
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'imageURL': imageURL,
      'name': name,
      'destination': destination,
      'start_date': start_date,
      'end_date': end_date,
      'id': id,
      'guide_id': guide_id,
      'people_quantity': people_quantity,
      'gender': gender,
      'duration': duration,
    };
  }
}
