import 'package:flutter/material.dart';
import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class LanguageNew extends StatefulWidget {
  @override
  State<LanguageNew> createState() => _LanguageNewState();
  late final String id;
  late final List<String> languages;
  LanguageNew(this.id, this.languages);
}

class _LanguageNewState extends State<LanguageNew> {
  List<String> selectedLanguages = [];
  bool isLanguageSelected = false;

  void updatingLanguages() async {
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/updateLanguages"), body: {
      "id": widget.id,
      "languages":
          selectedLanguages.join(','), // Convert list to comma-separated string
    });
    print("$SERVER_ADDRESS/api/updateLanguages");
    print(response.body);
    if (response.statusCode == 200) {
      print("Language Updated");
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print("Language Not Updated");
    }
  }

  @override
  void initState() {
    super.initState();
    selectedLanguages = List.from(
        widget.languages); // Initialize selectedLanguages with widget.languages
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input.substring(0, 1).toUpperCase() + input.substring(1);
  }

  CheckboxListTile buildCheckboxListTile(
      String key, String title, List<String> list) {
    return CheckboxListTile(
      dense: true,
      contentPadding: EdgeInsets.zero, // Set contentPadding to zero
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      title: Text(title),
      value: list.contains(key),
      onChanged: (newValue) {
        setState(() {
          if (newValue == true) {
            list.add(key);
          } else {
            list.remove(key);
          }
          isLanguageSelected =
              true; // Set isLanguageSelected to true whenever a language is selected or unselected
          print(list);
        });
      },
    );
  }

  Map<String, String> languageMap = {
    "english": "English",
    "bengali": "Bengali",
    "hindi": "Hindi",
    "urdu": "Urdu",
    "french": "French",
    "spanish": "Spanish"
  };

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Languages',
            style: Theme.of(context).textTheme.headline5!.apply(
                  color: Theme.of(context).backgroundColor,
                  fontWeightDelta: 5,
                ),
          ),
          backgroundColor: const Color.fromARGB(255, 243, 103, 9),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                if (isLanguageSelected && selectedLanguages.isNotEmpty) {
                  updatingLanguages();
                } else {
                  // Show a snackbar or some feedback to inform the user to select at least one language before saving
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: Color.fromARGB(255, 224, 16, 1),
                    content: Text(
                      'Please select at least one language.',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      textScaleFactor: 1.2,
                    ),
                  ));
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
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  HEALTHCARE,
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).primaryColorDark.withOpacity(0.4),
                    fontWeight: FontWeight.w900,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                height: 200,
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: languageMap.keys.map((key) {
                    return buildCheckboxListTile(
                        key,
                        capitalizeFirstLetter(languageMap[key]!),
                        selectedLanguages);
                  }).toList(),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width * 0.4,
                // child: Text(
                //   selectedLanguages
                //       .map((language) => capitalizeFirstLetter(language))
                //       .join(', '),
                //   style: TextStyle(
                //     fontSize: 15.0,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.grey,
                //   ),
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





























// // import 'package:dropdown_search/dropdown_search.dart';
// import 'package:flutter/material.dart';

// // import 'dart:convert';
// // import 'dart:ui';
// // import 'package:appcode3/views/BookingScreen.dart';
// // import 'package:appcode3/views/Doctor/DoctorProfile.dart';
// // import 'package:appcode3/views/Doctor/LogoutScreen.dart';
// // import 'package:appcode3/views/Doctor/loginAsDoctor.dart';
// // import 'package:appcode3/views/SendOfferScreen.dart';
// // import 'package:appcode3/views/SendOffersScreen.dart';
// // import 'package:connectycube_sdk/connectycube_chat.dart';

// import 'package:appcode3/en.dart';
// import 'package:appcode3/main.dart';
// // import 'package:appcode3/modals/DoctorAppointmentClass.dart';
// // import 'package:appcode3/modals/DoctorPastAppointmentsClass.dart';
// // import 'package:appcode3/views/Doctor/DoctorChatListScreen.dart';
// // import 'package:appcode3/views/Doctor/DoctorAllAppointments.dart';
// // import 'package:appcode3/views/Doctor/DoctorAppointmentDetails.dart';
// // import 'package:appcode3/views/Doctor/DoctorProfileWithRating.dart';
// // import 'package:appcode3/views/Doctor/moreScreen/change_password_screen.dart';
// // import 'package:appcode3/views/Doctor/moreScreen/income_report.dart';
// // import 'package:appcode3/views/Doctor/moreScreen/subscription_screen.dart';

// // import 'package:cached_network_image/cached_network_image.dart';
// //import 'package:facebook_audience_network/ad/ad_native.dart';
// // import 'package:firebase_messaging/firebase_messaging.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_html/style.dart';
// //import 'package:flutter_native_admob/flutter_native_admob.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // import 'package:flutter/material.dart';

// class LanguageNew extends StatefulWidget {
//   //const NameSettingsPage({super.key});

//   @override
//   State<LanguageNew> createState() => _LanguageNewState();
//   late final String id;
//   //late final String gender;
//   late final List<String> languages;
//   //late final String aboutMe;
//   //late final String city;

//   LanguageNew(this.id, this.languages);
// }

// class _LanguageNewState extends State<LanguageNew> {
//   // String selectedLanguage = "";
//   List<String> selectedLanguages = [];
//   // late TextEditingController _controller;
//   // String enteredValue = '';
//   bool isGenderSelected = false;
//   bool isLanguageSelected = false;
//   bool isValueChanged = false;

