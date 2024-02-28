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

class LocationSearchPageInfo extends StatefulWidget {
  @override
  _LocationSearchPageInfoState createState() => _LocationSearchPageInfoState();

  late final String id;
  late final String city;

  LocationSearchPageInfo(this.id, this.city);
}

class _LocationSearchPageInfoState extends State<LocationSearchPageInfo> {
  TextEditingController _searchController = TextEditingController();

  String? selectedCity;

  late TextEditingController _controller;
  String enteredValue = '';
  bool isValueChanged = false;
  void updatingCity() async {
    print('Entered value before updating city: $enteredValue');
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/updateCity"), body: {
      "id": widget.id,
      "city": enteredValue,
    });
    print("$SERVER_ADDRESS/api/updateCity");
    // print(response.body);
    if (response.statusCode == 200) {
      print("Location Updated");
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print("Location Not Updated");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.city);
  }

  List<String> suggestedCities = [
    'Bagerhat',
    'Bandarban',
    'Barguna',
    'Barishal',
    'Bhola',
    'Bogura',
    'Brahmanbaria',
    'Chandpur',
    'Chattogram',
    'Chuadanga',
    'Comilla',
    'Cox\'s Bazar',
    'Dhaka',
    'Dinajpur',
    'Faridpur',
    'Feni',
    'Gaibandha',
    'Gazipur',
    'Gopalganj',
    'Habiganj',
    'Jamalpur',
    'Jashore (Jessore)',
    'Jhalokathi',
    'Jhenaidah',
    'Joypurhat',
    'Khagrachari',
    'Khulna',
    'Kishoreganj',
    'Kushtia',
    'Lakshmipur',
    'Lalmonirhat',
    'Madaripur',
    'Magura',
    'Manikganj',
    'Meherpur',
    'Moulvibazar',
    'Munshiganj',
    'Mymensingh',
    'Naogaon',
    'Narail',
    'Narayanganj',
    'Narsingdi',
    'Netrokona',
    'Nilphamari',
    'Noakhali',
    'Pabna',
    'Panchagarh',
    'Patuakhali',
    'Pirojpur',
    'Rajbari',
    'Rajshahi',
    'Rangamati',
    'Rangpur',
    'Satkhira',
    'Shariatpur',
    'Sherpur',
    'Sirajganj',
    'Sunamganj',
    'Sylhet',
    'Tangail',
    'Thakurgaon',
    'Jamalpur',
    'Narsingdi',
    'Netrakona',
  ];

  List<String> filteredCities = []; // List to store filtered cities

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Search Location',
            style: TextStyle(color: Colors.black),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/moreScreenImages/header_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                if (isValueChanged) {
                  setState(() {
                    enteredValue = _searchController
                        .text; // Update enteredValue with the text from the search controller
                  });
                  updatingCity(); // Call updatingCity to update the city
                } else {
                  // If there's no value change, you might want to handle this case
                  Navigator.pop(context);
                }
              },
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  // Filter the cities based on the entered text
                  setState(() {
                    filteredCities = suggestedCities
                        .where((city) =>
                            city.toLowerCase().contains(value.toLowerCase()))
                        .toList();
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search_sharp),
                  prefixIconColor: Colors.lightBlue,
                  hintText: 'Search city...',
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCities.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredCities[index]),
                      onTap: () {
                        // Store the selected value
                        String selectedCity = filteredCities[index];

                        // Update enteredValue with the selected city and clear suggestions
                        setState(() {
                          // Update enteredValue with the selected city
                          enteredValue = selectedCity;

                          isValueChanged = true;

                          // Update text controller's text with the selected city
                          _searchController.text = selectedCity;

                          // Close the keyboard
                          FocusScope.of(context).unfocus();
                        });

                        // Clear the suggestions list outside of setState
                        filteredCities.clear();

                        print(
                            'Entered value after tapping city: $enteredValue');
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
