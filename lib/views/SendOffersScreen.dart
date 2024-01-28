import 'dart:convert';
import 'package:appcode3/views/Doctor/DoctorProfile.dart';
import 'package:appcode3/views/SendOfferScreen.dart';
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

class SendOffersScreen extends StatefulWidget {
  const SendOffersScreen({super.key});

  @override
  State<SendOffersScreen> createState() => _SendOffersScreenState();
}

class _SendOffersScreenState extends State<SendOffersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Send offers',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.red,
                  width: 4.0,
                ),
              ),
              child: CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage(
                    'assets/jon--snow.jpg'), // Replace with your avatar image
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                Text(
                  'Jon Snow',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text('Winterfell, The North'),
              ],
            ),

            Divider(
              height: 20,
              color: Colors.grey,
            ),

            Align(
              alignment: Alignment(-0.9, -0.7),
              child: Text(
                'Looking for a local between',
                style: TextStyle(fontSize: 15.0),
              ),
            ),

            // Text(
            //   'Looking for a local between',
            //   style: TextStyle(fontSize: 16.0),
            // ),

            //Text('Looking for a local between'),

            SizedBox(height: 5),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Padding(
            //       padding:
            //           const EdgeInsets.all(8.0), // Adjust the padding as needed
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         children: [
            //           Icon(
            //             Icons.calendar_today,
            //             color: Colors.blue,
            //           ),
            //         ],
            //       ),
            //     ),
            //     //SizedBox(height: 5),
            //     Text('Event Date'),
            //   ],
            // ),

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
                  '15 DEC 2024 - 20 DEC 2030', // Replace with the actual date or a variable
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold, // Change color as needed
                    fontSize: 18, // Change font size as needed
                  ),
                ),
              ],
            ),

            SizedBox(height: 5),
            Flexible(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SendOfferScreen(),
                    ),
                  );
                  // Add functionality for the second button
                },
                child: Text('SEND OFFER'),
                style: ElevatedButton.styleFrom(
                  textStyle: GoogleFonts.poppins(
                    fontSize: 19.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(
                      color: Colors.blue,
                    ), // Set border radius
                  ),
                  padding: EdgeInsets.all(15.0), // Customize horizontal padding
                  elevation: 5.0, // Set elevation
                  shadowColor: Colors.grey,
                ),
              ),
            ),

            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.red,
                  width: 4.0,
                ),
              ),
              child: CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage(
                    'assets/Arthur Dayne.jpg'), // Replace with your avatar image
              ),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                Text(
                  'Arthur Dayne',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text('Starfall, Dorne, The South'),
              ],
            ),

            Divider(
              height: 20,
              color: Colors.grey,
            ),

            //Text('Looking for a local between'),

            Align(
              alignment: Alignment(-0.9, -0.7),
              child: Text(
                'Looking for a local between',
                style: TextStyle(fontSize: 15.0),
              ),
            ),

            // Divider(
            //   height: 15,
            //   color: Colors.grey,
            // ),

            // SizedBox(height: 20),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Padding(
            //       padding:
            //           const EdgeInsets.all(8.0), // Adjust the padding as needed
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.start,
            //         children: [
            //           Icon(
            //             Icons.calendar_today,
            //             color: Colors.blue,
            //           ),
            //         ],
            //       ),
            //     ),
            //     SizedBox(height: 5),
            //     Text('Event Date'),
            //   ],
            // ),

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
                  '10 JAN 2025 - 10 JAN 2030', // Replace with the actual date or a variable
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold, // Change color as needed
                    fontSize: 18, // Change font size as needed
                  ),
                ),
              ],
            ),
            // Column(
            //   children: [
            //     Icon(
            //       Icons.calendar_today,
            //       color: Colors.blue,
            //     ),
            //     SizedBox(height: 5),
            //     Text('Event Date'),
            //   ],
            // ),

            // SizedBox(height: 20),
            // Column(
            //   children: [
            //     Icon(Icons.calendar_today),
            //     SizedBox(height: 5),
            //     Text('Event Date'),
            //   ],
            // ),
            SizedBox(height: 5),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SendOfferScreen(),
                  ),
                );
                // Add functionality for the first button
              },
              child: Text('SEND OFFER'),
              style: ElevatedButton.styleFrom(
                textStyle: GoogleFonts.poppins(
                  fontSize: 19.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(
                    color: Colors.blue,
                  ), // Set border radius
                ),
                padding: EdgeInsets.all(15.0), // Customize horizontal padding
                elevation: 5.0, // Set elevation
                shadowColor: Colors.grey,
              ),
            ),
            // SizedBox(height: 10),
            // ElevatedButton(
            //   onPressed: () {
            //     // Add functionality for the second button
            //   },
            //   child: Text('Button 2'),
            // ),
          ],
        ),
      ),
    );
  }
}
