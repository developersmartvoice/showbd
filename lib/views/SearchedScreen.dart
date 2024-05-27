// import 'dart:convert';

// import 'package:appcode3/en.dart';
// import 'package:appcode3/main.dart';
// import 'package:appcode3/modals/FilterClass.dart';
// import 'package:appcode3/modals/SearchDoctorClass.dart';
// import 'package:appcode3/modals/SpecialityClass.dart';
// import 'package:appcode3/views/FilteredGuidesScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SearchedScreen extends StatefulWidget {
//   // const SearchedScreen({super.key})

//   @override
//   _SearchedScreenState createState() => _SearchedScreenState();
// }

// class _SearchedScreenState extends State<SearchedScreen> {
//   bool isLoggedIn = false;
//   bool isSearching = false;
//   bool isLoading = false;
//   bool isErrorInLoading = false;
//   int? currentId;
//   FilterClass? _filterClass;
//   SearchDoctorClass? searchDoctorClass;
//   // List<DoctorData> _newData = [];
//   String nextUrl = "";
//   bool isLoadingMore = false;
//   String searchKeyword = "";
//   ScrollController _scrollController = ScrollController();
//   // TextEditingController _textController = TextEditingController();
//   SpecialityClass? specialityClass;
//   List<String> departmentList = [];
//   double priceRange = 0;
//   List<String> selectedLanguages = [];
//   List<String> selectedActivities = [];
//   int selectedGender = 0; // 0: None, 1: Male, 2: Female
//   int? filterFees;
//   String? filterGender;
//   bool isFeesSelected = false;
//   bool isLanguageSelected = false;
//   bool isActivitiesSelected = false;
//   bool isGenderSelected = false;
//   bool saveFilterSettings = false;
//   bool isFilterLoading = false;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     SharedPreferences.getInstance().then((pref) {
//       setState(() {
//         isLoggedIn = pref.getBool("isLoggedInAsDoctor") ?? false;
//         currentId = int.parse(pref.getString("userId").toString());
//         // print("this is to see the keys");
//         print("ID: ${currentId}");
//         // print("keysss: ${pref.getString("userId")}");
//       });
//     });
//   }

//   getFiltersDoctors() async {
//     String body = getBodyParameter();
//     if (body.isNotEmpty) {
//       print("This body is from Inside the condition!: $body");
//       final response = await post(Uri.parse("$SERVER_ADDRESS/api/filterdoctor"),
//           headers: {'Content-Type': 'application/json'}, body: body);
//       // print(getBodyParameter());
//       // print(response);
//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         print("Total Found: ${jsonResponse['data']['total']}");
//         setState(() {
//           _filterClass = FilterClass.fromJson(jsonResponse);
//           // print("Total Found: ${_filterClass!.data!.total}");
//           isFilterLoading = false;
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: ((context) => FilteredGuidesScreen(_filterClass!, body)),
//             ),
//           );
//         });
//       }
//     }
//   }

