import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
import 'package:flutter/widgets.dart';
import 'package:flutter_html/style.dart';
//import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

class PhotoSettingsPage extends StatefulWidget {
  //const NameSettingsPage({super.key});

  @override
  State<PhotoSettingsPage> createState() => _PhotoSettingsPageState();
  late final String id;
  late final String photos;
  //late final String aboutMe;
  //late final String city;

  PhotoSettingsPage(this.id, this.photos);
}

class _PhotoSettingsPageState extends State<PhotoSettingsPage> {
  File _pickedImage1 = File('');
  File _pickedImage2 = File('');
  File _pickedImage3 = File('');
  File _pickedImage4 = File('');
  File _pickedImage5 = File('');
  // Provide a default image path if needed

  //late File _pickedImage;
  late TextEditingController _controller;
  String enteredValue = '';
  bool isValueChanged = false;
  void updatingPhotos() async {
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/updatePhotos"), body: {
      "id": widget.id,
      "photos": enteredValue,
    });
    print("$SERVER_ADDRESS/api/updatePhotos");
    // print(response.body);
    if (response.statusCode == 200) {
      print("Photos Updated");
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print("Photos Not Updated");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.photos);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Photos',
              // style: GoogleFonts.robotoCondensed(
              //   color: Colors.white,
              //   fontSize: 25,
              //   fontWeight: FontWeight.w700,
              // ),
              style: Theme.of(context).textTheme.headline5!.apply(
                  color: Theme.of(context).backgroundColor,
                  fontWeightDelta: 5)),
          backgroundColor: const Color.fromARGB(255, 243, 103, 9),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                if (isValueChanged) {
                  updatingPhotos();
                } else {
                  // Navigator.pop(context);
                }
              },
              child: Text(
                'Save',
                style: GoogleFonts.robotoCondensed(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          color: LIGHT_GREY_SCREEN_BACKGROUND,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.topLeft,
                child: Column(
                  children: [
                    Text(
                      PHOTOS_PAGE,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      PHOTOS_PAGE_1,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: () async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Choose an Option"),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Text("Take a Photo"),
                                      onTap: () async {
                                        // Implement logic to take a photo
                                        print("Take a Photo pressed!");
                                        Navigator.pop(context);
                                        final pickedFile = await ImagePicker()
                                            .getImage(
                                                source: ImageSource.camera);
                                        if (pickedFile != null) {
                                          setState(() {
                                            _pickedImage1 =
                                                File(pickedFile.path);
                                          });
                                          // Handle the picked image file
                                          print(
                                              "Image taken: ${pickedFile.path}");
                                        } // Close the dialog
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                    ),
                                    GestureDetector(
                                      child: Text("Choose from Gallery"),
                                      onTap: () async {
                                        // Implement logic to choose from gallery
                                        print("Choose from Gallery pressed!");
                                        Navigator.pop(context);
                                        final pickedFile = await ImagePicker()
                                            .getImage(
                                                source: ImageSource.gallery);
                                        if (pickedFile != null) {
                                          print(
                                              "Image selected: ${pickedFile.path}");

                                          File imageFile =
                                              File(pickedFile.path);

                                          setState(() {
                                            _pickedImage1 = imageFile;
                                          });
                                          // Handle the picked image file
                                          // print(
                                          //     "Image selected: ${pickedFile.path}");

                                          // Set the picked image file to a variable
                                          // File imageFile =
                                          //     File(pickedFile.path);

                                          // Show the picked image on UI using Image.file widget
                                          // Example usage within a container:
                                          // Container(
                                          //   width: 90,
                                          //   height: 90,
                                          //   decoration: BoxDecoration(
                                          //     border: Border.all(
                                          //         color: Colors.grey),
                                          //   ),
                                          //   child: Image.file(
                                          //     _pickedImage1,
                                          //     fit: BoxFit.cover,
                                          //   ),
                                          // );
                                        } // Close the dialog
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                        // Implement your onPressed function here
                        // For example, you can show a dialog to choose a photo
                        print("Container pressed!");
                      },
                      child: Container(
                        width: 190,
                        height: 190, // Adjust height as needed
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey), // Optional border decoration
                        ),
                        child: _pickedImage1 != null
                            ? Image.file(
                                _pickedImage1,
                                fit: BoxFit.cover,
                              )
                            //     : Placeholder(),
                            // child: enteredValue.isNotEmpty
                            //     ? Image.network(
                            //         enteredValue,
                            //         fit: BoxFit.cover,
                            //       )
                            // : widget.photos.isNotEmpty
                            //     ? Image.file(
                            //         widget.photos as File,
                            //         fit: BoxFit.cover,
                            //       )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt),
                                  Text("Add Photo"),
                                ],
                              ),
                        //: Placeholder(), // Placeholder image if no image is set
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 1,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Choose an Option"),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Text("Take a Photo"),
                                        onTap: () async {
                                          // Implement logic to take a photo
                                          print("Take a Photo pressed!");
                                          Navigator.pop(context);
                                          final pickedFile = await ImagePicker()
                                              .getImage(
                                                  source: ImageSource.camera);
                                          if (pickedFile != null) {
                                            setState(() {
                                              _pickedImage2 =
                                                  File(pickedFile.path);
                                            });
                                            // Handle the picked image file
                                            print(
                                                "Image taken: ${pickedFile.path}");
                                          }
                                          // if (pickedFile != null) {
                                          //   // Handle the picked image file
                                          //   print(
                                          //       "Image taken: ${pickedFile.path}");
                                          // } // Close the dialog
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                      ),
                                      GestureDetector(
                                        child: Text("Choose from Gallery"),
                                        onTap: () async {
                                          // Implement logic to choose from gallery
                                          print("Choose from Gallery pressed!");
                                          Navigator.pop(context);
                                          final pickedFile = await ImagePicker()
                                              .getImage(
                                                  source: ImageSource.gallery);

                                          if (pickedFile != null) {
                                            print(
                                                "Image selected: ${pickedFile.path}");

                                            File imageFile =
                                                File(pickedFile.path);

                                            setState(() {
                                              _pickedImage2 = imageFile;
                                            });
                                            // if (pickedFile != null) {
                                            //   // Handle the picked image file
                                            //   print(
                                            //       "Image selected: ${pickedFile.path}");

                                            //   // Set the picked image file to a variable
                                            //   File imageFile =
                                            //       File(pickedFile.path);

                                            // Show the picked image on UI using Image.file widget
                                            // Example usage within a container:
                                            Container(
                                              width: 90,
                                              height: 90,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                              ),
                                              child: Image.file(
                                                _pickedImage2,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          } // Close the dialog
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          // Implement your onPressed function here
                          // For example, you can show a dialog to choose a photo
                          print("Container pressed!");
                        },
                        child: Container(
                          width: 90,
                          height: 90, // Adjust height as needed
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ), // Optional border decoration
                          ),
                          child: _pickedImage2 != null
                              ? Image.file(
                                  _pickedImage2,
                                  fit: BoxFit.cover,
                                )
                              // child: enteredValue.isNotEmpty
                              //     ? Image.network(
                              //         enteredValue,
                              //         fit: BoxFit.cover,
                              //       )
                              // : widget.photos.isNotEmpty
                              //     ? Image.file(
                              //         widget.photos as File,
                              //         fit: BoxFit.cover,
                              //       )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt),
                                    Text("Add Photo"),
                                  ],
                                ),
                          // : Placeholder(), // Placeholder image if no image is set
                        ),
                      ),
                      SizedBox(
                        height: 10, // Adjust spacing as needed
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Choose an Option"),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Text("Take a Photo"),
                                        onTap: () async {
                                          // Implement logic to take a photo
                                          print("Take a Photo pressed!");
                                          Navigator.pop(context);
                                          final pickedFile = await ImagePicker()
                                              .getImage(
                                                  source: ImageSource.camera);
                                          if (pickedFile != null) {
                                            setState(() {
                                              _pickedImage3 =
                                                  File(pickedFile.path);
                                            });
                                            // Handle the picked image file
                                            print(
                                                "Image taken: ${pickedFile.path}");
                                          }
                                          // if (pickedFile != null) {
                                          //   // Handle the picked image file
                                          //   print(
                                          //       "Image taken: ${pickedFile.path}");
                                          // } // Close the dialog
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                      ),
                                      GestureDetector(
                                        child: Text("Choose from Gallery"),
                                        onTap: () async {
                                          // Implement logic to choose from gallery
                                          print("Choose from Gallery pressed!");
                                          Navigator.pop(context);
                                          final pickedFile = await ImagePicker()
                                              .getImage(
                                                  source: ImageSource.gallery);
                                          if (pickedFile != null) {
                                            print(
                                                "Image selected: ${pickedFile.path}");

                                            File imageFile =
                                                File(pickedFile.path);

                                            setState(() {
                                              _pickedImage3 = imageFile;
                                            });
                                            // if (pickedFile != null) {
                                            //   // Handle the picked image file
                                            //   print(
                                            //       "Image selected: ${pickedFile.path}");

                                            //   // Set the picked image file to a variable
                                            //   File imageFile =
                                            //       File(pickedFile.path);

                                            // Show the picked image on UI using Image.file widget
                                            // Example usage within a container:
                                            Container(
                                              width: 90,
                                              height: 90,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                              ),
                                              child: Image.file(
                                                _pickedImage3,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          } // Close the dialog
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          // Implement your onPressed function here
                          // For example, you can show a dialog to choose a photo
                          print("Container pressed!");
                        },
                        child: Container(
                          width: 90,
                          height: 90, // Adjust height as needed
                          decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    Colors.grey), // Optional border decoration
                          ),
                          child: _pickedImage3 != null
                              ? Image.file(
                                  _pickedImage3,
                                  fit: BoxFit.cover,
                                )
                              // child: enteredValue.isNotEmpty
                              //     ? Image.network(
                              //         enteredValue,
                              //         fit: BoxFit.cover,
                              //       )
                              // : widget.photos.isNotEmpty
                              //     ? Image.file(
                              //         widget.photos as File,
                              //         fit: BoxFit.cover,
                              //       )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt),
                                    Text("Add Photo"),
                                  ],
                                ),
                          //: Placeholder(), // Placeholder image if no image is set
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Choose an Option"),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Text("Take a Photo"),
                                        onTap: () async {
                                          // Implement logic to take a photo
                                          print("Take a Photo pressed!");
                                          Navigator.pop(context);
                                          final pickedFile = await ImagePicker()
                                              .getImage(
                                                  source: ImageSource.camera);
                                          if (pickedFile != null) {
                                            setState(() {
                                              _pickedImage4 =
                                                  File(pickedFile.path);
                                            });
                                            // Handle the picked image file
                                            print(
                                                "Image taken: ${pickedFile.path}");
                                          }
                                          // if (pickedFile != null) {
                                          //   // Handle the picked image file
                                          //   print(
                                          //       "Image taken: ${pickedFile.path}");
                                          // } // Close the dialog
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                      ),
                                      GestureDetector(
                                        child: Text("Choose from Gallery"),
                                        onTap: () async {
                                          // Implement logic to choose from gallery
                                          print("Choose from Gallery pressed!");
                                          Navigator.pop(context);
                                          final pickedFile = await ImagePicker()
                                              .getImage(
                                                  source: ImageSource.gallery);
                                          if (pickedFile != null) {
                                            print(
                                                "Image selected: ${pickedFile.path}");

                                            File imageFile =
                                                File(pickedFile.path);

                                            setState(() {
                                              _pickedImage4 = imageFile;
                                            });
                                            // if (pickedFile != null) {
                                            //   // Handle the picked image file
                                            //   print(
                                            //       "Image selected: ${pickedFile.path}");

                                            //   // Set the picked image file to a variable
                                            //   File imageFile =
                                            //       File(pickedFile.path);

                                            // Show the picked image on UI using Image.file widget
                                            // Example usage within a container:
                                            Container(
                                              width: 90,
                                              height: 90,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                              ),
                                              child: Image.file(
                                                _pickedImage4,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          } // Close the dialog
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          // Implement your onPressed function here
                          // For example, you can show a dialog to choose a photo
                          print("Container pressed!");
                        },
                        child: Container(
                          width: 90,
                          height: 90, // Adjust height as needed
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ), // Optional border decoration
                          ),
                          child: _pickedImage4 != null
                              ? Image.file(
                                  _pickedImage4,
                                  fit: BoxFit.cover,
                                )
                              // child: enteredValue.isNotEmpty
                              //     ? Image.network(
                              //         enteredValue,
                              //         fit: BoxFit.cover,
                              //       )
                              // : widget.photos.isNotEmpty
                              //     ? Image.file(
                              //         widget.photos as File,
                              //         fit: BoxFit.cover,
                              //       )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt),
                                    Text("Add Photo"),
                                  ],
                                ),
                          // : Placeholder(), // Placeholder image if no image is set
                        ),
                      ),
                      SizedBox(
                        height: 10, // Adjust spacing as needed
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Choose an Option"),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      GestureDetector(
                                        child: Text("Take a Photo"),
                                        onTap: () async {
                                          // Implement logic to take a photo
                                          print("Take a Photo pressed!");
                                          Navigator.pop(context);
                                          final pickedFile = await ImagePicker()
                                              .getImage(
                                                  source: ImageSource.camera);
                                          if (pickedFile != null) {
                                            setState(() {
                                              _pickedImage5 =
                                                  File(pickedFile.path);
                                            });
                                            // Handle the picked image file
                                            print(
                                                "Image taken: ${pickedFile.path}");
                                          }
                                          // if (pickedFile != null) {
                                          //   // Handle the picked image file
                                          //   print(
                                          //       "Image taken: ${pickedFile.path}");
                                          // } // Close the dialog
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                      ),
                                      GestureDetector(
                                        child: Text("Choose from Gallery"),
                                        onTap: () async {
                                          // Implement logic to choose from gallery
                                          print("Choose from Gallery pressed!");
                                          Navigator.pop(context);
                                          final pickedFile = await ImagePicker()
                                              .getImage(
                                                  source: ImageSource.gallery);
                                          if (pickedFile != null) {
                                            print(
                                                "Image selected: ${pickedFile.path}");

                                            File imageFile =
                                                File(pickedFile.path);

                                            setState(() {
                                              _pickedImage5 = imageFile;
                                            });
                                            // if (pickedFile != null) {
                                            //   // Handle the picked image file
                                            //   print(
                                            //       "Image selected: ${pickedFile.path}");

                                            //   // Set the picked image file to a variable
                                            //   File imageFile =
                                            //       File(pickedFile.path);

                                            // Show the picked image on UI using Image.file widget
                                            // Example usage within a container:
                                            Container(
                                              width: 90,
                                              height: 90,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                              ),
                                              child: Image.file(
                                                _pickedImage5,
                                                fit: BoxFit.cover,
                                              ),
                                            );
                                          } // Close the dialog
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                          // Implement your onPressed function here
                          // For example, you can show a dialog to choose a photo
                          print("Container pressed!");
                        },
                        child: Container(
                          width: 90,
                          height: 90, // Adjust height as needed
                          decoration: BoxDecoration(
                            border: Border.all(
                                color:
                                    Colors.grey), // Optional border decoration
                          ),
                          child: _pickedImage5 != null
                              ? Image.file(
                                  _pickedImage5,
                                  fit: BoxFit.cover,
                                )
                              // child: enteredValue.isNotEmpty
                              //     ? Image.network(
                              //         enteredValue,
                              //         fit: BoxFit.cover,
                              //       )
                              // : widget.photos.isNotEmpty
                              //     ? Image.file(
                              //         widget.photos as File,
                              //         fit: BoxFit.cover,
                              //       )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt),
                                    Text("Add Photo"),
                                  ],
                                ),
                          // : Placeholder(), // Placeholder image if no image is set
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // SizedBox(
              //   height: 2,
              // ),
              Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.topLeft,
                child: Text(
                  PHOTOS_PAGE_3,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
              // SizedBox(
              //   width: 10,
              // ),
              //   SizedBox(
              //     width: 10,
              //   ),
            ],
          ),

          // Container(
          //   color: Colors.white,
          //   child: TextField(
          //     controller: _controller,
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 16,
          //       fontWeight: FontWeight.w200,
          //     ),
          //     onChanged: (value) {
          //       setState(
          //         () {
          //           enteredValue = value;
          //           if (enteredValue != widget.photos) {
          //             isValueChanged = true;
          //           } else {
          //             isValueChanged = false;
          //           }
          //         },
          //       );
          //     },
          //     decoration: InputDecoration(
          //       border: OutlineInputBorder(),
          //       hintText: widget.photos,
          //       hintStyle: TextStyle(color: Colors.black),
          //     ),
          //   ),
          // )
        ),
      ),
    );
  }
}
