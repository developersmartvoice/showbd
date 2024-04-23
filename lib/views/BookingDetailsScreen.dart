import 'dart:convert';

import 'package:appcode3/main.dart';
import 'package:appcode3/modals/AcceptBookingClass.dart';
import 'package:appcode3/modals/GetDirectBookingClass.dart';
import 'package:appcode3/views/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class BookingDetailsScreen extends StatefulWidget {
  final DirectBooking booking;

  BookingDetailsScreen({required this.booking});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  int? booking_id;
  bool loading = false;
  AcceptBookingClass? acceptBookingClass;
  @override
  void initState() {
    super.initState();
    booking_id = widget.booking.bookingId;
    print("This is booking ID: $booking_id");
  }

  acceptBooking() async {
    final response = await get(Uri.parse(
        "$SERVER_ADDRESS/api/accept_direct_booking?direct_booking_id=${booking_id}"));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      acceptBookingClass = AcceptBookingClass.fromJson(jsonResponse);
      setState(() {
        loading = false;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: ((context) => ChatScreen(
                  acceptBookingClass!.senderName,
                  '100' + acceptBookingClass!.senderId.toString(),
                  acceptBookingClass!.senderConnectycubeId,
                  false,
                  acceptBookingClass!.senderDeviceTokens,
                  acceptBookingClass!.senderImage,
                  acceptBookingClass!.recipientImage))));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Something went wrong. Please try again later."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pop(true); // Close the dialog
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  rejectBooking() async {
    final response = await get(Uri.parse(
        "$SERVER_ADDRESS/api/reject_direct_booking?direct_booking_id=$booking_id"));

    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Booking Rejected"),
            content: Text("You rejected ${widget.booking.senderName} booking."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          // Pop the dialog if it's open
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(true);
            return false; // Prevent default back button behavior
          }
          return true; // Allow default back button behavior
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              color: WHITE,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            title: Text("BOOKING DETAILS",
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
          body: loading
              ? Container(
                  alignment: Alignment.center,
                  transformAlignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 243, 103, 9),
                  ),
                )
              : Card(
                  elevation: 3,
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  widget.booking.senderImage ?? ''),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.booking.senderName ?? '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Date: ${widget.booking.date ?? ''}',
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Duration: ${widget.booking.duration ?? ''} h',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Timing: ${widget.booking.timing ?? ''}',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Number of People: ${widget.booking.numPeople ?? ''}',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Message: ${widget.booking.message ?? ''}',
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(height: 20), // Add some spacing
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Handle accept action
                                setState(() {
                                  loading = true;
                                });
                                acceptBooking();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: Text('Accept'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Handle reject action
                                setState(() {
                                  loading = true;
                                });
                                rejectBooking();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              child: Text('Reject'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
