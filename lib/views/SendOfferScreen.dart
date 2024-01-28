import 'dart:convert';
import 'package:appcode3/views/Doctor/DoctorProfile.dart';
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

class SendOfferScreen extends StatefulWidget {
  const SendOfferScreen({super.key});

  @override
  State<SendOfferScreen> createState() => _SendOfferScreenState();
}

class _SendOfferScreenState extends State<SendOfferScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Send offer',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Column(
            children: [
              // Thumbnail
              Container(
                height: 10,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/splash_bg.png'), // Replace with your image asset
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Round image, name, and address
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/images.jpg'), // Replace with your image asset
                ),
                title: Text(
                  'Jon Snow',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Winterfell, The North',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ),

              Align(
                alignment: Alignment(-0.5, -0.7),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DoctorProfile(),
                      ),
                    );
                  },
                  // Add button functionality here
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10.0), // Set border radius to 0 for a rectangle
                      ),
                    ),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.all(5.0), // Adjust padding as needed
                    ),
                  ),
                  child: Text('View Profile'),
                ),
              ),

              Divider(
                height: 10,
                color: Colors.grey,
              ),

              SizedBox(
                height: 5,
              ),

              Row(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0), // Adjust padding as needed
                      child: Icon(
                        Icons.calendar_today, // Choose your calendar icon
                        color: Colors.blue, // Change color as needed
                      ),
                    ),
                  ),
                  SizedBox(
                      width:
                          8), // Adjust the width as needed for spacing // Adjust padding as needed
                  Text(
                    'Your Date Here', // Replace with the actual date or a variable
                    style: TextStyle(
                      color: Colors.black, // Change color as needed
                      fontSize: 16, // Change font size as needed
                    ),
                  ),
                ],
              ),

              Divider(
                height: 20,
                color: Colors.grey,
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Number of People :',
                    style: TextStyle(
                      fontSize: 18,
                      // Add any additional styling here
                    ),
                  ),
                ),
              ),

              Divider(
                height: 20,
                color: Colors.grey,
              ),

              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Icon(
              //     Icons.calendar_today, // Choose your calendar icon
              //     color: Colors.blue, // Change color as needed
              //   ),
              // ),

              // SizedBox(
              //   height: 100,
              // ),
              // Container with title, data view, and button
              //Container(
              //padding: EdgeInsets.all(6.0),
              //child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              //children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'TOUR DURATION',
                  style: TextStyle(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                    // Add any additional styling here
                  ),
                ),
              ),
              SizedBox(height: 10),

              Divider(
                height: 15,
                color: Colors.grey,
              ),

              // Replace with your data view

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'Forever',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      // Add any additional styling here
                    ),
                  ),
                ),
              ),

              Divider(
                height: 10,
                color: Colors.grey,
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'PREFERRED MEETING TIME',
                  style: TextStyle(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                    // Add any additional styling here
                  ),
                ),
              ),

              Divider(
                height: 30,
                color: Colors.grey,
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    'Anytime',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      // Add any additional styling here
                    ),
                  ),
                ),
              ),

              Divider(
                height: 10,
                color: Colors.grey,
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'AVAILABLE DATE FOR THE TOUR',
                  style: TextStyle(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                    // Add any additional styling here
                  ),
                ),
              ),

              Divider(
                height: 30,
                color: Colors.grey,
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    '12 DEC 2024',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      // Add any additional styling here
                    ),
                  ),
                ),
              ),

              Divider(
                height: 10,
                color: Colors.grey,
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'TEXT THE GUIDE',
                  style: TextStyle(
                    fontSize: 18,
                    //fontWeight: FontWeight.bold,
                    // Add any additional styling here
                  ),
                ),
              ),

              Divider(
                height: 30,
                color: Colors.grey,
              ),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'You know nothing, Jon Snow',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    // Add any additional styling here
                  ),
                ),
              ),

              SizedBox(height: 20),
              // Replace with your button
              //ElevatedButton(
              //onPressed: () {
              // Add button functionality here
              //},
              //child: Text('View Profile'),
              //),
            ],
          ),
        ),
      ),
    );
  }
}
