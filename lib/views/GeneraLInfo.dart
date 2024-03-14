import 'package:appcode3/views/AboutMeDetailsPage.dart';
import 'package:appcode3/views/CreateTrip.dart';
import 'package:appcode3/views/EmailDetailsPage.dart';
import 'package:appcode3/views/LocationSearchPageInfo.dart';
import 'package:appcode3/views/NameSettingsPage.dart';
import 'package:appcode3/views/PhotoSettingsPage.dart';
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
import 'package:get/get.dart';
//import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

class GeneraLInfo extends StatefulWidget {
  // const GeneraLInfo({super.key});
  final String doctorId;

  GeneraLInfo(this.doctorId);

  @override
  State<GeneraLInfo> createState() => _GeneraLInfoState();
}

class _GeneraLInfoState extends State<GeneraLInfo> {
  String name = '';
  String about_me = '';
  String location = '';
  String photos = '';
  String imageUrl1 = '';
  // String imageUrls = '';
  List<String>? imageUrls;

  bool isNameFetched = false;
  bool isAboutMeFetched = false;
  bool isLocationFetched = false;
  bool isPhotosFetched = false;

  getName() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/getName?id=${widget.doctorId}"));
    print("$SERVER_ADDRESS/api/getName?id=${widget.doctorId}");
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          name = jsonResponse['name'].toString();
          print(name);
          isNameFetched = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  getAboutMe() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/getAboutUs?id=${widget.doctorId}"));
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          about_me = jsonResponse['aboutus'].toString();
          print(about_me);
          isAboutMeFetched = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  getCity() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/getCity?id=${widget.doctorId}"));
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          location = jsonResponse['city'].toString();
          print(location);
          isLocationFetched = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  // getPhotos() async {
  //   final response = await get(
  //       Uri.parse("$SERVER_ADDRESS/api/getPhotos?id=${widget.doctorId}"));
  //   try {
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       setState(() {
  //         photos = jsonResponse['photos'].toString();
  //         print(photos);
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  getImage() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/getImage?doctor_id=${widget.doctorId}"));

    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          imageUrl1 = jsonResponse['image_url'] ?? "";

          print("Only Image downloaded and assigned: $imageUrl1");
        });
      } else {
        print("Failed to fetch image. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching image: $e");
    }
  }

  Future<void> getImages() async {
    final Uri uri =
        Uri.parse("$SERVER_ADDRESS/api/getImages?doctor_id=${widget.doctorId}");
    final response = await get(uri);

    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        imageUrls = List<String>.from(jsonResponse['image_urls'] ?? "");
        setState(() {
          if (imageUrls == null) {
            imageUrls = [];
            isPhotosFetched = true;
          } else {
            isPhotosFetched = true;
            imageUrls!.forEach((imageUrl) {
              print("Image downloaded and assigned: $imageUrl");
              // Here you can do whatever you want with the downloaded images
            });
          }
        });
      } else {
        print("Failed to fetch images. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching images: $e");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getName();
    getAboutMe();
    getCity();
    // getPhotos();
    getImage();
    getImages();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: LIGHT_GREY_SCREEN_BACKGROUND,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 243, 103, 9),
          centerTitle: true,
          title: Text('General information',
              // style: GoogleFonts.robotoCondensed(
              //   color: Colors.white,
              //   fontSize: 25,
              //   fontWeight: FontWeight.w700, // Title text color
              // ),
              style: Theme.of(context).textTheme.headline5!.apply(
                  color: Theme.of(context).backgroundColor,
                  fontWeightDelta: 5)),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black, // Back button color
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: isNameFetched &&
                isPhotosFetched &&
                isLocationFetched &&
                isAboutMeFetched
            ? ContainerPage(widget.doctorId, name, about_me, location,
                imageUrl1, imageUrls!)
            : Container(
                alignment: Alignment.center,
                transformAlignment: Alignment.center,
                child: CircularProgressIndicator()),
      ),
    );
  }
}

