import 'dart:convert';
import 'dart:ui';
import 'package:appcode3/views/AboutMeDetailsPage.dart';

import 'package:appcode3/views/GenderSettingsPage.dart';
import 'package:appcode3/views/HourlyRate.dart';
import 'package:appcode3/views/IwillShowYouSettingsPage.dart';
import 'package:appcode3/views/LanguageNew.dart';
// ignore: unused_import
import 'package:appcode3/views/LanguagesSettingsPage.dart';
import 'package:appcode3/views/LocationSearchPageInfo.dart';
import 'package:appcode3/views/MottoSettingsPage.dart';
import 'package:appcode3/views/PhotoSettingsPage.dart';
import 'package:appcode3/views/ServicesSettings.dart';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class AboutHost extends StatefulWidget {
  //const AboutHost({super.key});

  final String doctorId;

  AboutHost(this.doctorId);

  @override
  State<AboutHost> createState() => _AboutHostState();
}

class _AboutHostState extends State<AboutHost> {
  // List<String> selectedServices = [
  //   'Translation & Interpretation',
  //   'Pick up & Driving tours',
  //   'Shopping',
  //   'Nightlife & Bars',
  //   'Food & Restaurants',
  //   'Art & Museums',
  //   'Sports & Recreation',
  //   'History & Culture',
  //   'Exploration & Sightseeing',
  // ];
  // List<String> selectedLanguages = [
  //   'English',
  //   'Bengali',
  //   'Urdu',
  //   'Spanish',
  //   'French',
  //   'Hindi'
  // ];

  Map<String, String> languageMap = {
    "english": "English",
    "bengali": "Bengali",
    "hindi": "Hindi",
    "urdu": "Urdu",
    "french": "French",
    "spanish": "Spanish"
  };

  String motto = '';
  String iwillshowyou = '';
  List<String>? services;
  String consultationfees = '';
  //String photos = '';
  String location = '';
  String photos = '';
  String about_me = '';
  String gender = '';
  List<String>? languages;
  String imageUrl1 = '';
  // String imageUrls = '';
  List<String>? imageUrls;
  bool isPhotosFetched = false;
  bool isMottoStored = false;

