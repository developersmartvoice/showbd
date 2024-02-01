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

// class _selectDate {
//   _selectDate(BuildContext context);
// }

class _SendOffersScreenState extends State<SendOffersScreen> {
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  bool datePickedStart = false;
  bool datePickedEnd = false;
  bool isLoading = false;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? startDate : endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? startDate : endDate)) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
          endDate = picked;
          datePickedStart = true;
        } else {
          endDate = picked;
          datePickedEnd = true;
        }
      });
    }
  }

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
          style: GoogleFonts.robotoCondensed(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          //alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.green,
                  width: 4.0,
                ),
              ),
              child: CircleAvatar(
                radius: 80,
                backgroundImage: AssetImage('assets/jon--snow.jpg'),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Jon Snow',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Winterfell, The North',
              style: TextStyle(
                fontSize: 15,
              ),
            ),

            // Divider(
            //   height: 20,
            //   color: Colors.grey,
            // ),

            SizedBox(
              height: 10,
            ),

            Align(
              alignment: Alignment(-0.9, -0.7),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Looking for a local between',
                  style: TextStyle(fontSize: 16.0),
                ),
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
                    padding: EdgeInsets.fromLTRB(
                        16, 0, 5, 0), // Adjust padding as needed
                    child: Icon(
                      Icons.calendar_today, // Choose your calendar icon
                      color: Colors.blue, // Change color as needed
                    ),
                  ),
                ),
                SizedBox(width: 8),

                // InkWell(
                //   onTap: () => _selectDate(context, true),
                //   child: InputDecorator(
                //     decoration: InputDecoration(
                //         labelText: DATE_FROM.toUpperCase(),
                //         labelStyle: GoogleFonts.poppins(
                //             fontWeight: FontWeight.w500,
                //             color: datePickedStart
                //                 ? Color.fromARGB(255, 255, 84, 5)
                //                 : Colors.lightBlue,
                //             fontSize: 24),
                //         errorText: !datePickedStart ? "Required!" : ""),
                //     child: Text(
                //       '${startDate.day.toString().padLeft(2, '0')} ${_getMonthAbbreviation(startDate.month)} ${startDate.year}',
                //     ),
                //   ),
                // ),

                // SizedBox(height: 10),
                // InkWell(
                //   onTap: () => _selectDate(context, false),
                //   child: InputDecorator(
                //     decoration: InputDecoration(
                //         labelText: DATE_TO.toUpperCase(),
                //         // labelStyle: TextStyle(fontSize: 18)
                //         labelStyle: GoogleFonts.poppins(
                //             fontWeight: FontWeight.w500,
                //             color: datePickedEnd
                //                 ? Color.fromARGB(255, 255, 84, 5)
                //                 : Colors.lightBlue,
                //             fontSize: 24),
                //         errorText: !datePickedEnd ? "Required!" : ""),
                //     child: Text(
                //       '${endDate.day.toString().padLeft(2, '0')} ${_getMonthAbbreviation(endDate.month)} ${endDate.year}',
                //     ),
                //   ),
                // ),

                // GestureDetector(
                //   onTap: () {
                //     _selectDate(context);
                //   },

                // Adjust the width as needed for spacing // Adjust padding as needed
                //           child: Text(
                //             selectedDate == null
                //       ? 'Select a Date'
                //       : '${DateFormat('dd MMM yyyy').format(selectedDate)}',
                //   style: TextStyle(
                //     color: Colors.black,
                //     fontWeight: FontWeight.bold,
                //     fontSize: 18,
                //   ),
                // ),

                Text(
                  '15 DEC 2024 - 20 DEC 2030', // Replace with the actual date or a variable
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold, // Change color as needed
                    fontSize: 18, // Change font size as needed
                  ),
                ),
                //               Future<void> _selectDate(BuildContext context) async {
                //   final DateTime? picked = await showDatePicker(
                //     context: context,
                //     initialDate: selectedDate ?? DateTime.now(),
                //     firstDate: DateTime(2024, 12, 15),
                //     lastDate: DateTime(2030, 12, 20),
                //   );

                //   if (picked != null && picked != selectedDate) {
                //     setState(() {
                //       selectedDate = picked;
                //     });
                //   }
                // }
              ],
            ),

            //       String _getMonthAbbreviation(int month) {
            //         switch (month) {
            //           case 1:
            //             return 'Jan';
            //           case 2:
            //             return 'Feb';
            //           case 3:
            //             return 'Mar';
            //           case 4:
            //             return 'Apr';
            //           case 5:
            //             return 'May';
            //           case 6:
            //             return 'Jun';
            //           case 7:
            //             return 'Jul';
            //           case 8:
            //             return 'Aug';
            //           case 9:
            //             return 'Sep';
            //           case 10:
            //             return 'Oct';
            //           case 11:
            //             return 'Nov';
            //           case 12:
            //             return 'Dec';
            //           default:
            //             return '';
            //         }
            //       }
            //     ],
            //     ),
            // ));
            //     }

            SizedBox(height: 5),
            Flexible(
              child: ElevatedButton(
                onPressed: () {
                  if (datePickedStart && datePickedEnd) {
                    setState(() {
                      isLoading = true;
                    });
                  }
                  ;

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
                  padding: EdgeInsets.fromLTRB(
                      135.0, 13, 135.0, 13), // Customize horizontal padding
                  elevation: 5.0, // Set elevation
                  shadowColor: Colors.grey,
                ),
              ),
            ),
            //

            // Divider(
            //   height: 10,
            //   color: Colors.grey,
            // ),

            SizedBox(height: 5),

            Divider(
              height: 20,
              color: Colors.grey,
            ),
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
                Text(
                  'Starfall, Dorne, The South',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),

            // Divider(
            //   height: 20,
            //   color: Colors.grey,
            // ),

            //Text('Looking for a local between'),

            SizedBox(
              height: 10,
            ),

            Align(
              alignment: Alignment(-0.9, -0.7),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Looking for a local between',
                  style: TextStyle(fontSize: 16.0),
                ),
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
                    padding: EdgeInsets.fromLTRB(
                        16, 0, 0, 0), // Adjust padding as needed
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
                padding: EdgeInsets.fromLTRB(
                    135.0, 13, 135.0, 13), // Customize horizontal padding
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
    //],
    //  ),
    //),
    //);
  }
}

class DateFormat {}

// class _selectDate {
//   _selectDate(BuildContext context);
// }
