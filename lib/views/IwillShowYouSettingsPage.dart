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

class IwillShowYouSettingsPage extends StatefulWidget {
  //const NameSettingsPage({super.key});

  @override
  State<IwillShowYouSettingsPage> createState() =>
      _IwillShowYouSettingsPageState();
  late final String id;
  late final String iwillshowyou;
  //late final String aboutMe;
  //late final String city;

  IwillShowYouSettingsPage(this.id, this.iwillshowyou);
}

class _IwillShowYouSettingsPageState extends State<IwillShowYouSettingsPage> {
  late TextEditingController _controller;
  String enteredValue = '';
  bool isValueChanged = false;
  void updatingIWillShowYou() async {
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/updateIWillShowYou"), body: {
      "id": widget.id,
      "I_will_show_you": enteredValue,
    });
    print("$SERVER_ADDRESS/api/updateIWillShowYou");
    // print(response.body);
    if (response.statusCode == 200) {
      print("IWillShowYou Updated");
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print("IWillShowYou Not Updated");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.iwillshowyou);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('I will show you',
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
                  updatingIWillShowYou();
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
                  IWILLSHOWYOU_PAGE_1,
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
                        if (enteredValue != widget.iwillshowyou) {
                          isValueChanged = true;
                        } else {
                          isValueChanged = false;
                        }
                      },
                    );
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: widget.iwillshowyou,
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