//   String getBodyParameter() {
//     if (isFeesSelected &&
//         isActivitiesSelected &&
//         isLanguageSelected &&
//         isGenderSelected) {
//       Map<String, dynamic> requestBody = {
//         'consultation_fees': filterFees,
//         'gender': filterGender,
//         'languages': selectedLanguages,
//         'services': selectedActivities,
//       };
//       print(jsonEncode(requestBody));
//       // return jsonEncode(requestBody);
//       return requestBody.toString();
//     } else if (isFeesSelected && isLanguageSelected && isActivitiesSelected) {
//       Map<String, dynamic> requestBody = {
//         'consultation_fees': filterFees,
//         'languages': selectedLanguages,
//         'services': selectedActivities,
//       };
//       print(jsonEncode(requestBody));
//       // return jsonEncode(requestBody);
//       return requestBody.toString();
//     } else if (isFeesSelected && isLanguageSelected && isGenderSelected) {
//       Map<String, dynamic> requestBody = {
//         'consultation_fees': filterFees,
//         'gender': filterGender,
//         'languages': selectedLanguages,
//       };
//       print(jsonEncode(requestBody));
//       // return jsonEncode(requestBody);
//       return requestBody.toString();
//     } else if (isFeesSelected && isActivitiesSelected && isGenderSelected) {
//       Map<String, dynamic> requestBody = {
//         'consultation_fees': filterFees,
//         'gender': filterGender,
//         'services': selectedActivities,
//       };
//       print(jsonEncode(requestBody));
//       // return jsonEncode(requestBody);
//       return requestBody.toString();
//     } else if (isLanguageSelected && isActivitiesSelected && isGenderSelected) {
//       Map<String, dynamic> requestBody = {
//         'gender': filterGender,
//         'languages': selectedLanguages,
//         'services': selectedActivities,
//       };
//       print(jsonEncode(requestBody));
//       // return jsonEncode(requestBody);
//       return requestBody.toString();
//     } else if (isFeesSelected && isLanguageSelected) {
//       Map<String, dynamic> requestBody = {
//         'consultation_fees': filterFees,
//         'languages': selectedLanguages,
//       };
//       print(jsonEncode(requestBody));
//       // return jsonEncode(requestBody);
//       return requestBody.toString();
//     } else if (isFeesSelected && isActivitiesSelected) {
//       Map<String, dynamic> requestBody = {
//         'consultation_fees': filterFees,
//         'services': selectedActivities,
//       };
//       print(jsonEncode(requestBody));
//       // return jsonEncode(requestBody);
//       return requestBody.toString();
//     } else if (isFeesSelected && isGenderSelected) {
//       Map<String, dynamic> requestBody = {
//         'consultation_fees': filterFees,
//         'gender': filterGender,
//       };
//       print(jsonEncode(requestBody));
//       // return jsonEncode(requestBody);
//       return requestBody.toString();
//     } else if (isLanguageSelected && isActivitiesSelected) {
//       Map<String, dynamic> requestBody = {
//         'languages': selectedLanguages,
//         'services': selectedActivities,
//       };
//       print(jsonEncode(requestBody));
//       // return jsonEncode(requestBody);
//       return requestBody.toString();
//     } else if (isLanguageSelected && isGenderSelected) {
//       Map<String, dynamic> requestBody = {
//         'gender': filterGender,
//         'languages': selectedLanguages,
//       };
//       print(jsonEncode(requestBody));
//       // return jsonEncode(requestBody);
//       return requestBody.toString();
//     } else if (isActivitiesSelected && isGenderSelected) {
//       Map<String, dynamic> requestBody = {
//         'gender': filterGender,
//         'services': selectedActivities,
//       };
//       print(jsonEncode(requestBody));
//       // return jsonEncode(requestBody);
//       return requestBody.toString();
//     } else if (isFeesSelected) {
//       Map<String, dynamic> requestBody = {
//         'consultation_fees': filterFees,
//       };
//       print(jsonEncode(requestBody));
//       return jsonEncode(requestBody);
//       // return requestBody.toString();
//     } else if (isLanguageSelected) {
//       Map<String, dynamic> requestBody = {
//         'languages': selectedLanguages,
//       };
//       // print(jsonEncode(requestBody));
//       print(requestBody.toString());
//       // return requestBody.toString();
//       return jsonEncode(requestBody);
//     } else if (isActivitiesSelected) {
//       Map<String, dynamic> requestBody = {
//         'services': selectedActivities,
//       };
//       print(jsonEncode(requestBody));
//       return jsonEncode(requestBody);
//       // return requestBody.toString();
//     } else if (isGenderSelected) {
//       Map<String, dynamic> requestBody = {
//         'gender': filterGender,
//       };
//       print(requestBody.toString());
//       return jsonEncode(requestBody);
//       // return requestBody.toString();
//     } else {
//       return '';
//     }
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _scrollController.dispose();
//   }

