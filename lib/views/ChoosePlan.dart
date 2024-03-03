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

class ChoosePlan extends StatefulWidget {
  //const ChoosePlan({super.key});
  final String id;
  final String guideName;

  ChoosePlan(this.id, this.guideName);
  //ChoosePlan(this.id, String s);

  @override
  State<ChoosePlan> createState() => _ChoosePlanState();
}

class _ChoosePlanState extends State<ChoosePlan> {
  //PageController _pageController = PageController(initialPage: 0);
  // List<bool> isSelected = [false, true];
  bool isLimitedSelected = false;
  // bool isExtendedSelected = true;
  // String? guideName;

  get isFadeOut => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose a Plan',
          style: GoogleFonts.robotoCondensed(
            fontSize: 25,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Row with 2 ToggleButtons
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // children: [
                //   Container(
                //     child: ToggleButtons(
                //       children: [
                //         Container(
                //           constraints: BoxConstraints(minWidth: 180),
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(10),
                //             //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20) // Adjust the radius as needed
                //             //border:
                //             //Border.all(color: Colors.black), // Border color
                //           ),
                //           alignment: Alignment.center,
                //           child: Text(
                //             'Limited',
                //             style: GoogleFonts.robotoCondensed(
                //               fontSize: 20,
                //               fontWeight: FontWeight.bold,
                //               //backgroundColor: Colors.white,
                //               //color: Colors.black,
                //               color: isSelected[0] ? Colors.grey : Colors.black,
                //             ),
                //           ),
                //         ),
                //         Container(
                //           constraints: BoxConstraints(
                //             minWidth: 180,
                //           ),
                //           decoration: BoxDecoration(
                //             borderRadius: BorderRadius.circular(
                //                 10), // Adjust the radius as needed
                //             //border:
                //             //  Border.all(color: Colors.black), // Border color
                //           ),
                //           alignment: Alignment.center,
                //           child: Text(
                //             'Extended',
                //             style: GoogleFonts.robotoCondensed(
                //               fontSize: 20,
                //               fontWeight: FontWeight.bold,
                //               //backgroundColor: Colors.white,
                //               //color: Colors.black,
                //               color: isSelected[1] ? Colors.grey : Colors.black,
                //             ),
                //           ),
                //         ),
                //       ],
                //       isSelected: [false, true],
                //       onPressed: (int index) {
                //         setState(
                //           () {
                //             //isSelected = List.generate(
                //             // isSelected.length, (i) => i == index);
                //             //_pageController.animateToPage(
                //             //index,
                //             //duration: Duration(milliseconds: 300),
                //             //curve: Curves.easeInOut,
                //             //);
                //             // Toggle the selected state for the pressed button
                //             isSelected[index] = !isSelected[index];
                //           },
                //         );
                //       },
                //       hoverColor: Colors.grey[300],
                //       // PageView(
                //       //   controller: _pageController,
                //       //   onPageChanged: (index) {
                //       //     setState(() {
                //       //       isSelected = List.generate(
                //       //           isSelected.length, (i) => i == index);
                //       //     });
                //       //   },
                //       //   children: [
                //       //     Container(
                //       //       color: Colors.green,
                //       //       child: Center(
                //       //         child: Text('Limited View'),
                //       //       ),
                //       //     ),
                //       //     // View for 'Extended'
                //       //     Container(
                //       //       color: Colors.blue,
                //       //       child: Center(
                //       //         child: Text('Extended View'),
                //       //       ),
                //       //     ),
                //       //   ],
                //       // ),
                //     ),
                //   ),
                // ],
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (!isLimitedSelected) {
                            isLimitedSelected = true;
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            isLimitedSelected ? Colors.white : Colors.black,
                        textStyle: GoogleFonts.robotoCondensed(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        backgroundColor: isLimitedSelected
                            ? Color.fromARGB(255, 243, 103, 9)
                            : Colors.white, // Text color
                        // elevation: 5, // Elevation
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // Border radius
                        ),
                        minimumSize: Size(160, 50), // Set width and height
                      ),
                      child: Text("Limited")),
                  SizedBox(
                    width: 2,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLimitedSelected = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            isLimitedSelected ? Colors.black : Colors.white,
                        textStyle: GoogleFonts.robotoCondensed(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        backgroundColor: isLimitedSelected
                            ? Colors.white
                            : const Color.fromARGB(
                                255, 243, 103, 9), // Text color
                        // elevation: 5, // Elevation
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15), // Border radius
                        ),
                        minimumSize: Size(160, 50), // Set width and height
                      ),
                      child: Text("Extended"))
                ],
              ),
            ),

            // Elevated Button in Column
            SizedBox(height: 30),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.of(context).push(
            //       MaterialPageRoute(
            //         builder: (context) => DoctorProfile(),
            //       ),
            //     );
            //   },
            //   child: Text('Continue'),
            //   style: ElevatedButton.styleFrom(
            //     textStyle: GoogleFonts.poppins(
            //       fontSize: 16.0,
            //       fontWeight: FontWeight.w500,
            //     ),
            //     foregroundColor: Colors.white,
            //     backgroundColor: Color.fromARGB(255, 243, 103, 9),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10.0),
            //       side: BorderSide(
            //         color: Colors.white,
            //       ), // Set border radius
            //     ),
            //   ),
            // ),

            // Container with 4 Avatars and Text in Rows
            SizedBox(height: 16),
            Container(
              //padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                //border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // BackdropFilter(
                      //   filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      //   child: Container(
                      //     color: Colors.grey.withOpacity(
                      //         0.5), // Adjust the opacity for the desired faded effect
                      //     child:

                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      AssetImage('assets/people 1.png'),
                                ),
                                Positioned(
                                  bottom: -10,
                                  right: -10,
                                  child: CircleAvatar(
                                    radius: 20, // Adjust the radius as needed
                                    backgroundImage:
                                        AssetImage('assets/srch.png'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Browse locals',
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'See available guides',
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 18,
                                    color: Color.fromARGB(131, 0, 0,
                                        0), // You can customize the style as needed
                                  ),
                                ),
                                Text(
                                  'for all locations',
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 18,
                                    color: Color.fromARGB(131, 0, 0,
                                        0), // You can customize the style as needed
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      // ),
                      //),
                      SizedBox(
                        height: 30,
                      ),
                      // BackdropFilter(
                      //   filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      //   child: Container(
                      //     color: Colors.grey.withOpacity(
                      //         0.5), // Adjust the opacity for the desired faded effect
                      //     child:
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      AssetImage('assets/people 2.png'),
                                ),
                                Positioned(
                                  bottom: -3,
                                  right: -8,
                                  child: CircleAvatar(
                                    radius: 20, // Adjust the radius as needed
                                    backgroundImage:
                                        AssetImage('assets/map 3.png'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create a trip',
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 27,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Get "MeetLocal" offers',
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 18,
                                    color: Color.fromARGB(131, 0, 0,
                                        0), // You can customize the style as needed
                                  ),
                                ),
                                Text(
                                  'from locals',
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 18,
                                    color: Color.fromARGB(131, 0, 0,
                                        0), // You can customize the style as needed
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      //),
                      //),
                      SizedBox(
                        height: 30,
                      ),

                      // BackdropFilter(
                      //   filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      //   child: Container(
                      //     color: Colors.grey.withOpacity(
                      //         0.5), // Adjust the opacity for the desired faded effect
                      //     child:

                      Container(
                        //color: Color.fromARGB(100, 236, 231, 231),
                        child: isLimitedSelected
                            ? AnimatedOpacity(
                                duration: Duration(seconds: 1),
                                opacity: isFadeOut ? 0.25 : 1.0,
                                child: Row(
                                  children: [
                                    Container(
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundImage: AssetImage(
                                                'assets/people 3.png'),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: CircleAvatar(
                                              radius:
                                                  15, // Adjust the radius as needed
                                              backgroundImage: AssetImage(
                                                  'assets/telegram icon.png'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Send Offers',
                                            style: GoogleFonts.robotoCondensed(
                                              fontSize: 27,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Connect with travellers',
                                            style: GoogleFonts.robotoCondensed(
                                              fontSize: 18,
                                              color: Color.fromARGB(131, 0, 0,
                                                  0), // You can customize the style as needed
                                            ),
                                          ),
                                          Text(
                                            'who visit your city',
                                            style: GoogleFonts.robotoCondensed(
                                              fontSize: 18,
                                              color: Color.fromARGB(131, 0, 0,
                                                  0), // You can customize the style as needed
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                children: [
                                  Container(
                                    child: Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundImage:
                                              AssetImage('assets/people 3.png'),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: CircleAvatar(
                                            radius:
                                                15, // Adjust the radius as needed
                                            backgroundImage: AssetImage(
                                                'assets/telegram icon.png'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Send Offers',
                                          style: GoogleFonts.robotoCondensed(
                                            fontSize: 27,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Connect with travellers',
                                          style: GoogleFonts.robotoCondensed(
                                            fontSize: 18,
                                            color: Color.fromARGB(131, 0, 0,
                                                0), // You can customize the style as needed
                                          ),
                                        ),
                                        Text(
                                          'who visit your city',
                                          style: GoogleFonts.robotoCondensed(
                                            fontSize: 18,
                                            color: Color.fromARGB(131, 0, 0,
                                                0), // You can customize the style as needed
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      // BackdropFilter(
                      //   filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      //   child: Container(
                      //     color: Colors.grey.withOpacity(
                      //         0.5), // Adjust the opacity for the desired faded effect
                      //     child:

                      Container(
                        child: isLimitedSelected
                            ? AnimatedOpacity(
                                duration: Duration(seconds: 1),
                                opacity: isFadeOut ? 0.25 : 1.0,
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      child: Stack(
                                        children: [
                                          CircleAvatar(
                                            radius: 40,
                                            backgroundImage: AssetImage(
                                                'assets/people 5.png'),
                                          ),
                                          Positioned(
                                            bottom: -3,
                                            right: -5,
                                            child: CircleAvatar(
                                              radius:
                                                  20, // Adjust the radius as needed
                                              backgroundImage: AssetImage(
                                                  'assets/whatsapp icon.png'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Pick a Local',
                                            style: GoogleFonts.robotoCondensed(
                                              fontSize: 27,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Contact those you like',
                                            style: GoogleFonts.robotoCondensed(
                                              fontSize: 18,
                                              color: Color.fromARGB(131, 0, 0,
                                                  0), // You can customize the style as needed
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    child: Stack(
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundImage:
                                              AssetImage('assets/people 5.png'),
                                        ),
                                        Positioned(
                                          bottom: -3,
                                          right: -5,
                                          child: CircleAvatar(
                                            radius:
                                                20, // Adjust the radius as needed
                                            backgroundImage: AssetImage(
                                                'assets/whatsapp icon.png'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Pick a Local',
                                          style: GoogleFonts.robotoCondensed(
                                            fontSize: 27,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Contact those you like',
                                          style: GoogleFonts.robotoCondensed(
                                            fontSize: 18,
                                            color: Color.fromARGB(131, 0, 0,
                                                0), // You can customize the style as needed
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      // ),
                      // ),
                      //SizedBox(height: 8),
                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: [
                      //     //Text('User 1'),
                      //     //Text('User 2'),
                      //   ],
                      // ),
                      SizedBox(height: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // CircleAvatar(
                          //   radius: 30,
                          //   backgroundImage: AssetImage('assets/avatar3.jpg'),
                          // ),
                          // SizedBox(
                          //   height: 20,
                          // ),
                          // CircleAvatar(
                          //   radius: 30,
                          //   backgroundImage: AssetImage('assets/avatar4.jpg'),
                          // ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          //Text('User 3'),
                          //Text('User 4'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 30,
            ),

            Container(
              child: isLimitedSelected
                  ? AnimatedOpacity(
                      duration: Duration(seconds: 1),
                      opacity: isFadeOut ? 0.25 : 1.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Member Subscription for',
                            style: GoogleFonts.robotoCondensed(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '৳1.00',
                            style: GoogleFonts.robotoCondensed(
                              fontSize: 16,
                              color: Colors
                                  .black, // You can customize the style as needed
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Member Subscription for',
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '৳1.00',
                          style: GoogleFonts.robotoCondensed(
                            fontSize: 16,
                            color: Colors
                                .black, // You can customize the style as needed
                          ),
                        ),
                      ],
                    ),
            ),

            SizedBox(
              height: 15,
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        BookingScreen(widget.id, widget.guideName),
                  ),
                );
              },
              child: Text('Continue'),
              style: ElevatedButton.styleFrom(
                textStyle: GoogleFonts.robotoCondensed(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
                padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 243, 103, 9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(
                    color: Colors.white,
                  ), // Set border radius
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
