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

class MottoSettingsPage extends StatefulWidget {
  //const NameSettingsPage({super.key});

  @override
  State<MottoSettingsPage> createState() => _MottoSettingsPageState();
  late final String id;
  late final String motto;
  //late final String aboutMe;
  //late final String city;

  MottoSettingsPage(this.id, this.motto);
}

class _MottoSettingsPageState extends State<MottoSettingsPage> {
  late TextEditingController _controller;
  String enteredValue = '';
  bool isValueChanged = false;
  void updatingMotto() async {
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/updateMotto"), body: {
      "id": widget.id,
      "motto": enteredValue,
    });
    print("$SERVER_ADDRESS/api/updateMotto");
    // print(response.body);
    if (response.statusCode == 200) {
      print("Motto Updated");
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print("Motto Not Updated");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.motto);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Motto',
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
                if (isValueChanged) {
                  updatingMotto();
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
                child: Column(
                  children: [
                    Text(
                      MOTTO_PAGE_1,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      MOTTO_PAGE_2,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
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
                    setState(
                      () {
                        enteredValue = value;
                        if (enteredValue != widget.motto) {
                          isValueChanged = true;
                        } else {
                          isValueChanged = false;
                        }
                      },
                    );
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: widget.motto,
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}