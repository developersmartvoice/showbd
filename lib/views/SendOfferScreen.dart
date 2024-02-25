import 'dart:convert';
import 'package:appcode3/modals/SendOfferClass.dart';
import 'package:appcode3/views/DetailsPage.dart';
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
import 'package:dropdown_search/dropdown_search.dart';
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
  DateTime? selectedDate; // Initialize with current date

  String selectedDuration = "";
  String selectedMeetingTime = "";

  String specificInterest = "";

  //bool datePickedStart = false;
  //bool datePickedEnd = false;
  bool isDurationSelected = false;
  bool isMeetingTimeSelected = false;
  bool isDateSelected = false;
  bool isMessageGiven = false;
  bool isErrorLoading = false;

  String? senderId;
  String? tripId;
  String? guideId;
  String? name;
  String? image;
  String? destination;
  String? start_date;
  String? end_date;
  int? people_quantity;
  int? selectedDurationValue;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((ref) {
      setState(() {
        senderId = ref.getString('userId');
        print("Sender Id is: $senderId");
      });
    });
    setState(() {
      print(widget.notifyGuide.name);
      tripId = widget.notifyGuide.id.toString();
      print("Trip Id is: $tripId");
      guideId = widget.notifyGuide.guide_id.toString();
      print("Recipent Id is: $guideId");
      name = widget.notifyGuide.name;
      image = widget.notifyGuide.imageURL;
      destination = widget.notifyGuide.destination;
      start_date = widget.notifyGuide.start_date;
      end_date = widget.notifyGuide.end_date;
      people_quantity = widget.notifyGuide.people_quantity;
    });
  }

  void postingSendOffer() async {
    Map<String, dynamic> postData = {
      'trip_id': int.parse(tripId!),
      'sender_id': int.parse(senderId!),
      'recipient_id': int.parse(guideId!),
      'date': selectedDate.toString().split(' ')[0],
      'duration': selectedDurationValue,
      'message': specificInterest,
    };

    var response = await post(Uri.parse("$SERVER_ADDRESS/api/updateSendOffer"),
        body: postData);

    if (response.statusCode == 201) {
      // Success
      final responseData = jsonDecode(response.body);
      setState(() {
        isErrorLoading = false;
        print(responseData);
      });
    } else {
      // Failure
      setState(() {
        isErrorLoading = false;
        print(
            'Failed to create send offer. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      });
    }
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

  String textFieldValue = '';

  double containerHeight = 50.0;

  String? _selectedOption;

// Function to show the modal bottom sheet with options
  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: [
            ListTile(
              title: Text('1H'),
              onTap: () {
                setState(() {
                  _selectedOption = '1H';
                  Navigator.pop(
                      context); // Close the bottom sheet after selection
                });
              },
            ),
            ListTile(
              title: Text('2H'),
              onTap: () {
                setState(() {
                  _selectedOption = '2H';
                  Navigator.pop(
                      context); // Close the bottom sheet after selection
                });
              },
            ),

            ListTile(
              title: Text('3H'),
              onTap: () {
                setState(() {
                  _selectedOption = '3H';
                  Navigator.pop(
                      context); // Close the bottom sheet after selection
                });
              },
            ),
            // Add more options as needed
          ],
        );
      },
    );
  }

  String? _selectedOption2;

