import 'package:appcode3/views/AboutMeDetailsPage.dart';
import 'package:appcode3/views/CreateTrip.dart';
import 'package:appcode3/views/EmailDetailsPage.dart';
import 'package:appcode3/views/LocationSearchPageInfo.dart';
import 'package:appcode3/views/NameSettingsPage.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:ui';
import 'package:appcode3/views/BookingScreen.dart';
import 'package:appcode3/views/Doctor/DoctorProfile.dart';
import 'package:appcode3/views/Doctor/LogoutScreen.dart';
import 'package:appcode3/views/Doctor/loginAsDoctor.dart';
import 'package:appcode3/views/SendOfferScreen.dart';
import 'package:appcode3/views/SendOffersScreen.dart';
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

class GeneraLInfo extends StatefulWidget {
  // const GeneraLInfo({super.key});
  final String doctorId;

  GeneraLInfo(this.doctorId);

  @override
  State<GeneraLInfo> createState() => _GeneraLInfoState();
}

class _GeneraLInfoState extends State<GeneraLInfo> {
  String name = '';
  String about_me = '';
  String location = '';

  getName() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/getName?id=${widget.doctorId}"));
    print("$SERVER_ADDRESS/api/getName?id=${widget.doctorId}");
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          name = jsonResponse['name'].toString();
          print(name);
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
    getAboutMe();
    getCity();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: LIGHT_GREY_SCREEN_BACKGROUND,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 243, 103, 9),
          centerTitle: true,
          title: Text('General information',
              // style: GoogleFonts.robotoCondensed(
              //   color: Colors.white,
              //   fontSize: 25,
              //   fontWeight: FontWeight.w700, // Title text color
              // ),
              style: Theme.of(context).textTheme.headline5!.apply(
                  color: Theme.of(context).backgroundColor,
                  fontWeightDelta: 5)),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black, // Back button color
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          // actions: [
          //   TextButton(
          //     onPressed: () {
          //       // Navigator.of(context).push(
          //       //           MaterialPageRoute(
          //       //             builder: (context) => DoctorChatListScreen(),
          //       //           ),
          //       //         );
          //       // Add your button functionality here
          //     },
          //     child: Text(
          //       'Save', // Text for the button
          //       style: GoogleFonts.robotoCondensed(
          //         fontSize: 23,
          //         fontWeight: FontWeight.bold,
          //         color: Colors.black, // Text color
          //       ),
          //     ),
          //   ),
          // ],
        ),
        body: ContainerPage(widget.doctorId, name, about_me, location),
      ),
    );
  }
}

class ContainerPage extends StatefulWidget {
  @override
  _ContainerPageState createState() => _ContainerPageState();
  final String id;
  final String name;
  final String aboutMe;
  final String city;

  ContainerPage(this.id, this.name, this.aboutMe, this.city);
}