  getMotto() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/get_motto?id=${widget.doctorId}"));
    print("$SERVER_ADDRESS/api/get_motto?id=${widget.doctorId}");
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          motto = jsonResponse['motto'].toString();
          print(motto);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  getConsultationFees() async {
    final response = await get(Uri.parse(
        "$SERVER_ADDRESS/api/getConsultationFees?id=${widget.doctorId}"));
    print("$SERVER_ADDRESS/api/getConsultationFees?id=${widget.doctorId}");
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          consultationfees = jsonResponse['consultation_fees'].toString();
          print("this is consultation fees: $consultationfees");
        });
      }
    } catch (e) {
      print(e);
    }
  }

  getAboutMe() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/getAboutUs?id=${widget.doctorId}"));
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          about_me = jsonResponse['aboutus'].toString();
          print(about_me);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  getCity() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/getCity?id=${widget.doctorId}"));
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          location = jsonResponse['city'].toString();
          print(location);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  getIWillShowYou() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/getIWillShowYou?id=${widget.doctorId}"));
    print("$SERVER_ADDRESS/api/getIWillShowYou?id=${widget.doctorId}");
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse);
        setState(() {
          iwillshowyou = jsonResponse['I_will_show_you'].toString();
          print(iwillshowyou);
        });
      } else {
        print("Api not called properly");
      }
    } catch (e) {
      print(e);
    }
  }

  getServices() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/getServices?id=${widget.doctorId}"));
    print("$SERVER_ADDRESS/api/getServices?id=${widget.doctorId}");
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['services'] != null) {
          setState(() {
            services = jsonResponse['services'].split(',');
            print(services);
          });
        } else {
          setState(() {
            services = [];
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  getGender() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/getGender?id=${widget.doctorId}"));
    print("$SERVER_ADDRESS/api/getGender?id=${widget.doctorId}");
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          gender = jsonResponse['gender'].toString();
          print(gender);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  getImage() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/getImage?doctor_id=${widget.doctorId}"));

    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          imageUrl1 = jsonResponse['image_url'] ?? "";

          print("Only Image downloaded and assigned: $imageUrl1");
        });
      } else {
        print("Failed to fetch image. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching image: $e");
    }
  }

  Future<void> getImages() async {
    final Uri uri =
        Uri.parse("$SERVER_ADDRESS/api/getImages?doctor_id=${widget.doctorId}");
    final response = await get(uri);

    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        imageUrls = List<String>.from(jsonResponse['image_urls'] ?? "");
        setState(() {
          if (imageUrls == null) {
            imageUrls = [];
            isPhotosFetched = true;
          } else {
            isPhotosFetched = true;
            imageUrls!.forEach((imageUrl) {
              print("Image downloaded and assigned: $imageUrl");
              // Here you can do whatever you want with the downloaded images
            });
          }
        });
      } else {
        print("Failed to fetch images. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching images: $e");
    }
  }

  getLanguages() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/getLanguages?id=${widget.doctorId}"));
    print("$SERVER_ADDRESS/api/getLanguages?id=${widget.doctorId}");

    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['languages'] != null) {
          setState(() {
            languages = jsonResponse['languages'].split(',');
            print(languages);
          });
        } else {
          setState(() {
            languages = [];
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchedData();
  }

  fetchedData() {
    getImage();
    getImages();
    getMotto();
    getConsultationFees();
    getAboutMe();
    getCity();
    getIWillShowYou();
    getServices();
    getGender();
    getLanguages();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          // Pop the dialog if it's open
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(true);
            return false; // Prevent default back button behavior
          }
          return true; // Allow default back button behavior
        },
        child: Scaffold(
            backgroundColor: LIGHT_GREY_SCREEN_BACKGROUND,
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 243, 103, 9),
              title: Text(
                'About host',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.headline5!.apply(
                      color: Theme.of(context).backgroundColor,
                      fontWeightDelta: 1,
                      fontSizeFactor: .8),
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                color: WHITE,
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ),
            body: services != null && languages != null
                ? ContainerPage(
                    widget.doctorId,
                    motto,
                    iwillshowyou,
                    services!,
                    consultationfees,
                    imageUrl1,
                    imageUrls,
                    location,
                    about_me,
                    gender,
                    languages!,
                    _handleDataReload)
                : Container(
                    alignment: Alignment.center,
                    transformAlignment: Alignment.center,
                    child: CircularProgressIndicator(
                      color: const Color.fromARGB(255, 243, 103, 9),
                    ),
                  )),
      ),
    );
  }

  // Add this method to handle the data reload
  void _handleDataReload(bool dataUpdated) {
    if (dataUpdated) {
      fetchedData();
    }
  }
}

// ignore: must_be_immutable
class ContainerPage extends StatefulWidget {
  @override
  _ContainerPageState createState() => _ContainerPageState();
  final String id;
  final String motto;
  final String iwillshowyou;
  final List<String> services;
  final String consultationfees;
  String? imageUrl1;
  List<String>? imageUrls;
  final String city;
  final String aboutMe;
  final String gender;
  final List<String> languages;
  final Function(bool) handleDataReload; // Add this field

  ContainerPage(
      this.id,
      this.motto,
      this.iwillshowyou,
      this.services,
      this.consultationfees,
      this.imageUrl1,
      this.imageUrls,
      this.city,
      this.aboutMe,
      this.gender,
      this.languages,
      this.handleDataReload);
}