class ContainerPage extends StatefulWidget {
  final String id;
  final String name;
  final String aboutMe;
  final String city;
  final String imageUrl1;
  // final String imageUrls;
  final List<String> imageUrls;

  ContainerPage(this.id, this.name, this.aboutMe, this.city, this.imageUrl1,
      this.imageUrls);
  @override
  _ContainerPageState createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  bool isNameStored = false;
  bool isAboutMeStored = false;
  bool isLocationStored = false;
  bool isPhotoStored = false;
  bool isImageStored = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.name.isNotEmpty) {
      setState(() {
        isNameStored = true;
      });
    }

    if (widget.aboutMe.isNotEmpty) {
      setState(() {
        isAboutMeStored = true;
      });
    }

    if (widget.city.isNotEmpty) {
      setState(() {
        isLocationStored = true;
      });
    }
    if (widget.imageUrl1.isNotEmpty) {
      setState(() {
        isPhotoStored = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                height: 60,
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            NameSettingsPage(widget.id, widget.name),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width * .1,
                            height: 25,
                            decoration: BoxDecoration(
                              //color: _boxColor, // Color of the button
                              color: isNameStored ? Colors.green : Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey, // Color of the border
                                width: 0.5, // Width of the border
                              ), // Circular shape
                            ),
                            child: Icon(
                              Icons.check,
                              color:
                                  !isNameStored ? Colors.green : Colors.white,
                              // color: Colors.white, // Color of the icon
                              size: 20.0, // Size of the icon
                            ),
                          )
                        ],
                      ),
                      // SizedBox(
                      //   width: MediaQuery.sizeOf(context).width * .01,
                      // ),
                      Container(
                        padding: EdgeInsets.only(right: 22),
                        alignment: Alignment.center,
                        width: MediaQuery.sizeOf(context).width * .2,
                        child: Text(
                          NAME,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            // color: Color.fromARGB(255, 243, 103, 9),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .1,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: MediaQuery.sizeOf(context).width * .4,
                        child: Text(
                          widget.name,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .05,
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * .1,
                        // child: IconButton(
                        //     onPressed: () {},
                        //     icon: Icon(Icons.arrow_forward_ios)),
                        child: Icon(Icons.arrow_forward_ios, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.white10,
              ),
              Container(
                padding: EdgeInsets.all(10),
                height: 60,
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            AboutMeDetailsPage(widget.id, widget.aboutMe),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width * .1,
                            height: 25,
                            decoration: BoxDecoration(
                              //color: _boxColor, // Color of the button
                              color:
                                  isAboutMeStored ? Colors.green : Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey, // Color of the border
                                width: 0.5, // Width of the border
                              ), // Circular shape
                            ),
                            child: Icon(
                              Icons.check,
                              color: !isAboutMeStored
                                  ? Colors.green
                                  : Colors.white,
                              // color: Colors.white, // Color of the icon
                              size: 20.0, // Size of the icon
                            ),
                          )
                        ],
                      ),
                      // SizedBox(
                      //   width: MediaQuery.sizeOf(context).width * .01,
                      // ),
                      Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(left: 5),
                          width: MediaQuery.sizeOf(context).width * .2,
                          child: Text(
                            ABOUT,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              // color: Color.fromARGB(255, 243, 103, 9),
                            ),
                          )),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .1,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: MediaQuery.sizeOf(context).width * .4,
                        child: Text(
                          widget.aboutMe,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .05,
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * .1,
                        // child: IconButton(
                        //     onPressed: () {},
                        //     icon: Icon(Icons.arrow_forward_ios)),
                        child: Icon(Icons.arrow_forward_ios, size: 20),
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.white10,
              ),

              Container(
                padding: EdgeInsets.all(10),
                height: 60,
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PhotoSettingsPage(
                            widget.id, widget.imageUrl1, widget.imageUrls),
                      ),
                    );
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) =>
                    //         NameSettingsPage(widget.id, widget.name),
                    //   ),
                    // );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width * .1,
                            height: 25,
                            decoration: BoxDecoration(
                              // color: Colors.white,
                              // color: _boxColor, // Color of the button
                              color: isPhotoStored ? Colors.green : Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey, // Color of the border
                                width: 0.5, // Width of the border
                              ), // Circular shape
                            ),
                            child: Icon(
                              Icons.check,
                              color:
                                  !isPhotoStored ? Colors.green : Colors.white,
                              // color: Colors.white, // Color of the icon
                              size: 20.0, // Size of the icon
                            ),
                          )
                        ],
                      ),
                      // SizedBox(
                      //   width: MediaQuery.sizeOf(context).width * .01,
                      // ),
                      Container(
                        padding: EdgeInsets.only(right: 15),
                        alignment: Alignment.center,
                        width: MediaQuery.sizeOf(context).width * .2,
                        child: Text(
                          'Photos',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            // color: Color.fromARGB(255, 243, 103, 9),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .1,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: MediaQuery.sizeOf(context).width * .4,
                        child: Text(
                            // widget.name,
                            // style: TextStyle(
                            //   fontSize: 18.0,
                            //   fontWeight: FontWeight.bold,
                            //   color: Colors.grey,
                            // ),
                            ""),
                      ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .05,
                      ),
                      Container(
                        // padding: EdgeInsets.only(left: 180),
                        width: MediaQuery.sizeOf(context).width * .1,
                        child: Icon(Icons.arrow_forward_ios, size: 20),
                      ),
                    ],
                  ),
                ),
              ),
              // Container(
              //   height: 70,
              //   color: Colors.white,
              //   child: Stack(
              //     children: [
              //       Positioned(
              //         left: 15, // Adjust the position of the button as needed
              //         top: 20, // Adjust the position of the button as needed
              //         child: InkWell(
              //           //onTap: _changeColor,
              //           // Add your logic for the selection button onTap event here

              //           child: Container(
              //             width: 30,
              //             height: 30,
              //             decoration: BoxDecoration(
              //               //color: _boxColor, // Color of the button
              //               color: Colors.green,
              //               shape: BoxShape.circle,
              //               border: Border.all(
              //                 color: Colors.black, // Color of the border
              //                 width: 1.0, // Width of the border
              //               ), // Circular shape
              //             ),
              //             child: Icon(
              //               Icons.check,
              //               //color: _isSelected ? Colors.green : Colors.white,
              //               color: Colors.white, // Color of the icon
              //               size: 25.0, // Size of the icon
              //             ),
              //           ),
              //         ),
              //       ),
              //       // Row(children: [
              //       //   Expanded(
              //       //     //child:
              //       //     //Padding(
              //       //     //padding: const EdgeInsets.only(right: 195.0),
              //       //     child: Container(
              //       //       padding: EdgeInsets.only(right: 200),
              //       //       child: Text(
              //       //         'Photos',
              //       //         textAlign: TextAlign.center,
              //       //         style: GoogleFonts.robotoCondensed(
              //       //           fontSize: 20.0,
              //       //           color: Colors.black,
              //       //           fontWeight: FontWeight.w500,
              //       //         ),
              //       //       ),
              //       //     ),
              //       //     // ),
              //       //   ),
              //       //   Align(
              //       //     alignment: Alignment.centerRight,
              //       //     child: Container(
              //       //       padding: EdgeInsets.only(right: 10),
              //       //       child: IconButton(
              //       //         onPressed: () {
              //       //           // Add your logic for the onPressed event here
              //       //           // Typically, this would involve navigating to the next screen or performing some action
              //       //         },
              //       //         //alignment: Alignment.centerRight,
              //       //         icon: Icon(Icons.arrow_forward_ios_sharp),
              //       //         color: Colors.black, // Color of the icon
              //       //         iconSize: 24.0, // Size of the icon
              //       //       ),
              //       //     ),
              //       //   ),
              //       // ]),
              //     ],
              //   ),
              // ),
              Divider(
                height: 1,
                color: Colors.white10,
              ),
              // Container(
              //   height: 70,
              //   color: Colors.white,
              //   child: Stack(
              //     children: [
              //       Positioned(
              //         left: 10, // Adjust the position of the button as needed
              //         top: 20, // Adjust the position of the button as needed
              //         child: InkWell(
              //           //onTap: _changeColor,
              //           // Add your logic for the selection button onTap event here

              //           child: Container(
              //             width: 30,
              //             height: 30,
              //             decoration: BoxDecoration(
              //               //color: _boxColor, // Color of the button
              //               color: Colors.green,
              //               shape: BoxShape.circle,
              //               border: Border.all(
              //                 color: Colors.black, // Color of the border
              //                 width: 1.0, // Width of the border
              //               ), // Circular shape
              //             ),
              //             child: Icon(
              //               Icons.check,
              //               //color: _isSelected ? Colors.green : Colors.white,
              //               color: Colors.white, // Color of the icon
              //               size: 25.0, // Size of the icon
              //             ),
              //           ),
              //         ),
              //       ),
              //       Row(children: [
              //         Expanded(
              //           child: Padding(
              //             padding: const EdgeInsets.only(right: 165.0),
              //             child: Text(
              //               'Location',
              //               textAlign: TextAlign.center,
              //               style: GoogleFonts.robotoCondensed(
              //                 fontSize: 20.0,
              //                 color: Colors.black,
              //                 fontWeight: FontWeight.w500,
              //               ),
              //             ),
              //           ),
              //         ),
              //         Align(
              //           alignment: Alignment.centerRight,
              //           child: IconButton(
              //             onPressed: () {
              //               Navigator.of(context).push(
              //                 MaterialPageRoute(
              //                   builder: (context) => LocationSearchPage(),
              //                 ),
              //               );
              //               // Add your logic for the onPressed event here
              //               // Typically, this would involve navigating to the next screen or performing some action
              //             },
              //             //alignment: Alignment.centerRight,
              //             icon: Icon(Icons.arrow_forward_ios_sharp),
              //             color: Colors.black, // Color of the icon
              //             iconSize: 24.0, // Size of the icon
              //           ),
              //         ),
              //       ]),
              //     ],
              //   ),
              // ),

              Container(
                padding: EdgeInsets.all(10),
                height: 60,
                color: Colors.white,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            LocationSearchPageInfo(widget.id, widget.city),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.sizeOf(context).width * .1,
                            height: 25,
                            decoration: BoxDecoration(
                              //color: _boxColor, // Color of the button
                              color:
                                  isLocationStored ? Colors.green : Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey, // Color of the border
                                width: 0.5, // Width of the border
                              ), // Circular shape
                            ),
                            child: Icon(
                              Icons.check,
                              color: !isLocationStored
                                  ? Colors.green
                                  : Colors.white,
                              // color: Colors.white, // Color of the icon
                              size: 20.0, // Size of the icon
                            ),
                          )
                        ],
                      ),
                      // SizedBox(
                      //   width: MediaQuery.sizeOf(context).width * .01,
                      // ),
                      Container(
                          alignment: Alignment.center,
                          width: MediaQuery.sizeOf(context).width * .2,
                          child: Text(
                            LOCATION,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              // color: Color.fromARGB(255, 243, 103, 9),
                            ),
                          )),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .1,
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: MediaQuery.sizeOf(context).width * .4,
                        child: Text(
                          widget.city,
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * .05,
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * .1,
                        // child: IconButton(
                        //     onPressed: () {},
                        //     icon: Icon(Icons.arrow_forward_ios)),
                        child: Icon(Icons.arrow_forward_ios, size: 20),
                      )
                    ],
                  ),
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
