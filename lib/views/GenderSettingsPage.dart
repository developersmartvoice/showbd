import 'package:dropdown_search/dropdown_search.dart';
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

class GenderSettingsPage extends StatefulWidget {
  //const NameSettingsPage({super.key});

  @override
  State<GenderSettingsPage> createState() => _GenderSettingsPageState();
  late final String id;
  late final String gender;
  //late final String aboutMe;
  //late final String city;

  GenderSettingsPage(this.id, this.gender);
}

class _GenderSettingsPageState extends State<GenderSettingsPage> {
  String selectedGender = "";
  late TextEditingController _controller;
  // String enteredValue = '';
  bool isGenderSelected = false;
  bool isValueChanged = false;
  void updatingGender() async {
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/updateGender"), body: {
      "id": widget.id,
      "gender": selectedGender,
    });
    print("$SERVER_ADDRESS/api/updateGender");
    print(response.body);
    if (response.statusCode == 200) {
      print("Gender Updated");
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print("Gender Not Updated");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.gender);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Gender',
              // style: GoogleFonts.robotoCondensed(
              //   color: Colors.white,
              //   fontSize: 25,
              //   fontWeight: FontWeight.w700,
              // ),
              style: Theme.of(context).textTheme.headline5!.apply(
                  color: Theme.of(context).backgroundColor,
                  fontWeightDelta: 5)),
          backgroundColor: const Color.fromARGB(255, 243, 103, 9),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                if (isGenderSelected) {
                  updatingGender();
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
          color: LIGHT_GREY_SCREEN_BACKGROUND,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.topLeft,
                child: Text(
                  GENDER_PAGE,
                  textAlign: TextAlign.justify, // Align text to center
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: DropdownSearch<String>(
                  items: [
                    'Male',
                    'Female',
                    'Other',
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!.toLowerCase();
                      if (selectedGender.isNotEmpty) {
                        isGenderSelected = true;
                        // if (selectedGender == 'Male') {}
                      } else {
                        isGenderSelected = false;
                      }
                    });
                  },
                  selectedItem:
                      isGenderSelected ? selectedGender : widget.gender,
                ),
                // TextField(
                //   controller: _controller,
                //   style: TextStyle(
                //     color: Colors.black,
                //     fontSize: 16,
                //     fontWeight: FontWeight.w200,
                //   ),
                //   onChanged: (value) {
                //     setState(
                //       () {
                //         enteredValue = value;
                //         if (enteredValue != widget.gender) {
                //           isValueChanged = true;
                //         } else {
                //           isValueChanged = false;
                //         }
                //       },
                //     );
                //   },
                //   decoration: InputDecoration(
                //     border: OutlineInputBorder(),
                //     hintText: widget.gender,
                //     hintStyle: TextStyle(color: Colors.black),
                //   ),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
