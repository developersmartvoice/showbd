import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
//import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class AboutMeDetailsPage extends StatefulWidget {
  //const AboutMeDetailsPage({super.key});

  @override
  State<AboutMeDetailsPage> createState() => _AboutMeDetailsPageState();

  late final String id;
  late final String aboutMe;
  AboutMeDetailsPage(this.id, this.aboutMe);
}

class _AboutMeDetailsPageState extends State<AboutMeDetailsPage> {
  late TextEditingController _controller;
  String enteredValue = '';
  bool isValueChanged = false;
  void updatingAboutMe() async {
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/updateAboutUs"), body: {
      "id": widget.id,
      "aboutus": enteredValue,
    });
    print("$SERVER_ADDRESS/api/updateAboutUs");
    // print(response.body);
    if (response.statusCode == 200) {
      print("About Me Updated");
      setState(() {
        Navigator.of(context).pop(true);
      });
    } else {
      print("About Me Not Updated");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.aboutMe);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('About Me',
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
                  updatingAboutMe();
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("You didn't change anything!"),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"))
                        ],
                      );
                    },
                  );
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
          // height: MediaQuery.sizeOf(context).height * 1,
          child: Column(
            children: [
              // Container(
              //   color: Colors.white,
              //   child: Stack(
              //     children: [
              //       Positioned(
              //         left: 10, // Adjust the position of the button as needed
              //         top: 20, // Adjust the position of the button as needed
              //         child: InkWell(
              //             //onTap: _changeColor,
              //             // Add your logic for the selection button onTap event here

              //             // child: Container(
              //             //   width: 30,
              //             //   height: 30,
              //             //   decoration: BoxDecoration(
              //             //     //color: _boxColor, // Color of the button
              //             //     color: Colors.green,
              //             //     shape: BoxShape.circle,
              //             //     border: Border.all(
              //             //       color: Colors.black, // Color of the border
              //             //       width: 1.0, // Width of the border
              //             //     ), // Circular shape
              //             //   ),
              //             //   child: Icon(
              //             //     Icons.check,
              //             //     //color: _isSelected ? Colors.green : Colors.white,
              //             //     color: Colors.white, // Color of the icon
              //             //     size: 25.0, // Size of the icon
              //             //   ),
              //             // ),
              //             ),
              //       ),
              //       Container(
              //         color: LIGHT_GREY_SCREEN_BACKGROUND,
              //         height: 200,
              //         child: Container(
              //           height: 200,
              //           child: Row(
              //             children: [
              //               Expanded(
              //                 //child: Padding(
              //                 //padding: const EdgeInsets.only(left: 15),
              //                 child: Container(
              //                   height: 200,
              //                   child: Column(
              //                     children: [
              //                       Text(
              //                         "Feel free to share your hobbies, interests, or anything else you'd like!",
              //                         textAlign: TextAlign.center,
              //                         style: GoogleFonts.robotoCondensed(
              //                           fontSize: 15.0,
              //                           color: Colors.black,
              //                           fontWeight: FontWeight.w500,
              //                         ),
              //                       ),
              //                       SizedBox(
              //                         height: 1,
              //                       ),
              //                       Text(
              //                         "Note: All languages preferable, but kindly fill out in English now",
              //                         textAlign: TextAlign.center,
              //                         style: GoogleFonts.robotoCondensed(
              //                           fontSize: 15.0,
              //                           color: Colors.black,
              //                           fontWeight: FontWeight.w500,
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Divider(
              //   height: 5,
              //   color: Colors.grey,
              // ),
              // Container(
              //   color: Colors.white,
              //   height: 50,
              //   child: Row(
              //     children: [
              //       Expanded(
              //         //child:
              //         //Padding(
              //         //padding: const EdgeInsets.only(right: 190.0),
              //         child: TextField(
              //           textAlign: TextAlign.center,
              //           controller: TextEditingController(),
              //           style: TextStyle(
              //             color: Colors.black,
              //             fontSize: 18,
              //             fontWeight: FontWeight.w500,
              //           ), // Use a TextEditingController
              //           decoration: InputDecoration(
              //             hintText: 'More about you',
              //             border: OutlineInputBorder(),
              //             hintStyle: TextStyle(
              //                 color:
              //                     Colors.grey), // Border around the input field
              //           ),
              //         ),
              //       ),
              //       //),
              //     ],
              //   ),
              // ),
              // Divider(
              //   height: 2,
              //   color: Colors.grey,
              // ),
              Container(
                  // margin: EdgeInsets.only(top: 5),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        ABOUT_ME_COL1,
                        textAlign: TextAlign.justify, // Align text to center
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        ABOUT_ME_COL2,
                        textAlign: TextAlign.justify, // Align text to center
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: TextField(
                  controller: _controller,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                  ),
                  onChanged: (value) {
                    setState(() {
                      enteredValue = value;
                      if (enteredValue != widget.aboutMe) {
                        isValueChanged = true;
                      } else {
                        isValueChanged = false;
                      }
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: widget.aboutMe,
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