//   Widget _getAdContainer() {
//     return Container(
//         // height: 60,
//         // margin: EdgeInsets.all(10),
//         // child: NativeAdmob(
//         //   // Your ad unit id
//         //   adUnitID: ADMOB_ID,
//         //   controller: nativeAdController,
//         //   type: NativeAdmobType.banner,
//         // ),
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: LIGHT_GREY_SCREEN_BACKGROUND,
//         body: Stack(
//           children: [
//             isErrorInLoading
//                 ? Container(
//                     child: Center(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.search_off_rounded,
//                             size: 100,
//                             color: LIGHT_GREY_TEXT,
//                           ),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Text(
//                             UNABLE_TO_LOAD_DATA_FORM_SERVER,
//                           )
//                         ],
//                       ),
//                     ),
//                   )
//                 : SingleChildScrollView(
//                     controller: _scrollController,
//                     child: isLoading
//                         ? Center(
//                             child: CircularProgressIndicator(
//                               color: const Color.fromARGB(255, 243, 103, 9),
//                               valueColor: AlwaysStoppedAnimation(
//                                   Theme.of(context).hintColor),
//                             ),
//                           )
//                         : Column(
//                             children: [
//                               header(),
//                               // upCommingAppointments(),
//                               isFilterLoading
//                                   ? Center(
//                                       child: CircularProgressIndicator(
//                                         color: const Color.fromARGB(
//                                             255, 243, 103, 9),
//                                       ),
//                                     )
//                                   : body()
//                             ],
//                           ),
//                   ),
//             header(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget header() {
//     return Stack(
//       children: [
//         Image.asset(
//           "assets/homeScreenImages/header_bg.png",
//           height: MediaQuery.of(context).size.height * 0.08,
//           width: MediaQuery.of(context).size.width,
//           fit: BoxFit.fill,
//         ),
//         SafeArea(
//           child: Container(
//             height: 60,
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Navigator.pop(context);
//                     },
//                     child: Image.asset(
//                       "assets/moreScreenImages/back.png",
//                       height: 25,
//                       width: 22,
//                     ),
//                   ),
//                   SizedBox(
//                     width: 10,
//                   ),
//                   Text(
//                     "Filters",
//                     style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.w600,
//                         color: WHITE,
//                         fontSize: MediaQuery.of(context).size.width * 0.04),
//                   ),
//                   SizedBox(
//                     width: 20,
//                   ),
//                   InkWell(
//                       onTap: () {
//                         // Navigator.pop(context);
//                         setState(() {
//                           print("Filter Fees: $filterFees");
//                           print("Languages Selected: $selectedLanguages");
//                           print("Activities Selected: $selectedActivities");
//                           print("Gender: $filterGender");
//                           if (isFeesSelected ||
//                               isLanguageSelected ||
//                               isActivitiesSelected ||
//                               isGenderSelected) {
//                             setState(() {
//                               isFilterLoading = true;
//                             });
//                             getFiltersDoctors();
//                           } else {
//                             print("No Value Selected");
//                           }
//                         });
//                       },
//                       child: Text(
//                         "Apply",
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.w600,
//                           color: const Color.fromARGB(255, 12, 88, 150),
//                           fontSize: MediaQuery.of(context).size.width * 0.03,
//                         ),
//                       )),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget body() {
//     return Container(
//       child: Padding(
//         padding: const EdgeInsets.all(0),
//         child: Column(
//           children: [
//             _buildSlider('Price Range', priceRange, (value) {
//               setState(() {
//                 priceRange = value.toDouble();
//               });
//             }),
//             SizedBox(height: 16),
//             _buildMultiSelect('Languages', selectedLanguages,
//                 ['English', 'Bengali', 'Hindi', 'Urdu'], (value) {
//               setState(() {
//                 selectedLanguages = value;
//                 if (selectedLanguages.isNotEmpty) {
//                   setState(() {
//                     isLanguageSelected = true;
//                   });
//                 } else {
//                   setState(() {
//                     isLanguageSelected = false;
//                   });
//                 }
//               });
//             }),
//             SizedBox(height: 16),
//             _buildMultiSelect('Activities', selectedActivities, [
//               'Translation & Interpretation',
//               'Pick Up & Driving Tours',
//               'Shopping',
//               'Nightlife & Bars',
//               'Food & Resturants',
//               'Arts & Museums',
//               'Sports & Recreation',
//               'History & Culture',
//               'Exploration & Sightseeing'
//             ], (value) {
//               setState(() {
//                 selectedActivities = value;
//                 if (selectedActivities.isNotEmpty) {
//                   setState(() {
//                     isActivitiesSelected = true;
//                   });
//                 } else {
//                   setState(() {
//                     isActivitiesSelected = false;
//                   });
//                 }
//               });
//             }),
//             SizedBox(height: 16),
//             _buildRadioButtons(
//                 'Gender', selectedGender, ['None', 'Male', 'Female'], (value) {
//               setState(() {
//                 selectedGender = value;
//               });
//             }),
//             SizedBox(height: 16),
//             _buildCheckbox(
//                 'Save my filter settings for future use', saveFilterSettings,
//                 (value) {
//               setState(() {
//                 saveFilterSettings = value;
//               });
//             }),
//             SizedBox(height: 15),
//             Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   _clearFilters();
//                   setState(() {
//                     filterGender = null;
//                     filterFees = null;
//                   });
//                 },
//                 style: ButtonStyle(
//                   backgroundColor: MaterialStateProperty.all<Color>(
//                       const Color.fromARGB(190, 255, 115,
//                           0)), // Set the background color to orange
//                 ),
//                 child: Text(
//                   'Clear Filters',
//                   style: TextStyle(color: WHITE),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSlider(String label, double value, ValueChanged<int> onChanged) {
//     return Container(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(
//                 left: 18.0), // Adjust the left padding as needed
//             child: Text(
//               label,
//               style: GoogleFonts.robotoCondensed(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey,
//                 fontSize: MediaQuery.of(context).size.width * 0.04,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           Container(
//             color: Colors.white,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(
//                         left: 18,
//                         right: 18,
//                       ), // Adjust the left padding as needed
//                       child: Text(
//                         'Free',
//                         style: GoogleFonts.robotoCondensed(
//                             fontSize: MediaQuery.of(context).size.width * 0.04,
//                             fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                     Text(
//                       '100',
//                       style: GoogleFonts.robotoCondensed(
//                           fontSize: 20, fontWeight: FontWeight.w500),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   children: [
//                     SliderTheme(
//                       data: SliderThemeData(
//                         //trackHeight: 5, // Change the height of the track
//                         thumbShape: RoundSliderThumbShape(
//                           enabledThumbRadius:
//                               10, // Change the size of the thumb
//                         ),
//                       ),
//                       child: Slider(
//                         value: value,
//                         min: 0,
//                         max: 100,
//                         onChanged: (double newValue) {
//                           onChanged(newValue
//                               .round()); // Round the double value to an integer
//                           setState(() {
//                             filterFees = newValue.round();
//                             print("filter Fees are: $filterFees");
//                             if (filterFees != null) {
//                               isFeesSelected = true;
//                             } else {
//                               isFeesSelected = false;
//                             }
//                           });
//                         },
//                         activeColor: Color.fromARGB(190, 255, 115, 0),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             color: Colors.white,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Selected Fees: ${value.round()}',
//                   style: GoogleFonts.robotoCondensed(
//                       fontSize: 18, fontWeight: FontWeight.w500),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMultiSelect(String label, List<String> selectedValues,
//       List<String> options, ValueChanged<List<String>> onChanged) {
//     return Container(
//         child: Column(children: [
//       Column(
//         children: [
//           Container(
//             color: LIGHT_GREY_SCREEN_BACKGROUND,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(
//                       left: 18.0), // Adjust the left padding as needed
//                   child: Text(
//                     label,
//                     style: GoogleFonts.robotoCondensed(
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey,
//                       fontSize: MediaQuery.of(context).size.width * 0.04,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 5,
//           ),
//           Wrap(
//             spacing: 12.0,
//             children: options.map((option) {
//               String mappedOption = mapOption(option);
//               return FilterChip(
//                 label: Text(option),
//                 selected: selectedValues.contains(mappedOption),
//                 onSelected: (selected) {
//                   List<String> newSelectedValues = List.from(selectedValues);
//                   String mappedOption = mapOption(option);
//                   if (selected) {
//                     newSelectedValues.add(mappedOption);
//                   } else {
//                     newSelectedValues.remove(mappedOption);
//                   }
//                   onChanged(newSelectedValues);
//                   // if (selectedLanguages.isNotEmpty) {
//                   //   isLanguageSelected = true;
//                   // } else {
//                   //   isLanguageSelected = false;
//                   // }
//                 },
//                 selectedColor: Color.fromARGB(190, 255, 115, 0),
//                 labelStyle: TextStyle(
//                   color: selectedValues.contains(mappedOption)
//                       ? Colors.white
//                       : Colors.black, // Set font color based on selection
//                 ),
//               );
//             }).toList(),
//           ),
//           Divider(
//             height: 20,
//             color: Colors.grey,
//           ),
//         ],
//       )
//     ]));
//   }

