import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/views/CreateTrip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

class Tour extends StatefulWidget {
  const Tour({super.key});

  @override
  State<Tour> createState() => _TourState();
}

class _TourState extends State<Tour> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(TOUR,
              style: Theme.of(context).textTheme.headline5!.apply(
                  color: Theme.of(context).backgroundColor,
                  fontWeightDelta: 5)),
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
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: BLACK,
                          fontSize: 16),
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
                      icon: Icon(Icons.add),
                      label: Text(
                        'Create a Trip',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            color: WHITE,
                            fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * .2,
                            vertical: MediaQuery.of(context).size.height * .02),
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
                height: MediaQuery.of(context).size.height * .25,
              ),
              Container(
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Center vertically
                    children: [
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
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
