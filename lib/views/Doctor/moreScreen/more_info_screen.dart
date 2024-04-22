import 'dart:convert';
import 'package:appcode3/views/AboutHost.dart';
import 'package:appcode3/views/ChoosePlan.dart';
import 'package:appcode3/views/ContactAndIdentification.dart';
import 'package:appcode3/views/DetailsPage.dart';
import 'package:appcode3/views/Doctor/loginAsDoctor.dart';
import 'package:appcode3/views/GeneraLInfo.dart';
import 'package:appcode3/views/MemberShipDetails.dart';
import 'package:connectycube_sdk/connectycube_chat.dart';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/modals/DoctorPastAppointmentsClass.dart';
import 'package:appcode3/views/Doctor/DoctorProfileWithRating.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MoreInfoScreen extends StatefulWidget {
  const MoreInfoScreen({super.key});

  @override
  _MoreInfoScreenState createState() => _MoreInfoScreenState();
}

class _MoreInfoScreenState extends State<MoreInfoScreen> {
  DoctorPastAppointmentsClass? doctorAppointmentsClass;
  DoctorProfileWithRating? doctorProfileWithRating;
  String? guideName;
  Future? future;
  Future? future2;
  bool isAppointmentAvailable = false;
  String? doctorId;
  bool isErrorInLoading = false;
  bool isMember = false;

  String selectedCurrency = 'Select Currency';