//   String mapOption(String option) {
//     switch (option) {
//       case 'Translation & Interpretation':
//         return 'translation';
//       case 'Pick Up & Driving Tours':
//         return 'pick';
//       case 'Shopping':
//         return 'shopping';
//       case 'Nightlife & Bars':
//         return 'nightlife';
//       case 'Food & Resturants':
//         return 'food';
//       case 'Arts & Museums':
//         return 'art';
//       case 'Sports & Recreation':
//         return 'sports';
//       case 'History & Culture':
//         return 'history';
//       case 'Exploration & Sightseeing':
//         return 'exploration';
//       case 'English':
//         return 'english';
//       case 'Bengali':
//         return 'bengali';
//       case 'Hindi':
//         return 'hindi';
//       case 'Urdu':
//         return 'urdu';
//       default:
//         return option;
//     }
//   }

//   Widget _buildRadioButtons(String label, int selectedValue,
//       List<String> options, ValueChanged<int> onChanged) {
//     return Container(
//       color: LIGHT_GREY_SCREEN_BACKGROUND,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(
//                 left: 18.0), // Adjust the left padding as needed
//             child: Text(
//               label,
//               style: GoogleFonts.robotoCondensed(
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey,
//                 fontSize: MediaQuery.of(context).size.width * 0.04,
//               ),
//             ),
//           ),
//           Container(
//             color: WHITE,
//             child: Column(
//               children: options.asMap().entries.map((entry) {
//                 int index = entry.key;
//                 String option = entry.value;
//                 return Row(
//                   children: [
//                     Radio(
//                       value: index,
//                       groupValue: selectedValue,
//                       onChanged: (value) {
//                         onChanged(value as int);
//                         setState(() {
//                           switch (value) {
//                             case 0:
//                               filterGender = "none";
//                               break;
//                             case 1:
//                               filterGender = "male";
//                               break;
//                             case 2:
//                               filterGender = "female";
//                               break;
//                             default:
//                               filterGender = "none";
//                           }
//                           if (filterGender != null) {
//                             isGenderSelected = true;
//                           } else {
//                             isGenderSelected = false;
//                           }
//                         });
//                       },
//                       activeColor: Color.fromARGB(190, 255, 115, 0),
//                     ),
//                     Text(option),
//                   ],
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCheckbox(
//       String label, bool value, ValueChanged<bool> onChanged) {
//     return Row(
//       children: [
//         Checkbox(
//           value: value,
//           onChanged: (newValue) {
//             onChanged(newValue!);
//           },
//           activeColor: Color.fromARGB(190, 255, 115, 0),
//         ),
//         Flexible(
//           child: Text(
//             label,
//             style: GoogleFonts.robotoCondensed(
//               fontWeight: FontWeight.w600,
//               color: Colors.grey,
//               fontSize: MediaQuery.of(context).size.width * 0.035,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }

//   void _clearFilters() {
//     setState(() {
//       isFeesSelected = false;
//       isGenderSelected = false;
//       isLanguageSelected = false;
//       isActivitiesSelected = false;
//       priceRange = 0;
//       selectedLanguages = [];
//       selectedActivities = [];
//       selectedGender = 0;
//       saveFilterSettings = false;
//     });
//   }
// }

import 'dart:convert';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/modals/FilterClass.dart';
import 'package:appcode3/modals/SearchDoctorClass.dart';
import 'package:appcode3/modals/SpecialityClass.dart';
import 'package:appcode3/views/FilteredGuidesScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchedScreen extends StatefulWidget {
  @override
  _SearchedScreenState createState() => _SearchedScreenState();
}