//   // void updatingLanguages() async {
//   //   final response =
//   //       await post(Uri.parse("$SERVER_ADDRESS/api/updateLanguages"), body: {
//   //     "id": widget.id,
//   //     "languages": selectedLanguages,
//   //   });
//   //   print("$SERVER_ADDRESS/api/updateLanguages");
//   //   print(response.body);
//   //   if (response.statusCode == 200) {
//   //     print("Language Updated");
//   //     setState(() {
//   //       Navigator.pop(context);
//   //     });
//   //   } else {
//   //     print("Language Not Updated");
//   //   }
//   // }

//   void updatingLanguages() async {
//     final response =
//         await post(Uri.parse("$SERVER_ADDRESS/api/updateLanguages"), body: {
//       "id": widget.id,
//       "languages":
//           selectedLanguages.join(','), // Convert list to comma-separated string
//     });
//     print("$SERVER_ADDRESS/api/updateLanguages");
//     print(response.body);
//     if (response.statusCode == 200) {
//       print("Language Updated");
//       setState(() {
//         Navigator.pop(context);
//       });
//     } else {
//       print("Language Not Updated");
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     // _controller = TextEditingController(text: widget.languages);
//   }

//   CheckboxListTile buildCheckboxListTile(
//       String key, String title, List<String> list) {
//     return CheckboxListTile(
//       dense: true,
//       contentPadding: EdgeInsets.zero, // Set contentPadding to zero
//       visualDensity: VisualDensity(horizontal: 0, vertical: -4),
//       title: Text(title),
//       value: list.contains(key),
//       onChanged: (newValue) {
//         // list1.addAll(list);
//         setState(() {
//           if (newValue == true) {
//             list.add(key);
//           } else {
//             list.remove(key);
//           }
//           print(list);
//         });
//       },
//     );
//   }

//   Map<String, String> languageMap = {
//     "english": "English",
//     "bengali": "Bengali",
//     "hindi": "Hindi",
//     "urdu": "Urdu",
//     "french": "French",
//     "spanish": "Spanish"
//   };

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'Languages',
//             // style: GoogleFonts.robotoCondensed(
//             //   color: Colors.white,
//             //   fontSize: 25,
//             //   fontWeight: FontWeight.w700,
//             // ),
//             style: Theme.of(context).textTheme.headline5!.apply(
//                   color: Theme.of(context).backgroundColor,
//                   fontWeightDelta: 5,
//                 ),
//           ),
//           backgroundColor: const Color.fromARGB(255, 243, 103, 9),
//           centerTitle: true,
//           actions: [
//             TextButton(
//               onPressed: () {
//                 if (isLanguageSelected) {
//                   updatingLanguages();
//                 } else {
//                   // Navigator.pop(context);
//                 }
//               },
//               child: Text(
//                 'Save',
//                 style: GoogleFonts.robotoCondensed(
//                   color: Colors.black,
//                   fontSize: 20,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         body: Container(
//           color: LIGHT_GREY_SCREEN_BACKGROUND,
//           child: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
//                 child: Text(
//                   'Select Your Preferred Language',
//                   style: GoogleFonts.robotoCondensed(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               // Container(
//               //   padding: EdgeInsets.all(16),
//               //   alignment: Alignment.topLeft,
//               //   child: Text(
//               //     GENDER_PAGE,
//               //     style: TextStyle(
//               //       color: Colors.black,
//               //       fontSize: 12,
//               //       fontWeight: FontWeight.w200,
//               //     ),
//               //   ),
//               // ),

//               Container(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   HEALTHCARE,
//                   style: GoogleFonts.poppins(
//                     color: Theme.of(context).primaryColorDark.withOpacity(0.4),
//                     fontWeight: FontWeight.w900,
//                     fontSize: 18,
//                   ),
//                 ),
//               ),
//               Container(
//                 height: 200,
//                 child: ListView(
//                   physics: NeverScrollableScrollPhysics(),
//                   children: languageMap.keys.map((key) {
//                     return buildCheckboxListTile(
//                         key, languageMap[key]!, selectedLanguages);
//                   }).toList(),
//                 ),
//               ),

//               // SizedBox(
//               //   height: 10,
//               // ),
//               // Container(
//               //   color: Colors.white,
//               //   child: DropdownSearch<String>(
//               //     items: [
//               //       'English',
//               //       'Bengali',
//               //       'Hindi',
//               //       'Urdu',
//               //       'German',
//               //       'Korean',
//               //       'Spanish',
//               //       'Arabic',
//               //     ],
//               //     onChanged: (value) {
//               //       setState(() {
//               //         selectedLanguage = value!;
//               //         if (selectedLanguage.isNotEmpty) {
//               //           isLanguageSelected = true;
//               //         } else {
//               //           isLanguageSelected = false;
//               //         }
//               //       });
//               //     },
//               //     selectedItem:
//               //         isLanguageSelected ? selectedLanguage : widget.languages,
//               //   ),
//               //   // TextField(
//               //   //   controller: _controller,
//               //   //   style: TextStyle(
//               //   //     color: Colors.black,
//               //   //     fontSize: 16,
//               //   //     fontWeight: FontWeight.w200,
//               //   //   ),
//               //   //   onChanged: (value) {
//               //   //     setState(
//               //   //       () {
//               //   //         enteredValue = value;
//               //   //         if (enteredValue != widget.gender) {
//               //   //           isValueChanged = true;
//               //   //         } else {
//               //   //           isValueChanged = false;
//               //   //         }
//               //   //       },
//               //   //     );
//               //   //   },
//               //   //   decoration: InputDecoration(
//               //   //     border: OutlineInputBorder(),
//               //   //     hintText: widget.gender,
//               //   //     hintStyle: TextStyle(color: Colors.black),
//               //   //   ),
//               //   // ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
