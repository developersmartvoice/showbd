// import 'dart:io';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/notificationHelper.dart';
import 'package:appcode3/views/Doctor/DoctorChatListScreen.dart';
import 'package:appcode3/views/Doctor/Tour.dart';
import 'package:appcode3/views/EventsScreen.dart';
import 'package:appcode3/views/HomeScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../UserAppointmentDetails.dart';
import 'DoctorAppointmentDetails.dart';
import 'moreScreen/more_info_screen.dart';

class DoctorTabsScreen extends StatefulWidget {
  final int? index;
  const DoctorTabsScreen({this.index});
  @override
  _DoctorTabsScreenState createState() => _DoctorTabsScreenState();
}

class _DoctorTabsScreenState extends State<DoctorTabsScreen> {
  List<Widget> screens = [
    // DoctorDashboard(),
    HomeScreen(),
    // DoctorPastAppointments(),
    Tour(),
    // EventsScreen(),
    // DoctorProfile(),
    ChatListScreen(),
    MoreInfoScreen(),
    // LogOutScreen(),
  ];

  int? index;
  NotificationHelper notificationHelper = NotificationHelper();
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<bool> willPopScope() async {
    // exit(0);
    if (index != 0) {
      setState(() {
        index = 0;
      });
      return false;
    } else {
      // exit(0);
      return true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.index != null) {
      setState(() {
        index = widget.index;
      });
    } else {
      setState(() {
        index = 0;
      });
    }
    notificationHelper.initialize();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Here is notification is call ");
      print("Here is notification is call ");
      print("onMessage: $message");
      print("\n\n" + message.toString());
      notificationHelper.showNotification(
          title: message.notification!.title!,
          body: message.notification!.body!,
          payload: "${message.data['type']}:${message.data['order_id']}",
          id: "124",
          context2: context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("onResume: $message");
      print("\n\n" + message.data.toString());
      if (message.data['type'] == "user_id") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  UserAppointmentDetails(message.data['order_id'].toString())),
        );
      } else if (message.data['type'] == "doctor_id") {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DoctorAppointmentDetails(
                  message.data['order_id'].toString())),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: willPopScope,
      child: Scaffold(
        body: screens[index!],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: LIGHT_GREY_SCREEN_BACKGROUND,
            //borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15)),
            child: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Image.asset(
                    index == 0
                        ? "assets/homeScreenImages/home_active.png"
                        : "assets/homeScreenImages/home_unactive.png",
                    height: 25,
                    width: 25,
                  ),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    index == 1
                        ? "assets/homeScreenImages/plane_active.png"
                        : "assets/homeScreenImages/plane_unactive.png",
                    height: 25,
                    width: 25,
                    fit: BoxFit.cover,
                  ),
                  label: "Tour",
                ),
                // BottomNavigationBarItem(
                //   icon: Image.asset(
                //     index == 2
                //         ? "assets/events_active.png"
                //         : "assets/events_inactive.png",
                //     height: 25,
                //     width: 25,
                //     fit: BoxFit.cover,
                //   ),
                //   label: "Events",
                // ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    // index == 3
                    index == 2
                        ? "assets/homeScreenImages/chat fill.png"
                        : "assets/homeScreenImages/chat unfill.png",
                    height: 25,
                    width: 25,
                    // fit: BoxFit.cover,
                  ),
                  label: RECENT_CHATS,
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    // index == 4
                    index == 3
                        ? "assets/homeScreenImages/profile_active.png"
                        : "assets/homeScreenImages/profile_unactive.png",
                    height: 25,
                    width: 25,
                    fit: BoxFit.cover,
                  ),
                  label: "My Profile",
                ),
              ],
              selectedLabelStyle: GoogleFonts.poppins(
                color: BLACK,
                fontSize: 8,
              ),
              type: BottomNavigationBarType.fixed,
              unselectedLabelStyle: GoogleFonts.poppins(
                color: BLACK,
                fontSize: 7,
              ),
              unselectedItemColor: LIGHT_GREY_TEXT,
              selectedItemColor: BLACK,
              onTap: (i) {
                setState(() {
                  index = i;
                });
              },
              currentIndex: index!,
            ),
          ),
        ),
      ),
    );
  }

  messageDialog(String s1, String s2) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              s1,
              style: GoogleFonts.comfortaa(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s2,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await SharedPreferences.getInstance().then((pref) {
                    pref.setBool("isLoggedInAsDoctor", false);
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                // color: Theme.of(context).primaryColor,
                child: Text(
                  YES,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: BLACK,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
