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
              : Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        widget.booking.senderImage ?? ''),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.03),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.booking.senderName ?? '',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Date: ${widget.booking.date ?? ''}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Duration: ${widget.booking.duration ?? ''} hours',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          const Color.fromARGB(255, 4, 11, 22),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Timing: ${widget.booking.timing ?? ''}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          const Color.fromARGB(255, 6, 31, 8),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Number of People: ${widget.booking.numPeople ?? ''}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color:
                                          const Color.fromARGB(255, 14, 8, 39),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Message: ${widget.booking.message ?? ''}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 169, 163, 163),
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        loading = true;
                                      });
                                      acceptBooking();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 15),
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Text('Accept',
                                        style: TextStyle(
                                          fontSize:
                                              MediaQuery.sizeOf(context).width *
                                                  .04,
                                        )),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        loading = true;
                                      });
                                      rejectBooking();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 15),
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Text('Reject',
                                        style: TextStyle(
                                          fontSize:
                                              MediaQuery.sizeOf(context).width *
                                                  .04,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
