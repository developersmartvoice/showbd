import 'dart:convert';
import 'package:appcode3/views/DetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/modals/AcceptBookingClass.dart';
import 'package:appcode3/modals/GetDirectBookingClass.dart';
import 'package:appcode3/views/ChatScreen.dart';

class BookingDetailsScreen extends StatefulWidget {
  final DirectBooking booking;
  final String recip_id;

  BookingDetailsScreen({required this.booking, required this.recip_id});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  int? booking_id;
  bool loading = false;
  AcceptBookingClass? acceptBookingClass;
  // String? recip_id;

  @override
  void initState() {
    super.initState();
    notificationHelper.initialize();
    booking_id = widget.booking.bookingId;
    // recip_id = widget.booking.
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

      // Send notifications
      notificationHelper.showNotification(
        title: 'Request Accepted!',
        body: '${acceptBookingClass!.recipientName} has sent you a booking.',
        payload: 'user_id:${acceptBookingClass!.senderId}',
        id: acceptBookingClass!.senderId.toString(),
      );

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
              acceptBookingClass!.recipientImage)),
        ),
      );
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
              ? Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 243, 103, 9),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Hero(
                              tag: 'profile-pic',
                              child: Container(
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage:
                                      NetworkImage(widget.booking.senderImage!),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Center(
                            child: TextButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (builder) =>
                                        DetailsPage(widget.recip_id, false),
                                  ),
                                );
                              },
                              icon: Icon(Icons.badge),
                              label: Text("View Profile"),
                              style: ButtonStyle(
                                elevation: MaterialStatePropertyAll(5),
                                iconSize: MaterialStatePropertyAll(15),
                                textStyle: MaterialStatePropertyAll(
                                  TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                ),
                                foregroundColor:
                                    MaterialStatePropertyAll(WHITE),
                                backgroundColor: MaterialStatePropertyAll(
                                  Color.fromARGB(255, 243, 103, 9),
                                ),
                                minimumSize:
                                    MaterialStatePropertyAll(Size(15, 15)),
                                shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                    side: BorderSide(
                                      width: .5,
                                      color: Color.fromARGB(255, 243, 103, 9),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            widget.booking.senderName ?? '',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Date: ${widget.booking.date ?? ''}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.timer),
                                    SizedBox(width: 8),
                                    Text(
                                        'Duration: ${widget.booking.duration ?? ''} hours'),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.schedule),
                                    SizedBox(width: 8),
                                    Text(
                                        'Timing: ${widget.booking.timing ?? ''}'),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.person),
                                    SizedBox(width: 8),
                                    Text(
                                        'Number of People: ${widget.booking.numPeople ?? ''}'),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.message),
                                    SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        'Message: ${widget.booking.message ?? ''}',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
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
    );
  }
}
