import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appcode3/modals/TripsClass.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TripCard extends StatelessWidget {
  final Trip trip;

  TripCard({required this.trip});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        // title: tripsTitle(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 8.0),
            tripImage(),
            SizedBox(height: 6.0),
            tripDetails(),
          ],
        ),
        onTap: () {
          // Handle tap on a trip (if needed)
        },
      ),
    );
  }

  // Widget tripsTitle() {
  //   String titleText = (trip != null && trip.destination != null)
  //       ? "My Trips to ${trip.destination}"
  //       : "My Trips";

  //   return Text(
  //     titleText,
  //     style: TextStyle(
  //       fontSize: 18.0,
  //       fontWeight: FontWeight.bold,
  //     ),
  //   );
  // }

  Widget tripImage() {
    // Placeholder image, replace with your own or use a network image
    return Image.asset(
      'assets/trip_image_placeholder.jpg',
      height: 150.0,
      width: double.infinity,
      fit: BoxFit.fill,
    );
  }

  Widget tripDetails() {
    return Container(
      padding: EdgeInsets.fromLTRB(14, 5, 14, 5),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(CupertinoIcons.location_circle_fill),
              SizedBox(width: 10),
              Text(
                'Trip to ${trip.destination ?? ''}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Icon(Icons.calendar_month_sharp),
              SizedBox(width: 10),
              Text(
                '${trip.startDate ?? ''} to ${trip.endDate ?? ''}',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Icon(CupertinoIcons.person_3_fill),
              SizedBox(width: 10),
              Text(
                'Number of People: ${getNumberString(trip.peopleQuantity)}',
                style: TextStyle(
                    // color: Colors.blue,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String getNumberString(n) {
    switch (n) {
      case 1:
        return "Just me";
      case 2:
        return "Two People";
      case 3:
        return "Three People";
      default:
        return "More than Three";
    }
  }
}
