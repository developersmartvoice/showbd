import 'package:appcode3/views/AboutMeDetailsPage.dart';
import 'package:appcode3/views/CreateTrip.dart';
import 'package:appcode3/views/EmailDetailsPage.dart';
import 'package:appcode3/views/NameSettingsPage.dart';
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

class GeneraLInfo extends StatefulWidget {
  const GeneraLInfo({super.key});

  @override
  State<GeneraLInfo> createState() => _GeneraLInfoState();
}

class _GeneraLInfoState extends State<GeneraLInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHT_GREY_SCREEN_BACKGROUND,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 103, 9),
        centerTitle: true,
        title: Text(
          'General information',
          style: GoogleFonts.robotoCondensed(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w700, // Title text color
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black, // Back button color
          ),
          onPressed: () {
            Navigator.of(context).pop();
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
              'Save', // Text for the button
              style: GoogleFonts.robotoCondensed(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text color
              ),
            ),
          ),
        ],
      ),
      body: ContainerPage(),
    );
  }
}

class ContainerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                height: 70,
                color: Colors.white,
                child: Stack(
                  children: [
                    Positioned(
                      left: 10, // Adjust the position of the button as needed
                      top: 20, // Adjust the position of the button as needed
                      child: InkWell(
                        //onTap: _changeColor,
                        // Add your logic for the selection button onTap event here

                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            //color: _boxColor, // Color of the button
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black, // Color of the border
                              width: 1.0, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            //color: _isSelected ? Colors.green : Colors.white,
                            color: Colors.white, // Color of the icon
                            size: 25.0, // Size of the icon
                          ),
                        ),
                      ),
                    ),
                    Row(children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 190.0),
                          child: Text(
                            'Name',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.robotoCondensed(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => NameSettingsPage(),
                              ),
                            );
                            // Add your logic for the onPressed event here
                            // Typically, this would involve navigating to the next screen or performing some action
                          },
                          //alignment: Alignment.centerRight,
                          icon: Icon(Icons.arrow_forward_ios_sharp),
                          color: Colors.black, // Color of the icon
                          iconSize: 24.0, // Size of the icon
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              Divider(
                height: 2,
                color: Colors.white10,
              ),
              Container(
                height: 70,
                color: Colors.white,
                child: Stack(
                  children: [
                    Positioned(
                      left: 10, // Adjust the position of the button as needed
                      top: 20, // Adjust the position of the button as needed
                      child: InkWell(
                        //onTap: _changeColor,
                        // Add your logic for the selection button onTap event here

                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            //color: _boxColor, // Color of the button
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black, // Color of the border
                              width: 1.0, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            //color: _isSelected ? Colors.green : Colors.white,
                            color: Colors.white, // Color of the icon
                            size: 25.0, // Size of the icon
                          ),
                        ),
                      ),
                    ),
                    Row(children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 160.0),
                          child: Text(
                            'About me',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.robotoCondensed(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AboutMeDetailsPage(),
                              ),
                            );
                            // Add your logic for the onPressed event here
                            // Typically, this would involve navigating to the next screen or performing some action
                          },
                          //alignment: Alignment.centerRight,
                          icon: Icon(Icons.arrow_forward_ios_sharp),
                          color: Colors.black, // Color of the icon
                          iconSize: 24.0, // Size of the icon
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              Divider(
                height: 2,
                color: Colors.white10,
              ),
              Container(
                height: 70,
                color: Colors.white,
                child: Stack(
                  children: [
                    Positioned(
                      left: 10, // Adjust the position of the button as needed
                      top: 20, // Adjust the position of the button as needed
                      child: InkWell(
                        //onTap: _changeColor,
                        // Add your logic for the selection button onTap event here

                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            //color: _boxColor, // Color of the button
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black, // Color of the border
                              width: 1.0, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            //color: _isSelected ? Colors.green : Colors.white,
                            color: Colors.white, // Color of the icon
                            size: 25.0, // Size of the icon
                          ),
                        ),
                      ),
                    ),
                    Row(children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 180.0),
                          child: Text(
                            'Photos',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.robotoCondensed(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            // Add your logic for the onPressed event here
                            // Typically, this would involve navigating to the next screen or performing some action
                          },
                          //alignment: Alignment.centerRight,
                          icon: Icon(Icons.arrow_forward_ios_sharp),
                          color: Colors.black, // Color of the icon
                          iconSize: 24.0, // Size of the icon
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              Divider(
                height: 2,
                color: Colors.white10,
              ),
              Container(
                height: 70,
                color: Colors.white,
                child: Stack(
                  children: [
                    Positioned(
                      left: 10, // Adjust the position of the button as needed
                      top: 20, // Adjust the position of the button as needed
                      child: InkWell(
                        //onTap: _changeColor,
                        // Add your logic for the selection button onTap event here

                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            //color: _boxColor, // Color of the button
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black, // Color of the border
                              width: 1.0, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            //color: _isSelected ? Colors.green : Colors.white,
                            color: Colors.white, // Color of the icon
                            size: 25.0, // Size of the icon
                          ),
                        ),
                      ),
                    ),
                    Row(children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 165.0),
                          child: Text(
                            'Location',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.robotoCondensed(
                              fontSize: 20.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LocationSearchPage(),
                              ),
                            );
                            // Add your logic for the onPressed event here
                            // Typically, this would involve navigating to the next screen or performing some action
                          },
                          //alignment: Alignment.centerRight,
                          icon: Icon(Icons.arrow_forward_ios_sharp),
                          color: Colors.black, // Color of the icon
                          iconSize: 24.0, // Size of the icon
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              Divider(
                height: 2,
                color: Colors.white10,
              ),
            ],
          ),
        )
      ],
    );
  }
}
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Container(
//                   height: 70,
//                   color: Colors.white,
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         left: 10, // Adjust the position of the button as needed
//                         top: 15, // Adjust the position of the button as needed
//                         child: InkWell(
//                           //onTap: _changeColor,
//                           // Add your logic for the selection button onTap event here

//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               //color: _boxColor, // Color of the button
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: Colors.black, // Color of the border
//                                 width: 1.0, // Width of the border
//                               ), // Circular shape
//                             ),
//                             child: Icon(
//                               Icons.check,
//                               //color: _isSelected ? Colors.green : Colors.white,
//                               color: Colors.white, // Color of the icon
//                               size: 30.0, // Size of the icon
//                             ),
//                           ),
//                         ),
//                       ),
//                       Row(children: [
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.only(right: 170.0),
//                             child: Text(
//                               'Name',
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.robotoCondensed(
//                                 fontSize: 25.0,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: IconButton(
//                             onPressed: () {
//                               // Add your logic for the onPressed event here
//                               // Typically, this would involve navigating to the next screen or performing some action
//                             },
//                             //alignment: Alignment.centerRight,
//                             icon: Icon(Icons.arrow_forward_ios_sharp),
//                             color: Colors.black, // Color of the icon
//                             iconSize: 24.0, // Size of the icon
//                           ),
//                         ),
//                       ]),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   height: 70,
//                   color: Colors.white,
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         left: 10, // Adjust the position of the button as needed
//                         top: 15, // Adjust the position of the button as needed
//                         child: InkWell(
//                           //onTap: _changeColor,
//                           // Add your logic for the selection button onTap event here

//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               //color: _boxColor, // Color of the button
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: Colors.black, // Color of the border
//                                 width: 1.0, // Width of the border
//                               ), // Circular shape
//                             ),
//                             child: Icon(
//                               Icons.check,
//                               //color: _isSelected ? Colors.green : Colors.white,
//                               color: Colors.white, // Color of the icon
//                               size: 30.0, // Size of the icon
//                             ),
//                           ),
//                         ),
//                       ),
//                       Row(children: [
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.only(right: 170.0),
//                             child: Text(
//                               'About me',
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.robotoCondensed(
//                                 fontSize: 25.0,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: IconButton(
//                             onPressed: () {
//                               // Add your logic for the onPressed event here
//                               // Typically, this would involve navigating to the next screen or performing some action
//                             },
//                             //alignment: Alignment.centerRight,
//                             icon: Icon(Icons.arrow_forward_ios_sharp),
//                             color: Colors.black, // Color of the icon
//                             iconSize: 24.0, // Size of the icon
//                           ),
//                         ),
//                       ]),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   height: 70,
//                   color: Colors.white,
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         left: 10, // Adjust the position of the button as needed
//                         top: 15, // Adjust the position of the button as needed
//                         child: InkWell(
//                           //onTap: _changeColor,
//                           // Add your logic for the selection button onTap event here

//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               //color: _boxColor, // Color of the button
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: Colors.black, // Color of the border
//                                 width: 1.0, // Width of the border
//                               ), // Circular shape
//                             ),
//                             child: Icon(
//                               Icons.check,
//                               //color: _isSelected ? Colors.green : Colors.white,
//                               color: Colors.white, // Color of the icon
//                               size: 30.0, // Size of the icon
//                             ),
//                           ),
//                         ),
//                       ),
//                       Row(children: [
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.only(right: 170.0),
//                             child: Text(
//                               'Photos',
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.robotoCondensed(
//                                 fontSize: 25.0,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: IconButton(
//                             onPressed: () {
//                               // Add your logic for the onPressed event here
//                               // Typically, this would involve navigating to the next screen or performing some action
//                             },
//                             //alignment: Alignment.centerRight,
//                             icon: Icon(Icons.arrow_forward_ios_sharp),
//                             color: Colors.black, // Color of the icon
//                             iconSize: 24.0, // Size of the icon
//                           ),
//                         ),
//                       ]),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   height: 70,
//                   color: Colors.white,
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         left: 10, // Adjust the position of the button as needed
//                         top: 15, // Adjust the position of the button as needed
//                         child: InkWell(
//                           //onTap: _changeColor,
//                           // Add your logic for the selection button onTap event here

//                           child: Container(
//                             width: 40,
//                             height: 40,
//                             decoration: BoxDecoration(
//                               //color: _boxColor, // Color of the button
//                               color: Colors.white,
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: Colors.black, // Color of the border
//                                 width: 1.0, // Width of the border
//                               ), // Circular shape
//                             ),
//                             child: Icon(
//                               Icons.check,
//                               //color: _isSelected ? Colors.green : Colors.white,
//                               color: Colors.white, // Color of the icon
//                               size: 30.0, // Size of the icon
//                             ),
//                           ),
//                         ),
//                       ),
//                       Row(children: [
//                         Expanded(
//                           child: Padding(
//                             padding: const EdgeInsets.only(right: 170.0),
//                             child: Text(
//                               'Location',
//                               textAlign: TextAlign.center,
//                               style: GoogleFonts.robotoCondensed(
//                                 fontSize: 25.0,
//                                 color: Colors.black,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: IconButton(
//                             onPressed: () {
//                               // Add your logic for the onPressed event here
//                               // Typically, this would involve navigating to the next screen or performing some action
//                             },
//                             //alignment: Alignment.centerRight,
//                             icon: Icon(Icons.arrow_forward_ios_sharp),
//                             color: Colors.black, // Color of the icon
//                             iconSize: 24.0, // Size of the icon
//                           ),
//                         ),
//                       ]),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
