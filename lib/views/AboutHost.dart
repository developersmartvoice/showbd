import 'dart:convert';
import 'dart:ui';
import 'package:appcode3/views/AboutMeDetailsPage.dart';
import 'package:appcode3/views/BookingScreen.dart';
import 'package:appcode3/views/CreateTrip.dart';
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

class AboutHost extends StatefulWidget {
  const AboutHost({super.key});

  @override
  State<AboutHost> createState() => _AboutHostState();
}

class _AboutHostState extends State<AboutHost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHT_GREY_SCREEN_BACKGROUND,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 243, 103, 9),
        title: Text('About host',
            // style: GoogleFonts.robotoCondensed(
            //   fontSize: 25,
            //   fontWeight: FontWeight.bold,
            //   color: WHITE,
            // ),
            style: Theme.of(context).textTheme.headline5!.apply(
                color: Theme.of(context).backgroundColor, fontWeightDelta: 5)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ContainerPage(),
    );
  }
}

class ContainerPage extends StatelessWidget {
  // Color _boxColor = Colors.white;
  // bool _isSelected = false;

  // void _changeColor() {
  //   setState(() {
  //     // Change box color to a random color
  //     _boxColor = Colors.green;
  //   });
  // }

  // void _toggleSelection() {
  //   setState(() {
  //     _isSelected = !_isSelected;
  //   });
  // }

