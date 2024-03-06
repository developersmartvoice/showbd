import 'dart:convert';
import 'dart:ui';
import 'package:appcode3/views/AboutMeDetailsPage.dart';
import 'package:appcode3/views/BookingScreen.dart';
import 'package:appcode3/views/ChatScreen.dart';
import 'package:appcode3/views/CreateTrip.dart';
import 'package:appcode3/views/Doctor/DoctorProfile.dart';
import 'package:appcode3/views/Doctor/LogoutScreen.dart';
import 'package:appcode3/views/Doctor/loginAsDoctor.dart';
import 'package:appcode3/views/GenderSettingsPage.dart';
import 'package:appcode3/views/HourlyRate.dart';
import 'package:appcode3/views/IwillShowYouSettingsPage.dart';
import 'package:appcode3/views/LanguagesSettingsPage.dart';
import 'package:appcode3/views/LocationSearchPageInfo.dart';
import 'package:appcode3/views/MottoSettingsPage.dart';
import 'package:appcode3/views/SendOfferScreen.dart';
import 'package:appcode3/views/SendOffersScreen.dart';
import 'package:appcode3/views/ServicesSettings.dart';
import 'package:connectycube_sdk/connectycube_chat.dart';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/modals/DoctorAppointmentClass.dart';
import 'package:appcode3/modals/DoctorPastAppointmentsClass.dart';
import 'package:appcode3/views/Doctor/DoctorChatListScreen.dart';
import 'package:appcode3/views/Doctor/DoctorAllAppointments.dart';
import 'package:appcode3/views/Doctor/DoctorAppointmentDetails.dart';
import 'package:appcode3/views/Doctor/DoctorProfileWithRating.dart';
import 'package:appcode3/views/Doctor/moreScreen/change_password_screen.dart';
import 'package:appcode3/views/Doctor/moreScreen/income_report.dart';
import 'package:appcode3/views/Doctor/moreScreen/subscription_screen.dart';

import 'package:cached_network_image/cached_network_image.dart';
//import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
//import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

class AboutHost extends StatefulWidget {
  //const AboutHost({super.key});

  final String doctorId;

  AboutHost(this.doctorId);

  @override
  State<AboutHost> createState() => _AboutHostState();
}

class _AboutHostState extends State<AboutHost> {
  String motto = '';
  String iwillshowyou = '';
  String services = '';
  String consultationfees = '';
  //String photos = '';
  String location = '';
  String about_me = '';
  String gender = '';
  String languages = '';

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
        setState(() {
          services = jsonResponse['services'].toString();
          print(services);
        });
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

  getLanguages() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/getLanguages?id=${widget.doctorId}"));
    print("$SERVER_ADDRESS/api/getLanguages?id=${widget.doctorId}");
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          languages = jsonResponse['languages'].toString();
          print(languages);
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    return Scaffold(
      backgroundColor: LIGHT_GREY_SCREEN_BACKGROUND,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 103, 9),
        title: Text('About host',
            // style: GoogleFonts.robotoCondensed(
            //   fontSize: 25,
            //   fontWeight: FontWeight.bold,
            //   color: WHITE,
            // ),
            style: Theme.of(context).textTheme.headline5!.apply(
                color: Theme.of(context).backgroundColor, fontWeightDelta: 5)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ContainerPage(widget.doctorId, motto, iwillshowyou, services,
          consultationfees, location, about_me, gender, languages),
    );
  }
}

class ContainerPage extends StatefulWidget {
  @override
  _ContainerPageState createState() => _ContainerPageState();
  final String id;
  final String motto;
  final String iwillshowyou;
  final String services;
  final String consultationfees;
  final String city;
  final String aboutMe;
  final String gender;
  final String languages;

