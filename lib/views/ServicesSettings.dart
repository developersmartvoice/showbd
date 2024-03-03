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

class ServicesSettingsPage extends StatefulWidget {
  //const NameSettingsPage({super.key});

  @override
  State<ServicesSettingsPage> createState() => _ServicesSettingsPageState();
  late final String id;
  late final String services;
  //late final String aboutMe;
  //late final String city;

  ServicesSettingsPage(this.id, this.services);
}

class _ServicesSettingsPageState extends State<ServicesSettingsPage> {
  bool isChecked = false;
  late TextEditingController _controller;
  String enteredValue = '';
  bool isValueChanged = false;
  void updatingServices() async {
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/updateServices"), body: {
      "id": widget.id,
      "services": enteredValue,
    });
    print("$SERVER_ADDRESS/api/updateServices");
    // print(response.body);
    if (response.statusCode == 200) {
      print("Services Updated");
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print("Services Not Updated");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.services);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // title: Text('Services',
          //     // style: GoogleFonts.robotoCondensed(
          //     //   color: Colors.white,
          //     //   fontSize: 25,
          //     //   fontWeight: FontWeight.w700,
          //     // ),
          //     style: Theme.of(context).textTheme.headline5!.apply(
          //         color: Theme.of(context).backgroundColor,
          //         fontWeightDelta: 5)),
          backgroundColor: const Color.fromARGB(255, 243, 103, 9),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                if (isValueChanged) {
                  updatingServices();
                } else {
                  // Navigator.pop(context);
                }
              },
              child: Text(
                'Save',
                style: GoogleFonts.robotoCondensed(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Icon(
                        Icons.sign_language, // Language icon (as an example)
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        SERVICES_PAGE_1,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight:
                              isChecked ? FontWeight.bold : FontWeight.w200,
                        ),
                      ),
                      Spacer(),
                      isChecked
                          ? Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 20,
                            ) // Check icon
                          : SizedBox(), // Invisible placeholder if not checked
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Icon(
                        Icons.directions_car, // Pickup car icon
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        SERVICES_PAGE_2,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight:
                              isChecked ? FontWeight.bold : FontWeight.w200,
                        ),
                      ),
                      Spacer(),
                      isChecked
                          ? Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 20,
                            ) // Check icon
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Icon(
                        Icons.shopping_bag, // Choose the appropriate icon
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        SERVICES_PAGE_3,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight:
                              isChecked ? FontWeight.bold : FontWeight.w200,
                        ),
                      ),
                      Spacer(),
                      isChecked
                          ? Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 20,
                            ) // Check icon
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Icon(
                        Icons
                            .local_bar, // Nightlife and bars icon (as an example)
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        SERVICES_PAGE_4,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight:
                              isChecked ? FontWeight.bold : FontWeight.w200,
                        ),
                      ),
                      Spacer(),
                      isChecked
                          ? Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 20,
                            ) // Check icon
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Icon(
                        Icons
                            .restaurant, // Food and restaurants icon (as an example)
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        SERVICES_PAGE_5,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight:
                              isChecked ? FontWeight.bold : FontWeight.w200,
                        ),
                      ),
                      Spacer(),
                      isChecked
                          ? Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 20,
                            ) // Check icon
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Icon(
                        Icons.palette, // Arts and museums icon (as an example)
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        SERVICES_PAGE_6,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight:
                              isChecked ? FontWeight.bold : FontWeight.w200,
                        ),
                      ),
                      Spacer(),
                      isChecked
                          ? Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 20,
                            ) // Check icon
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Icon(
                        Icons
                            .sports_tennis, // Sports and recreation icon (as an example)
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        SERVICES_PAGE_7,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight:
                              isChecked ? FontWeight.bold : FontWeight.w200,
                        ),
                      ),
                      Spacer(),
                      isChecked
                          ? Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 20,
                            ) // Check icon
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Icon(
                        Icons.menu_book, // Book-reading icon
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        SERVICES_PAGE_8,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight:
                              isChecked ? FontWeight.bold : FontWeight.w200,
                        ),
                      ),
                      Spacer(),
                      isChecked
                          ? Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 20,
                            ) // Check icon
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
                color: Colors.grey,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Icon(
                        Icons
                            .explore, // Exploration and sightseeing icon (as an example)
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        SERVICES_PAGE_9,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight:
                              isChecked ? FontWeight.bold : FontWeight.w200,
                        ),
                      ),
                      Spacer(),
                      isChecked
                          ? Icon(
                              Icons.check,
                              color: Colors.black,
                              size: 20,
                            ) // Check icon
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 10,
                color: Colors.grey,
              ),
              // Container(
              //   color: Colors.white,
              //   child: TextField(
              //     controller: _controller,
              //     style: TextStyle(
              //       color: Colors.black,
              //       fontSize: 16,
              //       fontWeight: FontWeight.w200,
              //     ),
              //     onChanged: (value) {
              //       setState(
              //         () {
              //           enteredValue = value;
              //           if (enteredValue != widget.services) {
              //             isValueChanged = true;
              //           } else {
              //             isValueChanged = false;
              //           }
              //         },
              //       );
              //     },
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(),
              //       hintText: widget.services,
              //       hintStyle: TextStyle(color: Colors.black),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
