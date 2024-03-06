import 'package:dropdown_search/dropdown_search.dart';
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

class LanguagesSettingsPage extends StatefulWidget {
  //const NameSettingsPage({super.key});

  @override
  State<LanguagesSettingsPage> createState() => _LanguagesSettingsPageState();
  late final String id;
  late final String languages;
  //late final String aboutMe;
  //late final String city;

  LanguagesSettingsPage(this.id, this.languages);
}

class _LanguagesSettingsPageState extends State<LanguagesSettingsPage> {
  List<String> languages = [
    'English',
    'Bengali',
    'Urdu',
    'Spanish',
    'French',
    'Hindi'
  ];
  Map<String, bool> selectedLanguages = {};
  bool isValueChanged = false;
  bool isLanguageSelected = false;
  //String selectedLanguage = '';

  bool isChecked = false;
  String selectedLanguage = "";

  //late String _selectedLanguage;

  //bool isMeetingTimeSelected = false; // Variable to store the selected language

  @override
  void initState() {
    super.initState();
    for (var language in languages) {
      selectedLanguages[language] = false;
    }
    //_selectedLanguage = widget.languages; // Set default selected language
  }

  late TextEditingController _controller;
  String enteredValue = '';
  //bool isValueChanged = false;
  void updatingLanguages(List<String> selectedLanguageList) async {
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/updateLanguages"), body: {
      "id": widget.id,
      "languages": enteredValue,
    });
    print("$SERVER_ADDRESS/api/updateLanguages");
    // print(response.body);
    if (response.statusCode == 200) {
      print("Languages Updated");
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print("Languages Not Updated");
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = TextEditingController(text: widget.languages);
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Languages',
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
                // if (isValueChanged) {
                //   updatingLanguages();
                if (selectedLanguages.isNotEmpty) {
                  List<String> selectedLanguageList = [
                    'English',
                    'Bengali',
                    'Urdu',
                    'Spanish',
                    'French',
                    'Hindi',
                  ];
                  selectedLanguages.forEach((key, value) {
                    if (value) {
                      selectedLanguageList.add(key);
                    }
                  });
                  print('Selected languages: $selectedLanguages');
                  updatingLanguages(selectedLanguageList);
                } else {
                  // Navigator.pop(context);
                }
              },
              child: Text(
                'Save',
                style: GoogleFonts.robotoCondensed(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  'Select Your Preferred Language',
                  style: GoogleFonts.robotoCondensed(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(
                height: 2,
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final language = languages[index];
                    return CheckboxListTile(
                      title: Text(language),
                      value: selectedLanguages.containsKey(language)
                          ? selectedLanguages[language]
                          : false,
                      //value: selectedLanguages[language],
                      onChanged: (value) {
                        setState(() {
                          selectedLanguages[language] = value!;
                          isValueChanged = true;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.trailing,
                      //itemAsString:
                      //isLanguageSelected ? selectedLanguages : widget.languages,
                    );
                  },
                ),
              ),

              // Expanded(
              //   child: ListView.builder(
              //     itemCount: languages.length,
              //     itemBuilder: (context, index) {
              //       return ListTile(
              //         title: Text(languages[index]),
              //         onTap: () {
              //           setState(() {
              //             selectedLanguage = languages[index];
              //           });
              //         },
              //         selected: selectedLanguage == languages[index],
              //         selectedTileColor: Colors.orange.withOpacity(0.5),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),

        // bottomNavigationBar: BottomAppBar(
        //   child: Padding(
        //     padding: EdgeInsets.all(16.0),
        //     child: Text(
        //       'Selected Languages: ${selectedLanguages.entries.where((entry) => entry.value).map((entry) => entry.key).toList()}',
        //       style: TextStyle(fontSize: 18.0),
        //     ),
        //   ),
        // ),
        // bottomNavigationBar: BottomAppBar(
        //   child: Padding(
        //     padding: EdgeInsets.all(16.0),
        //     child: Text(
        //       'Selected Language: $selectedLanguage',
        //       style: TextStyle(fontSize: 18.0),
        //     ),
        //   ),
        // ),
      ),
    );
  }
  // void updatingLanguages() {
  //   // Perform the update operation
  //   print('Updating languages...');
  //   setState(() {
  //     isValueChanged = false; // Reset the value changed flag
  //   });
  // }
}
//         Container(
//           color: LIGHT_GREY_SCREEN_BACKGROUND,
//           child: Column(
//             children: [
//               // Container(
//               //   padding: EdgeInsets.all(16),
//               //   alignment: Alignment.topLeft,
//               //   child: Text(
//               //     LANGUAGES_PAGE,
//               //     style: TextStyle(
//               //       color: Colors.black,
//               //       fontSize: 12,
//               //       fontWeight: FontWeight.w200,
//               //     ),
//               //   ),
//               // ),
//               SizedBox(
//                 height: 10,
//               ),
//               Container(
//                 color: Colors.white,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(top: 15.0),
//                       child: Text(
//                         LANGUAGES_PAGE,
//                         style: GoogleFonts.robotoCondensed(fontSize: 18),
//                       ),
//                     ),
//                     SizedBox(height: 15),