  ContainerPage(
    this.id,
    this.motto,
    this.iwillshowyou,
    this.services,
    this.consultationfees,
    this.city,
    this.aboutMe,
    this.gender,
    this.languages,
  );
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.motto.isEmpty) {
      isMottoStored = false;
    } else {
      print("motto is not empty");
      isMottoStored = true;
    }

    if (widget.consultationfees.isEmpty) {
      isConsultationFeesStored = false;
    } else {
      print("hourly_rate is not empty");
      isConsultationFeesStored = true;
    }

    if (widget.aboutMe.isEmpty) {
      isAboutMeStored = false;
    } else {
      print("aboutme is not empty");
      isAboutMeStored = true;
    }

    if (widget.city.isEmpty) {
      isLocationStored = false;
    } else {
      print("location is not empty");
      isLocationStored = true;
    }

    if (widget.iwillshowyou.isEmpty) {
      isIWillShowYouStored = false;
    } else {
      print("iwillshowyou is not empty");
      isIWillShowYouStored = true;
    }

    if (widget.services.isEmpty) {
      isServicesStored = false;
    } else {
      print("services is not empty");
      isServicesStored = true;
    }

    if (widget.gender.isEmpty) {
      isGenderStored = false;
    } else {
      print("gender is not empty");
      isGenderStored = true;
    }

    if (widget.languages.isEmpty) {
      isLanguagesStored = false;
    } else {
      print("languages is not empty");
      isLanguagesStored = true;
    }
  }

  // Color _boxColor = Colors.white;
  // bool _isSelected = false;

  // void _changeColor() {
  //   setState(() {
  //     // Change box color to a random color
  //     _boxColor = Colors.green;
  //   });
  // }

  // void _toggleSelection() {
  //   setState(() {
  //     _isSelected = !_isSelected;
  //   });
  // }

  bool isButtonSelected = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //Expanded(
        //child:
        Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 4),
              height: 60,
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          MottoSettingsPage(widget.id, widget.motto),
                    ),
                  );
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
                            color: !isMottoStored ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey, // Color of the border
                              width: 0.5, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color: isMottoStored ? Colors.green : Colors.white,
                            // color: Colors.white, // Color of the icon
                            size: 20.0, // Size of the icon
                          ),
                        )
                      ],
                    ),
                    // SizedBox(
                    //   width: MediaQuery.sizeOf(context).width * .01,
                    // ),
                    Container(
                      padding: EdgeInsets.only(right: 25),
                      alignment: Alignment.center,
                      width: MediaQuery.sizeOf(context).width * .2,
                      child: Text(
                        'Motto',
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          // color: Color.fromARGB(255, 243, 103, 9),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .1,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: Text(
                        widget.motto,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .05,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .1,
                      // child: IconButton(
                      //     onPressed: () {},
                      //     icon: Icon(Icons.arrow_forward_ios)),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Container(
            //   padding: EdgeInsets.only(left: 4),
            //   height: 70,
            //   color: Colors.white,
            //   child: InkWell(
            //     onTap: () {
            //       Navigator.of(context).push(
            //         MaterialPageRoute(
            //           builder: (context) =>
            //               MottoSettingsPage(widget.id, widget.motto),
            //         ),
            //       );
            //     },
            //     child: Row(
            //       mainAxisSize: MainAxisSize.max,
            //       // crossAxisAlignment: CrossAxisAlignment.stretch,
            //       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Stack(
            //           children: [
            //             Container(
            //               width: MediaQuery.sizeOf(context).width * .1,
            //               height: 30,
            //               decoration: BoxDecoration(
            //                 //color: _boxColor, // Color of the button
            //                 color:
            //                     !isMottoStored ? Colors.green : Colors.grey,
            //                 shape: BoxShape.circle,
            //                 border: Border.all(
            //                   color: Colors.black, // Color of the border
            //                   width: 1.0, // Width of the border
            //                 ), // Circular shape
            //               ),
            //               child: Icon(
            //                 Icons.check,
            //                 color:
            //                     isMottoStored ? Colors.green : Colors.white,
            //                 // color: Colors.white, // Color of the icon
            //                 size: 25.0, // Size of the icon
            //               ),
            //             )
            //           ],
            //         ),
            //         // SizedBox(
            //         //   width: MediaQuery.sizeOf(context).width * .01,
            //         // ),
            //         Container(
            //           padding: EdgeInsets.only(right: 5),
            //           alignment: Alignment.center,
            //           width: MediaQuery.sizeOf(context).width * .2,
            //           child: Text(
            //             'Motto',
            //             style: GoogleFonts.robotoCondensed(
            //               fontSize: 20.0,
            //               fontWeight: FontWeight.w500,
            //               // color: Color.fromARGB(255, 243, 103, 9),
            //             ),
            //           ),
            //         ),

            //         SizedBox(
            //           width: MediaQuery.sizeOf(context).width * .1,
            //         ),
            //         Container(
            //           alignment: Alignment.centerRight,
            //           width: MediaQuery.sizeOf(context).width * .4,
            //           child: Text(
            //             widget.motto,
            //             style: TextStyle(
            //               fontSize: 18.0,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.grey,
            //             ),
            //           ),
            //         ),
            //         // SizedBox(
            //         //   width: 10,
            //         // ),
            //         SizedBox(
            //           width: MediaQuery.sizeOf(context).width * .05,
            //         ),
            //         Container(
            //           width: MediaQuery.sizeOf(context).width * .1,
            //           // child: IconButton(
            //           //     onPressed: () {},
            //           //     icon: Icon(Icons.arrow_forward_ios)),
            //           child: Icon(Icons.arrow_forward_ios),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // Container(
            //   height: 70,
            //   color: Colors.white,
            //   child: Stack(
            //     children: [
            //       Positioned(
            //         left: 10, // Adjust the position of the button as needed
            //         top: 20, // Adjust the position of the button as needed
            //         child: InkWell(
            //           onTap: () {
            //             Navigator.of(context).push(
            //               MaterialPageRoute(
            //                 builder: (context) =>
            //                     MottoSettingsPage(widget.id, widget.motto),
            //               ),
            //             );
            //           },
            //           //onTap: _changeColor,
            //           // Add your logic for the selection button onTap event here

            //           child: Container(
            //             width: 30,
            //             height: 30,
            //             decoration: BoxDecoration(
            //               //color: _boxColor, // Color of the button
            //               color: Colors.green,
            //               shape: BoxShape.circle,
            //               border: Border.all(
            //                 color: Colors.black, // Color of the border
            //                 width: 1.0, // Width of the border
            //               ), // Circular shape
            //             ),
            //             child: Icon(
            //               Icons.check,
            //               //color: _isSelected ? Colors.green : Colors.white,
            //               color: Colors.white, // Color of the icon
            //               size: 30.0, // Size of the icon
            //             ),
            //           ),
            //         ),
            //       ),
            //       Row(children: [
            //         Expanded(
            //           child: Padding(
            //             padding: const EdgeInsets.only(right: 205.0),
            //             child: Text(
            //               'Motto',
            //               textAlign: TextAlign.center,
            //               style: GoogleFonts.robotoCondensed(
            //                 fontSize: 20.0,
            //                 color: Colors.black,
            //                 fontWeight: FontWeight.w500,
            //               ),
            //             ),
            //           ),
            //         ),

            //         Container(
            //           width: MediaQuery.sizeOf(context).width * .1,
            //           // child: IconButton(
            //           //     onPressed: () {},
            //           //     icon: Icon(Icons.arrow_forward_ios)),
            //           child: Icon(Icons.arrow_forward_ios),
            //         ),

            //         // Align(
            //         //   alignment: Alignment.centerRight,
            //         //   child: IconButton(
            //         //     onPressed: () {
            //         //       // Add your logic for the onPressed event here
            //         //       // Typically, this would involve navigating to the next screen or performing some action
            //         //     },
            //         //     //alignment: Alignment.centerRight,
            //         //     icon: Icon(Icons.arrow_forward_ios_sharp),
            //         //     color: Colors.black, // Color of the icon
            //         //     iconSize: 24.0, // Size of the icon
            //         //   ),
            //         // ),
            //       ]),
            //     ],
            //   ),
            // ),
            Divider(
              height: 1,
              color: Colors.white10,
            ),

            Container(
              padding: EdgeInsets.only(left: 4),
              height: 60,
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => IwillShowYouSettingsPage(
                          widget.id, widget.iwillshowyou),
                    ),
                  );
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
                            color: !isIWillShowYouStored
                                ? Colors.green
                                : Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey, // Color of the border
                              width: 0.5, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color: isIWillShowYouStored
                                ? Colors.green
                                : Colors.white,
                            // color: Colors.white, // Color of the icon
                            size: 20.0, // Size of the icon
                          ),
                        )
                      ],
                    ),
                    // SizedBox(
                    //   width: MediaQuery.sizeOf(context).width * .01,
                    // ),
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      alignment: Alignment.center,
                      //width: 150,
                      //width: MediaQuery.sizeOf(context).width * .2,
                      child: Text(
                        'I will show you',
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          // color: Color.fromARGB(255, 243, 103, 9),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .1,
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 37),
                      alignment: Alignment.centerRight,
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: Text(
                        widget.iwillshowyou,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 5,
                    // ),
                    // SizedBox(
                    //   width: 1,
                    //   //width: MediaQuery.sizeOf(context).width * .05,
                    // ),

                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                    ),
                    // Container(
                    //   //padding: EdgeInsets.only(right: 15),

                    //   width: MediaQuery.sizeOf(context).width * .1,
                    //   //   // child: IconButton(
                    //   //   //     onPressed: () {},
                    //   //   //     icon: Icon(Icons.arrow_forward_ios)),
                    //   child: Icon(Icons.arrow_forward_ios),
                    // ),
                  ],
                ),
              ),
            ),

            Divider(
              height: 1,
              color: Colors.white10,
            ),

            Container(
              padding: EdgeInsets.only(left: 4),
              height: 60,
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ServicesSettingsPage(widget.id, widget.services),
                    ),
                  );
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
                            color:
                                !isServicesStored ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey, // Color of the border
                              width: 0.5, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color:
                                isServicesStored ? Colors.green : Colors.white,
                            // color: Colors.white, // Color of the icon
                            size: 20.0, // Size of the icon
                          ),
                        )
                      ],
                    ),
                    // SizedBox(
                    //   width: MediaQuery.sizeOf(context).width * .01,
                    // ),
                    Container(
                      padding: EdgeInsets.only(right: 1),
                      alignment: Alignment.center,
                      width: MediaQuery.sizeOf(context).width * .2,
                      child: Text(
                        'Activities',
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          // color: Color.fromARGB(255, 243, 103, 9),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .1,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: Text(
                        widget.services,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .05,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .1,
                      // child: IconButton(
                      //     onPressed: () {},
                      //     icon: Icon(Icons.arrow_forward_ios)),
                      child: Icon(Icons.arrow_forward_ios, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            // Container(
            //   height: 70,
            //   color: Colors.white,
            //   child: Stack(
            //     children: [
            //       Positioned(
            //         left: 10, // Adjust the position of the button as needed
            //         top: 20, // Adjust the position of the button as needed
            //         child: InkWell(
            //           onTap: () {
            //             // Add your logic for the selection button onTap event here
            //           },
            //           child: Container(
            //             width: 30,
            //             height: 30,
            //             decoration: BoxDecoration(
            //               color: Colors.green, // Color of the button
            //               shape: BoxShape.circle,
            //               border: Border.all(
            //                 color: Colors.black, // Color of the border
            //                 width: 1.0, // Width of the border
            //               ), // Circular shape
            //             ),
            //             child: Icon(
            //               Icons.check,
            //               color: Colors.white, // Color of the icon
            //               size: 30.0, // Size of the icon
            //             ),
            //           ),
            //         ),
            //       ),
            //       Row(
            //         children: [
            //           Expanded(
            //             child: Padding(
            //               padding: const EdgeInsets.only(right: 130.0),
            //               child: Text(
            //                 'I will show you',
            //                 textAlign: TextAlign.center,
            //                 style: GoogleFonts.robotoCondensed(
            //                   fontSize: 20.0,
            //                   color: Colors.black,
            //                   fontWeight: FontWeight.w500,
            //                 ),
            //               ),
            //             ),
            //           ),
            //           Align(
            //             alignment: Alignment.centerRight,
            //             child: IconButton(
            //               onPressed: () {
            //                 // Navigator.of(context).push(
            //                 //   MaterialPageRoute(
            //                 //     builder: (context) => ChatScreen(widget.userName, widget.),
            //                 //   ),
            //                 // );
            //                 // Add your logic for the onPressed event here
            //                 // Typically, this would involve navigating to the next screen or performing some action
            //               },
            //               //alignment: Alignment.centerRight,
            //               icon: Icon(Icons.arrow_forward_ios_sharp),
            //               color: Colors.black, // Color of the icon
            //               iconSize: 24.0, // Size of the icon
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            // Divider(
            //   height: 2,
            //   color: Colors.white10,
            // ),
            // Container(
            //   height: 70,
            //   color: Colors.white,
            //   child: Stack(
            //     children: [
            //       Positioned(
            //         left: 10, // Adjust the position of the button as needed
            //         top: 20, // Adjust the position of the button as needed
            //         child: InkWell(
            //           onTap: () {
            //             // Add your logic for the selection button onTap event here
            //           },
            //           child: Container(
            //             width: 30,
            //             height: 30,
            //             decoration: BoxDecoration(
            //               color: Colors.green, // Color of the button
            //               shape: BoxShape.circle,
            //               border: Border.all(
            //                 color: Colors.black, // Color of the border
            //                 width: 1.0, // Width of the border
            //               ), // Circular shape
            //             ),
            //             child: Icon(
            //               Icons.check,
            //               color: Colors.white, // Color of the icon
            //               size: 30.0, // Size of the icon
            //             ),
            //           ),
            //         ),
            //       ),
            //       Row(
            //         children: [
            //           Expanded(
            //             child: Padding(
            //               padding: const EdgeInsets.only(right: 175.0),
            //               child: Text(
            //                 'Activities',
            //                 textAlign: TextAlign.center,
            //                 style: GoogleFonts.robotoCondensed(
            //                   fontSize: 20.0,
            //                   color: Colors.black,
            //                   fontWeight: FontWeight.w500,
            //                 ),
            //               ),
            //             ),
            //           ),
            //           Align(
            //             alignment: Alignment.centerRight,
            //             child: IconButton(
            //               onPressed: () {
            //                 // Add your logic for the onPressed event here
            //                 // Typically, this would involve navigating to the next screen or performing some action
            //               },
            //               alignment: Alignment.centerRight,
            //               icon: Icon(Icons.arrow_forward_ios_sharp),
            //               color: Colors.black, // Color of the icon
            //               iconSize: 24.0, // Size of the icon
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),

            Divider(
              height: 1,
              color: Colors.white10,
            ),

            Container(
              padding: EdgeInsets.only(left: 4),
              height: 60,
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => HourlyRateSettingsPage(
                          widget.id, widget.consultationfees),
                    ),
                  );
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
                            color: !isLocationStored
                                ? Colors.green
                                : Colors.grey, // Color of the button
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey, // Color of the border
                              width: 0.5, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color: isConsultationFeesStored
                                ? Colors.green
                                : Colors.white,
                            //color: Colors.white, // Color of the icon
                            size: 20.0, // Size of the icon
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      alignment: Alignment.center,
                      //width: MediaQuery.sizeOf(context).width * .2,
                      child: Text(
                        'Hourly rate',
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          // color: Color.fromARGB(255, 243, 103, 9),
                        ),
                      ),
                    ),
                    SizedBox(
                      //width: MediaQuery.sizeOf(context).width * .1,
                      width: 50,
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 15),
                      alignment: Alignment.centerRight,
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: Text(
                        widget.consultationfees,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: MediaQuery.sizeOf(context).width * .05,
                    // ),
                    Container(
                      height: 70,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: IconButton(
                          onPressed: () {
                            // Add your logic for the onPressed event here
                            // Typically, this would involve navigating to the next screen or performing some action
                          },
                          alignment: Alignment.centerRight,
                          icon: Icon(Icons.arrow_forward_ios_sharp),
                          color: Colors.black, // Color of the icon
                          iconSize: 20.0, // Size of the icon
                        ),
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
              padding: EdgeInsets.only(left: 4),
              height: 60,
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         HourlyRateSettingsPage(widget.id, widget.hourly_rate),
                  //   ),
                  // );
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
                            color: Colors.white, // Color of the button
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
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      alignment: Alignment.center,
                      //width: MediaQuery.sizeOf(context).width * .2,
                      child: Text(
                        'Photos',
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          // color: Color.fromARGB(255, 243, 103, 9),
                        ),
                      ),
                    ),
                    SizedBox(
                      //width: MediaQuery.sizeOf(context).width * .1,
                      width: 253,
                    ),
                    // Container(
                    //   alignment: Alignment.centerRight,
                    //   width: MediaQuery.sizeOf(context).width * .4,
                    //   child: Text(
                    //     '',
                    //     style: TextStyle(
                    //       fontSize: 15.0,
                    //       fontWeight: FontWeight.bold,
                    //       color: Colors.grey,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: MediaQuery.sizeOf(context).width * .05,
                    // ),
                    Container(
                      height: 70,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: IconButton(
                          onPressed: () {
                            // Add your logic for the onPressed event here
                            // Typically, this would involve navigating to the next screen or performing some action
                          },
                          alignment: Alignment.centerRight,
                          icon: Icon(Icons.arrow_forward_ios_sharp),
                          color: Colors.black, // Color of the icon
                          iconSize: 20.0, // Size of the icon
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Container(
            //   height: 60,
            //   color: Colors.white,
            //   child: Stack(
            //     children: [
            //       Positioned(
            //         left: 10, // Adjust the position of the button as needed
            //         top: 20, // Adjust the position of the button as needed
            //         child: InkWell(
            //           onTap: () {
            //             // Add your logic for the selection button onTap event here
            //           },
            //           child: Container(
            //             width: 30,
            //             height: 30,
            //             decoration: BoxDecoration(
            //               color: Colors.white, // Color of the button
            //               shape: BoxShape.circle,
            //               border: Border.all(
            //                 color: Colors.black, // Color of the border
            //                 width: 1.0, // Width of the border
            //               ), // Circular shape
            //             ),
            //             child: Icon(
            //               Icons.check,
            //               color: Colors.white, // Color of the icon
            //               size: 20.0, // Size of the icon
            //             ),
            //           ),
            //         ),
            //       ),
            //       Row(
            //         children: [
            //           Expanded(
            //             child: Padding(
            //               padding: const EdgeInsets.only(right: 200.0),
            //               child: Text(
            //                 'Photos',
            //                 textAlign: TextAlign.center,
            //                 style: GoogleFonts.robotoCondensed(
            //                   fontSize: 20.0,
            //                   color: Colors.black,
            //                   fontWeight: FontWeight.w500,
            //                 ),
            //               ),
            //             ),
            //           ),

            //           Container(
            //             height: 70,
            //             child: Padding(
            //               padding: const EdgeInsets.only(right: 15),
            //               child: IconButton(
            //                 onPressed: () {
            //                   // Add your logic for the onPressed event here
            //                   // Typically, this would involve navigating to the next screen or performing some action
            //                 },
            //                 alignment: Alignment.centerRight,
            //                 icon: Icon(Icons.arrow_forward_ios_sharp),
            //                 color: Colors.black, // Color of the icon
            //                 iconSize: 24.0, // Size of the icon
            //               ),
            //             ),
            //           ),
            //           // Align(
            //           //   alignment: Alignment.centerRight,
            //           //   child: IconButton(
            //           //     onPressed: () {
            //           //       // Add your logic for the onPressed event here
            //           //       // Typically, this would involve navigating to the next screen or performing some action
            //           //     },
            //           //     alignment: Alignment.centerRight,
            //           //     icon: Icon(Icons.arrow_forward_ios_sharp),
            //           //     color: Colors.black, // Color of the icon
            //           //     iconSize: 24.0, // Size of the icon
            //           //   ),
            //           // ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            Divider(
              height: 1,
              color: Colors.white10,
            ),

            Container(
              padding: EdgeInsets.only(left: 5),
              height: 60,
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          LocationSearchPageInfo(widget.id, widget.city),
                    ),
                  );
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
                            color:
                                !isLocationStored ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey, // Color of the border
                              width: 0.5, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color:
                                isLocationStored ? Colors.green : Colors.white,
                            // color: Colors.white, // Color of the icon
                            size: 20.0, // Size of the icon
                          ),
                        )
                      ],
                    ),
                    // SizedBox(
                    //   width: MediaQuery.sizeOf(context).width * .01,
                    // ),
                    Container(
                        padding: EdgeInsets.only(right: 5),
                        alignment: Alignment.center,
                        width: MediaQuery.sizeOf(context).width * .2,
                        child: Text(
                          LOCATION,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            // color: Color.fromARGB(255, 243, 103, 9),
                          ),
                        )),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .1,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: Text(
                        widget.city,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .05,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .1,
                      // child: IconButton(
                      //     onPressed: () {},
                      //     icon: Icon(Icons.arrow_forward_ios)),
                      child: Icon(Icons.arrow_forward_ios, size: 20),
                    )
                  ],
                ),
              ),
            ),

            // Container(
            //   padding: EdgeInsets.only(left: 4),
            //   height: 70,
            //   color: Colors.white,
            //   child: InkWell(
            //     onTap: () {
            //       Navigator.of(context).push(
            //         MaterialPageRoute(
            //           builder: (context) =>
            //               LocationSearchPageInfo(widget.id, widget.city),
            //         ),
            //       );
            //     },
            //     child: Row(
            //       mainAxisSize: MainAxisSize.max,
            //       // crossAxisAlignment: CrossAxisAlignment.stretch,
            //       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Stack(
            //           children: [
            //             Container(
            //               width: MediaQuery.sizeOf(context).width * .1,
            //               height: 30,
            //               decoration: BoxDecoration(
            //                 //color: _boxColor, // Color of the button
            //                 color: !isLocationStored
            //                     ? Colors.green
            //                     : Colors.grey,
            //                 shape: BoxShape.circle,
            //                 border: Border.all(
            //                   color: Colors.black, // Color of the border
            //                   width: 1.0, // Width of the border
            //                 ), // Circular shape
            //               ),
            //               child: Icon(
            //                 Icons.check,
            //                 color: isLocationStored
            //                     ? Colors.green
            //                     : Colors.white,
            //                 // color: Colors.white, // Color of the icon
            //                 size: 25.0, // Size of the icon
            //               ),
            //             )
            //           ],
            //         ),
            //         // SizedBox(
            //         //   width: MediaQuery.sizeOf(context).width * .01,
            //         // ),
            //         Container(
            //           padding: EdgeInsets.only(right: 5),
            //           alignment: Alignment.center,
            //           width: MediaQuery.sizeOf(context).width * .2,
            //           child: Text(
            //             'Location',
            //             style: GoogleFonts.robotoCondensed(
            //               fontSize: 20.0,
            //               fontWeight: FontWeight.w500,
            //               // color: Color.fromARGB(255, 243, 103, 9),
            //             ),
            //           ),
            //         ),

            //         SizedBox(
            //           width: MediaQuery.sizeOf(context).width * .1,
            //         ),
            //         Container(
            //           alignment: Alignment.centerRight,
            //           width: MediaQuery.sizeOf(context).width * .4,
            //           child: Text(
            //             widget.city,
            //             style: TextStyle(
            //               fontSize: 18.0,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.grey,
            //             ),
            //           ),
            //         ),
            //         // SizedBox(
            //         //   width: 10,
            //         // ),
            //         SizedBox(
            //           width: MediaQuery.sizeOf(context).width * .05,
            //         ),
            //         Container(
            //           width: MediaQuery.sizeOf(context).width * .1,
            //           // child: IconButton(
            //           //     onPressed: () {},
            //           //     icon: Icon(Icons.arrow_forward_ios)),
            //           child: Icon(Icons.arrow_forward_ios),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // Container(
            //   height: 70,
            //   color: Colors.white,
            //   child: Stack(
            //     children: [
            //       Positioned(
            //         left: 10, // Adjust the position of the button as needed
            //         top: 20, // Adjust the position of the button as needed
            //         child: InkWell(
            //           onTap: () {
            //             // Add your logic for the selection button onTap event here
            //           },
            //           child: Container(
            //             width: 30,
            //             height: 30,
            //             decoration: BoxDecoration(
            //               color: Colors.green, // Color of the button
            //               shape: BoxShape.circle,
            //               border: Border.all(
            //                 color: Colors.black, // Color of the border
            //                 width: 1.0, // Width of the border
            //               ), // Circular shape
            //             ),
            //             child: Icon(
            //               Icons.check,
            //               color: Colors.white, // Color of the icon
            //               size: 30.0, // Size of the icon
            //             ),
            //           ),
            //         ),
            //       ),

            //       Container(
            //         padding: EdgeInsets.only(right: 5),
            //         alignment: Alignment.center,
            //         width: MediaQuery.sizeOf(context).width * .2,
            //         child: Text(
            //           'Location',
            //           style: GoogleFonts.robotoCondensed(
            //             fontSize: 20.0,
            //             fontWeight: FontWeight.w500,
            //             // color: Color.fromARGB(255, 243, 103, 9),
            //           ),
            //         ),
            //       ),
            //       // Row(
            //       //   children: [
            //       //     Expanded(
            //       //       child: Padding(
            //       //         padding: const EdgeInsets.only(right: 175.0),
            //       //         child: Text(
            //       //           'Location',
            //       //           textAlign: TextAlign.center,
            //       //           style: GoogleFonts.robotoCondensed(
            //       //             fontSize: 20.0,
            //       //             color: Colors.black,
            //       //             fontWeight: FontWeight.w500,
            //       //           ),
            //       //         ),
            //       //       ),
            //       //     ),
            //       SizedBox(
            //         width: MediaQuery.sizeOf(context).width * .1,
            //       ),
            //       Container(
            //         alignment: Alignment.centerRight,
            //         width: MediaQuery.sizeOf(context).width * .4,
            //         child: Text(
            //           widget.city,
            //           style: TextStyle(
            //             fontSize: 18.0,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.grey,
            //           ),
            //         ),
            //       ),
            //       Align(
            //         alignment: Alignment.centerRight,
            //         child: IconButton(
            //           onPressed: () {
            //             Navigator.of(context).push(
            //               MaterialPageRoute(
            //                 builder: (context) => LocationSearchPage(),
            //               ),
            //             );
            //             // Add your logic for the onPressed event here
            //             // Typically, this would involve navigating to the next screen or performing some action
            //           },
            //           alignment: Alignment.centerRight,
            //           icon: Icon(Icons.arrow_forward_ios_sharp),
            //           color: Colors.black, // Color of the icon
            //           iconSize: 24.0, // Size of the icon
            //         ),
            //       ),
            //     ],
            //     // ),
            //     //],
            //   ),
            // ),
            Divider(
              height: 1,
              color: Colors.white10,
            ),

            Container(
              padding: EdgeInsets.only(left: 5),
              height: 60,
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          AboutMeDetailsPage(widget.id, widget.aboutMe),
                    ),
                  );
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
                            color:
                                !isAboutMeStored ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey, // Color of the border
                              width: 0.5, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color:
                                isAboutMeStored ? Colors.green : Colors.white,
                            // color: Colors.white, // Color of the icon
                            size: 20.0, // Size of the icon
                          ),
                        )
                      ],
                    ),
                    // SizedBox(
                    //   width: MediaQuery.sizeOf(context).width * .01,
                    // ),
                    Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(left: 5),
                        width: MediaQuery.sizeOf(context).width * .2,
                        child: Text(
                          ABOUT,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            // color: Color.fromARGB(255, 243, 103, 9),
                          ),
                        )),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .1,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: Text(
                        widget.aboutMe,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .05,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .1,
                      // child: IconButton(
                      //     onPressed: () {},
                      //     icon: Icon(Icons.arrow_forward_ios)),
                      child: Icon(Icons.arrow_forward_ios, size: 20),
                    )
                  ],
                ),
              ),
            ),
            // Container(
            //   height: 70,
            //   color: Colors.white,
            //   child: Stack(
            //     children: [
            //       Positioned(
            //         left: 10, // Adjust the position of the button as needed
            //         top: 20, // Adjust the position of the button as needed
            //         child: InkWell(
            //           onTap: () {
            //             // Add your logic for the selection button onTap event here
            //           },
            //           child: Container(
            //             width: 30,
            //             height: 30,
            //             decoration: BoxDecoration(
            //               color: Colors.green, // Color of the button
            //               shape: BoxShape.circle,
            //               border: Border.all(
            //                 color: Colors.black, // Color of the border
            //                 width: 1.0, // Width of the border
            //               ), // Circular shape
            //             ),
            //             child: Icon(
            //               Icons.check,
            //               color: Colors.white, // Color of the icon
            //               size: 30.0, // Size of the icon
            //             ),
            //           ),
            //         ),
            //       ),
            //       Row(
            //         children: [
            //           Expanded(
            //             child: Padding(
            //               padding: const EdgeInsets.only(right: 170.0),
            //               child: Text(
            //                 'About me',
            //                 textAlign: TextAlign.center,
            //                 style: GoogleFonts.robotoCondensed(
            //                   fontSize: 20.0,
            //                   color: Colors.black,
            //                   fontWeight: FontWeight.w500,
            //                 ),
            //               ),
            //             ),
            //           ),
            //           Align(
            //             alignment: Alignment.centerRight,
            //             child: IconButton(
            //               onPressed: () {
            //                 // Navigator.of(context).push(
            //                 //   MaterialPageRoute(
            //                 //     builder: (context) => AboutMeDetailsPage(),
            //                 //   ),
            //                 // );
            //                 // Add your logic for the onPressed event here
            //                 // Typically, this would involve navigating to the next screen or performing some action
            //               },
            //               alignment: Alignment.centerRight,
            //               icon: Icon(Icons.arrow_forward_ios_sharp),
            //               color: Colors.black, // Color of the icon
            //               iconSize: 24.0, // Size of the icon
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            Divider(
              height: 1,
              color: Colors.white10,
            ),
            // Container(
            //   height: 70,
            //   color: Colors.white,
            //   child: Stack(
            //     children: [
            //       Positioned(
            //         left: 10, // Adjust the position of the button as needed
            //         top: 20, // Adjust the position of the button as needed
            //         child: InkWell(
            //           onTap: () {
            //             // Add your logic for the selection button onTap event here
            //           },
            //           child: Container(
            //             width: 30,
            //             height: 30,
            //             decoration: BoxDecoration(
            //               color: Colors.green, // Color of the button
            //               shape: BoxShape.circle,
            //               border: Border.all(
            //                 color: Colors.black, // Color of the border
            //                 width: 1.0, // Width of the border
            //               ), // Circular shape
            //             ),
            //             child: Icon(
            //               Icons.check,
            //               color: Colors.white, // Color of the icon
            //               size: 30.0, // Size of the icon
            //             ),
            //           ),
            //         ),
            //       ),
            //       Row(
            //         children: [
            //           Expanded(
            //             child: Padding(
            //               padding: const EdgeInsets.only(right: 190.0),
            //               child: Text(
            //                 'Gender',
            //                 textAlign: TextAlign.center,
            //                 style: GoogleFonts.robotoCondensed(
            //                   fontSize: 20.0,
            //                   color: Colors.black,
            //                   fontWeight: FontWeight.w500,
            //                 ),
            //               ),
            //             ),
            //           ),
            //           Align(
            //             alignment: Alignment.centerRight,
            //             child: IconButton(
            //               onPressed: () {
            //                 // Add your logic for the onPressed event here
            //                 // Typically, this would involve navigating to the next screen or performing some action
            //               },
            //               alignment: Alignment.centerRight,
            //               icon: Icon(Icons.arrow_forward_ios_sharp),
            //               color: Colors.black, // Color of the icon
            //               iconSize: 24.0, // Size of the icon
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),

            Container(
              padding: EdgeInsets.only(left: 5),
              height: 60,
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          GenderSettingsPage(widget.id, widget.gender),
                    ),
                  );
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
                            color: !isGenderStored ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey, // Color of the border
                              width: 0.5, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color: isGenderStored ? Colors.green : Colors.white,
                            // color: Colors.white, // Color of the icon
                            size: 20.0, // Size of the icon
                          ),
                        )
                      ],
                    ),
                    // SizedBox(
                    //   width: MediaQuery.sizeOf(context).width * .01,
                    // ),
                    Container(
                      padding: EdgeInsets.only(right: 15),
                      alignment: Alignment.center,
                      width: MediaQuery.sizeOf(context).width * .2,
                      child: Text(
                        'Gender',
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          // color: Color.fromARGB(255, 243, 103, 9),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .1,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: Text(
                        widget.gender,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .05,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .1,
                      // child: IconButton(
                      //     onPressed: () {},
                      //     icon: Icon(Icons.arrow_forward_ios)),
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
              padding: EdgeInsets.only(left: 5),
              height: 60,
              color: Colors.white,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          LanguagesSettingsPage(widget.id, widget.languages),
                    ),
                  );
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
                            color:
                                !isLanguagesStored ? Colors.green : Colors.grey,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey, // Color of the border
                              width: 0.5, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color:
                                isLanguagesStored ? Colors.green : Colors.white,
                            // color: Colors.white, // Color of the icon
                            size: 20.0, // Size of the icon
                          ),
                        )
                      ],
                    ),
                    // SizedBox(
                    //   width: MediaQuery.sizeOf(context).width * .01,
                    // ),
                    Container(
                      padding: EdgeInsets.only(left: 8),
                      alignment: Alignment.center,
                      //width: MediaQuery.sizeOf(context).width * .2,
                      child: Text(
                        LANGUAGES,
                        style: GoogleFonts.robotoCondensed(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          // color: Color.fromARGB(255, 243, 103, 9),
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 30,
                      //width: MediaQuery.sizeOf(context).width * .1,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: Text(
                        widget.languages,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .05,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .1,
                      // child: IconButton(
                      //     onPressed: () {},
                      //     icon: Icon(Icons.arrow_forward_ios)),
                      child: Icon(Icons.arrow_forward_ios, size: 20),
                    ),
                  ],
                ),
              ),
            ),
            // Container(
            //   height: 70,
            //   color: Colors.white,
            //   child: Stack(
            //     children: [
            //       Positioned(
            //         left: 10, // Adjust the position of the button as needed
            //         top: 20, // Adjust the position of the button as needed
            //         child: GestureDetector(
            //           onTap: () {
            //             setState(() {
            //               if (!isButtonSelected) {
            //                 isButtonSelected = true;
            //               }
            //               //isButtonSelected = !isButtonSelected;
            //             });
            //             // Add your logic for the selection button onTap event here
            //           },
            //           child: Container(
            //             width: 30,
            //             height: 30,

            //             // primary: isButtonSelected
            //             //     ? Color.fromARGB(255, 243, 103, 9)
            //             //     : Colors.white, // Background color
            //             // onPrimary:
            //             //     isButtonSelected ? Colors.white : Colors.black,
            //             decoration: BoxDecoration(
            //               color: Colors.green, // Color of the button
            //               shape: BoxShape.circle,
            //               border: Border.all(
            //                 color: Colors.black, // Color of the border
            //                 width: 1.0, // Width of the border
            //               ), // Circular shape
            //             ),
            //             // child: IconButton(
            //             //   onPressed: () {
            //             //     // Add your logic for the onPressed event here
            //             //     // Typically, this would involve navigating to the next screen or performing some action
            //             //   },
            //             //   icon: Icon(
            //             //     Icons.check,
            //             //     size: 30.0,
            //             //     color: isButtonSelected
            //             //         ? Colors.white
            //             //         : Colors
            //             //             .white, // Use onPrimary color for the icon
            //             //   ),
            //             //   color: isButtonSelected
            //             //       ? Color.fromARGB(255, 243, 103, 9)
            //             //       : Colors
            //             //           .white, // Use primary color for the background
            //             // ),
            //             child: Icon(
            //               Icons.check,
            //               //color:
            //               //  isButtonSelected ? Colors.white : Colors.white,
            //               color: Colors.white, // Color of the icon
            //               size: 30.0, // Size of the icon
            //             ),
            //           ),
            //         ),
            //       ),
            //       Row(
            //         children: [
            //           Expanded(
            //             child: Padding(
            //               padding: const EdgeInsets.only(right: 155.0),
            //               child: Text(
            //                 'Languages',
            //                 textAlign: TextAlign.center,
            //                 style: GoogleFonts.robotoCondensed(
            //                   fontSize: 20.0,
            //                   color: Colors.black,
            //                   fontWeight: FontWeight.w500,
            //                 ),
            //               ),
            //             ),
            //           ),
            //           Align(
            //             alignment: Alignment.centerRight,
            //             child: IconButton(
            //               onPressed: () {
            //                 // Add your logic for the onPressed event here
            //                 // Typically, this would involve navigating to the next screen or performing some action
            //               },
            //               alignment: Alignment.centerRight,
            //               icon: Icon(Icons.arrow_forward_ios_sharp),
            //               color: Colors.black, // Color of the icon
            //               iconSize: 24.0, // Size of the icon
            //             ),
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),
            Divider(
              height: 1,
              color: Colors.white10,
            ),
          ],
        ),

        SizedBox(
          height: 20,
        ),

        //Container(
        //padding: EdgeInsets.all(30),
        //child: SizedBox(
        //height: 70, // Adjust the height as needed
        //child:
        Padding(
          padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
          child: ElevatedButton(
            onPressed: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         BookingScreen(widget.id, widget.guideName),
              //   ),
              // );
            },
            //child: Text('SUBMIT PROFILE'),
            child: Padding(
              padding: EdgeInsets.all(10), // Adjust padding as needed
              child: Text('SUBMIT PROFILE'),
            ),
            style: ElevatedButton.styleFrom(
              textStyle: GoogleFonts.robotoCondensed(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              foregroundColor: Colors.white,
              backgroundColor: Color.fromARGB(255, 243, 103, 9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
                side: BorderSide(
                  color: Colors.white,
                ), // Set border radius
              ),
            ),
          ),
        ),
      ],
    );
  }

  //void setState(Null Function() param0) {}
}