class _SearchedScreenState extends State<SearchedScreen> {
  bool isLoggedIn = false;
  bool isSearching = false;
  bool isLoading = false;
  bool isErrorInLoading = false;
  int? currentId;
  FilterClass? _filterClass;
  SearchDoctorClass? searchDoctorClass;
  String nextUrl = "";
  bool isLoadingMore = false;
  String searchKeyword = "";
  ScrollController _scrollController = ScrollController();
  SpecialityClass? specialityClass;
  List<String> departmentList = [];
  double priceRange = 0;
  List<String> selectedLanguages = [];
  List<String> selectedActivities = [];
  int selectedGender = 0; // 0: None, 1: Male, 2: Female
  int? filterFees;
  String? filterGender;
  bool isFeesSelected = false;
  bool isLanguageSelected = false;
  bool isActivitiesSelected = false;
  bool isGenderSelected = false;
  bool saveFilterSettings = false;
  bool isFilterLoading = false;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((pref) {
      setState(() {
        isLoggedIn = pref.getBool("isLoggedInAsDoctor") ?? false;
        currentId = int.parse(pref.getString("userId").toString());
        print("ID: ${currentId}");
      });
    });
  }

  getFiltersDoctors() async {
    String body = getBodyParameter();
    if (body.isNotEmpty) {
      print("This body is from Inside the condition!: $body");
      final response = await post(Uri.parse("$SERVER_ADDRESS/api/filterdoctor"),
          headers: {'Content-Type': 'application/json'}, body: body);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("Total Found: ${jsonResponse['data']['total']}");
        setState(() {
          _filterClass = FilterClass.fromJson(jsonResponse);
          isFilterLoading = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => FilteredGuidesScreen(_filterClass!, body)),
            ),
          );
        });
      }
    }
  }

  String getBodyParameter() {
    Map<String, dynamic> requestBody = {};

    if (isFeesSelected) {
      requestBody['consultation_fees'] = filterFees;
    }
    if (isGenderSelected) {
      requestBody['gender'] = filterGender;
    }
    if (isLanguageSelected) {
      requestBody['languages'] = selectedLanguages;
    }
    if (isActivitiesSelected) {
      requestBody['services'] = selectedActivities;
    }

    if (requestBody.isNotEmpty) {
      print(jsonEncode(requestBody));
      return jsonEncode(requestBody);
    } else {
      return '';
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Widget _getAdContainer() {
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: LIGHT_GREY_SCREEN_BACKGROUND,
        body: Stack(
          children: [
            isErrorInLoading
                ? Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 100,
                            color: LIGHT_GREY_TEXT,
                          ),
                          SizedBox(height: 20),
                          Text(UNABLE_TO_LOAD_DATA_FORM_SERVER),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    controller: _scrollController,
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: const Color.fromARGB(255, 243, 103, 9),
                              valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).hintColor),
                            ),
                          )
                        : Column(
                            children: [
                              header(),
                              isFilterLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: const Color.fromARGB(
                                            255, 243, 103, 9),
                                      ),
                                    )
                                  : body()
                            ],
                          ),
                  ),
            header(),
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Stack(
      children: [
        Image.asset(
          "assets/homeScreenImages/header_bg.png",
          height: MediaQuery.of(context).size.height * 0.08,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
        ),
        SafeArea(
          child: Container(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      "assets/moreScreenImages/back.png",
                      height: 25,
                      width: 22,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Filters",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: WHITE,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                  SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      setState(() {
                        print("Filter Fees: $filterFees");
                        print("Languages Selected: $selectedLanguages");
                        print("Activities Selected: $selectedActivities");
                        print("Gender: $filterGender");
                        if (isFeesSelected ||
                            isLanguageSelected ||
                            isActivitiesSelected ||
                            isGenderSelected) {
                          setState(() {
                            isFilterLoading = true;
                          });
                          getFiltersDoctors();
                        } else {
                          print("No Value Selected");
                        }
                      });
                    },
                    child: Text(
                      "Apply",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRadioButtons(String title, int selectedValue,
      List<String> options, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: options.asMap().entries.map((entry) {
            int idx = entry.key;
            String option = entry.value;
            return Expanded(
              child: Row(
                children: [
                  Radio<int>(
                    value: idx,
                    groupValue: selectedValue,
                    onChanged: (value) => onChanged(value!),
                    activeColor: Color.fromARGB(255, 12, 88, 150),
                  ),
                  if (option == 'Male')
                    Icon(Icons.male, color: Color.fromARGB(255, 12, 88, 150)),
                  if (option == 'Female')
                    Icon(Icons.female, color: Color.fromARGB(255, 12, 88, 150)),
                  SizedBox(width: 4),
                  Text(option),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget body() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(seconds: 1),
              child: _buildRadioButtons(
                'Gender',
                selectedGender,
                ['All', 'Male', 'Female'],
                (value) {
                  setState(() {
                    selectedGender = value;
                    filterGender = value == 1
                        ? 'Male'
                        : value == 2
                            ? 'Female'
                            : null;
                    isGenderSelected = value != 0;
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: _buildSlider('Price Range', priceRange, (value) {
                setState(() {
                  priceRange = value.toDouble();
                  filterFees = value.toInt();
                  isFeesSelected = true;
                });
              }),
            ),
            SizedBox(height: 16),
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(seconds: 1),
              child: _buildMultiSelect('Languages', selectedLanguages,
                  ['English', 'Bengali', 'Hindi', 'Urdu'], (value) {
                setState(() {
                  selectedLanguages = value;
                  isLanguageSelected = selectedLanguages.isNotEmpty;
                });
              }),
            ),
            SizedBox(height: 16),
            AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: _buildMultiSelect(
                'Activities',
                selectedActivities,
                [
                  'Translation & Interpretation',
                  'Pick Up & Driving Tours',
                  'Shopping',
                  'Nightlife & Bars',
                  'Food & Resturants',
                  'Arts & Museums',
                  'Sports & Recreation',
                  'History & Culture',
                  'Exploration & Sightseeing'
                ],
                (value) {
                  setState(() {
                    selectedActivities = value;
                    isActivitiesSelected = selectedActivities.isNotEmpty;
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            _buildCheckbox(
                'Save my filter settings for future use', saveFilterSettings,
                (value) {
              setState(() {
                saveFilterSettings = value;
              });
            }),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedGender = 0;
                    priceRange = 0;
                    selectedLanguages = [];
                    selectedActivities = [];
                    saveFilterSettings = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: Color.fromARGB(255, 243, 103, 9),
                    width: 1.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                ),
                child: Text(
                  'Clear All',
                  style: TextStyle(
                    color: Color.fromARGB(255, 243, 103, 9),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, ValueChanged<int> onChanged) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 18.0), // Adjust the left padding as needed
            child: Text(
              label,
              style: GoogleFonts.robotoCondensed(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // Divider(
          //   height: 10,
          //   color: Colors.grey,
          // ),
          Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 18,
                        right: 18,
                      ), // Adjust the left padding as needed
                      child: Text(
                        'Free',
                        style: GoogleFonts.robotoCondensed(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    // SizedBox(
                    //   width: MediaQuery.of(context).size.width * 0.65,
                    // ),
                    Text(
                      '100',
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                // SliderTheme(
                //   data: SliderThemeData(
                //     //trackHeight: 5, // Change the height of the track
                //     thumbShape: RoundSliderThumbShape(
                //       enabledThumbRadius: 10, // Change the size of the thumb
                //     ),
                //   ),
                //   child: Slider(
                //     value: value,
                //     min: 0,
                //     max: 100,
                //     onChanged: (double newValue) {
                //       onChanged(
                //           newValue.round()); // Round the double value to an integer
                //     },
                //     activeColor: Color.fromARGB(190, 255, 115, 0),
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Text(
                //       '100',
                //       style: GoogleFonts.robotoCondensed(
                //           fontSize: 20, fontWeight: FontWeight.w500),
                //     ),
                //   ],
                // ),
                Column(
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        //trackHeight: 5, // Change the height of the track
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius:
                              10, // Change the size of the thumb
                        ),
                      ),
                      child: Slider(
                        value: value,
                        min: 0,
                        max: 100,
                        onChanged: (double newValue) {
                          onChanged(newValue
                              .round()); // Round the double value to an integer
                          setState(() {
                            filterFees = newValue.round();
                            print("filter Fees are: $filterFees");
                            if (filterFees != null) {
                              isFeesSelected = true;
                            } else {
                              isFeesSelected = false;
                            }
                          });
                        },
                        activeColor: Color.fromARGB(190, 255, 115, 0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Selected Fees: ${value.round()}',
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          // Divider(
          //   height: 10,
          //   color: Colors.grey,
          // ),
        ],
      ),
    );
  }

  // Widget _buildSlider(String title, double value, Function(double) onChanged) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Container(
  //         padding: EdgeInsets.only(left: 16),
  //         child: Text(
  //           title,
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ),
  //       Slider(
  //         value: value,
  //         onChanged: (value) => onChanged(value),
  //         activeColor: Color.fromARGB(255, 243, 103, 9),
  //         min: 0,
  //         max: 100,
  //         divisions: 100,
  //         label: value.round().toString(),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildMultiSelect(String title, List<String> selectedValues,
      List<String> options, Function(List<String>) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16, vertical: 8), // Adjusted padding
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 8),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
              horizontal: 16, vertical: 8), // Adjusted padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[200],
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (selectedValues.contains(option)) {
                      selectedValues.remove(option);
                    } else {
                      selectedValues.add(option);
                    }
                    onChanged(selectedValues);
                  });
                },
                child: Chip(
                  label: Text(option),
                  backgroundColor: selectedValues.contains(option)
                      ? Color.fromARGB(255, 243, 103, 9)
                      : Colors.transparent,
                  labelStyle: TextStyle(
                    color: selectedValues.contains(option)
                        ? Colors.white
                        : Colors.black,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: Color.fromARGB(255, 243, 103, 9),
                      width: 1.5,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox(String title, bool value, Function(bool) onChanged) {
    return CheckboxListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      value: value,
      onChanged: (value) => onChanged(value!),
      activeColor: Color.fromARGB(255, 243, 103, 9),
    );
  }

  void _clearFilters() {
    setState(() {
      selectedGender = 0;
      priceRange = 0;
      selectedLanguages.clear();
      selectedActivities.clear();
      saveFilterSettings = false;
    });
  }
}
