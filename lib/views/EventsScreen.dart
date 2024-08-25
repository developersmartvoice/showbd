import 'dart:convert';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/modals/EventsClass.dart';
import 'package:appcode3/views/CreateEvent.dart';
import 'package:appcode3/views/EventDetailsPage.dart';
import 'package:appcode3/views/EventsCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with SingleTickerProviderStateMixin {
  EventResponseClass? _eventResponseClass;
  late TabController _tabController;
  List<Event>? eventList;
  List<Event>? myEventList;
  String? userId;
  int? userIntId;
  int status = 0;

  Future<void> fetchAllEvents() async {
    final response = await get(Uri.parse("$SERVER_ADDRESS/api/all_event"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        _eventResponseClass = EventResponseClass.fromJson(jsonResponse);
        eventList = _eventResponseClass!.events;
      });
    } else {
      setState(() {
        eventList = [];
      });
    }
  }

  Future<void> fetchMyEvents() async {
    final response =
        await get(Uri.parse("$SERVER_ADDRESS/api/my_event?user_id=$userId"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        _eventResponseClass = EventResponseClass.fromJson(jsonResponse);
        myEventList = _eventResponseClass!.events;
        print(_eventResponseClass!.events);
      });
    } else {
      setState(() {
        myEventList = [];
      });
    }
  }

  int checkStatus(Event event) {
    userIntId = int.parse(userId!);
    if (event.interested != null && event.interested!.contains(userIntId)) {
      return 1;
    } else if (event.going != null && event.going!.contains(userIntId)) {
      return 2;
    } else if (event.notGoing != null && event.notGoing!.contains(userIntId)) {
      return 3;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    SharedPreferences.getInstance().then((pref) {
      setState(() {
        userId = pref.getString("userId");
        fetchAllEvents();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LIGHT_GREY_SCREEN_BACKGROUND,
      appBar: AppBar(
        title: Text(
          EVENTS,
          style: GoogleFonts.poppins(
            textStyle: Theme.of(context)
                .textTheme
                .headlineSmall!
                .apply(color: WHITE, fontWeightDelta: 1),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Column(
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
                      'Create events to showcase the traditional festivals of your region',
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateEvent(),
                          ),
                        );
                      },
                      icon: Icon(CupertinoIcons.plus_circle_fill),
                      label: Text(
                        'Create Event',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize:
                              MediaQuery.of(context).size.width * 0.05 / 1.2,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: 13, horizontal: 25),
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
              SizedBox(
                height: 25,
              ),
              TabBar(
                controller: _tabController,
                onTap: (value) {
                  print("Tab value is: $value");
                  if (value == 1) {
                    fetchMyEvents();
                  }
                },
                tabs: [
                  Tab(text: "All Events"),
                  Tab(text: "My Events")
                  // Tab(text: "Interested"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _eventResponseClass != null
                        ? eventList!.isNotEmpty
                            ? ListView.builder(
                                itemCount: eventList!.length,
                                itemBuilder: (context, index) {
                                  final event = eventList![index];
                                  final status = checkStatus(event);

                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EventDetailsPage(
                                            eventId: event.id,
                                            imgUrl: event.image,
                                            eventName: event.name,
                                            eventDescription: event.description,
                                            location: event.location,
                                            startDate: event.startDate,
                                            endDate: event.endDate,
                                            time: event.startDateTime,
                                            countInterested:
                                                event.interested != null
                                                    ? event.interested!.length
                                                        .toString()
                                                    : "0",
                                            countGoing: event.going != null
                                                ? event.going!.length.toString()
                                                : "0",
                                            status: status.toString(),
                                            self: event.userId == userIntId
                                                ? true
                                                : false,
                                          ),
                                        ),
                                      );
                                    },
                                    child: EventsCard(
                                      eventId: event.id,
                                      imgUrl: event.image,
                                      eventName: event.name,
                                      location: event.location,
                                      startDate: event.startDate,
                                      endtDate: event.endDate,
                                      time: event.startDateTime,
                                      countInterested: event.interested != null
                                          ? event.interested!.length.toString()
                                          : "0",
                                      countGoing: event.going != null
                                          ? event.going!.length.toString()
                                          : "0",
                                      status: status.toString(),
                                      self: event.userId == userIntId
                                          ? true
                                          : false,
                                    ),
                                  );
                                },
                              )
                            : Center(child: Text("No Events Upcoming"))
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                    // Center(child: Text("Create Your Events")),
                    myEventList != null
                        ? myEventList!.isNotEmpty
                            ? ListView.builder(
                                itemCount: myEventList!.length,
                                itemBuilder: (context, index) {
                                  final event = myEventList![index];
                                  final status = checkStatus(event);

                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EventDetailsPage(
                                            eventId: event.id,
                                            imgUrl: event.image,
                                            eventName: event.name,
                                            eventDescription: event.description,
                                            location: event.location,
                                            startDate: event.startDate,
                                            endDate: event.endDate,
                                            time: event.startDateTime,
                                            countInterested:
                                                event.interested != null
                                                    ? event.interested!.length
                                                        .toString()
                                                    : "0",
                                            countGoing: event.going != null
                                                ? event.going!.length.toString()
                                                : "0",
                                            status: status.toString(),
                                            self: true,
                                          ),
                                        ),
                                      );
                                    },
                                    child: EventsCard(
                                      eventId: event.id,
                                      imgUrl: event.image,
                                      eventName: event.name,
                                      location: event.location,
                                      startDate: event.startDate,
                                      endtDate: event.endDate,
                                      time: event.startDateTime,
                                      countInterested: event.interested != null
                                          ? event.interested!.length.toString()
                                          : "0",
                                      countGoing: event.going != null
                                          ? event.going!.length.toString()
                                          : "0",
                                      status: status.toString(),
                                      self: true,
                                    ),
                                  );
                                },
                              )
                            : Center(child: Text("No Events Upcoming"))
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                    // Center(child: Text("Past Events")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
