import 'dart:convert';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/modals/TripsClass.dart';
import 'package:appcode3/views/CreateTrip.dart';
import 'package:appcode3/views/TripCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tour extends StatefulWidget {
  const Tour({Key? key});

  @override
  State<Tour> createState() => _TourState();
}

class _TourState extends State<Tour> {
  TripsClass? tripsClass;
  String? doctorId;
  Future? future1;
  Future? future2;
  bool isTripsAvailable = false;

  void handleDeleteSuccess(int deletedTripId) {
    // Remove the deleted trip from tripsClass.data
    setState(() {
      tripsClass?.data?.removeWhere((trip) => trip.id == deletedTripId);
    });
  }

  fetchTrips(int id) async {
    final response =
        await get(Uri.parse("$SERVER_ADDRESS/api/gettrip?guide_id=$id"));
    print(Uri.parse("$SERVER_ADDRESS/api/gettrip?guide_id=$id"));
    print('Trips are -> ${response.body}');
    // print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'].toString() == "1") {
        setState(() {
          isTripsAvailable = true;
          tripsClass = TripsClass.fromJson(jsonResponse);
          print("Here data after successful request!!");
          print(tripsClass!.data!);
        });
      } else {
        setState(() {
          isTripsAvailable = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((pref) {
      setState(() {
        doctorId = pref.getString("userId");
        print(doctorId);
        print("fetchTrips function is calling");
        future1 = fetchTrips(int.parse(doctorId!));
        print("This is future: $future1");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(TOUR,
              style: Theme.of(context).textTheme.headline5!.apply(
                  color: Theme.of(context).backgroundColor,
                  fontWeightDelta: 5)),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/moreScreenImages/header_bg.png"), // Add your background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Save time by planning your trip and get offers from locals',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: BLACK,
                          fontSize: 15),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle the create trip button click
                        // You can navigate to a new screen or perform other actions
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateTrip()),
                        );
                      },
                      icon: Icon(CupertinoIcons.plus_circle_fill),
                      label: Text(
                        'Create Trip',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize:
                              MediaQuery.of(context).size.width * 0.05 / 1.2,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(95, 13, 95, 13),
                        backgroundColor: Color.fromARGB(255, 243, 103, 9),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Add the column view for displaying trips here
              // You can use a ListView.builder or any other widget based on your data
              SizedBox(
                height: MediaQuery.of(context).size.height * .02,
              ),
              isTripsAvailable && tripsClass!.data!.isNotEmpty
                  ? Text(
                      "My Trips",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: BLACK,
                          fontSize: 18),
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .25,
                          ),
                          Text(
                            "My saved Trips!",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: BLACK,
                                fontSize: 18),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "You haven't created any Trips yet. Create your first Trip so available locals can send you offers.",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                color: BLACK,
                                fontSize: 14),
                          )
                        ],
                      ),
                    ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              buildTripList()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTripList() {
    if (isTripsAvailable && tripsClass != null && tripsClass!.data != null) {
      return Expanded(
        child: ListView.builder(
          itemCount: tripsClass!.data!.length,
          itemBuilder: (context, index) {
            Trip trip = tripsClass!.data![index];

            return TripCard(
              trip: trip,
              context: context, // Pass the context here
              onDeleteSuccess: handleDeleteSuccess, // Pass callback function
            );
          },
        ),
      );
    } else {
      return Container();
    }
  }
}
