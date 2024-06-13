// import 'dart:convert';

// import 'package:appcode3/en.dart';
// import 'package:appcode3/main.dart';
// import 'package:appcode3/notificationHelper.dart';
// // import 'package:appcode3/modals/OffersClassSender.dart';
// import 'package:flutter/material.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart';
// import 'package:intl/intl.dart';

// import '../modals/DirectBookingClass.dart';

// class BookingScreen extends StatefulWidget {
//   final String receiver_id;
//   final String sender_id;
//   final String guideName;

//   BookingScreen(this.receiver_id, this.sender_id, this.guideName);

//   @override
//   State<BookingScreen> createState() => _BookingScreenState();
// }

// class _BookingScreenState extends State<BookingScreen> {
//   final NotificationHelper notificationHelper = NotificationHelper();
//   DirectBookingClass? directBookingClass;
//   DateTime? selectedDate;
//   String? selectedDatePost;
//   String selectedDuration = "";
//   String selectedMeetingTime = "";
//   String selectedNumberOfPeople = "";
//   String specificInterest = "";
//   int people = 0;
//   int timeDuration = 0;
//   bool isDatePicked = false;
//   bool isTimeDurationPicked = false;
//   bool isMeetingTimePicled = false;
//   bool isNumberofPeoplePicked = false;
//   bool isMessageGiven = false;
//   bool loading = false;
//   // String? receipent_image;
//   // String? sender_image;
//   // List<DeviceToken>? deviceToken;

//   @override
//   void initState() {
//     super.initState();
//     notificationHelper.initialize();
//   }

//   directBooking() async {
//     Map<String, dynamic> postData = {
//       'sender_id': int.parse(widget.sender_id),
//       'recipient_id': int.parse(widget.receiver_id),
//       'date': selectedDatePost,
//       'duration': timeDuration,
//       'timing': selectedMeetingTime,
//       'num_people': people,
//       'message': specificInterest,
//     };

//     String postDataJson = jsonEncode(postData);

//     final response = await post(
//         Uri.parse("$SERVER_ADDRESS/api/updateDirectBooking"),
//         body: postDataJson,
//         headers: {
//           'Content-Type': 'application/json',
//         });

//     if (response.statusCode == 200) {
//       setState(() {
//         loading = false;
//       });
//       final jsonResponse = jsonDecode(response.body);
//       directBookingClass = DirectBookingClass.fromJson(jsonResponse);

