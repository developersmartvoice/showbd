import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:ui';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:appcode3/views/BookingScreen.dart';
import 'package:appcode3/views/Doctor/DoctorProfile.dart';
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

class ServicesSettingsPage extends StatefulWidget {
  //const NameSettingsPage({super.key});
  final String id;
  final List<String> services;
  //late final String aboutMe;
  //late final String city;

  ServicesSettingsPage(this.id, this.services);

  @override
  State<ServicesSettingsPage> createState() => _ServicesSettingsPageState();
}

class _ServicesSettingsPageState extends State<ServicesSettingsPage> {
  //List<String>? selectedServices;
  //late SharedPreferences _prefs;
  List<String> selectedServices = [];
  bool isValueChanged = false;
  bool isServiceSelected = false;
  bool isActivitiesSelected = false;
  List<String> selectedLanguages = [];
  //List<String> selectedActivities = [];
  //String selectedLanguage = '';

  bool isChecked = false;
  //late SharedPreferences prefs;
  String selectedService = "";

  // Define your service map
  Map<String, String> serviceMap = {
    "translation": "Translation & Interpretation",
    "shopping": "Shopping",
    "food": "Food & Restaurants",
    "art": "Art & Museums",
    "history": "History & Culture",
    "exploration": "Exploration & Sightseeing",
    "pick": "Pick up & Driving Tours",
    "nightlife": "Nightlife & Bars",
    "sports": "Sports & Recreation"
  };

  //late String _selectedService;

  //bool isMeetingTimeSelected = false; // Variable to store the selected language

  @override
  void initState() {
    super.initState();
    // Initialize selected services based on backend values
    selectedServices.addAll(widget.services);
    isServiceSelected = selectedServices.isNotEmpty;
    //loadPreferences();
    // for (var service in services) {
    //   selectedServices[service] = false;
    // }
    //_selectedLanguage = widget.languages; // Set default selected language
  }

// Load the user's selected services from SharedPreferences
  // void loadPreferences() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     // Load the list of selected services
  //     List<String>? savedServices = _prefs.getStringList('selectedServices');
  //     selectedServices = savedServices ?? [];
  //     isServiceSelected =
  //         selectedServices.isNotEmpty; // Check if services are selected
  //   });
  // }

  // Save the user's selected services to SharedPreferences
  // void savePreferences() async {
  //   await _prefs.setStringList('selectedServices', selectedServices);
  //   setState(() {
  //     isServiceSelected = selectedServices.isNotEmpty;
  //   });
  // }

