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

class PhoneNumberPage extends StatefulWidget {
  // const PhoneNumberPage(String phone, {super.key});

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();

  late final String id;
  late final String phone;
  //late final String aboutMe;
  //late final String city;

  PhoneNumberPage(this.id, this.phone);
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  late TextEditingController _controller;
  String enteredValue = '';
  bool isValueChanged = false;
  void updatingPhone() async {
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/updatePhoneNo"), body: {
      "id": widget.id,
      "phoneno": enteredValue,
    });
    print("$SERVER_ADDRESS/api/updatePhoneNo");
    // print(response.body);
    if (response.statusCode == 200) {
      print("Phone No. Updated");
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print("Phone No. Not Updated");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Phone',
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
              if (isValueChanged) {
                updatingPhone();
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
      body: Column(
        children: [
          Container(
            height: 70,
            color: Colors.white,
            child: Stack(children: [
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
                // color: LIGHT_GREY_SCREEN_BACKGROUND,
                // height: 180,
                // child: Row(children: [
                //   Expanded(
                //     child: Padding(
                padding: EdgeInsets.all(16),
                alignment: Alignment.topLeft,
                child: Text(
                  "Phone Page",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                // Text(
                //   "Your phone number will be used to send you booking confirmations. It won't be displayed on your profile. Be sure to use a cell number you can easily be reached at!",
                //   textAlign: TextAlign.center,
                //   style: GoogleFonts.robotoCondensed(
                //     fontSize: 15.0,
                //     color: Colors.black,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
              ),

              // Align(
              //   alignment: Alignment.centerRight,
              //   child: IconButton(
              //     onPressed: () {
              //       // Add your logic for the onPressed event here
              //       // Typically, this would involve navigating to the next screen or performing some action
              //     },
              //     //alignment: Alignment.centerRight,
              //     icon: Icon(Icons.arrow_forward_ios_sharp),
              //     color: Colors.black, // Color of the icon
              //     iconSize: 24.0, // Size of the icon
              //   ),
              // ),
            ]),
          ),
          Divider(
            height: 2,
            color: Colors.grey,
          ),

          Container(
            color: Colors.white,
            child: TextField(
              controller: _controller,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w200,
              ),
              onChanged: (value) {
                setState(() {
                  enteredValue = value;
                  if (enteredValue != widget.phone) {
                    isValueChanged = true;
                  } else {
                    isValueChanged = false;
                  }
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: widget.phone,
                hintStyle: TextStyle(color: Colors.black),
              ),
            ),
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
          //       setState(() {
          //         enteredValue = value;
          //         if (enteredValue != widget.phone) {
          //           isValueChanged = true;
          //         } else {
          //           isValueChanged = false;
          //         }
          //       });
          //     },
          //     decoration: InputDecoration(
          //       border: OutlineInputBorder(),
          //       hintText: widget.phone,
          //       hintStyle: TextStyle(color: Colors.black),
          //     ),
          //   ),
          // ),
          // Container(
          //   child: TextField(
          //     controller: TextEditingController(),
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 16,
          //       fontWeight: FontWeight.w200,
          //     ),
          //     decoration: InputDecoration(
          //         border: OutlineInputBorder(),
          //         //hintText: "More About You",
          //         //hintText: widget.,
          //         hintStyle: TextStyle(color: Colors.grey)),
          //   ),
          // ),
          // Container(
          //   color: Colors.white,
          //   height: 50,
          //   child: Row(
          //     children: [
          //       Expanded(
          //         //child: Padding(
          //         //padding: const EdgeInsets.only(right: 190.0),
          //         child: TextField(
          //           textAlign: TextAlign.start,
          //           controller: TextEditingController(),
          //           style: TextStyle(
          //             color: Colors.black,
          //             fontSize: 18,
          //             fontWeight: FontWeight.w500,
          //           ), // Use a TextEditingController
          //           decoration: InputDecoration(
          //             hintText: 'Your phone number',
          //             border: OutlineInputBorder(),
          //             hintStyle: TextStyle(
          //                 color: Colors.grey), // Border around the input field
          //           ),
          //         ),
          //       ),
          //       //),
          //     ],
          //   ),
          // ),
          Divider(
            height: 2,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}
