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

class ServiceNew extends StatefulWidget {
  final String id;
  final String services;

  ServiceNew(this.id, this.services);
  //const NameSettingsPage({super.key});

  @override
  State<ServiceNew> createState() => _ServiceNewState();
  //late final String id;
  //late final String gender;
  //late final String services;
  //late final String aboutMe;
  //late final String city;

  //ServiceNew(this.id, this.services);
}

class _ServiceNewState extends State<ServiceNew> {
  List<String> selectedServices = [];
  String selectedService = "";
  late TextEditingController _controller;
  // String enteredValue = '';
  //bool isGenderSelected = false;
  bool isServiceSelected = false;
  bool isValueChanged = false;

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
  void updatingServices() async {
    List<String> mappedServices =
        selectedServices.map((service) => serviceMap[service]!).toList();
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/updateServices"), body: {
      "id": widget.id,
      "services": selectedServices,
    });
    print("$SERVER_ADDRESS/api/updateServices");
    print(response.body);
    if (response.statusCode == 200) {
      print("Service Updated");
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print("Service Not Updated");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.services);
  }

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
                  'Select Your Preferred Activity',
                  style: GoogleFonts.robotoCondensed(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Container(
              //   padding: EdgeInsets.all(16),
              //   alignment: Alignment.topLeft,
              //   child: Text(
              //     GENDER_PAGE,
              //     style: TextStyle(
              //       color: Colors.black,
              //       fontSize: 12,
              //       fontWeight: FontWeight.w200,
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 5,
              ),

              Column(
                children: serviceMap.keys.map((key) {
                  return CheckboxListTile(
                    title: Text(serviceMap[key]!),
                    value: selectedServices.contains(key),
                    onChanged: (newValue) {
                      setState(() {
                        if (newValue != null) {
                          if (newValue) {
                            selectedServices.add(key);
                          } else {
                            selectedServices.remove(key);
                          }
                          isServiceSelected = selectedServices.isNotEmpty;
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
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
              // Container(
              //   color: Colors.white,
              //   child: DropdownSearch<String>(
              //     items: [
              //       'Translation & Interpretation',
              //       'Pick up & Driving tours ',
              //       'Shopping',
              //       'Nightlife & Bars',
              //       'Food & Restaurants',
              //       'Arts & Museums',
              //       'Sports & Recreation',
              //       'History & Culture',
              //       'Exploration & Sightseeing',
              //     ],
              //     onChanged: (value) {
              //       setState(() {
              //         selectedService = value!;
              //         if (selectedService.isNotEmpty) {
              //           isServiceSelected = true;
              //         } else {
              //           isServiceSelected = false;
              //         }
              //       });
              //     },
              //     selectedItem:
              //         isServiceSelected ? selectedService : widget.services,
              //   ),
              //   // TextField(
              //   //   controller: _controller,
              //   //   style: TextStyle(
              //   //     color: Colors.black,
              //   //     fontSize: 16,
              //   //     fontWeight: FontWeight.w200,
              //   //   ),
              //   //   onChanged: (value) {
              //   //     setState(
              //   //       () {
              //   //         enteredValue = value;
              //   //         if (enteredValue != widget.gender) {
              //   //           isValueChanged = true;
              //   //         } else {
              //   //           isValueChanged = false;
              //   //         }
              //   //       },
              //   //     );
              //   //   },
              //   //   decoration: InputDecoration(
              //   //     border: OutlineInputBorder(),
              //   //     hintText: widget.gender,
              //   //     hintStyle: TextStyle(color: Colors.black),
              //   //   ),
              //   // ),
              // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