class _ContainerPageState extends State<ContainerPage> {
  bool isMottoStored = false;
  bool isAboutMeStored = false;
  bool isLocationStored = false;
  bool isConsultationFeesStored = false;
  bool isIWillShowYouStored = false;
  bool isServicesStored = false;
  bool isGenderStored = false;
  bool isLanguagesStored = false;
  bool isPhotoStored = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.motto.isNotEmpty) {
      setState(() {
        isMottoStored = true;
      });
    }

    if (widget.consultationfees.isNotEmpty) {
      setState(() {
        isConsultationFeesStored = true;
      });
    }

    if (widget.aboutMe.isNotEmpty) {
      setState(() {
        isAboutMeStored = true;
      });
    }

    if (widget.city.isNotEmpty) {
      setState(() {
        isLocationStored = true;
      });
    }

    if (widget.iwillshowyou.isNotEmpty) {
      setState(() {
        isIWillShowYouStored = true;
      });
    }

    if (widget.services.isNotEmpty) {
      setState(() {
        isServicesStored = true;
      });
    }

    if (widget.gender.isNotEmpty) {
      setState(() {
        isGenderStored = true;
      });
    }

    if (widget.languages.isNotEmpty) {
      setState(() {
        isLanguagesStored = true;
      });
    }

    if (widget.imageUrl1!.isNotEmpty) {
      setState(() {
        isPhotoStored = true;
      });
    }
  }

  bool isButtonSelected = false;

  @override
  Widget build(BuildContext context) {
    List<String> selectedServices = [
      'Translation & Interpretation',
      'Pick up & Driving tours',
      'Shopping',
      'Nightlife & Bars',
      'Food & Restaurants',
      'Art & Museums',
      'Sports & Recreation',
      'History & Culture',
      'Exploration & Sightseeing',
    ];
    // Define your mapping of services to specific values
    Map<String, String> serviceMapping = {
      'Translation & Interpretation': 'Translate',
      'Pick up & Driving tours': 'Tours',
      'Shopping': 'Shop',
      'Nightlife & Bars': 'Nightlife',
      'Food & Restaurants': 'Food',
      'Art & Museums': 'Art',
      'Sports & Recreation': 'Sports',
      'History & Culture': 'History',
      'Exploration & Sightseeing': 'Exploration',
    };

    // Now, iterate through the selected services and map them to their values
    for (String service in selectedServices) {
      String mappedValue = serviceMapping[service] ??
          ''; // Handle if service doesn't exist in mapping
      print('$service -> $mappedValue');
    }
    ;

    // ignore: unused_local_variable
    List<String> selectedLanguages = [
      'English',
      'Bengali',
      'Hindi',
      'Urdu',
      'German',
      'Korean',
      'Spanish',
      'Arabic',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //Expanded(
        //child:
        Column(
          children: [
            Container(
              // padding: EdgeInsets.only(left: 4),
              height: 60,
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) =>
                          MottoSettingsPage(widget.id, widget.motto),
                    ),
                  )
                      .then((dataUpdated) {
                    widget.handleDataReload(dataUpdated ?? false);
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width * .1,
                          height: 25,
                          decoration: BoxDecoration(
                            //color: _boxColor, // Color of the button
                            color: widget.motto.isNotEmpty
                                ? Colors.green
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey, // Color of the border
                              width: 0.5, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white, // Color of the icon
                            size: 20.0, // Size of the icon
                          ),
                        )
                      ],
                    ),
                    Container(
                      // padding: EdgeInsets.only(right: 30),
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.sizeOf(context).width * .25,
                      child: Text(
                        'Motto',
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w500,
                          // color: Color.fromARGB(255, 243, 103, 9),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .1,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: Text(
                        widget.motto != 'null'
                            ? widget.motto
                            : "Add your motto",
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .01,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .1,
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.white10,
            ),
            Container(
              // padding: EdgeInsets.only(left: 4),
              height: 60,
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => IwillShowYouSettingsPage(
                          widget.id, widget.iwillshowyou),
                    ),
                  )
                      .then((dataUpdated) {
                    widget.handleDataReload(dataUpdated ?? false);
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width * .1,
                          height: 25,
                          decoration: BoxDecoration(
                            //color: _boxColor, // Color of the button
                            color: widget.iwillshowyou.isNotEmpty
                                ? Colors.green
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey, // Color of the border
                              width: 0.5, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20.0, // Size of the icon
                          ),
                        )
                      ],
                    ),
                    // SizedBox(
                    //   width: MediaQuery.sizeOf(context).width * .01,
                    // ),
                    Container(
                      alignment: Alignment.centerLeft,
                      //width: 150,
                      width: MediaQuery.sizeOf(context).width * .25,
                      child: Text(
                        'I will show you',
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w500,
                          // color: Color.fromARGB(255, 243, 103, 9),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .1,
                    ),
                    Container(
                      // padding: EdgeInsets.only(right: 37),
                      alignment: Alignment.centerRight,
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: Text(
                        widget.iwillshowyou != 'null'
                            ? widget.iwillshowyou
                            : "Add what you can show",
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .01,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .1,
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.white10,
            ),
            Container(
              // padding: EdgeInsets.only(left: 4),
              height: 60,
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         ServiceNew(widget.id, widget.services),
                  //   ),
                  // );
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ServicesSettingsPage(widget.id, widget.services),
                    ),
                  )
                      .then((dataUpdated) {
                    widget.handleDataReload(dataUpdated ?? false);
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width * .1,
                          height: 25,
                          decoration: BoxDecoration(
                            //color: _boxColor, // Color of the button
                            color: widget.services.isNotEmpty
                                ? Colors.green
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey, // Color of the border
                              width: 0.5, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20.0, // Size of the icon
                          ),
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.sizeOf(context).width * .25,
                      child: Text(
                        'Activities',
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w500,
                          // color: Color.fromARGB(255, 243, 103, 9),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .1,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: Text(
                        //'${serviceMapping}',
                        'See your activities...',
                        //widget.services.toString(),
                        //'${selectedActivities}',
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .01,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .1,
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward_ios, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.white10,
            ),
            Container(
              // padding: EdgeInsets.only(left: 4),
              height: 60,
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => HourlyRateSettingsPage(
                          widget.id, widget.consultationfees),
                    ),
                  )
                      .then((dataUpdated) {
                    widget.handleDataReload(dataUpdated ?? false);
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width * .1,
                          height: 25,
                          decoration: BoxDecoration(
                            //color: Colors.white,
                            color: widget.consultationfees.isNotEmpty
                                ? Colors.green
                                : Colors.white, // Color of the button
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey, // Color of the border
                              width: 0.5, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20.0, // Size of the icon
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.sizeOf(context).width * .25,
                      child: Text(
                        'Hourly rate',
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w500,
                          // color: Color.fromARGB(255, 243, 103, 9),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .1,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: Text(
                        widget.consultationfees != '0'
                            ? widget.consultationfees
                            : "Free",
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .01,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .1,
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward_ios, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.white10,
            ),
            Container(
              // padding: EdgeInsets.only(left: 5),
              height: 60,
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) => PhotoSettingsPage(
                          widget.id, widget.imageUrl1!, widget.imageUrls!),
                    ),
                  )
                      .then((dataUpdated) {
                    widget.handleDataReload(dataUpdated ?? false);
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width * .1,
                          height: 25,
                          decoration: BoxDecoration(
                            // color: Colors.white,
                            // color: _boxColor, // Color of the button
                            color: widget.imageUrl1!.isNotEmpty
                                ? Colors.green
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey, // Color of the border
                              width: 0.5, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20.0, // Size of the icon
                          ),
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.sizeOf(context).width * .25,
                      child: Text(
                        'Photos',
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w500,
                          // color: Color.fromARGB(255, 243, 103, 9),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .1,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: Text(""),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .01,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .1,
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward_ios, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.white10,
            ),
            Container(
              // padding: EdgeInsets.only(left: 5),
              height: 60,
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) =>
                          LocationSearchPageInfo(widget.id, widget.city),
                    ),
                  )
                      .then((dataUpdated) {
                    widget.handleDataReload(dataUpdated ?? false);
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width * .1,
                          height: 25,
                          decoration: BoxDecoration(
                            //color: _boxColor, // Color of the button
                            color: widget.city.isNotEmpty
                                ? Colors.green
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey, // Color of the border
                              width: 0.5, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20.0, // Size of the icon
                          ),
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.sizeOf(context).width * .25,
                      child: Text(
                        LOCATION,
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w500,
                          // color: Color.fromARGB(255, 243, 103, 9),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .1,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: Text(
                        widget.city != 'null' ? widget.city : "Add your city",
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .01,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .1,
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward_ios, size: 20),
                    )
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.white10,
            ),
            Container(
              // padding: EdgeInsets.only(left: 5),
              height: 60,
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) =>
                          AboutMeDetailsPage(widget.id, widget.aboutMe),
                    ),
                  )
                      .then((dataUpdated) {
                    widget.handleDataReload(dataUpdated ?? false);
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width * .1,
                          height: 25,
                          decoration: BoxDecoration(
                            //color: _boxColor, // Color of the button
                            color: widget.aboutMe.isNotEmpty
                                ? Colors.green
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey, // Color of the border
                              width: 0.5, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20.0, // Size of the icon
                          ),
                        )
                      ],
                    ),
                    // SizedBox(
                    //   width: MediaQuery.sizeOf(context).width * .01,
                    // ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.sizeOf(context).width * .25,
                      child: Text(
                        ABOUT,
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w500,
                          // color: Color.fromARGB(255, 243, 103, 9),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .1,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: Text(
                        widget.aboutMe != 'null'
                            ? widget.aboutMe
                            : "Add About me",
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .01,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .1,
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward_ios, size: 20),
                    )
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.white10,
            ),
            Container(
              // padding: EdgeInsets.only(left: 5),
              height: 60,
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) =>
                          GenderSettingsPage(widget.id, widget.gender),
                    ),
                  )
                      .then((dataUpdated) {
                    widget.handleDataReload(dataUpdated ?? false);
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width * .1,
                          height: 25,
                          decoration: BoxDecoration(
                            //color: _boxColor, // Color of the button
                            color: widget.gender.isNotEmpty
                                ? Colors.green
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey, // Color of the border
                              width: 0.5, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20.0, // Size of the icon
                          ),
                        )
                      ],
                    ),
                    // SizedBox(
                    //   width: MediaQuery.sizeOf(context).width * .01,
                    // ),
                    Container(
                      // padding: EdgeInsets.only(right: 15),
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.sizeOf(context).width * .25,
                      child: Text(
                        'Gender',
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w500,
                          // color: Color.fromARGB(255, 243, 103, 9),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .1,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: Text(
                        widget.gender != 'null'
                            ? widget.gender.capitalize.toString()
                            : "Add your gender",
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .01,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .1,
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward_ios, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.white10,
            ),
            Container(
              // padding: EdgeInsets.only(left: 5),
              height: 60,
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(
                    MaterialPageRoute(
                      builder: (context) =>
                          LanguageNew(widget.id, widget.languages),
                    ),
                  )
                      .then((dataUpdated) {
                    widget.handleDataReload(dataUpdated ?? false);
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.sizeOf(context).width * .1,
                          height: 25,
                          decoration: BoxDecoration(
                            //color: _boxColor, // Color of the button
                            color: widget.languages.isNotEmpty
                                ? Colors.green
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey, // Color of the border
                              width: 0.5, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20.0, // Size of the icon
                          ),
                        )
                      ],
                    ),
                    // SizedBox(
                    //   width: MediaQuery.sizeOf(context).width * .01,
                    // ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.sizeOf(context).width * .25,
                      child: Text(
                        LANGUAGES,
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .1,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        widget.languages
                            .map((language) => language.capitalize)
                            .join(
                                ', '), // Join the list elements with a comma and space
                        style: GoogleFonts.poppins(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .01,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .1,
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.arrow_forward_ios, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              color: Colors.white10,
            ),
          ],
        ),

        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
