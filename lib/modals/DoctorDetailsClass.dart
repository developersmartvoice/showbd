class DoctorDetailsClass {
  String? success;
  String? register;
  Data? data;

  DoctorDetailsClass({this.success, this.register, this.data});

  DoctorDetailsClass.fromJson(Map<String, dynamic> json) {
    success = json['success'].toString();
    register = json['register'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  int? id;
  String? name;
  String? email;
  dynamic aboutus;
  String? address;
  String? lat;
  String? lon;
  String? phoneno;
  // dynamic services;
  // dynamic healthcare;
  List<String>? services;
  List<String>? languages;
  // List<String>? aboutme;
  String?
      motto; /////////////////////////////////////////////////////////////////
  String? iwillshowyou;
  String? image;
  List<String>? images; // Add images field as a list of strings
  String? city;
  int? departmentId;
  String? workingTime;
  String? password;
  dynamic facebookUrl;
  dynamic twitterUrl;
  String? createdAt;
  String? updatedAt;
  String? departmentName;
  double? avgratting;
  int? totalReview;
  String? consultationFee;

  Data({
    this.id,
    this.name,
    this.email,
    this.aboutus,
    this.motto,
    this.address,
    this.lat,
    this.lon,
    this.phoneno,
    this.iwillshowyou,
    // this.aboutme,
    this.services,
    this.languages,
    this.image,
    this.images, // Include images field in the constructor
    this.city,
    this.departmentId,
    this.workingTime,
    this.password,
    this.facebookUrl,
    this.twitterUrl,
    this.createdAt,
    this.updatedAt,
    this.departmentName,
    this.avgratting,
    this.totalReview,
    this.consultationFee,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    aboutus = json['aboutus'];
    motto = json['motto'];
    iwillshowyou = json['iwillshowyou'];
    address = json['address'];
    lat = json['lat'].toString();
    lon = json['lon'].toString();
    phoneno = json['phoneno'].toString();
    // services = json['services'];
    // healthcare = json['healthcare'];
    services =
        (json['services'] as String?)?.split(',').map((e) => e.trim()).toList();
    languages = (json['languages'] as String?)
        ?.split(',')
        .map((e) => e.trim())
        .toList();
    // aboutme =
    //     (json['about me'] as String?)?.split(',').map((e) => e.trim()).toList();
    image = json['image'];
    images = json['images'] != null
        ? List<String>.from(json['images'])
        : []; // Parse images as a list
    city = json['city'];
    departmentId = json['department_id'] is String ? 0 : json['department_id'];
    workingTime = json['working_time'].toString();
    password = json['password'].toString();
    facebookUrl = json['facebook_url'];
    twitterUrl = json['twitter_url'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    departmentName = json['department_name'];
    avgratting = json['avgratting'] != null
        ? double.parse(json['avgratting'].toString())
        : 0;
    totalReview = json['total_review'];
    consultationFee = json['consultation_fees'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['aboutus'] = this.aboutus;
    data['motto'] = this.motto;
    data['iwillshowyou'] = this.iwillshowyou;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['phoneno'] = this.phoneno;
    // data['services'] = this.services;
    // data['healthcare'] = this.healthcare;
    data['services'] = services?.join(', ');
    data['languages'] = languages?.join(', ');
    // data['about me'] = aboutme?.join(', ');
    //data['i will show you'] = iwillshowyou?.join(', ');
    data['image'] = this.image;
    data['images'] = this.images; // Include images in the JSON output
    //data['department_id'] = this.departmentId.toString();
    data['city'] = this.city;
    data['working_time'] = this.workingTime;
    data['password'] = this.password;
    data['facebook_url'] = this.facebookUrl;
    data['twitter_url'] = this.twitterUrl;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['department_name'] = this.departmentName;
    data['avgratting'] = this.avgratting;
    data['total_review'] = this.totalReview;
    return data;
  }
}