//       if (directBookingClass!.message ==
//           'Direct booking created successfully') {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Booking Successful'),
//               content: Text('Your booking has been successfully created.'),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     } else {
//       // final jsonResponse = jsonDecode(response.body);
//       // print("This is error message!! : ${jsonResponse['error']}");
//       setState(() {
//         loading = false;
//       });
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Booking Unsuccessful'),
//             content: Text('Something went wrong. Try again later.'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     String greetings = 'Hello ${widget.guideName.capitalize}, ';
//     String hintText = greetings;
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'Booking ${widget.guideName.toString().capitalize}',
//             //centerTitle: true,
//             style: GoogleFonts.robotoCondensed(
//               color: Colors.white,
//               fontSize: 21,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           centerTitle: true,
//           backgroundColor: Color.fromARGB(255, 243, 103, 9),
//           actions: [
//             // IconButton(
//             //   icon: Icon(Icons.send_rounded),
//             //   onPressed: () {
//             //     // Implement send logic
//             //   },
//             // ),
//           ],
//         ),
//         body: loading
//             ? Container(
//                 alignment: Alignment.center,
//                 transformAlignment: Alignment.center,
//                 child: CircularProgressIndicator(
//                   color: Color.fromARGB(255, 243, 103, 9),
//                 ),
//               )
//             : SingleChildScrollView(
//                 child: Container(
//                   child: Padding(
//                     padding: const EdgeInsets.all(14.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(left: 10),
//                           child: Text(
//                             'Select Date',
//                             style: GoogleFonts.robotoCondensed(
//                               fontSize:
//                                   MediaQuery.of(context).size.width * 0.04,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () => _selectDate(context),
//                           child: Container(
//                             padding: EdgeInsets.all(7),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: Colors.grey),
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Padding(
//                                   padding: const EdgeInsets.all(
//                                       8.0), // Add padding here
//                                   child: Icon(Icons.calendar_today),
//                                 ),
//                                 selectedDate != null
//                                     ? Padding(
//                                         padding: const EdgeInsets.all(
//                                             8.0), // Add padding here
//                                         child: Text(
//                                           DateFormat('dd - MMM - yyyy')
//                                               .format(selectedDate!),
//                                           style: TextStyle(fontSize: 16),
//                                         ),
//                                       )
//                                     : Text('Select Date'),
//                               ],
//                             ),
//                           ),
//                         ),

//                         // Divider(
//                         //   height: 30,
//                         //   color: Colors.grey,
//                         // ),

//                         //SizedBox(height: 10),
//                         // Padding(
//                         //   padding: const EdgeInsets.all(8.0), // Add padding here
//                         //   child: Row(
//                         //     children: [
//                         //       Text(
//                         //         'Tour Duration',
//                         //         style: GoogleFonts.robotoCondensed(
//                         //           fontSize: 20,
//                         //           fontWeight: FontWeight.w500,
//                         //         ),
//                         //       ),
//                         //       SizedBox(
//                         //           width:
//                         //               8), // Add spacing between text and DropdownSearch
//                         //       Column(
//                         //         children: [
//                         //           Expanded(
//                         //             child: DropdownSearch<String>(
//                         //               items: ['1h', '2h', '3h'],
//                         //               onChanged: (value) {
//                         //                 setState(() {
//                         //                   selectedDuration = value!;
//                         //                 });
//                         //               },
//                         //               selectedItem: selectedDuration,
//                         //             ),
//                         //           ),
//                         //         ],
//                         //       ),
//                         //     ],
//                         //   ),
//                         // ),

//                         SizedBox(
//                           height: 100,
//                           child: Container(
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               // decoration: BoxDecoration(
//                               //     border: Border.all(color: Colors.grey),
//                               //     borderRadius: BorderRadius.circular(8),
//                               // ),
//                               child: Container(
//                                 height:
//                                     50, // Set a fixed height or adjust according to your design
//                                 child: Column(
//                                   children: [
//                                     Align(
//                                       alignment: Alignment.centerLeft,
//                                       child: Text(
//                                         'Tour Duration',
//                                         style: GoogleFonts.robotoCondensed(
//                                           fontSize: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               0.04,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(width: 50),
//                                     Expanded(
//                                       child: DropdownSearch<String>(
//                                         items: ['1h', '2h', '3h'],
//                                         onChanged: (value) {
//                                           setState(() {
//                                             isTimeDurationPicked = true;
//                                             if (value == '1h') {
//                                               timeDuration = 1;
//                                             } else if (value == '2h') {
//                                               timeDuration = 2;
//                                             } else if (value == '3h') {
//                                               timeDuration = 3;
//                                             } else {
//                                               timeDuration = 0;
//                                               isTimeDurationPicked = false;
//                                             }
//                                             selectedDuration = value!;
//                                           });
//                                         },
//                                         selectedItem: selectedDuration,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),

//                         // Divider(
//                         //   height: 20,
//                         //   color: Colors.grey,
//                         // ),

//                         //SizedBox(height: 20),
//                         SizedBox(
//                           height: 100,
//                           child: Container(
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.all(8.0), // Add padding here
//                               child: Container(
//                                 height: MediaQuery.of(context).size.width *
//                                     0.025, // Set a fixed height or adjust according to your design
//                                 child: Column(
//                                   children: [
//                                     Align(
//                                       alignment: Alignment.centerLeft,
//                                       child: Text(
//                                         'Preferred Meeting Time',
//                                         style: GoogleFonts.robotoCondensed(
//                                           fontSize: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               0.04,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                         width:
//                                             50), // Add spacing between text and DropdownSearch
//                                     Expanded(
//                                       child: DropdownSearch<String>(
//                                         items: [
//                                           'Flexible',
//                                           'Earlier',
//                                           'Morning',
//                                           'Noon',
//                                           'Afternoon'
//                                         ],
//                                         onChanged: (value) {
//                                           setState(() {
//                                             if (value != null) {
//                                               isMeetingTimePicled = true;
//                                             } else {
//                                               isMeetingTimePicled = false;
//                                             }
//                                             selectedMeetingTime = value!;
//                                           });
//                                         },
//                                         selectedItem: selectedMeetingTime,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         // ... (similar changes for other widgets)

//                         // Divider(
//                         //   height: 20,
//                         //   color: Colors.grey,
//                         // ),

//                         SizedBox(
//                           height: 100,
//                           child: Container(
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.all(8.0), // Add padding here
//                               child: Container(
//                                 height:
//                                     50, // Set a fixed height or adjust according to your design
//                                 child: Column(
//                                   children: [
//                                     Align(
//                                       alignment: Alignment.centerLeft,
//                                       child: Text(
//                                         'Number of People',
//                                         style: GoogleFonts.robotoCondensed(
//                                           fontSize: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               0.04,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                         width:
//                                             50), // Add spacing between text and DropdownSearch
//                                     Expanded(
//                                       child: DropdownSearch<String>(
//                                         items: [
//                                           'Just me',
//                                           'Two people',
//                                           'Three people',
//                                           'More than three people',
//                                         ],
//                                         onChanged: (value) {
//                                           setState(() {
//                                             isNumberofPeoplePicked = true;
//                                             if (value == 'Just me') {
//                                               people = 1;
//                                             } else if (value == 'Two people') {
//                                               people = 2;
//                                             } else if (value ==
//                                                 'Three people') {
//                                               people = 3;
//                                             } else if (value ==
//                                                 'More than three people') {
//                                               people = 4;
//                                             } else {
//                                               people = 0;
//                                               isMeetingTimePicled = false;
//                                             }
//                                             selectedNumberOfPeople = value!;
//                                           });
//                                         },
//                                         selectedItem: selectedNumberOfPeople,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),

//                         //SizedBox(height: 16),

//                         // Divider(
//                         //   height: 20,
//                         //   color: Colors.grey,
//                         // ),

//                         Center(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(height: 16),
//                               Text(
//                                 WHAT_BRING_YOU_HERE,
//                                 style: GoogleFonts.robotoCondensed(
//                                   fontSize:
//                                       MediaQuery.of(context).size.width * 0.04,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               TextField(
//                                 onChanged: (value) {
//                                   setState(() {
//                                     if (value.isNotEmpty) {
//                                       isMessageGiven = true;
//                                       specificInterest = greetings + value;
//                                     } else {
//                                       isMessageGiven = false;
//                                       specificInterest = '';
//                                     }
//                                   });
//                                 },
//                                 decoration: InputDecoration(
//                                   prefixText: hintText,
//                                   hintStyle: TextStyle(
//                                       color: Colors.black38, fontSize: 15),
//                                 ),
//                               ),
//                               SizedBox(height: 50),
//                               Center(
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     if (isDatePicked &&
//                                         isTimeDurationPicked &&
//                                         isMeetingTimePicled &&
//                                         isNumberofPeoplePicked &&
//                                         isMessageGiven) {
//                                       print(
//                                           "This is Time duration: $timeDuration");
//                                       print(
//                                           "This is number of people: $people");
//                                       print(
//                                           "This is Sender_ID: ${widget.sender_id}");
//                                       print(
//                                           "This is Receiver_ID: ${widget.receiver_id}");
//                                       print(
//                                           "This is Message: $specificInterest");
//                                       setState(() {
//                                         loading = true;
//                                       });
//                                       directBooking();
//                                     }
//                                   },
//                                   child: Text(
//                                     'REQUEST TO BOOK',
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                     textStyle: GoogleFonts.robotoCondensed(
//                                       fontSize:
//                                           MediaQuery.of(context).size.width *
//                                               0.03,
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                     padding:
//                                         EdgeInsets.fromLTRB(112, 20, 114, 20),
//                                     foregroundColor: Colors.white,
//                                     backgroundColor:
//                                         Color.fromARGB(255, 243, 103, 9),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10.0),
//                                       side: BorderSide(
//                                         color: Colors.white,
//                                       ), // Set border radius
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(4000),
//     );

//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//         selectedDatePost = DateFormat('yyyy-MM-dd').format(selectedDate!);
//         isDatePicked = true;
//         print("This is selected Date: $selectedDatePost");
//       });
//     } else {
//       setState(() {
//         isDatePicked = false;
//       });
//     }
//   }
// }

import 'dart:convert';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/notificationHelper.dart';
// import 'package:appcode3/modals/OffersClassSender.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../modals/DirectBookingClass.dart';

class BookingScreen extends StatefulWidget {
  final String receiver_id;
  final String sender_id;
  final String guideName;

  BookingScreen(this.receiver_id, this.sender_id, this.guideName);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final NotificationHelper notificationHelper = NotificationHelper();
  DirectBookingClass? directBookingClass;
  DateTime? selectedDate;
  String? selectedDatePost;
  String selectedDuration = "";
  String selectedMeetingTime = "";
  String selectedNumberOfPeople = "";
  String specificInterest = "";
  int people = 0;
  int timeDuration = 0;
  bool isDatePicked = false;
  bool isTimeDurationPicked = false;
  bool isMeetingTimePicled = false;
  bool isNumberofPeoplePicked = false;
  bool isMessageGiven = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    notificationHelper.initialize();
  }

  directBooking() async {
    setState(() {
      loading = true;
    });

    Map<String, dynamic> postData = {
      'sender_id': int.parse(widget.sender_id),
      'recipient_id': int.parse(widget.receiver_id),
      'date': selectedDatePost,
      'duration': timeDuration,
      'timing': selectedMeetingTime,
      'num_people': people,
      'message': specificInterest,
    };

    String postDataJson = jsonEncode(postData);

    final response = await post(
        Uri.parse("$SERVER_ADDRESS/api/updateDirectBooking"),
        body: postDataJson,
        headers: {
          'Content-Type': 'application/json',
        });

    setState(() {
      loading = false;
    });

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      directBookingClass = DirectBookingClass.fromJson(jsonResponse);

      if (directBookingClass!.message ==
          'Direct booking created successfully') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Booking Successful'),
              content: Text('Your booking has been successfully created.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );

        // Send notifications
        notificationHelper.showNotification(
          title: 'Booking request sent',
          body: 'You have successfully sent a request to ${widget.guideName}.',
          payload: 'user_id:${widget.sender_id}',
          id: widget.sender_id,
        );

        notificationHelper.showNotification(
          title: 'New Booking Request',
          body: '${widget.guideName} has sent you a booking.',
          payload: 'user_id:${widget.receiver_id}',
          id: widget.receiver_id,
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Booking Unsuccessful'),
            content: Text('Something went wrong. Try again later.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String greetings = 'Hello ${widget.guideName.capitalize}, ';
    String hintText = greetings;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Booking ${widget.guideName.toString().capitalize}',
            style: GoogleFonts.robotoCondensed(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 243, 103, 9),
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 243, 103, 9),
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Select Date',
                          style: GoogleFonts.robotoCondensed(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.calendar_today),
                              ),
                              selectedDate != null
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        DateFormat('dd - MMM - yyyy')
                                            .format(selectedDate!),
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    )
                                  : Text('Select Date'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Tour Duration',
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: 50),
                              Expanded(
                                child: DropdownSearch<String>(
                                  items: ['1h', '2h', '3h'],
                                  onChanged: (value) {
                                    setState(() {
                                      isTimeDurationPicked = true;
                                      if (value == '1h') {
                                        timeDuration = 1;
                                      } else if (value == '2h') {
                                        timeDuration = 2;
                                      } else if (value == '3h') {
                                        timeDuration = 3;
                                      } else {
                                        timeDuration = 0;
                                        isTimeDurationPicked = false;
                                      }
                                      selectedDuration = value!;
                                    });
                                  },
                                  selectedItem: selectedDuration,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Preferred Meeting Time',
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 50),
                              Expanded(
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
                                      if (value != null) {
                                        isMeetingTimePicled = true;
                                      } else {
                                        isMeetingTimePicled = false;
                                      }
                                      selectedMeetingTime = value!;
                                    });
                                  },
                                  selectedItem: selectedMeetingTime,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Number of People',
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: 50),
                              Expanded(
                                child: DropdownSearch<String>(
                                  items: [
                                    'Just me',
                                    'Two people',
                                    'Three people',
                                    'More than three people',
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      isNumberofPeoplePicked = true;
                                      if (value == 'Just me') {
                                        people = 1;
                                      } else if (value == 'Two people') {
                                        people = 2;
                                      } else if (value == 'Three people') {
                                        people = 3;
                                      } else if (value ==
                                          'More than three people') {
                                        people = 4;
                                      } else {
                                        people = 0;
                                        isMeetingTimePicled = false;
                                      }
                                      selectedNumberOfPeople = value!;
                                    });
                                  },
                                  selectedItem: selectedNumberOfPeople,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        WHAT_BRING_YOU_HERE,
                        style: GoogleFonts.robotoCondensed(
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            if (value.isNotEmpty) {
                              isMessageGiven = true;
                              specificInterest = greetings + value;
                            } else {
                              isMessageGiven = false;
                              specificInterest = '';
                            }
                          });
                        },
                        decoration: InputDecoration(
                          prefixText: hintText,
                          hintStyle:
                              TextStyle(color: Colors.black38, fontSize: 15),
                        ),
                      ),
                      SizedBox(height: 50),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (isDatePicked &&
                                isTimeDurationPicked &&
                                isMeetingTimePicled &&
                                isNumberofPeoplePicked &&
                                isMessageGiven) {
                              setState(() {
                                loading = true;
                              });
                              directBooking();
                            }
                          },
                          child: Text(
                            'REQUEST TO BOOK',
                            overflow: TextOverflow.ellipsis,
                          ),
                          style: ElevatedButton.styleFrom(
                            textStyle: GoogleFonts.robotoCondensed(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              fontWeight: FontWeight.w700,
                            ),
                            padding: EdgeInsets.fromLTRB(112, 20, 114, 20),
                            foregroundColor: Colors.white,
                            backgroundColor: Color.fromARGB(255, 243, 103, 9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(4000),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedDatePost = DateFormat('yyyy-MM-dd').format(selectedDate!);
        isDatePicked = true;
        print("This is selected Date: $selectedDatePost");
      });
    } else {
      setState(() {
        isDatePicked = false;
      });
    }
  }
}