class _ContainerPageState extends State<ContainerPage> {
  bool isNameStored = false;
  bool isAboutMeStored = false;
  bool isLocationStored = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.name.isEmpty) {
      isNameStored = false;
    } else {
      print("name is not empty");
      isNameStored = true;
    }

    if (widget.aboutMe.isEmpty) {
      isAboutMeStored = false;
    } else {
      print("about is not empty");
      isAboutMeStored = true;
    }

    if (widget.city.isEmpty) {
      isLocationStored = false;
    } else {
      print("location is not empty");
      isLocationStored = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                height: 60,
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            NameSettingsPage(widget.id, widget.name),
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
                              color: !isNameStored ? Colors.green : Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey, // Color of the border
                                width: 0.5, // Width of the border
                              ), // Circular shape
                            ),
                            child: Icon(
                              Icons.check,
                              color: isNameStored ? Colors.green : Colors.white,
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
                        padding: EdgeInsets.only(right: 22),
                        alignment: Alignment.center,
                        width: MediaQuery.sizeOf(context).width * .2,
                        child: Text(
                          NAME,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
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
                          widget.name,
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
              // Container(
              //   height: 70,
              //   color: Colors.white,
              //   child: Stack(
              //     children: [
              //       Positioned(
              //         left: 10, // Adjust the position of the button as needed
              //         top: 20, // Adjust the position of the button as needed
              //         child: InkWell(
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
              //               size: 25.0, // Size of the icon
              //             ),
              //           ),
              //         ),
              //       ),
              //       Row(children: [
              //         Expanded(
              //           child: Padding(
              //             padding: const EdgeInsets.only(right: 160.0),
              //             child: Text(
              //               'About me',
              //               textAlign: TextAlign.center,
              //               style: GoogleFonts.robotoCondensed(
              //                 fontSize: 20.0,
              //                 color: Colors.black,
              //                 fontWeight: FontWeight.w500,
              //               ),
              //             ),
              //           ),
              //         ),
              //         Align(
              //           alignment: Alignment.centerRight,
              //           child: IconButton(
              //             onPressed: () {
              //               Navigator.of(context).push(
              //                 MaterialPageRoute(
              //                   builder: (context) => AboutMeDetailsPage(),
              //                 ),
              //               );
              //               // Add your logic for the onPressed event here
              //               // Typically, this would involve navigating to the next screen or performing some action
              //             },
              //             //alignment: Alignment.centerRight,
              //             icon: Icon(Icons.arrow_forward_ios_sharp),
              //             color: Colors.black, // Color of the icon
              //             iconSize: 24.0, // Size of the icon
              //           ),
              //         ),
              //       ]),
              //     ],
              //   ),
              // ),
              Container(
                padding: EdgeInsets.all(10),
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
              Divider(
                height: 1,
                color: Colors.white10,
              ),

              Container(
                padding: EdgeInsets.all(10),
                height: 60,
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         NameSettingsPage(widget.id, widget.name),
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
                              //color: _boxColor, // Color of the button
                              color: !isNameStored ? Colors.green : Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey, // Color of the border
                                width: 0.5, // Width of the border
                              ), // Circular shape
                            ),
                            child: Icon(
                              Icons.check,
                              color: isNameStored ? Colors.green : Colors.white,
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
                          'Photos',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            // color: Color.fromARGB(255, 243, 103, 9),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .1,
                      ),
                      // Container(
                      //   alignment: Alignment.centerRight,
                      //   width: MediaQuery.sizeOf(context).width * .4,
                      //   child: Text(
                      //     widget.name,
                      //     style: TextStyle(
                      //       fontSize: 18.0,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.grey,
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .05,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 180),
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
              //         left: 15, // Adjust the position of the button as needed
              //         top: 20, // Adjust the position of the button as needed
              //         child: InkWell(
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
              //               size: 25.0, // Size of the icon
              //             ),
              //           ),
              //         ),
              //       ),
              //       // Row(children: [
              //       //   Expanded(
              //       //     //child:
              //       //     //Padding(
              //       //     //padding: const EdgeInsets.only(right: 195.0),
              //       //     child: Container(
              //       //       padding: EdgeInsets.only(right: 200),
              //       //       child: Text(
              //       //         'Photos',
              //       //         textAlign: TextAlign.center,
              //       //         style: GoogleFonts.robotoCondensed(
              //       //           fontSize: 20.0,
              //       //           color: Colors.black,
              //       //           fontWeight: FontWeight.w500,
              //       //         ),
              //       //       ),
              //       //     ),
              //       //     // ),
              //       //   ),
              //       //   Align(
              //       //     alignment: Alignment.centerRight,
              //       //     child: Container(
              //       //       padding: EdgeInsets.only(right: 10),
              //       //       child: IconButton(
              //       //         onPressed: () {
              //       //           // Add your logic for the onPressed event here
              //       //           // Typically, this would involve navigating to the next screen or performing some action
              //       //         },
              //       //         //alignment: Alignment.centerRight,
              //       //         icon: Icon(Icons.arrow_forward_ios_sharp),
              //       //         color: Colors.black, // Color of the icon
              //       //         iconSize: 24.0, // Size of the icon
              //       //       ),
              //       //     ),
              //       //   ),
              //       // ]),
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
              //               size: 25.0, // Size of the icon
              //             ),
              //           ),
              //         ),
              //       ),
              //       Row(children: [
              //         Expanded(
              //           child: Padding(
              //             padding: const EdgeInsets.only(right: 165.0),
              //             child: Text(
              //               'Location',
              //               textAlign: TextAlign.center,
              //               style: GoogleFonts.robotoCondensed(
              //                 fontSize: 20.0,
              //                 color: Colors.black,
              //                 fontWeight: FontWeight.w500,
              //               ),
              //             ),
              //           ),
              //         ),
              //         Align(
              //           alignment: Alignment.centerRight,
              //           child: IconButton(
              //             onPressed: () {
              //               Navigator.of(context).push(
              //                 MaterialPageRoute(
              //                   builder: (context) => LocationSearchPage(),
              //                 ),
              //               );
              //               // Add your logic for the onPressed event here
              //               // Typically, this would involve navigating to the next screen or performing some action
              //             },
              //             //alignment: Alignment.centerRight,
              //             icon: Icon(Icons.arrow_forward_ios_sharp),
              //             color: Colors.black, // Color of the icon
              //             iconSize: 24.0, // Size of the icon
              //           ),
              //         ),
              //       ]),
              //     ],
              //   ),
              // ),

              Container(
                padding: EdgeInsets.all(10),
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
                              color: !isLocationStored
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
                              color: isLocationStored
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

              Divider(
                height: 2,
                color: Colors.white10,
              ),
            ],
          ),
        )
      ],
    );
  }
}
