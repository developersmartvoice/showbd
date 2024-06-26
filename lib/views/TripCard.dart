import 'dart:convert';
import 'package:appcode3/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:appcode3/modals/TripsClass.dart';

class TripCard extends StatelessWidget {
  final Trip trip;
  final BuildContext context;
  final Function(int) onDeleteSuccess; // Define callback function

  TripCard({
    required this.trip,
    required this.context,
    required this.onDeleteSuccess,
  });

  Future<void> deleteTrip(int id) async {
    final response = await http.post(
      Uri.parse("$SERVER_ADDRESS/api/deleteTrip"),
      body: {
        "id": id.toString(),
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['delete'] == "Trip deleted successfully") {
        print("Trip Deleted");
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                "Trip Deleted Successfully",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onDeleteSuccess(
                        id); // Call onDeleteSuccess with the trip ID
                  },
                  child: Text("OK"),
                )
              ],
            );
          },
        );
      } else {
        print("Trip Not Deleted");
      }
    } else {
      print("Trip Not Deleted");
    }
  }

  void showDeleteConfirmationDialog(Function(int) onDeleteConfirmed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Trip"),
          content: Text(
            "Are you sure you want to delete this trip?",
            style: TextStyle(
              color: Colors.black,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                onDeleteConfirmed(
                    trip.id!); // Pass trip ID to onDeleteConfirmed
                Navigator.pop(context);
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Widget tripImage() {
    return Image.asset(
      'assets/Tropical-Wallpaper03-1920x1200.jpg',
      height: 150.0,
      width: double.infinity,
      fit: BoxFit.fill,
    );
  }

  Widget tripDetails() {
    String formattedStartDate = formatDate(trip.startDate ?? '');
    String formattedEndDate = formatDate(trip.endDate ?? '');

    return Container(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Flexible(
                child: FittedBox(
                  child: Icon(
                    CupertinoIcons.location_circle_fill,
                    size: MediaQuery.of(context).size.width * 0.07,
                  ),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              Expanded(
                flex: 9,
                child: Text(
                  'Trip to ${trip.destination ?? ''}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.of(context).size.width * 0.05 / 1.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  size: MediaQuery.of(context).size.width * 0.1,
                ),
                onPressed: () {
                  showDeleteConfirmationDialog((id) {
                    deleteTrip(id); // Call deleteTrip with the trip ID
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Flexible(
                child: FittedBox(
                  child: Icon(Icons.calendar_month_sharp,
                      size: MediaQuery.of(context).size.width * 0.07),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 10,
                child: Text(
                  '$formattedStartDate to $formattedEndDate',
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Flexible(
                child: FittedBox(
                  child: Icon(
                    CupertinoIcons.person_3_fill,
                    size: MediaQuery.of(context).size.width * 0.06,
                  ),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              Expanded(
                flex: 5,
                child: Text(
                  'Number of People: ${getNumberString(trip.peopleQuantity)}',
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width * 0.032,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacer(),
              if (trip.endDate != null) // Check if endDate is not null
                Expanded(
                  flex: 2,
                  child: FittedBox(
                    child: Text(
                      trip.endDate!.compareTo(DateTime.now().toString()) < 0
                          ? 'Expired'
                          : 'Active',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.width * 0.006,
                        color:
                            trip.endDate!.compareTo(DateTime.now().toString()) <
                                    0
                                ? Colors.red
                                : Colors.green,
                        // overflow: TextOverflow.ellipsis,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String day = dateTime.day.toString();
    String month = dateTime.month.toString();
    String year = dateTime.year.toString();
    List<String> suffixes = [
      'th',
      'st',
      'nd',
      'rd',
      'th',
      'th',
      'th',
      'th',
      'th',
      'th'
    ];
    String suffix = suffixes[int.parse(day) % 10];
    if (day.length == 1) {
      day = '0$day';
    }
    return '$day$suffix ${_getMonth(month)} $year';
  }

  String _getMonth(String month) {
    switch (month) {
      case '1':
        return 'Jan';
      case '2':
        return 'Feb';
      case '3':
        return 'Mar';
      case '4':
        return 'Apr';
      case '5':
        return 'May';
      case '6':
        return 'Jun';
      case '7':
        return 'Jul';
      case '8':
        return 'Aug';
      case '9':
        return 'Sep';
      case '10':
        return 'Oct';
      case '11':
        return 'Nov';
      case '12':
        return 'Dec';
      default:
        return '';
    }
  }

  String getNumberString(n) {
    switch (n) {
      case 1:
        return "Only Me";
      case 2:
        return "Two People";
      case 3:
        return "Three People";
      default:
        return "More than Three";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width *
            0.9, // Adjust this factor as needed
        child: ListTile(
          contentPadding: EdgeInsets.all(0),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              tripImage(),
              SizedBox(height: 6.0),
              tripDetails(),
            ],
          ),
          onTap: () {
            // Handle tap on a trip (if needed)
          },
        ),
      ),
    );
  }
}