//                     Divider(
//                       height: 2,
//                     ),

//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           isChecked = !isChecked;
//                         });
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(16),
//                         alignment: Alignment.topLeft,
//                         child: Row(
//                           children: [
//                             SizedBox(width: 8),
//                             Text(
//                               "ENGLISH",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 12,
//                                 fontWeight: isChecked
//                                     ? FontWeight.bold
//                                     : FontWeight.w200,
//                               ),
//                             ),
//                             Spacer(),
//                             isChecked
//                                 ? Icon(
//                                     Icons.check,
//                                     color: Colors.black,
//                                     size: 20,
//                                   ) // Check icon
//                                 : SizedBox(), // Invisible placeholder if not checked
//                           ],
//                         ),
//                       ),
//                     ),

//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           isChecked = !isChecked;
//                         });
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(16),
//                         alignment: Alignment.topLeft,
//                         child: Row(
//                           children: [
//                             SizedBox(width: 8),
//                             Text(
//                               "BENGALI",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 12,
//                                 fontWeight: isChecked
//                                     ? FontWeight.bold
//                                     : FontWeight.w200,
//                               ),
//                             ),
//                             Spacer(),
//                             isChecked
//                                 ? Icon(
//                                     Icons.check,
//                                     color: Colors.black,
//                                     size: 20,
//                                   ) // Check icon
//                                 : SizedBox(), // Invisible placeholder if not checked
//                           ],
//                         ),
//                       ),
//                     ),

//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           isChecked = !isChecked;
//                         });
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(16),
//                         alignment: Alignment.topLeft,
//                         child: Row(
//                           children: [
//                             SizedBox(width: 8),
//                             Text(
//                               "ARABIC",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 12,
//                                 fontWeight: isChecked
//                                     ? FontWeight.bold
//                                     : FontWeight.w200,
//                               ),
//                             ),
//                             Spacer(),
//                             isChecked
//                                 ? Icon(
//                                     Icons.check,
//                                     color: Colors.black,
//                                     size: 20,
//                                   ) // Check icon
//                                 : SizedBox(), // Invisible placeholder if not checked
//                           ],
//                         ),
//                       ),
//                     ),

//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           isChecked = !isChecked;
//                         });
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(16),
//                         alignment: Alignment.topLeft,
//                         child: Row(
//                           children: [
//                             SizedBox(width: 8),
//                             Text(
//                               "HINDI",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 12,
//                                 fontWeight: isChecked
//                                     ? FontWeight.bold
//                                     : FontWeight.w200,
//                               ),
//                             ),
//                             Spacer(),
//                             isChecked
//                                 ? Icon(
//                                     Icons.check,
//                                     color: Colors.black,
//                                     size: 20,
//                                   ) // Check icon
//                                 : SizedBox(), // Invisible placeholder if not checked
//                           ],
//                         ),
//                       ),
//                     ),

