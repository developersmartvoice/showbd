class NearbyDoctorsClass {
  int? status;
  String? msg;
  Data? data;

  NearbyDoctorsClass({this.status, this.msg, this.data});

  NearbyDoctorsClass.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? currentPage;
  List<NearbyData>? nearbyData;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Data(
      {this.currentPage,
      this.nearbyData,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Data.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      nearbyData = <NearbyData>[];
      json['data'].forEach((v) {
        nearbyData!.add(new NearbyData.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(new Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'].toString();
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'].toString();
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    if (this.nearbyData != null) {
      data['data'] = this.nearbyData!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = this.firstPageUrl;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['last_page_url'] = this.lastPageUrl;
    if (this.links != null) {
      data['links'] = this.links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = this.nextPageUrl;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['prev_page_url'] = this.prevPageUrl;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}

class   NearbyData {
  int? id;
  String? name;
  String? address;
  String? image;
  List<String>? images; // Add images field as a list of strings
  double? distance;
  String? departmentName;
  String? consultationFee;
  String? aboutme;
  String? avgrating;
  String? totalreview;

  NearbyData(
      {this.id,
      this.name,
      this.address,
      this.image,
      this.images, // Include images field in the constructor
      this.distance,
      this.departmentName,
      this.consultationFee,
      this.aboutme,
      this.avgrating,
      this.totalreview});

  NearbyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    image = json['image'];
    images = json['images'] != null
        ? List<String>.from(json['images'])
        : []; // Parse images as a list

    //distance = double.parse(json['distance'].toString()) ?? 0.0;
    departmentName = json['department_name'];
    consultationFee = json['consultation_fees'].toString();
    aboutme = json['aboutus'];
    avgrating = json['avgratting'].toString();
    totalreview = json['total_review'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['image'] = this.image;
    data['images'] = this.images; // Include images in the JSON output
    data['distance'] = this.distance;
    data['department_name'] = this.departmentName;
    data['consultation_fees'] = this.consultationFee;
    data['aboutus'] = this.aboutme;
    data['avgratting'] = this.avgrating;
    data['total_review'] = this.totalreview;

    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'].toString();
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['label'] = this.label;
    data['active'] = this.active;
    return data;
  }
}
