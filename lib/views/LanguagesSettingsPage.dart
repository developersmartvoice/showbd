//import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
//import 'package:appcode3/views/BookingScreen.dart';
//import 'package:appcode3/views/Doctor/DoctorProfile.dart';
//import 'package:appcode3/views/Doctor/LogoutScreen.dart';
//import 'package:appcode3/views/Doctor/loginAsDoctor.dart';
//import 'package:appcode3/views/SendOfferScreen.dart';
//import 'package:appcode3/views/SendOffersScreen.dart';
//import 'package:connectycube_sdk/connectycube_chat.dart';

//import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
//import 'package:appcode3/modals/DoctorAppointmentClass.dart';
//import 'package:appcode3/modals/DoctorPastAppointmentsClass.dart';
//import 'package:appcode3/views/Doctor/DoctorChatListScreen.dart';
//import 'package:appcode3/views/Doctor/DoctorAllAppointments.dart';
//import 'package:appcode3/views/Doctor/DoctorAppointmentDetails.dart';
//import 'package:appcode3/views/Doctor/DoctorProfileWithRating.dart';
//import 'package:appcode3/views/Doctor/moreScreen/change_password_screen.dart';
//import 'package:appcode3/views/Doctor/moreScreen/income_report.dart';
//import 'package:appcode3/views/Doctor/moreScreen/subscription_screen.dart';

//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:facebook_audience_network/ad/ad_native.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_html/style.dart';
//import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
//import 'package:shared_preferences/shared_preferences.dart';

