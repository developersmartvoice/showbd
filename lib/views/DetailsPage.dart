import 'dart:convert';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/modals/CheckAcceptBookingClass.dart';
import 'package:appcode3/modals/DoctorDetailsClass.dart';
import 'package:appcode3/views/BookingScreen.dart';
import 'package:appcode3/views/ChatScreen.dart';
import 'package:appcode3/views/ChoosePlan.dart';
// import 'package:appcode3/views/CreateTrip.dart';
// import 'package:appcode3/views/CreateTrip.dart';
import 'package:appcode3/views/MakeAppointment.dart';
import 'package:appcode3/views/PendingScreen.dart';
import 'package:appcode3/views/RejectedScreen.dart';
import 'package:appcode3/views/loginAsUser.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class DetailsPage extends StatefulWidget {
  String id;
  bool isSelf;

  DetailsPage(this.id, this.isSelf);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  DoctorDetailsClass? doctorDetailsClass;
  ApiResponse? apiResponse;
  bool isLoading = true;
  bool? isLoggedIn;
  bool isErrorInLoading = false;
  int count = 0;
  String? guideName;
  String? img;
  String? city;
  List<String>? imgs;
  int currentPage = 0;
  String? selfId;
  bool isMember = false;
  bool isDirectBooking = false;
  bool sender = false;
  bool isAcceptBooking = false;
  bool isRejectBooking = false;

  // String? get consultationFee => null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDoctorDetails();
    print(widget.id);
    SharedPreferences.getInstance().then((pref) {
      setState(() {
        isLoggedIn = pref.getBool("isLoggedInAsDoctor") ?? false;
        selfId = pref.getString("userId");
        checkIsMember();
        checkDirectBooking();
        checkAcceptBooking();
        checkRejectBooking();
      });
    });
  }

  checkIsMember() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/check_membership?id=${selfId}"));
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

  checkDirectBooking() async {
    final response = await get(Uri.parse(
        "$SERVER_ADDRESS/api/check_direct_booking?sender_id=${selfId}&recipient_id=${widget.id}"));
    print(
        "$SERVER_ADDRESS/api/check_direct_booking?sender_id=${selfId}&recipient_id=${widget.id}");
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['value'] == true) {
        setState(() {
          isDirectBooking = true;
          if (jsonResponse['msg1'] == "sender is sender") {
            sender = true;
          } else {
            sender = false;
          }
        });
      } else {
        setState(() {
          isDirectBooking = false;
        });
      }
    }
  }

  checkAcceptBooking() async {
    final response = await get(Uri.parse(
        "$SERVER_ADDRESS/api/check_accept_booking?sender_id=${selfId}&recipient_id=${widget.id}"));
    print(
        "$SERVER_ADDRESS/api/check_accept_booking?sender_id=${selfId}&recipient_id=${widget.id}");
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      apiResponse = ApiResponse.fromJson(jsonResponse);
      print(apiResponse!.message);
      // print(apiResponse!.message);
      if (apiResponse!.value == true) {
        setState(() {
          isAcceptBooking = true;
          if (apiResponse!.msg1 == "sender is sender") {
            sender = true;
          } else {
            sender = false;
          }
        });
      } else {
        setState(() {
          isAcceptBooking = false;
        });
      }
    }
  }

  checkRejectBooking() async {
    final response = await get(Uri.parse(
        "$SERVER_ADDRESS/api/check_reject_booking?sender_id=${selfId}&recipient_id=${widget.id}"));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['value'] == true) {
        setState(() {
          isRejectBooking = true;
          if (jsonResponse['msg1'] == "sender is sender") {
            sender = true;
          } else {
            sender = false;
          }
        });
      } else {
        setState(() {
          isRejectBooking = false;
        });
      }
    }
  }

  fetchDoctorDetails() async {
    setState(() {
      isLoading = true;
    });
    final response = await get(Uri.parse(
            "$SERVER_ADDRESS/api/doctordetail?doctor_id=${widget.id}"))
        // ignore: body_might_complete_normally_catch_error
        .catchError((e) {
      print("ERROR ${e.toString()}");
      setState(() {
        isErrorInLoading = true;
      });
    });

    print(response.request);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      doctorDetailsClass = DoctorDetailsClass.fromJson(jsonResponse);
      guideName = doctorDetailsClass!.data!.name;
      img = doctorDetailsClass!.data!.image;
      // imgs?.addAll(doctorDetailsClass!.data!.images!);
      city = doctorDetailsClass!.data!.city;
      print(doctorDetailsClass!.data!.avgratting);
      print(doctorDetailsClass!.data!.images!);
      // print(doctorDetailsClass!.data!.services!);
      // print(doctorDetailsClass!.data!.services![0]);
      // print(doctorDetailsClass!.data!.services![3]);
      count = doctorDetailsClass!.data!.languages != null
          ? doctorDetailsClass!.data!.languages!.length
          : 0;
      print(widget.id);
      setState(() {
        isLoading = false;
        //doctorDetailsClass.data.avgratting = '3';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Is this Direct Booking: $isDirectBooking");
    print("Is this Accept Booking: $isAcceptBooking");
    print("Is this Reject Booking: $isRejectBooking");
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
            body: Stack(
              children: [
                isErrorInLoading
                    ? Container(
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 100,
                                color: LIGHT_GREY_TEXT,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                UNABLE_TO_LOAD_DATA_FORM_SERVER,
                              )
                            ],
                          ),
                        ),
                      )
                    : !isLoading
                        ? Column(
                            children: [
                              header(),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      doctorDetails(),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Center(
                            child: CircularProgressIndicator(
                                color: const Color.fromARGB(255, 243, 103, 9)),
                          ),
                // header(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget header() {
    return Stack(
      children: [
        Image.asset(
          "assets/moreScreenImages/header_bg.png",
          height: 60,
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          height: 60,
          child: Row(
            children: [
              SizedBox(
                width: 15,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  "assets/moreScreenImages/back.png",
                  height: 25,
                  width: 22,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width * .8,
                alignment: Alignment.center,
                child: Text(
                  guideName!.capitalize.toString(),
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, color: WHITE, fontSize: 20),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget doctorDetails() {
    // Page controller for handling image navigation
    PageController _pageController = PageController();

    return Column(
      children: [
        Container(
          height: 400, // Adjust the height as needed
          width: 400, // Set the width to the same as height
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: doctorDetailsClass!.data!.images!.isNotEmpty
                      ? (doctorDetailsClass!.data!.images!.length + 1)
                      : 1,
                  onPageChanged: (int page) {
                    print("Current Page is: $page");
                    setState(() {
                      currentPage = page;
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return CachedNetworkImage(
                        imageUrl: doctorDetailsClass!.data!.image!,
                        fit: BoxFit.fitWidth,
                        placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                          color: const Color.fromARGB(255, 243, 103, 9),
                        )),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      );
                    } else {
                      return CachedNetworkImage(
                        imageUrl: doctorDetailsClass!.data!.images![index - 1],
                        fit: BoxFit.fitWidth,
                        placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                          color: const Color.fromARGB(255, 243, 103, 9),
                        )),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      );
                    }
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .02),
                width: MediaQuery.sizeOf(context).width * 1,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .37),
                child: Text(
                  guideName.toString().toUpperCase(),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    // color: Color.fromARGB(255, 255, 94, 0)
                    //     .withOpacity(0.8),
                    color: Colors.white,
                    backgroundColor: Color.fromARGB(94, 194, 191, 191),
                    fontSize: MediaQuery.of(context).size.height * .02,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .02),
                width: MediaQuery.sizeOf(context).width * 1,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * .41),
                child: doctorDetailsClass!.data!.city == null
                    ? Container()
                    : Text(
                        city.toString().toUpperCase(),
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          // color: Color.fromARGB(255, 255, 94, 0)
                          //     .withOpacity(0.8),
                          color: Colors.white,
                          backgroundColor: Color.fromARGB(94, 194, 191, 191),
                          fontSize: MediaQuery.of(context).size.height * .015,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
              // Positioned(
              //     top: 55,
              //     // right: 15,
              //     child: consultationFee(
              //         doctorDetailsClass!.data!.consultationFee!),),
            ],
          ),
        ),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
              doctorDetailsClass!.data!.images!.isNotEmpty
                  ? (doctorDetailsClass!.data!.images!.length + 1)
                  : 1, (index) {
            print(currentPage);
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5),
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentPage == index ? Colors.blue : Colors.grey,
              ),
            );
          }),
        ),
        SizedBox(height: 10),
        Container(
          //height: MediaQuery.of(context).size.height - 300,
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: WHITE,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    widget.isSelf
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    !isMember
                                        ? Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChoosePlan(),
                                            ),
                                          )
                                        : isDirectBooking
                                            ? sender
                                                ? Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PendingScreen(
                                                              fromSender: true),
                                                    ),
                                                  )
                                                : Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PendingScreen(
                                                              fromSender:
                                                                  false),
                                                    ),
                                                  )
                                            : isAcceptBooking
                                                ? sender
                                                    ? Navigator.of(context)
                                                        .push(
                                                        MaterialPageRoute(
                                                          builder: (context) => ChatScreen(
                                                              apiResponse!
                                                                  .recipientInfo
                                                                  .recipientName,
                                                              "100" +
                                                                  apiResponse!
                                                                      .recipientInfo
                                                                      .recipientId
                                                                      .toString(),
                                                              apiResponse!
                                                                  .recipientInfo
                                                                  .recipientConnectycubeId,
                                                              true,
                                                              apiResponse!
                                                                  .recipientInfo
                                                                  .recipientDeviceTokens,
                                                              apiResponse!
                                                                  .recipientInfo
                                                                  .recipientImage,
                                                              apiResponse!
                                                                  .senderInfo
                                                                  .senderImage),
                                                        ),
                                                      )
                                                    : Navigator.of(context)
                                                        .push(
                                                        MaterialPageRoute(
                                                          builder: (context) => ChatScreen(
                                                              apiResponse!
                                                                  .senderInfo
                                                                  .senderName,
                                                              "100" +
                                                                  apiResponse!
                                                                      .senderInfo
                                                                      .senderId
                                                                      .toString(),
                                                              apiResponse!
                                                                  .senderInfo
                                                                  .senderConnectycubeId,
                                                              true,
                                                              apiResponse!
                                                                  .senderInfo
                                                                  .senderDeviceTokens,
                                                              apiResponse!
                                                                  .senderInfo
                                                                  .senderImage,
                                                              apiResponse!
                                                                  .recipientInfo
                                                                  .recipientImage),
                                                        ),
                                                      )
                                                : isRejectBooking
                                                    ? sender
                                                        ? Navigator.of(context)
                                                            .push(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  RejectedScreen(
                                                                      fromSender:
                                                                          true),
                                                            ),
                                                          )
                                                        : Navigator.of(context)
                                                            .push(
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  RejectedScreen(
                                                                      fromSender:
                                                                          false),
                                                            ),
                                                          )
                                                    : Navigator.of(context)
                                                        .push(
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              BookingScreen(
                                                                  widget.id,
                                                                  selfId!,
                                                                  guideName!),
                                                        ),
                                                      );
                                  },
                                  icon: Icon(
                                    Icons.connect_without_contact_sharp,
                                    size: MediaQuery.of(context).size.width *
                                        0.05,
                                  ),
                                  label: Flexible(
                                    child: Text(
                                      "Contact",
                                      style: GoogleFonts.poppins(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(255, 243, 103, 9),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      side: BorderSide(
                                        color: Colors.white,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(10.0),
                                    elevation: 5.0,
                                    shadowColor: Colors.grey,
                                  ),
                                ),
                              ),
                              // SizedBox(
                              //   width: 10,
                              // ),
                              // Expanded(
                              //   child: ElevatedButton.icon(
                              //     onPressed: () {
                              //       Navigator.of(context).push(
                              //         MaterialPageRoute(
                              //           builder: (context) => CreateTrip(),
                              //         ),
                              //       );
                              //     },
                              //     icon: Icon(
                              //       Icons.airplane_ticket_sharp,
                              //       size: MediaQuery.of(context).size.width *
                              //           0.05,
                              //     ),
                              //     label: Flexible(
                              //       child: Text(
                              //         "Create A Trip",
                              //         style: TextStyle(
                              //           fontSize:
                              //               MediaQuery.of(context).size.width *
                              //                   0.04,
                              //         ),
                              //         overflow: TextOverflow.ellipsis,
                              //       ),
                              //     ),
                              //     style: ElevatedButton.styleFrom(
                              //       backgroundColor:
                              //           Color.fromARGB(255, 243, 103, 9),
                              //       foregroundColor: Colors.white,
                              //       shape: RoundedRectangleBorder(
                              //         borderRadius: BorderRadius.circular(10.0),
                              //         side: BorderSide(
                              //           color: Colors.white,
                              //         ),
                              //       ),
                              //       padding: EdgeInsets.all(10.0),
                              //       elevation: 5.0,
                              //       shadowColor: Colors.grey,
                              //     ),
                              //   ),
                              // ),
                            ],
                          )
                        : Container(),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              doctorDetailsClass!.data!.motto == null
                  ? Container()
                  : Container(
                      child: Center(
                        child: Text(
                          doctorDetailsClass!.data!.motto.toString(),

                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              //color: LIGHT_GREY_TEXT,
                              color: Color.fromARGB(255, 24, 18, 31),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04),
                          textAlign: TextAlign.center,
                          //textAlignVertical: TextAlignVertical.center,
                        ),
                      ),
                    ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                color: Colors.grey,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50,
                    ),
                  ],
                ),
              ),
              doctorDetailsClass!.data!.iwillshowyou == null
                  ? Container()
                  : Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(
                            height: 10.0,
                            color: Colors.grey[500],
                          ),
                          Text(
                            I_WILL_SHOW_YOU,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                color: BLACK,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.045),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          doctorDetailsClass!.data!.iwillshowyou == null
                              ? Text("")
                              : Text(
                                  style: GoogleFonts.poppins(
                                      // fontWeight: FontWeight.w400,
                                      color: Colors.blueGrey,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.03),
                                  doctorDetailsClass!.data!.iwillshowyou
                                      .toString(),
                                )
                        ],
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              doctorDetailsClass!.data!.iwillshowyou == null
                  ? Container()
                  : Divider(
                      height: 35.0,
                      color: Colors.grey[500],
                    ),
              doctorDetailsClass!.data!.aboutus == null
                  ? Container()
                  : Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ABOUT_GUIDE,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                color: BLACK,
                                fontSize: 20),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          doctorDetailsClass!.data!.aboutus == null
                              ? Text("")
                              : Text(
                                  doctorDetailsClass!.data!.aboutus.toString(),
                                  style: GoogleFonts.poppins(
                                      // fontWeight: FontWeight.w400,
                                      color: Colors.blueGrey,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.03),
                                )
                        ],
                      ),
                    ),
              SizedBox(
                height: 10,
              ),
              doctorDetailsClass!.data!.aboutus == null
                  ? Container()
                  : Divider(
                      height: 35.0,
                      color: Colors.grey[500],
                    ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorDetailsClass!.data!.services == null ? " " : SERVICES,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        color: BLACK,
                        fontSize: MediaQuery.of(context).size.width * 0.045),
                  ),
                  SizedBox(
                    width: 0,
                  ),
                  doctorDetailsClass!.data!.services == null
                      ? Text(
                          "No Activities",
                          style: GoogleFonts.poppins(
                              fontSize: MediaQuery.of(context).size.width *
                                  0.05 /
                                  1.5),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap:
                                  true, // This ensures that the ListView takes up as much space as needed within the Column
                              itemCount:
                                  doctorDetailsClass!.data!.services!.length,
                              itemBuilder: (BuildContext context, int index) {
                                // Use the index to access each service in the list
                                String service =
                                    doctorDetailsClass!.data!.services![index];

                                // Map service names to text and icons
                                Map<String, dynamic> serviceData =
                                    getServiceData(service);

                                // Customize text size`
                                // Adjust the font size as needed
                                // Customize ListTile height
                                // double customListTileHeight = 0.0;
                                // Create a widget to represent each service with an icon
                                return Container(
                                  // padding: EdgeInsets.only(left: 0),
                                  // height: 25,
                                  child: ListTile(
                                    // contentPadding: EdgeInsets.symmetric(
                                    //     vertical: customListTileHeight),
                                    dense: true,
                                    contentPadding: EdgeInsets
                                        .zero, // Set contentPadding to zero
                                    visualDensity: VisualDensity(
                                        horizontal: 0,
                                        vertical:
                                            -4), // Adjust values as needed

                                    title: Row(
                                      children: [
                                        // Add an icon before the text

                                        Icon(serviceData['icon'],
                                            size: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05 /
                                                1.5), // Replace with the desired icon

                                        // Add some spacing between the icon and text
                                        SizedBox(width: 8.0),

                                        // Display the text with customized style

                                        Expanded(
                                          child: Text(serviceData['text'],
                                              style: GoogleFonts.poppins(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05 /
                                                    1.5,
                                                color: Colors.blueGrey,
                                                //fontWeight: FontWeight.w900,
                                              )),
                                        ),
                                      ],
                                    ),
                                    // You can customize the ListTile further if needed
                                  ),
                                );
                              },
                            ),
                          ],
                        )
                ],
              ),
              Divider(
                height: 35.0,
                color: Colors.grey[500],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorDetailsClass!.data!.languages == null
                        ? " "
                        : HEALTH_CARE,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: BLACK,
                        fontSize: MediaQuery.of(context).size.width * 0.045),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  doctorDetailsClass!.data!.languages == null
                      ? Container()
                      : Row(
                          children: doctorDetailsClass!.data!.languages!
                              .map((language) {
                            // Customize text size
                            TextStyle textStyle = GoogleFonts.poppins(
                                fontSize: MediaQuery.of(context).size.width *
                                    0.05 /
                                    1.5,
                                //color: LIGHT_GREY_TEXT,
                                fontWeight: FontWeight.w500);

                            // Map language to display text
                            String displayText =
                                getDisplayTextForLanguage(language);

                            return Container(
                              // padding: EdgeInsets.zero,
                              margin: EdgeInsets.only(left: 0, right: 8.0),
                              child: doctorDetailsClass!.data!.languages!
                                          .indexOf(language) !=
                                      count - 1
                                  ? Text(
                                      '$displayText,',
                                      style: textStyle,
                                    )
                                  : Text('$displayText',
                                      style: GoogleFonts.poppins(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05 /
                                                1.5,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )),
                            );
                          }).toList(),
                        )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              // Divider(
              //   height: 35.0,
              //   color: Colors.grey[500],
              // ),
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Text(
              //       // doctorDetailsClass!.data!.aboutme == null
              //       //     ? " "
              //       //     :
              //       ABOUT_GUIDE,
              //       style: GoogleFonts.poppins(
              //           fontWeight: FontWeight.w600,
              //           color: BLACK,
              //           fontSize: 20),
              //     ),
              //     SizedBox(
              //       height: 5,
              //     ),
              //     doctorDetailsClass!.data!.aboutme == null
              //         ? Text("No Data Found")
              //         : Row(
              //             children:
              //                 doctorDetailsClass!.data!.aboutme!.map((aboutme) {
              //               // Customize text size
              //               TextStyle textStyle = TextStyle(
              //                   fontSize: 12.0,
              //                   //color: LIGHT_GREY_TEXT,
              //                   fontWeight: FontWeight.w500);

              //               // Map language to display text
              //               String displayText =
              //                   getDisplayTextForAboutMe(aboutme);

              //               return Container(
              //                 // padding: EdgeInsets.zero,
              //                 margin: EdgeInsets.only(left: 0, right: 8.0),
              //                 child: doctorDetailsClass!.data!.aboutme!
              //                             .indexOf(aboutme) !=
              //                         count - 1
              //                     ? Text(
              //                         '$displayText,',
              //                         style: textStyle,
              //                       )
              //                     : Text('$displayText',
              //                         style: TextStyle(
              //                           fontSize: 15,
              //                           fontWeight: FontWeight.w500,
              //                           color: Colors.black,
              //                         )),
              //               );
              //             }).toList(),
              //           )
              //   ],
              // ),
            ],
          ),
        ),
      ],
    );
  }

  // Function to map service names to text and icons
  Map<String, dynamic> getServiceData(String serviceName) {
    switch (serviceName) {
      case 'translation':
        return {
          'text': 'Translation & Interpretation',
          'icon': Icons.translate
        };
      case 'shopping':
        return {'text': 'Shopping', 'icon': Icons.shopping_cart};
      case 'food':
        return {'text': 'Food & Restaurants', 'icon': Icons.restaurant};
      case 'art':
        return {'text': 'Art & Museums', 'icon': Icons.museum_outlined};
      case 'history':
        return {'text': 'History & Culture', 'icon': Icons.music_video};
      case 'exploration':
        return {
          'text': 'Exploration & Sightseeing',
          'icon': Icons.explore_outlined
        };
      case 'pick':
        return {
          'text': 'Pick up & Driving Tours',
          'icon': Icons.drive_eta_rounded
        };
      case 'nightlife':
        return {'text': 'Nightlife & Bars', 'icon': Icons.nightlife_rounded};
      // Add more cases as needed for other services
      // Default to a generic icon and the service name
      default:
        return {
          'text': 'Sports & Recreation',
          'icon': Icons.sports_kabaddi_outlined
        };
    }
  }

  String getDisplayTextForLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'english':
        return 'English';
      case 'hindi':
        return 'Hindi';
      case 'bengali':
        return 'Bengali';
      case 'urdu':
        return 'Urdu';
      case 'french':
        return 'French';
      case 'spanish':
        return 'Spanish';
      // Add more cases for other languages
      default:
        return language;
    }
  }

  String getDisplayTextForAboutMe(String aboutme) {
    switch (aboutme.toLowerCase()) {
      case 'english':
        return 'English';
      case 'hindi':
        return 'Hindi';
      case 'bengali':
        return 'Bengali';
      case 'urdu':
        return 'Urdu';
      case 'french':
        return 'French';
      case 'spanish':
        return 'Spanish';
      // Add more cases for other languages
      default:
        return aboutme;
    }
  }

  String getDisplayTextForIWillShowYou(String iwillshowyou) {
    switch (iwillshowyou.toLowerCase()) {
      case 'english':
        return 'English';
      case 'hindi':
        return 'Hindi';
      case 'bengali':
        return 'Bengali';
      case 'urdu':
        return 'Urdu';
      case 'french':
        return 'French';
      case 'spanish':
        return 'Spanish';
      // Add more cases for other languages
      default:
        return iwillshowyou;
    }
  }

  Future<void> openMap(double latitude, double longitude) async {
    print("opening map");
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      print("Could not open the map");
      throw 'Could not open the map.';
    }
  }

  _launchMaps() async {
    print('launching maps');
    String googleUrl =
        'comgooglemaps://?center=${doctorDetailsClass!.data!.lat},${doctorDetailsClass!.data!.lon}';
    String appleUrl =
        'https://maps.apple.com/?sll=${doctorDetailsClass!.data!.lat},${doctorDetailsClass!.data!.lon}';
    if (await canLaunch("comgooglemaps://")) {
      print('launching com googleUrl');
      await launch(googleUrl);
    } else if (await canLaunch(appleUrl)) {
      print('launching apple url');
      await launch(appleUrl);
    } else {
      print('launching apple url');
      throw 'Could not launch url';
    }
  }

  processPayment() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => isLoggedIn!
                ? MakeAppointment(widget.id, doctorDetailsClass!.data!.name!,
                    doctorDetailsClass!.data!.consultationFee!)
                : LoginAsUser()));
    //}
  }

  messageDialog(String s1, String s2) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              s1,
              style: GoogleFonts.poppins(
                  fontSize: 17, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s2,
                  style: Theme.of(context).textTheme.bodyText1,
                )
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  // color: Theme.of(context).primaryColor,
                  child:
                      Text(OK, style: Theme.of(context).textTheme.bodyText1)),
            ],
          );
        });
  }
}

// Widget consultationFee(String consultationFee) {
//   return Container(
//     width: 80.0, // Fixed width
//     height: 40.0, // Fixed height
//     margin: EdgeInsets.only(top: 20),
//     decoration: BoxDecoration(
//         color: Color.fromARGB(255, 255, 94, 0).withOpacity(0.8),
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(5),
//           bottomLeft: Radius.circular(5),
//         )),
//     child: Center(
//       child: Text(
//         '\$' + consultationFee + "/h",
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 14.0,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ),
//   );
// }