  bool isButtonSelected = false;

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
                            size: 30.0, // Size of the icon
                          ),
                        ),
                      ),
                    ),
                    Row(children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 205.0),
                          child: Text(
                            'Motto',
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
                        onTap: () {
                          // Add your logic for the selection button onTap event here
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.green, // Color of the button
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black, // Color of the border
                              width: 1.0, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white, // Color of the icon
                            size: 30.0, // Size of the icon
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 130.0),
                            child: Text(
                              'I will show you',
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
                      ],
                    ),
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
                        onTap: () {
                          // Add your logic for the selection button onTap event here
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.green, // Color of the button
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black, // Color of the border
                              width: 1.0, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white, // Color of the icon
                            size: 30.0, // Size of the icon
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 175.0),
                            child: Text(
                              'Activities',
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
                            alignment: Alignment.centerRight,
                            icon: Icon(Icons.arrow_forward_ios_sharp),
                            color: Colors.black, // Color of the icon
                            iconSize: 24.0, // Size of the icon
                          ),
                        ),
                      ],
                    ),
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
                        onTap: () {
                          // Add your logic for the selection button onTap event here
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.green, // Color of the button
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black, // Color of the border
                              width: 1.0, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white, // Color of the icon
                            size: 30.0, // Size of the icon
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 160.0),
                            child: Text(
                              'Hourly rate',
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
                            alignment: Alignment.centerRight,
                            icon: Icon(Icons.arrow_forward_ios_sharp),
                            color: Colors.black, // Color of the icon
                            iconSize: 24.0, // Size of the icon
                          ),
                        ),
                      ],
                    ),
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
                        onTap: () {
                          // Add your logic for the selection button onTap event here
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.green, // Color of the button
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black, // Color of the border
                              width: 1.0, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white, // Color of the icon
                            size: 30.0, // Size of the icon
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 190.0),
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
                            alignment: Alignment.centerRight,
                            icon: Icon(Icons.arrow_forward_ios_sharp),
                            color: Colors.black, // Color of the icon
                            iconSize: 24.0, // Size of the icon
                          ),
                        ),
                      ],
                    ),
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
                        onTap: () {
                          // Add your logic for the selection button onTap event here
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.green, // Color of the button
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black, // Color of the border
                              width: 1.0, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white, // Color of the icon
                            size: 30.0, // Size of the icon
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 175.0),
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
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => LocationSearchPage(),
                              //   ),
                              // );
                              // Add your logic for the onPressed event here
                              // Typically, this would involve navigating to the next screen or performing some action
                            },
                            alignment: Alignment.centerRight,
                            icon: Icon(Icons.arrow_forward_ios_sharp),
                            color: Colors.black, // Color of the icon
                            iconSize: 24.0, // Size of the icon
                          ),
                        ),
                      ],
                    ),
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
                        onTap: () {
                          // Add your logic for the selection button onTap event here
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.green, // Color of the button
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black, // Color of the border
                              width: 1.0, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white, // Color of the icon
                            size: 30.0, // Size of the icon
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 170.0),
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
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => AboutMeDetailsPage(),
                              //   ),
                              // );
                              // Add your logic for the onPressed event here
                              // Typically, this would involve navigating to the next screen or performing some action
                            },
                            alignment: Alignment.centerRight,
                            icon: Icon(Icons.arrow_forward_ios_sharp),
                            color: Colors.black, // Color of the icon
                            iconSize: 24.0, // Size of the icon
                          ),
                        ),
                      ],
                    ),
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
                        onTap: () {
                          // Add your logic for the selection button onTap event here
                        },
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.green, // Color of the button
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black, // Color of the border
                              width: 1.0, // Width of the border
                            ), // Circular shape
                          ),
                          child: Icon(
                            Icons.check,
                            color: Colors.white, // Color of the icon
                            size: 30.0, // Size of the icon
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 190.0),
                            child: Text(
                              'Gender',
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
                            alignment: Alignment.centerRight,
                            icon: Icon(Icons.arrow_forward_ios_sharp),
                            color: Colors.black, // Color of the icon
                            iconSize: 24.0, // Size of the icon
                          ),
                        ),
                      ],
                    ),
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
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!isButtonSelected) {
                              isButtonSelected = true;
                            }
                            //isButtonSelected = !isButtonSelected;
                          });
                          // Add your logic for the selection button onTap event here
                        },
                        child: Container(
                          width: 30,
                          height: 30,

                          // primary: isButtonSelected
                          //     ? Color.fromARGB(255, 243, 103, 9)
                          //     : Colors.white, // Background color
                          // onPrimary:
                          //     isButtonSelected ? Colors.white : Colors.black,
                          decoration: BoxDecoration(
                            color: Colors.green, // Color of the button
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.black, // Color of the border
                              width: 1.0, // Width of the border
                            ), // Circular shape
                          ),
                          // child: IconButton(
                          //   onPressed: () {
                          //     // Add your logic for the onPressed event here
                          //     // Typically, this would involve navigating to the next screen or performing some action
                          //   },
                          //   icon: Icon(
                          //     Icons.check,
                          //     size: 30.0,
                          //     color: isButtonSelected
                          //         ? Colors.white
                          //         : Colors
                          //             .white, // Use onPrimary color for the icon
                          //   ),
                          //   color: isButtonSelected
                          //       ? Color.fromARGB(255, 243, 103, 9)
                          //       : Colors
                          //           .white, // Use primary color for the background
                          // ),
                          child: Icon(
                            Icons.check,
                            //color:
                            //  isButtonSelected ? Colors.white : Colors.white,
                            color: Colors.white, // Color of the icon
                            size: 30.0, // Size of the icon
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 155.0),
                            child: Text(
                              'Languages',
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
                            alignment: Alignment.centerRight,
                            icon: Icon(Icons.arrow_forward_ios_sharp),
                            color: Colors.black, // Color of the icon
                            iconSize: 24.0, // Size of the icon
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(
                height: 2,
                color: Colors.white10,
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(30),
          child: SizedBox(
            height: 70, // Adjust the height as needed
            child: ElevatedButton(
              onPressed: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) =>
                //         BookingScreen(widget.id, widget.guideName),
                //   ),
                // );
              },
              //child: Text('SUBMIT PROFILE'),
              child: Padding(
                padding: EdgeInsets.all(10), // Adjust padding as needed
                child: Text('SUBMIT PROFILE'),
              ),
              style: ElevatedButton.styleFrom(
                textStyle: GoogleFonts.robotoCondensed(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w500,
                ),
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 243, 103, 9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                    color: Colors.white,
                  ), // Set border radius
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void setState(Null Function() param0) {}
}