//import 'package:flutter/material.dart';

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
  late SharedPreferences _prefs;
  List<String> selectedLanguages = [];
  // List<String> languages = [
  //   'English',
  //   'Bengali',
  //   'Urdu',
  //   'Spanish',
  //   'French',
  //   'Hindi'
  // ];
  //Map<String, bool> selectedLanguages = {};
  bool isValueChanged = false;
  bool isLanguageSelected = false;
  bool isActivitiesSelected = false;
  //String selectedLanguage = '';

  bool isChecked = false;
  String selectedLanguage = "";

  //late String _selectedLanguage;

  //bool isMeetingTimeSelected = false; // Variable to store the selected language

  @override
  void initState() {
    super.initState();
    loadPreferences();
    // for (var language in languages) {
    //   selectedLanguages[language] = false;
    // }
    //_selectedLanguage = widget.languages; // Set default selected language
  }

  // Load the user's selected languages from SharedPreferences
  void loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      // Load the list of selected languages
      List<String>? savedLanguages = _prefs.getStringList('selectedLanguages');
      selectedLanguages = savedLanguages ?? [];
      isLanguageSelected =
          selectedLanguages.isNotEmpty; // Check if languages are selected
    });
  }

  // Save the user's selected languages to SharedPreferences
  void savePreferences() async {
    await _prefs.setStringList('selectedLanguages', selectedLanguages);
    setState(() {
      isLanguageSelected = selectedLanguages.isNotEmpty;
    });
  }

  String enteredValue = '';
  //bool isValueChanged = false;
  Future<void> updatingLanguages() async {
    try {
      final response =
          await post(Uri.parse("$SERVER_ADDRESS/api/updateLanguages"), body: {
        "id": widget.id,
        "languages": json.encode(selectedLanguages),
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
    } catch (e) {
      print("Error updating languages: $e");
      // Handle error as needed
    }
  }

  Map<String, String> languageMap = {
    "english": "English",
    "bengali": "Bengali",
    "hindi": "Hindi",
    "urdu": "Urdu",
    "french": "French",
    "spanish": "Spanish"
  };

  CheckboxListTile buildCheckboxListTile(
      String key, String title, List<String> list) {
    return CheckboxListTile(
      dense: true,
      contentPadding: EdgeInsets.zero, // Set contentPadding to zero
      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
      title: Text(title),
      value: list.contains(key),
      onChanged: (newValue) {
        // list1.addAll(list);
        setState(() {
          if (newValue == true) {
            list.add(key);
          } else {
            list.remove(key);
          }
          savePreferences(); // Save the preferences when selection changes
          print(list);
        });
      },
    );
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
                if (isLanguageSelected) {
                  updatingLanguages();
                } else {
                  // Navigator.pop(context);
                }
                // if (isValueChanged) {
                //   updatingLanguages();
                //if (selectedLanguages.isNotEmpty) {
                //List<String> selectedLanguageList = [
                // 'English',
                // 'Bengali',
                // 'Urdu',
                // 'Spanish',
                // 'French',
                // 'Hindi',
                //];
                // selectedLanguages.forEach((key, value) {
                //   if (value) {
                //     selectedLanguageList.add(key);
                //   }
                // });
                //print('Selected languages: $selectedLanguages');
                //updatingLanguages();
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
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.white, // Set the color as needed
                height: 230,
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  children: languageMap.keys.map((key) {
                    return buildCheckboxListTile(
                        key, languageMap[key]!, selectedLanguages);
                  }).toList(),
                ),
              ),

              //     Divider(
              //       height: 10,
              //     ),
              //     _buildMultiSelect('Languages', selectedLanguages, [
              //       'English',
              //       'Bengali',
              //       'Hindi',
              //       'Urdu',
              //       'German',
              //       'Korean',
              //       'Spanish',
              //       'Arabic'
              //     ], (value) {
              //       setState(() {
              //         selectedLanguages = value;
              //       });
              //     }),
              // Divider(
              //   height: 20,
              // ),
              // Text(
              //   'Selected Languages: ${selectedLanguages.join(', ')}',
              //   style: TextStyle(fontSize: 16),
              // ),
              // Divider(
              //   height: 2,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildMultiSelect(String label, List<String> selectedValues,
  //     List<String> options, ValueChanged<List<String>> onChanged) {
  //   return Container(
  //     child: Column(
  //       // crossAxisAlignment: CrossAxisAlignment.start,
  //       //mainAxisAlignment: MainAxisAlignment.start,

  //       children: [
  //         Column(
  //           children: [
  //             Container(
  //               color: LIGHT_GREY_SCREEN_BACKGROUND,
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Padding(
  //                     padding: EdgeInsets.only(
  //                         left: 18.0), // Adjust the left padding as needed
  //                     // child: Text(
  //                     //   label,
  //                     //   style: GoogleFonts.robotoCondensed(
  //                     //       fontWeight: FontWeight.w600,
  //                     //       color: Colors.grey,
  //                     //       fontSize: 25),
  //                     // ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             SizedBox(
  //               height: 5,
  //             ),
  //             // Wrap(
  //             //   spacing: 10.0,
  //             //   children: options.map((option) {
  //             //     String mappedOption = mapOption(option);
  //             //     return FilterChip(
  //             //       label: Text(option),
  //             //       selected: selectedValues.contains(mappedOption),
  //             //       onSelected: (selected) {
  //             //         List<String> newSelectedValues =
  //             //             List.from(selectedValues);
  //             //         String mappedOption = mapOption(option);
  //             //         if (selected) {
  //             //           newSelectedValues.add(mappedOption);
  //             //         } else {
  //             //           newSelectedValues.remove(mappedOption);
  //             //         }
  //             //         onChanged(newSelectedValues);
  //             //         if (selectedLanguages.isNotEmpty) {
  //             //           isActivitiesSelected = true;
  //             //         } else {
  //             //           isActivitiesSelected = false;
  //             //         }
  //             //       },
  //             //       selectedColor: Color.fromARGB(190, 255, 115, 0),
  //             //       labelStyle: TextStyle(
  //             //         color: selectedValues.contains(mappedOption)
  //             //             ? Colors.white
  //             //             : Colors.black, // Set font color based on selection
  //             //       ),
  //             //     );
  //             //   }).toList(),
  //             // ),
  //             // Divider(
  //             //   height: 20,
  //             //   color: Colors.grey,
  //             // ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // String mapOption(String option) {
  //   switch (option) {
  //     case 'Translation & Interpretation':
  //       return 'translation';
  //     case 'Pick Up & Driving Tours':
  //       return 'pick';
  //     case 'Shopping':
  //       return 'shopping';
  //     case 'Nightlife & Bars':
  //       return 'nightlife';
  //     case 'Food & Resturants':
  //       return 'food';
  //     case 'Arts & Museums':
  //       return 'art';
  //     case 'Sports & Recreation':
  //       return 'sports';
  //     case 'History & Culture':
  //       return 'history';
  //     case 'Exploration & Sightseeing':
  //       return 'exploration';
  //     case 'English':
  //       return 'english';
  //     case 'Bengali':
  //       return 'bengali';
  //     case 'Hindi':
  //       return 'hindi';
  //     case 'Urdu':
  //       return 'urdu';
  //     default:
  //       return option;
  //   }
  // }
  //   child: Expanded(
  //     child: ListView.builder(
  //       itemCount: languages.length,
  //       itemBuilder: (context, index) {
  //         final language = languages[index];
  //         return CheckboxListTile(
  //           title: Text(language),
  //           value: selectedLanguages.containsKey(language)
  //               ? selectedLanguages[language]
  //               : false,
  //           //value: selectedLanguages[language],
  //           onChanged: (value) {
  //             setState(() {
  //               selectedLanguages[language] = value!;
  //               isValueChanged = true;
  //             });
  //           },
  //           controlAffinity: ListTileControlAffinity.trailing,
  //           //itemAsString:
  //           //isLanguageSelected ? selectedLanguages : widget.languages,
  //         );
  //       },
  //     ),
  //   ),
  // ),

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
  // ],
  // ),
  // ),

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
  //),
  //);
}
  // void updatingLanguages() {
  //   // Perform the update operation
  //   print('Updating languages...');
  //   setState(() {
  //     isValueChanged = false; // Reset the value changed flag
  //   });
  // }
//}


