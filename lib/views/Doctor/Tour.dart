import 'dart:convert';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/modals/TripsClass.dart';
import 'package:appcode3/views/ChoosePlan.dart';
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
  bool isMember = false;

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

  checkIsMember() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/check_membership?id=${doctorId}"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        if (jsonResponse['is_member'] == 0) {
          isMember = false;
        } else {
          isMember = true;
        }
      });
    } else {
      print("Api is not call properly");
    }
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((pref) {
      setState(() {
        doctorId = pref.getString("userId");
        print(doctorId);
        if (doctorId != null) {
          print("Check Member called");
          checkIsMember();
        }
        print("fetchTrips function is calling");
        future1 = fetchTrips(int.parse(doctorId!));
        print("This is future: $future1");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/moreScreenImages/header_bg.png",
          height: 140,
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
        ),
        SafeArea(
          child: Scaffold(
            backgroundColor: LIGHT_GREY_SCREEN_BACKGROUND,
            appBar: AppBar(
              title: Text(
                TOUR,
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.headlineSmall!.apply(
                      color: Theme.of(context).primaryColorDark,
                      fontWeightDelta: 1),
                ),
              ),
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
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Handle the create trip button click
                            // You can navigate to a new screen or perform other actions
                            isMember
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CreateTrip()),
                                  )
                                : Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => ChoosePlan()),
                                  );
                          },
                          icon: Icon(CupertinoIcons.plus_circle_fill),
                          label: Text(
                            'Create Trip',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: MediaQuery.of(context).size.width *
                                  0.05 /
                                  1.2,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 13,
                                horizontal: 25), // Adjust padding dynamically
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
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05),
                        )
                      : Container(
                          alignment: Alignment.center,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.03, // Adjust the height dynamically
                              ),
                              Text(
                                "My saved Trips!",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "You haven't created any Trips yet. Create your first Trip so available locals can send you offers.",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.025,
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    0.01, // Adjust the height dynamically
                              ),
                              buildTripList(),
                            ],
                          ),
                        ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .01,
                  ),
                  Flexible(child: buildTripList())
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTripList() {
    if (isTripsAvailable && tripsClass != null && tripsClass!.data != null) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: tripsClass!.data!.length,
        itemBuilder: (context, index) {
          Trip trip = tripsClass!.data![index];

          return TripCard(
            trip: trip,
            context: context, // Pass the context here
            onDeleteSuccess: handleDeleteSuccess, // Pass callback function
          );
        },
      );
    } else {
      return Container();
    }
  }
}