  late TextEditingController _controller;
  String enteredValue = '';
  //bool isValueChanged = false;
  void updatingServices(
      //List<String> list
      ) async {
    //String selectedServicesString = selectedServiceList.join(', ');
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/updateServices"), body: {
      "id": widget.id,
      "services": selectedServices.join(','),
    });
    print("$SERVER_ADDRESS/api/updateServices");
    // print(response.body);
    if (response.statusCode == 200) {
      print("Services Updated");
      // setState(() {
      //   // Update local state to reflect the selected services
      //   selectedServices.clear();
      //   for (var service in selectedServiceList) {
      //     selectedServices[service] = true;
      //   }
      //   //Navigator.pop(context);
      // });
      Navigator.pop(context);
    } else {
      print("Services Not Updated");
    }
  }

  // Map<String, String> serviceMap = {
  //   "translation": "Translation & Interpretation",
  //   "shopping": "Shopping",
  //   "food": "Food & Restaurants",
  //   "art": "Art & Museums",
  //   "history": "History & Culture",
  //   "exploration": "Exploration & Sightseeing",
  //   "pick": "Pick up & Driving Tours",
  //   "nightlife": "Nightlife & Bars",
  //   "sports": "Sports & Recreation"
  // };

  // CheckboxListTile buildCheckboxListTile(
  //     String key, String title, List<String> list) {
  //   return CheckboxListTile(
  //     dense: true,
  //     contentPadding: EdgeInsets.zero, // Set contentPadding to zero
  //     visualDensity: VisualDensity(horizontal: 0, vertical: -4),
  //     title: Text(title),
  //     value: list.contains(key),
  //     onChanged: (newValue) {
  //       // list1.addAll(list);
  //       setState(() {
  //         if (newValue == true) {
  //           list.add(key);
  //         } else {
  //           list.remove(key);
  //         }
  //         //savePreferences(); // Save the preferences when selection changes
  //         print(list);
  //       });
  //     },
  //   );
  // }

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
          title: Text('Activities',
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
                if (isServiceSelected) {
                  updatingServices();
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
          padding: EdgeInsets.all(10),
          child: ListView(
            children: serviceMap.keys.map((key) {
              return CheckboxListTile(
                dense: true,
                title: Text(serviceMap[key]!),
                value: selectedServices.contains(key),
                onChanged: (newValue) {
                  setState(() {
                    if (newValue == true) {
                      selectedServices.add(key);
                    } else {
                      selectedServices.remove(key);
                    }
                    isServiceSelected = selectedServices.isNotEmpty;
                  });
                },
                secondary: key == 'translation' ? Icon(Icons.translate) : null,
              );
            }).toList(),
          ),
        ),
        // body: Container(
        //   padding: EdgeInsets.all(10),
        //   height: 300,
        //   child: ListView(
        //     physics: NeverScrollableScrollPhysics(),
        //     children: serviceMap.keys.map((key) {
        //       // print('----');
        //       // print(services);
        //       return buildCheckboxListTile(
        //           key, serviceMap[key]!, selectedServices);
        //     }).toList(),
        //   ),
        // ),
        // child: Column(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     _buildMultiSelect('Activities', selectedActivities, [
        //       'Translation & Interpretation',
        //       'Pick Up & Driving Tours',
        //       'Shopping',
        //       'Nightlife & Bars',
        //       'Food & Resturants',
        //       'Arts & Museums',
        //       'Sports & Recreation',
        //       'History & Culture',
        //       'Exploration & Sightseeing'
        //     ], (value) {
        //       setState(() {
        //         selectedActivities = value;
        //       });
        //     }),
        //     // Expanded(
        //     //   child: ListView.builder(
        //     //     itemCount: services.length,
        //     //     itemBuilder: (context, index) {
        //     //       final service = services[index];
        //     //       return CheckboxListTile(
        //     //         title: Text(service),
        //     //         value: selectedServices.containsKey(service)
        //     //             ? selectedServices[service]
        //     //             : false,
        //     //         //value: selectedServices[service],
        //     //         onChanged: (value) {
        //     //           setState(() {
        //     //             selectedServices[service] = value!;
        //     //             isValueChanged = true;
        //     //           });
        //     //         },
        //     //         controlAffinity: ListTileControlAffinity.trailing,
        //     //       );
        //     //     },
        //     //   ),
        //     // ),

        //     // Expanded(
        //     //   child: ListView.builder(
        //     //     itemCount: languages.length,
        //     //     itemBuilder: (context, index) {
        //     //       return ListTile(
        //     //         title: Text(languages[index]),
        //     //         onTap: () {
        //     //           setState(() {
        //     //             selectedLanguage = languages[index];
        //     //           });
        //     //         },
        //     //         selected: selectedLanguage == languages[index],
        //     //         selectedTileColor: Colors.orange.withOpacity(0.5),
        //     //       );
        //     //     },
        //     //   ),
        //     // ),
        //   ],
        // ),
      ),
    );
  }

  // Widget _buildMultiSelect(String label, List<String> selectedValues,
  //     List<String> options, ValueChanged<List<String>> onChanged) {
  //   return Container(
  //       child: Column(
  //           // crossAxisAlignment: CrossAxisAlignment.start,
  //           //mainAxisAlignment: MainAxisAlignment.start,

  //           children: [
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
  //             //   spacing: 12.0,
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
  //         )
  //       ]));
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