//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           isChecked = !isChecked;
//                         });
//                       },
//                       child: Container(
//                         padding: EdgeInsets.all(16),
//                         alignment: Alignment.topLeft,
//                         child: Row(
//                           children: [
//                             SizedBox(width: 8),
//                             Text(
//                               "GERMAN",
//                               style: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 12,
//                                 fontWeight: isChecked
//                                     ? FontWeight.bold
//                                     : FontWeight.w200,
//                               ),
//                             ),
//                             Spacer(),
//                             isChecked
//                                 ? Icon(
//                                     Icons.check,
//                                     color: Colors.black,
//                                     size: 20,
//                                   ) // Check icon
//                                 : SizedBox(), // Invisible placeholder if not checked
//                           ],
//                         ),
//                       ),
//                     ),

//                     //       Container(
//                     //         //padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
//                     //         color: Colors.white,
//                     //         child: Align(
//                     //           alignment: Alignment.centerLeft,
//                     //           child: DropdownSearch<String>(
//                     //             items: [
//                     //               'English',
//                     //               'Bengali',
//                     //               'Arabic',
//                     //               'Spanish',
//                     //               'Japanese',
//                     //               'Korean',
//                     //               'Chinese'
//                     //             ],
//                     //             onChanged: (value) {
//                     //               setState(() {
//                     //                 selectedMeetingTime = value!;
//                     //                 if (selectedMeetingTime.isNotEmpty) {
//                     //                   isMeetingTimeSelected = true;
//                     //                 } else {
//                     //                   isMeetingTimeSelected = false;
//                     //                 }
//                     //               });
//                     //             },
//                     //             selectedItem: selectedMeetingTime,
//                     //           ),
//                     //         ),
//                     //       ),
//                     //       // DropdownButton<String>(
//                     //       //   value: _selectedLanguage,
//                     //       //   // onChanged: (String newValue) {
//                     //       //   //   setState(() {
//                     //       //   //     _selectedLanguage = newValue;
//                     //       //   //   });
//                     //       //   // },
//                     //       //   items: <String>['English', 'French', 'Spanish', 'German']
//                     //       //       .map<DropdownMenuItem<String>>((String value) {
//                     //       //     return DropdownMenuItem<String>(
//                     //       //       value: value,
//                     //       //       child: Text(value),
//                     //       //     );
//                     //       //   }).toList(),
//                     //       // ),
//                     //       SizedBox(height: 15),
//                     //       ElevatedButton(
//                     //         onPressed: () {
//                     //           // Handle selection here, e.g., save selected language
//                     //           print('Selected language: $_selectedLanguage');
//                     //         },
//                     //         child: Text('Continue'),
//                     //         style: ElevatedButton.styleFrom(
//                     //           textStyle: GoogleFonts.robotoCondensed(
//                     //             fontSize: 15.0,
//                     //             fontWeight: FontWeight.bold,
//                     //           ),
//                     //           //padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
//                     //           foregroundColor: Colors.white,
//                     //           backgroundColor: Color.fromARGB(255, 243, 103, 9),
//                     //           shape: RoundedRectangleBorder(
//                     //             borderRadius: BorderRadius.circular(10.0),
//                     //             side: BorderSide(
//                     //               color: Colors.white,
//                     //             ), // Set border radius
//                     //           ),
//                     //         ),
//                     //       ),

//                     //       // TextField(
//                     //       //   controller: _controller,
//                     //       //   style: TextStyle(
//                     //       //     color: Colors.black,
//                     //       //     fontSize: 16,
//                     //       //     fontWeight: FontWeight.w200,
//                     //       //   ),
//                     //       //   onChanged: (value) {
//                     //       //     setState(
//                     //       //       () {
//                     //       //         enteredValue = value;
//                     //       //         if (enteredValue != widget.languages) {
//                     //       //           isValueChanged = true;
//                     //       //         } else {
//                     //       //           isValueChanged = false;
//                     //       //         }
//                     //       //       },
//                     //       //     );
//                     //       //   },
//                     //       //   decoration: InputDecoration(
//                     //       //     border: OutlineInputBorder(),
//                     //       //     hintText: widget.languages,
//                     //       //     hintStyle: TextStyle(color: Colors.black),
//                     //       //   ),
//                     //       // ),
//                     //     ],
//                     //   ),
//                     // ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
