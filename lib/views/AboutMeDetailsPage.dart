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

class AboutMeDetailsPage extends StatefulWidget {
  const AboutMeDetailsPage({super.key});

  @override
  State<AboutMeDetailsPage> createState() => _AboutMeDetailsPageState();
}

class _AboutMeDetailsPageState extends State<AboutMeDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About me',
          style: GoogleFonts.robotoCondensed(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 243, 103, 9),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // Handle button tap
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
      body: Column(
        children: [
          Container(
            height: 70,
            color: Colors.white,
            child: Stack(
              children: [
                Positioned(
                  left: 10, // Adjust the position of the button as needed
                  top: 20, // Adjust the position of the button as needed
                  child: InkWell(
                      //onTap: _changeColor,
                      // Add your logic for the selection button onTap event here

                      // child: Container(
                      //   width: 30,
                      //   height: 30,
                      //   decoration: BoxDecoration(
                      //     //color: _boxColor, // Color of the button
                      //     color: Colors.green,
                      //     shape: BoxShape.circle,
                      //     border: Border.all(
                      //       color: Colors.black, // Color of the border
                      //       width: 1.0, // Width of the border
                      //     ), // Circular shape
                      //   ),
                      //   child: Icon(
                      //     Icons.check,
                      //     //color: _isSelected ? Colors.green : Colors.white,
                      //     color: Colors.white, // Color of the icon
                      //     size: 25.0, // Size of the icon
                      //   ),
                      // ),
                      ),
                ),
                Container(
                  color: LIGHT_GREY_SCREEN_BACKGROUND,
                  height: 200,
                  child: Container(
                    height: 200,
                    child: Row(
                      children: [
                        Expanded(
                          //child: Padding(
                          //padding: const EdgeInsets.only(left: 15),
                          child: Container(
                            height: 200,
                            child: Column(
                              children: [
                                Text(
                                  "Feel free to share your hobbies, interests, or anything else you'd like!",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  "Note: All languages preferable, but kindly fill out in English now",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 5,
            color: Colors.grey,
          ),
          Container(
            color: Colors.white,
            height: 50,
            child: Row(
              children: [
                Expanded(
                  //child:
                  //Padding(
                  //padding: const EdgeInsets.only(right: 190.0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: TextEditingController(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ), // Use a TextEditingController
                    decoration: InputDecoration(
                      hintText: 'More about you',
                      border: OutlineInputBorder(),
                      hintStyle: TextStyle(
                          color: Colors.grey), // Border around the input field
                    ),
                  ),
                ),
                //),
              ],
            ),
          ),
          Divider(
            height: 2,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}