  fetchDoctorAppointment() async {
    final response = await get(Uri.parse(
        "$SERVER_ADDRESS/api/doctoruappointment?doctor_id=$doctorId"));
    print('dashboard api -> ${response.request}');
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'].toString() == "1") {
        setState(() {
          isAppointmentAvailable = true;
          doctorAppointmentsClass =
              DoctorPastAppointmentsClass.fromJson(jsonResponse);
        });
      } else {
        setState(() {
          isAppointmentAvailable = false;
        });
      }
    }
  }

  fetchDoctorDetails() async {
    print(
        'doctor detail url ->${'$SERVER_ADDRESS/api/doctordetail?doctor_id=$doctorId'}');
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/doctordetail?doctor_id=$doctorId"));

    try {
      if (response.statusCode == 200) {
        print("url --> ${response.request!.url}");
        print("body --> ${response.body}");
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          try {
            doctorProfileWithRating =
                DoctorProfileWithRating.fromJson(jsonResponse);
            print('doctor image is ${doctorProfileWithRating!.data!.image}');
          } catch (E) {
            print('Dashboard error is : ${E}');
          }
        });
      } else {
        setState(() {});
      }
    } catch (e) {
      setState(() {
        isErrorInLoading = true;
      });
    }
  }

  Future<void> getCurrency() async {
    print("doctor id: $doctorId");
    print("Get currency is called");
    try {
      final response = await http
          .get(Uri.parse("$SERVER_ADDRESS/api/getCurrency?id=$doctorId"));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          // currencies = data.cast<String>();
          // selectedCurrency = currencies.isNotEmpty ? currencies.first : '';
          selectedCurrency = jsonResponse['currency'] != null
              ? jsonResponse['currency']
              : "Select Currency";

          saveCurrencyToSharedPreferences(selectedCurrency);
          print("Currency from api: $selectedCurrency");
        });
      } else {
        throw Exception('Failed to load currencies');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void saveCurrencyToSharedPreferences(String currency) async {
    if (currency == "Select Currency") {
      currency = "BDT";
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedCurrency', currency);
      print('Currency saved to SharedPreferences: $currency');
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('Currency', currency);
      print('Currency saved to SharedPreferences: $currency');
    }
  }

  Future<void> updateCurrency(String currency) async {
    print("doctor id: $doctorId");
    print("Post currency is called");
    try {
      final response = await http.get(Uri.parse(
          "$SERVER_ADDRESS/api/updateCurrency?id=$doctorId&currency=$currency"));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          selectedCurrency = jsonResponse['currency'] != null
              ? "Select Currency"
              : jsonResponse['currency'];
          print("Currency from api: $selectedCurrency");
        });
      } else {
        throw Exception('Failed to load currencies');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  checkIsMember() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/check_membership?id=${doctorId}"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['is_member'] == 0) {
        setState(() {
          isMember = false;
        });
      } else {
        setState(() {
          isMember = true;
        });
      }
    } else {
      print("Api is not call properly");
    }
  }

  @override
  void initState() {
    // nativeAdController.setNonPersonalizedAds(true);
    // nativeAdController.setTestDeviceIds(["0B43A6DF92B4C06E3D9DBF00BA6DA410"]);
    // nativeAdController.stateChanged.listen((event) {
    //   print(event);
    // });
    // TODO: implement initState
    super.initState();

    //getMessages();
    SharedPreferences.getInstance().then((pref) {
      setState(() {
        doctorId = pref.getString("userId");
        future = fetchDoctorAppointment();
        fetchedData();
      });
    });
  }

  fetchedData() {
    getCurrency();
    checkIsMember();
    future2 = fetchDoctorDetails();
  }

  void _handleDataReload(bool dataUpdated) {
    if (dataUpdated) {
      fetchedData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: LIGHT_GREY_SCREEN_BACKGROUND,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: header(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            doctorProfile(),
            upCommingAppointments(),
          ],
        ),
      ),
    ));
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // SizedBox(
              //   width: 15,
              // ),
              Text(MORE_INFO,
                  style: Theme.of(context).textTheme.headline5!.apply(
                      color: Theme.of(context).backgroundColor,
                      fontWeightDelta: 5))
            ],
          ),
        ),
      ],
    );
  }

  Widget doctorProfile() {
    return isErrorInLoading
        ? Container(
            height: MediaQuery.sizeOf(context).height * .25,
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
        : FutureBuilder(
            future: future2,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  doctorId == null) {
                return Container(
                    height: MediaQuery.sizeOf(context).height * .25,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: const Color.fromARGB(255, 243, 103, 9),
                      strokeWidth: 2,
                    )));
              }
              return Container(
                height: MediaQuery.sizeOf(context).height * .25,
                width: MediaQuery.sizeOf(context).width * 1,
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailsPage(doctorId.toString(), false)),
                          );
                        },
                        child: CachedNetworkImage(
                          //alignment: Alignment.topCenter,
                          imageUrl: doctorProfileWithRating!.data!.image!,
                          height: 85,
                          width: 85,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Theme.of(context).primaryColorLight,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Image.asset(
                                "assets/homeScreenImages/user_unactive.png",
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, err) => Container(
                              color: Theme.of(context).primaryColorLight,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Image.asset(
                                  "assets/homeScreenImages/user_unactive.png",
                                  height: 20,
                                  width: 20,
                                ),
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    // Expanded(
                    //   child: Column(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Container(
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: [
                    //             Text(
                    //               doctorProfileWithRating!.data!.name!,
                    //               style: Theme.of(context)
                    //                   .textTheme
                    //                   .subtitle1!
                    //                   .apply(fontWeightDelta: 2),
                    //             ),
                    //             Row(
                    //               children: [
                    //                 //Text(
                    //                 //doctorProfileWithRating!
                    //                 //     .data!.departmentName!.isEmpty
                    //                 // ? SPECIALITY
                    //                 // : doctorProfileWithRating!
                    //                 //   .data!.departmentName!,
                    //                 //style: Theme.of(context)
                    //                 //  .textTheme
                    //                 //.bodyText1!
                    //                 //.apply(
                    //                 //  color: Theme.of(context)
                    //                 //    .primaryColorDark),
                    //                 //),
                    //                 SizedBox(
                    //                   width: 10,
                    //                 ),
                    //                 //Image.asset(
                    //                 //"assets/detailScreenImages/star_fill.png",
                    //                 //height: 15,
                    //                 //width: 15,
                    //                 //),
                    //                 SizedBox(
                    //                   width: 5,
                    //                 ),
                    //                 //Text(
                    //                 //double.parse(doctorProfileWithRating!
                    //                 //      .data!.avgratting
                    //                 //    .toString())
                    //                 //.toString(),
                    //                 //style: Theme.of(context)
                    //                 //  .textTheme
                    //                 //.bodyText1!
                    //                 //.apply(
                    //                 //  color: Theme.of(context)
                    //                 //    .primaryColorDark),
                    //                 //),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       //Container(
                    //       //child: Text(
                    //       //doctorProfileWithRating!.data!.address ??
                    //       //  ADDRESS_GOES_HERE,
                    //       //style: Theme.of(context).textTheme.caption!.apply(
                    //       //    color: Theme.of(context)
                    //       //      .primaryColorDark
                    //       //    .withOpacity(0.4),
                    //       //fontSizeDelta: 0.1,
                    //       //),
                    //       //),
                    //       //),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    Text(
                      doctorProfileWithRating!.data!.name!.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .apply(fontWeightDelta: 2),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => DoctorProfile(),
                        //   ),
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailsPage(doctorId.toString(), false)),
                        );
                      },
                      child: Text('View Profile'),
                      style: ElevatedButton.styleFrom(
                        textStyle: GoogleFonts.poppins(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: Color.fromARGB(255, 243, 103, 9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                            color: Colors.white,
                          ), // Set border radius
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
  }

  Widget upCommingAppointments() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top: 5),

      //margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //----------- Edit Profile -------------

          //Expanded(
          //SizedBox(
          //ElevatedButton(onPressed: () {
          //Navigator.of(context).push(
          //MaterialPageRoute(
          // builder: (context) => DoctorProfile(),
          //),
          //);
          //},
          //icon: Icon(Icons.airplane_ticket_sharp),
          //label: Text("View Profile"),
          //style: ElevatedButton.styleFrom(
          //textStyle: GoogleFonts.poppins(
          // fontSize: 19.0,
          //fontWeight: FontWeight.w500,
          //color: Colors.blueAccent,
          //),
          //backgroundColor: Colors.white,
          //foregroundColor: const Color.fromARGB(255, 3, 142, 255),
          //shape: RoundedRectangleBorder(
          //borderRadius: BorderRadius.circular(10.0),
          //side: BorderSide(
          //color: Colors.blue,
          //), // Set border radius
          //),
          //padding: EdgeInsets.all(10.0), // Customize horizontal padding
          //elevation: 5.0, // Set elevation
          //shadowColor: Colors.grey, // Set shadow color
          //),
          //),
          //),

          SizedBox(
            height: 20,
          ),

          // Divider(
          //   height: 25,
          //   color: Colors.grey,
          // ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 30, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: Text(
                    'PROFILE SETTINGS',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 243, 103, 9),
                    ),
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => GeneraLInfo(doctorId!)),
              ).then((dataUpdated) {
                _handleDataReload(dataUpdated ?? false);
              });
            },
            child: Container(
              width: MediaQuery.sizeOf(context).width * 1,
              height: MediaQuery.of(context).size.height * .06,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              decoration: BoxDecoration(
                // color: Color.fromARGB(255, 243, 103, 9),
                color: WHITE,
                borderRadius: BorderRadius.circular(10),
                border: Border(
                  bottom: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                  top: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                  right: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                  left: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                ),
              ),
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * .5,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        GENERAL_INFORMATION,
                        //style: Theme.of(context).textTheme.subtitle1,
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              color: Color.fromARGB(255, 243, 103,
                                  9), // Replace with your desired color
                              fontSize: MediaQuery.of(context).size.width *
                                  0.05 /
                                  1.5,
                            ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .1,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .05,
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Color.fromARGB(255, 243, 103, 9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(
            height: 5,
          ),

          ///---------  change password ----------
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContactAndIdentification(doctorId!)),
              );
            },
            child: Container(
              width: MediaQuery.sizeOf(context).width * 1,
              height: MediaQuery.of(context).size.height * .06,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              decoration: BoxDecoration(
                color: WHITE,
                borderRadius: BorderRadius.circular(10),
                border: Border(
                  bottom: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                  top: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                  right: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                  left: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                ),
              ),
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * .5,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        CONTACT_AND_IDENTIFICATION,
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              color: Color.fromARGB(255, 243, 103, 9),
                              fontSize: MediaQuery.of(context).size.width *
                                  0.05 /
                                  1.5, // Adjust this value as needed
                            ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .05,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .05,
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Color.fromARGB(255, 243, 103, 9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(
            height: 5,
          ),

          // /--------- subscription ------------
          GestureDetector(
            onTap: () {
              isMember
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MemberShipDetails(doctorId)))
                  : Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChoosePlan()),
                    );
            },
            child: Container(
              width: MediaQuery.sizeOf(context).width * 1,
              height: MediaQuery.of(context).size.height * .06,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              decoration: BoxDecoration(
                color: WHITE,
                borderRadius: BorderRadius.circular(10),
                border: Border(
                  bottom: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                  top: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                  right: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                  left: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                ),
              ),
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * .25,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        MEMBERSHIP,
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              color: Color.fromARGB(255, 243, 103, 9),
                              fontSize: MediaQuery.of(context).size.width *
                                  0.05 /
                                  1.5, // Adjust this value as needed
                            ),
                      ),
                    ),

                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .05,
                    ),

                    Container(
                        width: MediaQuery.sizeOf(context).width * .4,
                        alignment: Alignment.centerRight,
                        child: isMember
                            ? Text(
                                "Member",
                                style: GoogleFonts.robotoCondensed(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  //color: Color.fromARGB(197, 1, 50, 3),
                                  color: Colors.green,
                                ),
                              )
                            : Text(
                                "Waiting for payment!",
                                style: GoogleFonts.robotoCondensed(
                                  fontSize: MediaQuery.of(context).size.width *
                                      0.05 /
                                      1.5,
                                  fontWeight: FontWeight.w600,
                                  //color: Color.fromARGB(197, 131, 22, 0),
                                  color: Colors.red,
                                ),
                              )),

                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .05,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .05,
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Color.fromARGB(255, 243, 103, 9),
                      ),
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => DoctorAllAppointments()),
                    //     );
                    //   },
                    //   child: Text(SEE_ALL,
                    //       style: Theme.of(context).textTheme.bodyText2!.apply(
                    //             color: Theme.of(context).hintColor,
                    //             fontWeightDelta: 5,
                    //           )),
                    // )
                  ],
                ),
              ),
            ),
          ),

          SizedBox(
            height: 15,
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 30, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: Text(
                    'LOCAL HOST',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 243, 103, 9),
                    ),
                  ),
                ),
              ],
            ),
          ),

          ///--------- subscription ------------
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutHost(doctorId!)),
              ).then((dataUpdated) {
                _handleDataReload(dataUpdated ?? false);
              });
            },
            child: Container(
              height: MediaQuery.of(context).size.height * .06,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              decoration: BoxDecoration(
                color: WHITE,
                borderRadius: BorderRadius.circular(10),
                border: Border(
                  bottom: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                  top: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                  right: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                  left: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                ),
              ),
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * .5,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        ABOUT_HOST,
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              color: Color.fromARGB(255, 243, 103, 9),
                              fontSize: MediaQuery.of(context).size.width *
                                  0.05 /
                                  1.5,
                            ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .1,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .05,
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Color.fromARGB(255, 243, 103, 9),
                      ),
                    ),
                    // TextButton(onPressed: (){
                    //   Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => DoctorAllAppointments()),
                    //   );
                    // }, child: Text(SEE_ALL,
                    //     style: Theme.of(context).textTheme.bodyText2!.apply(
                    //       color: Theme.of(context).hintColor,
                    //       fontWeightDelta: 5,
                    //     )
                    // ),)
                  ],
                ),
              ),
            ),
          ),

          SizedBox(
            height: 5,
          ),

          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Center(
                      child: Text(
                        "Select Currency".toUpperCase(),
                        style: TextStyle(
                          color: const Color.fromARGB(255, 243, 103, 9),
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(
                        color: const Color.fromARGB(255, 243, 103, 9),
                      ),
                    ),
                    children: <Widget>[
                      SimpleDialogOption(
                        onPressed: () {
                          // Perform actions upon selecting USD
                          setState(() {
                            selectedCurrency = 'USD';
                            updateCurrency(selectedCurrency);
                          });
                          fetchedData();
                          Navigator.of(context).pop(true);
                        },
                        child: Center(
                          child: Text(
                            'USD',
                            style: TextStyle(
                              color: Color.fromARGB(197, 1, 50, 3),
                              fontSize: 17,
                              fontWeight: selectedCurrency == 'USD'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          // Perform actions upon selecting BDT
                          setState(() {
                            selectedCurrency = 'BDT';
                            updateCurrency(selectedCurrency);
                          });
                          fetchedData();
                          Navigator.of(context).pop(true);
                        },
                        child: Center(
                          child: Text(
                            'BDT',
                            style: TextStyle(
                              color: Color.fromARGB(197, 1, 50, 3),
                              fontSize: 17,
                              fontWeight: selectedCurrency == 'BDT'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: Container(
              width: MediaQuery.sizeOf(context).width * 1,
              height: MediaQuery.of(context).size.height * .06,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              decoration: BoxDecoration(
                color: WHITE,
                borderRadius: BorderRadius.circular(10),
                border: Border(
                  bottom: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                  top: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                  right: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                  left: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                ),
              ),

              child: Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * .25,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        CURRENCY_EXCHANGE,
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              color: Color.fromARGB(255, 243, 103, 9),
                              fontSize: MediaQuery.of(context).size.width *
                                  0.05 /
                                  1.5,
                            ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .05,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .4,
                      alignment: Alignment.centerRight,
                      child: Text(
                        selectedCurrency,
                        style: GoogleFonts.robotoCondensed(
                          fontSize:
                              MediaQuery.of(context).size.width * 0.05 / 1.5,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(197, 1, 50, 3),
                        ),
                        // Theme.of(context).textTheme.subtitle1?.copyWith(
                        //       color: Colors.black,
                        //     ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .05,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .05,
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Color.fromARGB(255, 243, 103, 9),
                      ),
                    ),
                  ],
                ),
              ),
              // child: Container(
              //   margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         selectedCurrency,
              //         style: Theme.of(context).textTheme.subtitle1?.copyWith(
              //               color: Colors.white,
              //             ),
              //       ),
              //       Icon(
              //         Icons.arrow_drop_down,
              //         size: 20,
              //         color: Colors.white,
              //       ),
              //     ],
              //   ),
              // ),
            ),
          ),

          // PopupMenuButton<String>(
          //   onSelected: (String value) {
          //     setState(() {
          //       selectedCurrency = value;
          //     });
          //   },
          //   itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
          //     PopupMenuItem<String>(
          //       value: 'USD',
          //       child: Text('USD'),
          //     ),
          //     PopupMenuItem<String>(
          //       value: 'BDT',
          //       child: Text('BDT'),
          //     ),
          //     PopupMenuItem<String>(
          //       value: 'EUR',
          //       child: Text('EUR'),
          //     ),
          //     PopupMenuItem<String>(
          //       value: 'GBP',
          //       child: Text('GBP'),
          //     ),
          //   ],
          //   child: Container(
          //     height: 50,
          //     margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          //     decoration: BoxDecoration(
          //       color: Color.fromARGB(255, 243, 103, 9),
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     child: Container(
          //       margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             selectedCurrency,
          //             style: Theme.of(context).textTheme.subtitle1?.copyWith(
          //                   color: Colors.white,
          //                 ),
          //           ),
          //           Icon(
          //             Icons.arrow_drop_down,
          //             size: 20,
          //             color: Colors.white,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),

          // GestureDetector(
          //   onTap: () {
          //     showDialog(
          //       context: context,
          //       builder: (BuildContext context) {
          //         return SimpleDialog(
          //           title: Text("Select Currency"),
          //           children: <Widget>[
          //             SimpleDialogOption(
          //               onPressed: () {
          //                 // Perform actions upon selecting USD
          //                 Navigator.of(context).pop('USD');
          //               },
          //               child: Text('USD'),
          //             ),
          //             SimpleDialogOption(
          //               onPressed: () {
          //                 // Perform actions upon selecting BDT
          //                 Navigator.of(context).pop('BDT');
          //               },
          //               child: Text('BDT'),
          //             ),
          //             SimpleDialogOption(
          //               onPressed: () {
          //                 // Perform actions upon selecting EUR
          //                 Navigator.of(context).pop('EUR');
          //               },
          //               child: Text('EUR'),
          //             ),
          //             SimpleDialogOption(
          //               onPressed: () {
          //                 // Perform actions upon selecting GBP
          //                 Navigator.of(context).pop('GBP');
          //               },
          //               child: Text('GBP'),
          //             ),
          //           ],
          //         );
          //         // AlertDialog(
          //         //   title: Text("Select Currency"),
          //         //   content: SingleChildScrollView(
          //         //     child: ListBody(
          //         //       children: <Widget>[
          //         //         ListTile(
          //         //           title: Text('USD'),
          //         //           onTap: () {
          //         //             // Perform actions upon selecting USD
          //         //             Navigator.of(context).pop('USD');
          //         //           },
          //         //         ),
          //         //         ListTile(
          //         //           title: Text('BDT'),
          //         //           onTap: () {
          //         //             // Perform actions upon selecting USD
          //         //             Navigator.of(context).pop('BDT');
          //         //           },
          //         //         ),
          //         //         ListTile(
          //         //           title: Text('EUR'),
          //         //           onTap: () {
          //         //             // Perform actions upon selecting EUR
          //         //             Navigator.of(context).pop('EUR');
          //         //           },
          //         //         ),
          //         //         ListTile(
          //         //           title: Text('GBP'),
          //         //           onTap: () {
          //         //             // Perform actions upon selecting GBP
          //         //             Navigator.of(context).pop('GBP');
          //         //           },
          //         //         ),
          //         //         // Place your currency selection widgets here
          //         //       ],
          //         //     ),
          //         //   ),
          //         //   actions: <Widget>[
          //         //     TextButton(
          //         //       child: Text('Cancel'),
          //         //       onPressed: () {
          //         //         Navigator.of(context).pop();
          //         //       },
          //         //     ),
          //         //     TextButton(
          //         //       child: Text('OK'),
          //         //       onPressed: () {

          //         //         // Perform actions upon selecting currency
          //         //         Navigator.of(context).pop();
          //         //       },
          //         //     ),
          //         //   ],
          //         // );
          //       },
          //     );
          //   },
          //   child: Container(
          //     height: 50,
          //     margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          //     decoration: BoxDecoration(
          //       color: Color.fromARGB(255, 243, 103, 9),
          //       borderRadius: BorderRadius.circular(10),
          //     ),
          //     child: Container(
          //       margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             CURRENCY_EXCHANGE,
          //             style: Theme.of(context).textTheme.subtitle1?.copyWith(
          //                   color: Colors.white,
          //                 ),
          //           ),
          //           Icon(
          //             Icons.arrow_forward_ios,
          //             size: 20,
          //             color: Colors.white,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),

          ///-----------logoout -------------
          // GestureDetector(
          //   onTap: () {
          //     //_showCurrencySelectionDialog(context);
          //     //messageDialog(LOGOUT, ARE_YOU_SURE_TO_LOGOUT);
          //     // Navigator.push(context,
          //     //     MaterialPageRoute(builder: (context) => LogOutScreen()));
          //   },
          //   child: Container(
          //     height: 50,
          //     margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          //     decoration: BoxDecoration(
          //         color: Color.fromARGB(255, 243, 103, 9),
          //         borderRadius: BorderRadius.circular(10)),
          //     child: Container(
          //       margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             CURRENCY_EXCHANGE,
          //             style: Theme.of(context).textTheme.subtitle1?.copyWith(
          //                   color: Colors.white,
          //                 ),
          //           ),
          //           // Text(
          //           //   selectedCurrency.isEmpty
          //           //       ? 'Select Currency'
          //           //       : 'Selected Currency: $selectedCurrency',
          //           //   style: TextStyle(fontSize: 18),
          //           // ),
          //           Icon(
          //             Icons.arrow_forward_ios,
          //             size: 20,
          //             color: Colors.white,
          //           ),
          //           // TextButton(onPressed: (){
          //           //   Navigator.push(context,
          //           //     MaterialPageRoute(builder: (context) => DoctorAllAppointments()),
          //           //   );
          //           // }, child: Text(SEE_ALL,
          //           //     style: Theme.of(context).textTheme.bodyText2!.apply(
          //           //       color: Theme.of(context).hintColor,
          //           //       fontWeightDelta: 5,
          //           //     )
          //           // ),)
          //         ],
          //       ),
          //     ),
          //   ),
          // ),

          SizedBox(
            height: 5,
          ),

          //Divider(
          //height: 40,
          //color: Colors.grey,
          //),

          // Padding(
          //   padding: const EdgeInsets.fromLTRB(16, 0, 30, 0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       SizedBox(
          //         height: 40,
          //         child: Text(
          //           'NOTIFICATIONS',
          //           style: TextStyle(
          //             fontSize: 18.0,
          //             fontWeight: FontWeight.bold,
          //             color: Color.fromARGB(255, 243, 103, 9),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          //SizedBox(
          //height: 15,
          //),

          ///-----------logoout -------------
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       // MaterialPageRoute(builder: (context) => SubScriptionScreen()),
          //       MaterialPageRoute(builder: (context) => SendOffersScreen()),
          //     );
          //   },
          //   // GestureDetector(
          //   //   onTap: () {
          //   //     messageDialog(LOGOUT, ARE_YOU_SURE_TO_LOGOUT);
          //   //     // Navigator.push(context,
          //   //     //     MaterialPageRoute(builder: (context) => LogOutScreen()
          //   //     // ));
          //   //   },
          //   child: Container(
          //     height: 50,
          //     margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          //     decoration: BoxDecoration(
          //         color: Color.fromARGB(255, 243, 103, 9),
          //         borderRadius: BorderRadius.circular(10)),
          //     child: Container(
          //       margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             NOTIFICATION_SETTINGS,
          //             style: Theme.of(context).textTheme.subtitle1?.copyWith(
          //                   color: Colors.white,
          //                 ),
          //           ),
          //           Icon(
          //             Icons.arrow_forward_ios,
          //             size: 20,
          //             color: Colors.white,
          //           ),
          //           // TextButton(onPressed: (){
          //           //   Navigator.push(context,
          //           //     MaterialPageRoute(builder: (context) => DoctorAllAppointments()),
          //           //   );
          //           // }, child: Text(SEE_ALL,
          //           //     style: Theme.of(context).textTheme.bodyText2!.apply(
          //           //       color: Theme.of(context).hintColor,
          //           //       fontWeightDelta: 5,
          //           //     )
          //           // ),)
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // GestureDetector(
          //   onTap: () {
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(
          //     //       builder: (context) => ChoosePlan(widget.id, guideName!)),
          //     // );
          //   },
          //   child: Container(
          //     height: 50,
          //     margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          //     decoration: BoxDecoration(
          //         color: Color.fromARGB(255, 243, 103, 9),
          //         borderRadius: BorderRadius.circular(10)),
          //     child: Container(
          //       margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Text(
          //             MEMBERSHIP,
          //             //style: Theme.of(context).textTheme.subtitle1,
          //             style: Theme.of(context).textTheme.subtitle1?.copyWith(
          //                   color:
          //                       Colors.white, // Replace with your desired color
          //                 ),
          //           ),
          //           Icon(
          //             Icons.arrow_forward_ios,
          //             size: 20,
          //             color: Colors.white,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 30, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: Text(
                    'OTHERS',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 243, 103, 9),
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   // MaterialPageRoute(builder: (context) => SubScriptionScreen()),
              //   MaterialPageRoute(builder: (context) => SendOffersScreen()),
              // );
              deleteAccount(DELETE_ACCOUNT, DELETE_MESSAGE);
            },
            // GestureDetector(
            //   onTap: () {
            //     messageDialog(LOGOUT, ARE_YOU_SURE_TO_LOGOUT);
            //     // Navigator.push(context,
            //     //     MaterialPageRoute(builder: (context) => LogOutScreen()
            //     // ));
            //   },
            child: Container(
              height: MediaQuery.of(context).size.height * .06,
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              decoration: BoxDecoration(
                color: WHITE,
                borderRadius: BorderRadius.circular(10),
                border: Border(
                  bottom: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                  top: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                  right: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                  left: BorderSide(
                      width: 2, color: Color.fromARGB(255, 243, 103, 9)),
                ),
              ),
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * .5,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        DELETE_ACCOUNT,
                        style: Theme.of(context).textTheme.subtitle1?.copyWith(
                              color: Color.fromARGB(255, 243, 103, 9),
                              fontSize: MediaQuery.of(context).size.width *
                                  0.05 /
                                  1.5,
                            ),
                      ),
                    ),

                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .1,
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * .05,
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Color.fromARGB(255, 243, 103, 9),
                      ),
                    ),
                    // TextButton(onPressed: (){
                    //   Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => DoctorAllAppointments()),
                    //   );
                    // }, child: Text(SEE_ALL,
                    //     style: Theme.of(context).textTheme.bodyText2!.apply(
                    //       color: Theme.of(context).hintColor,
                    //       fontWeightDelta: 5,
                    //     )
                    // ),)
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: ElevatedButton.icon(
              // onPressed: () {
              //   Navigator.of(context).push(
              //     MaterialPageRoute(
              //       // builder: (context) => LogOutScreen(),
              //     ),
              //   );
              // },
              onPressed: () {
                messageDialog(LOGOUT, ARE_YOU_SURE_TO_LOGOUT);
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => LogOutScreen()));
              },
              icon: Icon(Icons.logout),
              label: Text('Logout'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color.fromARGB(255, 243, 103, 9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side: BorderSide(
                    color: Colors.white,
                  ),
                ),
                padding: EdgeInsets.all(10.0),
                elevation: 5.0,
                //shadowColor: Colors.grey,
                textStyle: GoogleFonts.poppins(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white, // Set text color to white
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  messageDialog(String s1, String s2) {
    return showDialog(
        context: context,
        barrierDismissible: true,
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
                  try {
                    CubeChatConnection.instance.logout();
                  } catch (e) {}
                  await SharedPreferences.getInstance().then((pref) {
                    pref.setBool("isLoggedInAsDoctor", false);
                    pref.setBool("isLoggedIn", false);
                    pref.clear();
                    // pref.setString("userId", null);
                    // pref.setString("name", null);
                    // pref.setString("phone", null);
                    // pref.setString("email", null);
                    // pref.setString("token", null);
                  });
                  // Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginAsDoctor(),
                      ));
                  // Navigator.of(context)
                  //     .pushReplacement(MaterialPageRoute(
                  //         builder: (context) => LoginAsDoctor()))
                  //     .then((_) {
                  //   // After pushing the new route, remove the previous route from the stack
                  //   Navigator.of(context).popUntil((route) => route.isFirst);
                  // });
                },
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).hintColor,
                ),
                // color: Theme.of(context).hintColor,
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

  deleteAccount(String msg1, String msg2) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            msg1,
            style: GoogleFonts.comfortaa(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                msg2,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                ),
              )
            ],
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  int id = int.parse(doctorId!);
                  final response = await get(
                      Uri.parse("$SERVER_ADDRESS/api/deletedoctor?id=$id"));
                  try {
                    if (response.statusCode == 200) {
                      final jsonResponse = jsonDecode(response.body);
                      if (jsonResponse['delete'].toString() ==
                          "User deleted successfully") {
                        setState(() async {
                          isErrorInLoading = false;
                          await SharedPreferences.getInstance().then((pref) {
                            pref.setBool("isLoggedInAsDoctor", false);
                            pref.setBool("isLoggedIn", false);
                            pref.clear();
                            // pref.setString("userId", null);
                            // pref.setString("name", null);
                            // pref.setString("phone", null);
                            // pref.setString("email", null);
                            // pref.setString("token", null);
                          });
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title:
                                      Text("User Account deleted successfully"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginAsDoctor()));
                                        },
                                        child: Text(
                                          "OK",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ))
                                  ],
                                );
                              });
                        } as Null Function());
                      } else {
                        setState(() {
                          isErrorInLoading = false;
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Error arise!, Try again Later"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: TextButton.styleFrom(
                                          backgroundColor: Colors.green,
                                        ),
                                        child: Text(
                                          "OK",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                          ),
                                        ))
                                  ],
                                );
                              });
                        });
                      }
                    } else {
                      isErrorInLoading = true;
                    }
                  } catch (e) {
                    isErrorInLoading = true;
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: Text(
                  YES,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: BLACK,
                  ),
                )),
            SizedBox(
              width: 5,
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text(
                  NO,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: BLACK,
                  ),
                ))
          ],
        );
      },
    );
  }
}

// Future<void> _showCurrencySelectionDialog(BuildContext context) async {
//     final selectedCurrency = await showDialog<String>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Choose Currency'),
//           content: Container(
//             width: double.minPositive,
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: currencies.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return ListTile(
//                   title: Text(currencies[index]),
//                   onTap: () {
//                     Navigator.of(context).pop(currencies[index]);
//                   },
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
// }

