import 'dart:convert';
import 'package:appcode3/modals/SendOfferClass.dart';
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
  // const SendOfferScreen({super.key});

  final NotifiedGuides notifyGuide;

  SendOfferScreen({required this.notifyGuide});
  @override
  State<SendOfferScreen> createState() => _SendOfferScreenState();
}

class _SendOfferScreenState extends State<SendOfferScreen> {
  //DateTime startDate = DateTime.now();
  //DateTime endDate = DateTime.now();
  DateTime selectedDate = DateTime.now(); // Initialize with current date

  //bool datePickedStart = false;
  //bool datePickedEnd = false;
  String? name;
  String? image;
  String? destination;
  String? start_date;
  String? end_date;
  int? people_quantity;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      print(widget.notifyGuide.name);
      name = widget.notifyGuide.name;
      image = widget.notifyGuide.imageURL;
      destination = widget.notifyGuide.destination;
      start_date = widget.notifyGuide.start_date;
      end_date = widget.notifyGuide.end_date;
      people_quantity = widget.notifyGuide.people_quantity;
    });
  }

  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  // Future<void> _selectDate(BuildContext context, bool isStartDate) async {
  //   DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: isStartDate ? startDate : endDate,
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null && picked != (isStartDate ? startDate : endDate)) {
  //     setState(() {
  //       if (isStartDate) {
  //         startDate = picked;
  //         endDate = picked;
  //         datePickedStart = true;
  //       } else {
  //         endDate = picked;
  //         datePickedEnd = true;
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // var numberOfPeople;
    // String dynamicText1 = 'Forever';
    // String dynamicText2 = 'Anytime';
    // String dynamicText3 = 'I am Groot';
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 255, 94, 0).withOpacity(0.8),
          title: Text(
            'Send offer',
            style: Theme.of(context).textTheme.headline5!.apply(
                color: Theme.of(context).backgroundColor, fontWeightDelta: 5),
          ),

          // ElevatedButton(
          //   onPressed: () {

          //               // Add your button functionality here
          //   },
          //   child: Text('Button'),
          // ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.of(context).push(
                //           MaterialPageRoute(
                //             builder: (context) => DoctorChatListScreen(),
                //           ),
                //         );
                // Add your button functionality here
              },
              child: Text(
                'Apply', // Text for the button
                style: GoogleFonts.robotoCondensed(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 165, 210, 247), // Text color
                ),
              ),
            ),
          ],
        ),
        body:
            //padding: const EdgeInsets.all(16.0),
            Container(
          color: Colors.white,
          child: Card(
            child: Column(
              children: [
                // Thumbnail
                // Container(
                //   height: 10,
                //   decoration: BoxDecoration(
                //     image: DecorationImage(
                //       image: AssetImage(
                //           'assets/splash_bg.png'), // Replace with your image asset
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                // ),
                // Round image, name, and address
                Container(
                  //padding: EdgeInsets.only(left: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                        radius: 35,
                        backgroundImage: CachedNetworkImageProvider(
                            image!) // Replace with your image asset
                        ),
                    title: Text(
                      name!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      destination!,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
                  child: Align(
                    alignment: Alignment(-0.5, -0.7),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(35, 0, 10, 0),
                      child: TextButton(
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
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            EdgeInsets.fromLTRB(
                                5, 0, 20, 0), // Adjust padding as needed
                          ),
                        ),
                        child: Text(
                          'View Profile',
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Divider(
                  height: 2,
                  color: Colors.grey,
                ),

                // SizedBox(
                //   height: 5,
                // ),

                Container(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding:
                              EdgeInsets.all(8.0), // Adjust padding as needed
                          child: Icon(
                            Icons.calendar_today, // Choose your calendar icon
                            color: Colors.blue, // Change color as needed
                          ),
                        ),
                      ),

                      SizedBox(width: 0),

                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,

                          // TextButton(
                          //   onPressed: () async {
                          //     final DateTime? pickedDate = await showDatePicker(
                          //       context: context,
                          //       initialDate: selectedDate,
                          //       firstDate: DateTime.now(),
                          //       lastDate: DateTime(2101),
                          //     );

                          //     if (pickedDate != null &&
                          //         pickedDate != selectedDate) {
                          //       setState(() {
                          //         selectedDate = pickedDate;
                          //       });
                          //     }
                          //   },
                          //   child: Text(
                          //     '${selectedDate.day.toString().padLeft(2, '0')} ${_getMonthAbbreviation(selectedDate.month)} ${selectedDate.year}', // Display selected date
                          //     style: TextStyle(
                          //       color: Colors.black, // Change color as needed
                          //       fontSize: 16,
                          //       fontWeight:
                          //           FontWeight.bold, // Change font size as needed
                          //     ),
                          //   ),

                          // onPressed: () => _selectDate(
                          //     context, true), // Function to open date picker
                          child: Text(
                            '$start_date - $end_date', // Replace with the actual date or a variable
                            style: TextStyle(
                              color: Colors.black, // Change color as needed
                              fontSize: 16, // Change font size as needed
                            ),
                          ),
                          //),
                        ),
                      ),

                      // Container(
                      //   child: InkWell(
                      //     onTap: () => _selectDate(context, true),
                      //     child: InputDecorator(
                      //       decoration: InputDecoration(
                      //           labelText: DATE_FROM.toUpperCase(),
                      //           labelStyle: GoogleFonts.poppins(
                      //               fontWeight: FontWeight.w500,
                      //               color: datePickedStart
                      //                   ? Color.fromARGB(255, 255, 84, 5)
                      //                   : Colors.grey,
                      //               fontSize: 24),
                      //           //),
                      //           errorText: !datePickedStart
                      //               ? "Field cannot be empty!"
                      //               : ""),
                      //       child: Text(
                      //         '${startDate.day.toString().padLeft(2, '0')} ${_getMonthAbbreviation(startDate.month)} ${startDate.year}',
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // Adjust the width as needed for spacing // Adjust padding as needed
                      // Text(
                      //   'Your Date Here', // Replace with the actual date or a variable
                      //   style: TextStyle(
                      //     color: Colors.black, // Change color as needed
                      //     fontSize: 16, // Change font size as needed
                      //   ),
                      // ),
                    ],
                  ),
                ),

                Divider(
                  height: 2,
                  color: Colors.grey,
                ),

                Container(
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Number of People : $people_quantity',
                        style: TextStyle(
                          fontSize: 18,
                          // Add any additional styling here
                        ),
                      ),
                    ),
                  ),
                ),

                Divider(
                  height: 2,
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
                Container(
                  padding: EdgeInsets.all(15),
                  child: Align(
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
                ),
                //SizedBox(height: 10),

                Divider(
                  height: 2,
                  color: Colors.grey,
                ),

                // Replace with your data view

                Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    //child: Padding(
                    //padding: EdgeInsets.all(5.0),
                    child: TextField(
                      controller: TextEditingController(text: " "),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        // Add any additional styling here
                      ),
                    ),
                    // Text(
                    //   dynamicText1,
                    //   //'Forever',
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.bold,
                    //     // Add any additional styling here
                    //   ),
                    // ),
                  ),
                ),
                //),

                Divider(
                  height: 2,
                  color: Colors.grey,
                ),

                Container(
                  padding: EdgeInsets.all(15),
                  child: Align(
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
                ),

                Divider(
                  height: 2,
                  color: Colors.grey,
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    //child: Padding(
                    //padding: EdgeInsets.all(5.0),

                    child: TextField(
                      controller: TextEditingController(text: " "),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        // Add any additional styling here
                      ),
                    ),
                    // child: Text(
                    //   dynamicText2,
                    //   //'Anytime',
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.bold,
                    //     // Add any additional styling here
                    //   ),
                    // ),
                  ),
                ),
                //),

                Divider(
                  height: 2,
                  color: Colors.grey,
                ),

                Container(
                  padding: EdgeInsets.all(15),
                  child: Align(
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
                ),

                Divider(
                  height: 2,
                  color: Colors.grey,
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  //padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: TextButton(
                        onPressed: () async {
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );

                          if (pickedDate != null &&
                              pickedDate != selectedDate) {
                            setState(() {
                              selectedDate = pickedDate;
                            });
                          }
                        },
                        child: Text(
                          '${selectedDate.day.toString().padLeft(2, '0')} ${_getMonthAbbreviation(selectedDate.month)} ${selectedDate.year}', // Display selected date
                          style: TextStyle(
                            color: Colors.black, // Change color as needed
                            fontSize: 16,
                            fontWeight:
                                FontWeight.bold, // Change font size as needed
                          ),
                        ),

                        // onPressed: () => _selectDate(
                        //     context, true), // Function to open date picker
                        // child: Text(
                        //   'Your Date Here', // Replace with the actual date or a variable
                        //   style: TextStyle(
                        //     color: Colors.black, // Change color as needed
                        //     fontSize: 16, // Change font size as needed
                        //   ),
                        // ),
                      ),
                      // Text(
                      //   '12 DEC 2024',
                      //   style: TextStyle(
                      //     fontSize: 18,
                      //     fontWeight: FontWeight.bold,
                      //     // Add any additional styling here
                      //   ),
                      // ),
                    ),
                  ),
                ),

                Divider(
                  height: 2,
                  color: Colors.grey,
                ),

                Container(
                  padding: EdgeInsets.all(15),
                  child: Align(
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
                ),

                Divider(
                  height: 2,
                  color: Colors.grey,
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                  color: Colors.white,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: TextEditingController(text: " "),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        // Add any additional styling here
                      ),
                    ),
                    // child: Padding(
                    //   padding: EdgeInsets.all(5),
                    //   child: Text(
                    //     dynamicText3,
                    //     //'You know nothing, Jon Snow',
                    //     style: TextStyle(
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.bold,
                    //       // Add any additional styling here
                    //     ),
                    //   ),
                    // ),
                  ),
                ),

                Divider(
                  height: 2,
                  color: Colors.grey,
                ),

                //SizedBox(height: 10),
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
      ),
    );
  }
}