// Function to show the modal bottom sheet with options
  void _showOptions2(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: [
            ListTile(
              title: Text('Flexible'),
              onTap: () {
                setState(() {
                  _selectedOption2 = 'Flexible';
                  Navigator.pop(
                      context); // Close the bottom sheet after selection
                });
              },
            ),
            ListTile(
              title: Text('Earlier'),
              onTap: () {
                setState(() {
                  _selectedOption2 = 'Earlier';
                  Navigator.pop(
                      context); // Close the bottom sheet after selection
                });
              },
            ),

            ListTile(
              title: Text('Morning'),
              onTap: () {
                setState(() {
                  _selectedOption2 = 'Morning';
                  Navigator.pop(
                      context); // Close the bottom sheet after selection
                });
              },
            ),

            ListTile(
              title: Text('Noon'),
              onTap: () {
                setState(() {
                  _selectedOption2 = 'Noon';
                  Navigator.pop(
                      context); // Close the bottom sheet after selection
                });
              },
            ),

            ListTile(
              title: Text('Afternoon'),
              onTap: () {
                setState(() {
                  _selectedOption2 = 'Afternoon';
                  Navigator.pop(
                      context); // Close the bottom sheet after selection
                });
              },
            )
            // Add more options as needed
          ],
        );
      },
    );
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
    String hintText = 'Hello $name, ';
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
                if (isDateSelected &&
                    isDurationSelected &&
                    isMeetingTimeSelected) {}
                setState(() {
                  print(
                      "Is duration selected $isDurationSelected and what duration? $selectedDurationValue");
                  print(
                      "Is preffered time selected $isMeetingTimeSelected and what is value? $selectedMeetingTime");
                  print(
                      "Is data is selected $isDateSelected and whats the date? $selectedDate");
                  print(
                      "Is message given $isMessageGiven and whats the message? $specificInterest");
                });
              },
              child: Text(
                'Apply', // Text for the button
                style: GoogleFonts.robotoCondensed(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Text color
                ),
              ),
            ),
          ],
        ),
        body:
            //padding: const EdgeInsets.all(16.0),
            SingleChildScrollView(
          child: Container(
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

                  // Divider(
                  //   height: 2,
                  //   color: Colors.grey,
                  // ),

                  //               GestureDetector(
                  // onTap: () {
                  //   _showOptions(context);
                  // },

                  //child:

                  // Replace with your data view

                  // Container(
                  //   //padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                  //   color: Colors.white,
                  //   child: Align(
                  //     alignment: Alignment.centerLeft,
                  //     //child: Padding(
                  //     //padding: EdgeInsets.all(5.0),
                  //     //         child: Text(
                  //     // _selectedOption ?? 'Select an option',
                  //     //           style: TextStyle(
                  //     //             fontSize: 18,
                  //     //             fontWeight: FontWeight.bold,
                  //     //             // Add any additional styling here
                  //     //           ),
                  //     //         ),

                  //     child: DropdownSearch<String>(
                  //       items: ['1h', '2h', '3h'],
                  //       onChanged: (value) {
                  //         setState(() {
                  //           selectedDuration = value!;
                  //         });
                  //       },
                  //       selectedItem: selectedDuration,
                  //       dropdownBuilder: (context, item) {
                  //         final number = int.tryParse(
                  //                 item!.replaceAll(RegExp(r'[^\d]'), '')) ??
                  //             'Choose an option';
                  //         final text = item.replaceAll(RegExp(r'[\d]'), '');
                  //         return Row(
                  //           children: [
                  //             Text(
                  //               number.toString(),
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.bold,
                  //               ),
                  //             ),
                  //             //SizedBox(width: 4), // Add spacing between the number and text
                  //             Text(
                  //               text,
                  //               style: TextStyle(
                  //                 fontWeight: FontWeight.bold,
                  //               ),
                  //             ),
                  //           ],
                  //         );
                  //       },
                  //     ),
                  //     // Text(
                  //     //   dynamicText1,
                  //     //   //'Forever',
                  //     //   style: TextStyle(
                  //     //     fontSize: 18,
                  //     //     fontWeight: FontWeight.bold,
                  //     //     // Add any additional styling here
                  //     //   ),
                  //     // ),
                  //   ),
                  // ),

                  // Divider(
                  //   height: 2,
                  //   color: Colors.grey,
                  // ),

                  Container(
                    //padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownSearch<String>(
                        items: ['1h', '2h', '3h'],
                        onChanged: (value) {
                          setState(() {
                            // Extract the integer part from the selected value
                            final number = int.tryParse(
                                    value!.replaceAll(RegExp(r'[^\d]'), '')) ??
                                0;
                            if (number > 0) {
                              isDurationSelected = true;
                            } else {
                              isDurationSelected = false;
                            }
                            // Update the global variable with the parsed integer value
                            selectedDurationValue = number;
                            print(selectedDurationValue);
                            // Update the selected duration string
                            selectedDuration = value;
                          });
                        },
                        selectedItem: selectedDuration,
                        // dropdownBuilder: (context, item) {
                        //   final number = int.tryParse(
                        //           item!.replaceAll(RegExp(r'[^\d]'), '')) ??
                        //       0;
                        //   final text = item.replaceAll(RegExp(r'[\d]'), '');
                        //   return Row(
                        //     children: [
                        //       Text(
                        //         number.toString(),
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //       //SizedBox(width: 4), // Add spacing between the number and text
                        //       Text(
                        //         text,
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //     ],
                        //   );
                        // },
                      ),
                    ),
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

                  // Divider(
                  //   height: 2,
                  //   color: Colors.grey,
                  // ),

                  //               GestureDetector(
                  // onTap: () {
                  //   _showOptions2(context);
                  // },

                  //child:
                  Container(
                    //padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownSearch<String>(
                        items: [
                          'Flexible',
                          'Earlier',
                          'Morning',
                          'Noon',
                          'Afternoon'
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedMeetingTime = value!;
                            if (selectedMeetingTime.isNotEmpty) {
                              isMeetingTimeSelected = true;
                            } else {
                              isMeetingTimeSelected = false;
                            }
                          });
                        },
                        selectedItem: selectedMeetingTime,
                      ),
                      //child: Padding(
                      //padding: EdgeInsets.all(5.0),

                      //         child: Text(
                      // _selectedOption2 ?? 'Select an option',
                      //           style: TextStyle(
                      //             fontSize: 18,
                      //             fontWeight: FontWeight.bold,
                      //             // Add any additional styling here
                      //           ),
                      //         ),
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

                  // Divider(
                  //   height: 2,
                  //   color: Colors.grey,
                  // ),

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

                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  //   //padding: EdgeInsets.all(10),
                  //   color: Colors.white,
                  //   child: Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Padding(
                  //       padding: EdgeInsets.all(5.0),
                  //       child: TextButton(
                  //         onPressed: () async {
                  //           final DateTime? pickedDate = await showDatePicker(
                  //             context: context,
                  //             initialDate: selectedDate,
                  //             firstDate: DateTime.now(),
                  //             lastDate: DateTime(2101),
                  //           );

                  //           if (pickedDate != null &&
                  //               pickedDate != selectedDate) {
                  //             setState(() {
                  //               selectedDate = pickedDate;
                  //             });
                  //           }
                  //         },
                  //         child: Text(
                  //           '${selectedDate.day.toString().padLeft(2, '0')} ${_getMonthAbbreviation(selectedDate.month)} ${selectedDate.year}', // Display selected date
                  //           style: TextStyle(
                  //             color: Colors.black, // Change color as needed
                  //             fontSize: 16,
                  //             fontWeight:
                  //                 FontWeight.bold, // Change font size as needed
                  //           ),
                  //         ),

                  //         // onPressed: () => _selectDate(
                  //         //     context, true), // Function to open date picker
                  //         // child: Text(
                  //         //   'Your Date Here', // Replace with the actual date or a variable
                  //         //   style: TextStyle(
                  //         //     color: Colors.black, // Change color as needed
                  //         //     fontSize: 16, // Change font size as needed
                  //         //   ),
                  //         // ),
                  //       ),
                  //       // Text(
                  //       //   '12 DEC 2024',
                  //       //   style: TextStyle(
                  //       //     fontSize: 18,
                  //       //     fontWeight: FontWeight.bold,
                  //       //     // Add any additional styling here
                  //       //   ),
                  //       // ),
                  //     ),
                  //   ),
                  // ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    color: Colors.white,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: TextButton(
                          onPressed: () async {
                            // Check if end_date is not null before parsing
                            if (end_date != null) {
                              // Convert end_date string to DateTime object
                              DateTime? endDate = DateTime.tryParse(end_date!);

                              if (endDate != null) {
                                final DateTime? pickedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate ??
                                      DateTime
                                          .now(), // Use selectedDate if not null, otherwise use DateTime.now()
                                  firstDate: DateTime.now(),
                                  lastDate:
                                      endDate, // Use the converted DateTime object
                                );

                                if (pickedDate != null) {
                                  setState(() {
                                    selectedDate = pickedDate;
                                    isDateSelected = true;
                                  });
                                }
                              }
                            }
                          },
                          child: Text(
                            selectedDate != null
                                ? '${selectedDate!.day.toString().padLeft(2, '0')} ${_getMonthAbbreviation(selectedDate!.month)} ${selectedDate!.year}'
                                : 'Select a date', // Display selected date if available, otherwise show default text
                            style: TextStyle(
                              color: selectedDate != null
                                  ? Colors.black
                                  : Colors
                                      .grey, // Change color based on selectedDate presence
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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

                  // Container(
                  //   padding: EdgeInsets.all(15),
                  //   child: Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text(
                  //       'TEXT THE GUIDE',
                  //       style: TextStyle(
                  //         fontSize: 18,
                  //         //fontWeight: FontWeight.bold,
                  //         // Add any additional styling here
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // Divider(
                  //   height: 2,
                  //   color: Colors.grey,
                  // ),

                  // TextField(
                  //         onChanged: (value) {
                  //           setState(() {
                  //             specificInterest = value;
                  //           });
                  //         },
                  //         decoration: InputDecoration(
                  //           prefixText: hintText,
                  //           hintStyle:
                  //               TextStyle(color: Colors.black38, fontSize: 15),
                  //         ),
                  //       ),

                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16),
                        Text(
                          SUGGESTION.toUpperCase(),
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextField(
                          onChanged: (value) {
                            setState(() {
                              specificInterest = value;
                            });
                            setState(() {
                              if (value.isNotEmpty) {
                                specificInterest = hintText + specificInterest;
                                isMessageGiven = true;
                              } else {
                                specificInterest = "";
                                isMessageGiven = false;
                              }
                            });
                          },
                          decoration: InputDecoration(
                            prefixText: hintText,
                            hintStyle:
                                TextStyle(color: Colors.black38, fontSize: 15),
                          ),
                        ),
                      ],
                    ),

                    //               GestureDetector(
                    // onTap: () {

                    //   // Implement action here, e.g., show options or a modal bottom sheet
                    // },
                    // child: Container(
                    //   color: Colors.white,
                    //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    // decoration: BoxDecoration(
                    //   border: Border.all(color: Colors.grey),
                    //   borderRadius: BorderRadius.circular(5),
                    // ),

                    // Container(
                    //   padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                    //   color: Colors.white,
                    //   child: Align(
                    //     alignment: Alignment.centerLeft,
                    //               child: Row(
                    // children: [
                    //   Expanded(
                    //      child: TextField(
                    //       controller: TextEditingController(text: " "),
                    //                   onChanged: (value) {
                    //                     setState(() {
                    //                       //specificInterest = value;
                    //                     });
                    //                   },
                    //                   decoration: InputDecoration(
                    //                     prefixText: hintText,
                    //                     hintStyle:
                    //                         TextStyle(color: Colors.black38, fontSize: 15),
                    //                   ),
                    //                 ),
                    // TextFormField(
                    //   initialValue: textFieldValue,
                    //   onChanged: (value) {
                    //     // Update the value entered by the user
                    //     setState(() {
                    //       textFieldValue = value;
                    //     });
                    //   },
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.w500,
                    //     color: Colors.black,
                    //   ),
                    //   decoration: InputDecoration(
                    //     hintText: 'Any suggestions?',
                    //     border: InputBorder.none,
                    //   ),
                    // ),
                    //           child: Text(
                    //   textFieldValue.isNotEmpty ? textFieldValue : 'What do you have in mind?',
                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // TextField(
                    //   controller: TextEditingController(text: " "),

                    //   style: TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.bold,
                    //     // Add any additional styling here
                    //   ),
                    // ),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // ],
    //           ),
    //           ),
    //           ),

    // Divider(
    //   height: 2,
    //   color: Colors.grey,
    // ),

    //SizedBox(height: 10),
    // Replace with your button
    //ElevatedButton(
    //onPressed: () {
    // Add button functionality here
    //},
    //child: Text('View Profile'),
    //),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
