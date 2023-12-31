class DoctorProfileDetails {
  dynamic success;
  // String? success;
  String? register;
  MyData? data;

  DoctorProfileDetails({this.success, this.register, this.data});

  DoctorProfileDetails.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    register = json['register'];
    data = json['data'] != null ? new MyData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['register'] = this.register;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class MyData {
  int? id;
  String? name;
  String? email;
  String? aboutus;
  String? workingTime;
  String? address;
  String? lat;
  String? lon;
  dynamic phoneno;
  // String? services;
  List<String>? services;
  // String? healthcare;
  List<String>? languages;
  String? image;
  List<String>? images; // Add images field as a list of strings
  dynamic password;
  String? facebookUrl;
  String? twitterUrl;
  String? createdAt;
  String? updatedAt;
  int? isApprove;
  // String? isApprove;
  dynamic consultationFees;
  String? departmentName;
  int? avgratting;

  MyData(
      {this.id,
      this.name,
      this.email,
      this.aboutus,
      this.workingTime,
      this.address,
      this.lat,
      this.lon,
      this.phoneno,
      this.services,
      this.languages,
      this.image,
      this.images, // Include images field in the constructor
      this.password,
      this.facebookUrl,
      this.twitterUrl,
      this.createdAt,
      this.updatedAt,
      this.isApprove,
      this.consultationFees,
      this.departmentName,
      this.avgratting});

  MyData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    aboutus = json['aboutus'] ?? "";
    workingTime = json['working_time'].toString();
    address = json['address'] ?? "";
    lat = json['lat'] == null ? "" : json['lat'].toString();
    lon = json['lon'] == null ? "" : json['lon'].toString();
    phoneno = json['phoneno'].toString();
    // services = json['services'] ?? "";
    services =
        (json['services'] as String?)?.split(',').map((e) => e.trim()).toList();
    // healthcare = json['healthcare'] ?? "";
    languages = (json['languages'] as String?)
        ?.split(',')
        .map((e) => e.trim())
        .toList();
    image = json['image'].toString();
    images = json['images'] != null
        ? List<String>.from(json['images'])
        : []; // Parse images as a list
    password = json['password'].toString();
    facebookUrl = json['facebook_url'] ?? "";
    twitterUrl = json['twitter_url'] ?? "";
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isApprove = json['is_approve'];
    consultationFees = json['consultation_fees'].toString();
    departmentName = json['department_name'] ?? "";
    avgratting = json['avgratting'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['aboutus'] = this.aboutus;
    data['working_time'] = this.workingTime;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['phoneno'] = this.phoneno;
    // data['services'] = this.services;
    data['services'] = services?.join(',');
    // data['healthcare'] = this.healthcare;
    data['languages'] = languages?.join(',');
    data['image'] = this.image;
    data['images'] =
        this.images?.join(','); // Include images in the JSON output
    data['password'] = this.password;
    data['facebook_url'] = this.facebookUrl;
    data['twitter_url'] = this.twitterUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_approve'] = this.isApprove;
    data['consultation_fees'] = this.consultationFees;
    data['department_name'] = this.departmentName;
    data['avgratting'] = this.avgratting;
    return data;
  }
}
