import 'dart:convert';

import 'package:appcode3/en.dart';
import 'package:appcode3/modals/NearbyDoctorClass.dart';
import 'package:appcode3/views/DetailsPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

String lat = "";
String lon = "";
String nextUrl = "";

List<NearbyData> list2 = [];
// List<DetailsClass.Data> list3 = [];
// List<dynamic> list3 = [];
bool hasApiBeenCalled = false;
NearbyDoctorsClass? nearbyDoctorsClass;
// DoctorDetailsClass? doctorDetailsClass;

// bool isScrollLocked = true;

// ignore: must_be_immutable
class HomeScreenNearby extends StatefulWidget {
  ScrollController scrollController;

  HomeScreenNearby(this.scrollController);

  @override
  _HomeScreenNearbyState createState() => _HomeScreenNearbyState();
}

class _HomeScreenNearbyState extends State<HomeScreenNearby> {
  bool isErrorInNearby = false;
  bool isNearbyLoading = true;
  bool isLoggedIn = false;
  bool isLoadingMore = false;
  int? currentId;
  int currentPage = 0;
  CarouselController sliderController = CarouselController();

  int maxPosition = 0;
  bool isLoadMoreEnable = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("Loadmore here 62");
    _getLocationStart();
    SharedPreferences.getInstance().then((pref) {
      setState(() {
        isLoggedIn = pref.getBool("isLoggedInAsDoctor") ?? false;
        currentId = int.parse(pref.getString("userId").toString());
        // print("this is to see the keys");
        print("ID: ${currentId}");
        // print("keysss: ${pref.getString("userId")}");
      });
    });
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels ==
          widget.scrollController.position.maxScrollExtent) {
        print("Loadmore");
        _loadMoreFunc();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget _getAdContainer() {
    return Container(
        // height: 60,
        // margin: EdgeInsets.all(10),
        // child: NativeAdmob(
        //   // Your ad unit id
        //   adUnitID: ADMOB_ID,
        //   controller: nativeAdController,
        //   type: NativeAdmobType.banner,
        // ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return isErrorInNearby
        ? Container()
        : SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    nearByDoctors(),
                  ],
                ),
              ],
            ),
          );
  }

  Widget nearByDoctors() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
        child: Column(
          children: [
            // isNearbyLoading ? Container(
            //   height: MediaQuery.of(context).size.height,
            //   width: MediaQuery.of(context).size.width,
            //   child: Column(
            //     children: [
            //       SizedBox(height: 150,),
            //       CircularProgressIndicator(),
            //     ],
            //   ),
            // ) :
            // list2 == null
            //     ? isErrorInNearby ? Container(
            //   child: Center(
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         SizedBox(
            //           height: 30,
            //         ),
            //         Text(TURN_ON_LOCATION_AND_RETRY,
            //           style: GoogleFonts.poppins(
            //               color: Colors.black,
            //               fontWeight: FontWeight.w400,
            //               fontSize: 12
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ) : Center(
            //   child: CircularProgressIndicator(
            //     valueColor: AlwaysStoppedAnimation(Theme.of(context).hintColor),
            //     strokeWidth: 2,
            //   ),
            // )
            //     :
            /// Old With Ads
            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: ClampingScrollPhysics(),
            //   itemCount: list.length > 4 ? (list.length/4).ceil() : 1,
            //   itemBuilder: (context, i){
            //     print((list.length/4).floor());
            //     print((list.length/4).ceil());
            //     // bool isFourMultiplay = list.length
            //     return Column(
            //       children: [
            //         GridView.builder(
            //           shrinkWrap: true,
            //           physics: ClampingScrollPhysics(),
            //           gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            //               maxCrossAxisExtent: 200,
            //               childAspectRatio: 0.75,
            //               crossAxisSpacing: 10,
            //               mainAxisSpacing: 10),
            //           itemCount: 4,
            //           itemBuilder: (BuildContext ctx, index) {
            //               return index + (i*4) > list.length - 1 ? Container(color:Colors.pink) : nearByGridWidget(
            //                 list[index + (i*4)].image,
            //                 list[index + (i*4)].name,
            //                 list[index + (i*4)].departmentName,
            //                 list[index + (i*4)].id,
            //               );
            //           },
            //         ),
            //         ENABLE_ADS ? customAds.nativeAds(id: AD_TYPE) : Container(height: 10,),
            //       ],
            //     );
            //   },
            // ),

            /// New For Spacing Issue

            GridView.builder(
              shrinkWrap: true,
              // physics: ClampingScrollPhysics(),
              physics: ScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 1.25,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: list2.length,
              itemBuilder: (BuildContext ctx, index) {
                var data = list2[index];

                print(
                    'Name is ${list2[index].name} and ratings are ${list2[index].avgrating}');
                print(list2[index].images);

                // for (int i = 0; i < list2.length; i++) {
                //   fetchDoctorDetails(list2[i].id);
                // }

                // var data1 = list3[index];
                // var data1 = list3[ind2x];
                // print("This printing from My gridbuilderview List2: $list2");
                // print("This printing from My gridbuilderview List3: $list3");

                // print(
                //     "wanna see the data ${data1.name} and total Reviews are: ${data1.totalReview}");

                return nearByGridWidget(
                    data.image,
                    data.name,
                    data.departmentName,
                    data.id,
                    data.consultationFee,
                    data.aboutme,
                    data.avgrating,
                    data.totalreview,
                    data.images);
              },
            ),

            nextUrl == "null"
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: CircularProgressIndicator(),
                  ),
            isLoadingMore
                ? Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: LinearProgressIndicator(),
                  )
                : Container(
                    // height: 50,
                    height: 10,
                  )
          ],
        ),
      ),
    );
  }

  Widget nearByGridWidget(img, name, dept, id, consultationFee, aboutMe,
      avgRating, totalReview, imgs) {
    // if (id == currentId) {
    //   return Container(height: 0, width: 0);
    // } else {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsPage(id.toString())),
        );
      },
      child: Container(
        // height: 900,
        decoration: BoxDecoration(
            // shape: BoxShape.rectangle,
            color: WHITE,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ]),
        // constraints: BoxConstraints(
        //   minHeight: 500.0, // Set the minimum height
        //   maxHeight: 500.0, // Set the maximum height
        // ),
        // padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
        child: Column(
          children: [
            Container(
              // height: 200,
              child: Expanded(
                child: Container(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      // -------------------------------------

                      CarouselSlider.builder(
                        carouselController: sliderController,
                        itemCount: imgs != null
                            ? imgs.length + 1
                            : 1, // Add 1 to account for the fixed image
                        itemBuilder: (context, index, realIndex) {
                          if (index == 0) {
                            print("realIndex is $realIndex");
                            // int individualPage = 0;
                            // currentPage = 0;
                            // Display the fixed image at the beginning
                            return Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: img,
                                  fit: BoxFit.fill,
                                  width: double.infinity,
                                  placeholder: (context, url) => Container(
                                    color: Theme.of(context).primaryColorLight,
                                    child: Center(
                                      child: Image.asset(
                                        "assets/homeScreenImages/user_unactive.png",
                                        height: 50,
                                        width: 50,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, err) => Container(
                                    color: Theme.of(context).primaryColorLight,
                                    child: Center(
                                      child: Image.asset(
                                        "assets/homeScreenImages/user_unactive.png",
                                        height: 50,
                                        width: 50,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            // Display the rest of the images from imgs
                            var imgIndex =
                                index - 1; // Adjust the index for imgs
                            // currentPage = imgIndex;
                            return ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                              child: CachedNetworkImage(
                                imageUrl:
                                    imgs[imgIndex], // Use the image from imgs
                                fit: BoxFit.cover,
                                width: double.infinity,
                                placeholder: (context, url) => Container(
                                  color: Theme.of(context).primaryColorLight,
                                  child: Center(
                                    child: Image.asset(
                                      "assets/homeScreenImages/user_unactive.png",
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, err) => Container(
                                  color: Theme.of(context).primaryColorLight,
                                  child: Center(
                                    child: Image.asset(
                                      "assets/homeScreenImages/user_unactive.png",
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200.0,
                          initialPage: 0,
                          reverse: false,
                          autoPlay: false, // Set to false for manual control
                          enableInfiniteScroll:
                              false, // Disable infinite scroll
                          onPageChanged: (index, reason) {
                            setState(() {
                              currentPage = index;
                            });
                          },
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 10),
                        // color: Colors.black,
                        width: MediaQuery.sizeOf(context).width * 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                              imgs!.isNotEmpty ? (imgs!.length + 1) : (1),
                              (index) {
                            // index < 0 ? currentPage = 0 : {};
                            print(currentPage);
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentPage == index
                                    ? Colors.orange
                                    : Colors.grey,
                              ),
                            );
                          }),
                        ),
                      ),

                      Container(
                        width: MediaQuery.sizeOf(context).width * 1,
                        margin: EdgeInsets.only(top: 150),
                        child: Text(
                          name.toString().toUpperCase(),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            // color: Color.fromARGB(255, 255, 94, 0)
                            //     .withOpacity(0.8),
                            color: Colors.white,
                            backgroundColor: Color.fromARGB(94, 194, 191, 191),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      Container(
                        width: 60.0, // Fixed width
                        height: 40.0, // Fixed height
                        margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 255, 94, 0)
                                .withOpacity(0.8),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            )),
                        child: Center(
                          child: Text(
                            '\$' + consultationFee + "/h",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          //child: SizedBox(child:
                          //Text(
                          //name,
                          //maxLines: 2,
                          //textAlign: TextAlign.center,
                          //overflow: TextOverflow.ellipsis,
                          //style: GoogleFonts.poppins(
                          //color: Color.fromARGB(255, 255, 94, 0).withOpacity(0.8),
                          //fontSize: 16,
                          //fontWeight: FontWeight.w500,
                          //),
                          //),

                          //)
                        ),
                      ),

                      // add button
                      // Container(
                      //   margin: EdgeInsets.only(top: 135),
                      //   width: 160,
                      //   height: 50,
                      //   child: isLoggedIn
                      //       ? ElevatedButton(
                      //           onPressed: () {
                      //             Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                     builder: (context) => MakeAppointment(
                      //                         id.toString(),
                      //                         name.toString(),
                      //                         consultationFee.toString())));
                      //           },
                      //           style: ElevatedButton.styleFrom(
                      //             primary: Color.fromARGB(186, 1, 122, 21),
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.only(
                      //                 topLeft: Radius.circular(5),
                      //                 bottomLeft: Radius.circular(5),
                      //               ),
                      //               // Adjust the radius as needed
                      //             ),
                      //             minimumSize: Size(10,
                      //                 35), // Set the minimum width and height
                      //             // Set the button color to orange
                      //           ),
                      //           child: Row(
                      //             mainAxisSize: MainAxisSize.min,
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             mainAxisAlignment: MainAxisAlignment.start,
                      //             children: [
                      //               Icon(
                      //                 Icons
                      //                     .calendar_today, // Add the booking icon
                      //                 color: Colors
                      //                     .white, // Set the icon color to white
                      //               ),
                      //               SizedBox(
                      //                   width:
                      //                       8), // Add some spacing between the icon and text
                      //               Text(
                      //                 BOOK_NOW,
                      //                 style: GoogleFonts.poppins(
                      //                   fontWeight: FontWeight.w500,
                      //                   color: Colors
                      //                       .white, // Set the text color to white
                      //                   fontSize: 10,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         )
                      //       : ElevatedButton(
                      //           onPressed: () {
                      //             // Handle button click, e.g., navigate to the login screen
                      //             Navigator.push(
                      //                 context,
                      //                 MaterialPageRoute(
                      //                     builder: (context) => LoginAsUser()));
                      //           },
                      //           style: ElevatedButton.styleFrom(
                      //             primary: const Color.fromARGB(255, 255, 94, 0)
                      //                 .withOpacity(0.8),
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.only(
                      //                 topLeft: Radius.circular(5),
                      //                 bottomLeft: Radius.circular(5),
                      //               ),
                      //               // Adjust the radius as needed
                      //             ),
                      //             minimumSize: Size(60,
                      //                 40), // Set the minimum width and height
                      //             // Set the button color to orange
                      //           ),
                      //           child: Row(
                      //             crossAxisAlignment: CrossAxisAlignment.center,
                      //             mainAxisAlignment: MainAxisAlignment.start,
                      //             children: [
                      //               Icon(
                      //                 Icons
                      //                     .calendar_today, // Add the booking icon
                      //                 color: Colors
                      //                     .white, // Set the icon color to white
                      //               ),
                      //               SizedBox(
                      //                   width:
                      //                       8), // Add some spacing between the icon and text
                      //               Text(
                      //                 BOOK_NOW,
                      //                 style: GoogleFonts.poppins(
                      //                   fontWeight: FontWeight.w500,
                      //                   color: Colors
                      //                       .white, // Set the text color to white
                      //                   fontSize: 10,
                      //                 ),
                      //               ),

                      //               Text(
                      //                 name,
                      //                 maxLines: 2,
                      //                 textAlign: TextAlign.center,
                      //                 overflow: TextOverflow.ellipsis,
                      //                 style: GoogleFonts.poppins(
                      //                   color: Color.fromARGB(255, 255, 94, 0)
                      //                       .withOpacity(0.8),
                      //                   fontSize: 16,
                      //                   fontWeight: FontWeight.w500,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      // )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            // Text(
            //   name,
            //   maxLines: 2,
            //   textAlign: TextAlign.center,
            //   overflow: TextOverflow.ellipsis,
            //   style: GoogleFonts.poppins(
            //     color: Color.fromARGB(255, 255, 94, 0).withOpacity(0.8),
            //     fontSize: 16,
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
            //Text(
            //dept,
            //style: GoogleFonts.poppins(
            //color: LIGHT_GREY_TEXT,
            //fontSize: 9.5,
            //fontWeight: FontWeight.w500,
            //),
            //),
            Text(
              aboutMe.toString().length >= 30
                  ? aboutMe.toString().substring(0, 30) + "..."
                  : aboutMe.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: LIGHT_GREY_TEXT,
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Divider(
              height: 30,
              color: Colors.grey,
            ),
            Container(
              height: 40,
              // padding: EdgeInsets.only(left: 30, right: 30),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        children: [
                          Text(
                            "Reviews",
                            style: GoogleFonts.poppins(
                              color: LIGHT_GREY_TEXT,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            totalReview,
                            style: GoogleFonts.poppins(
                              color: BLACK,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Column(
                        children: [
                          Text(
                            "Ratings",
                            style: GoogleFonts.poppins(
                              color: LIGHT_GREY_TEXT,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          avgRating != 'null'
                              ? StarRating(double.parse(avgRating))
                              : StarRating(0)
                        ],
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
    // }
  }

  Widget StarRating(avgRating) {
    List<Widget> starWidgets = [];
    for (int i = 1; i <= 5; i++) {
      IconData iconData = Icons.star;
      Color iconColor = i <= avgRating
          ? Color.fromARGB(255, 255, 94, 0).withOpacity(0.8)
          : Colors.grey;

      starWidgets.add(
        Icon(
          iconData,
          color: iconColor,
          size: 10,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: starWidgets,
    );
  }

  void _getLocationStart() async {
    setState(() {
      isErrorInNearby = false;
      isNearbyLoading = true;
    });
    print('Started');

    var status = await Permission.location.status;
    if (status.isDenied) {
      await [
        Permission.location,
      ].request();
    }
    status = await Permission.location.status;
    setState(() {});

    print("Here status ${status}");

    if (status.isGranted && !hasApiBeenCalled) {
      print("Here isGranted");
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      callApi(latitude: position.latitude, longitude: position.longitude);
      // for (int i = 0; i < list2.length; i++) {
      //   fetchDoctorDetails(list2[i].id);
      // }
      hasApiBeenCalled = true;
    } else if (status.isPermanentlyDenied) {
      print("Here isPermanentlyDenied");

      messageDialog(PERMISSION_NOT_GRANTED,
          "We required location permission to server you nearby doctors.");
      setState(() {
        isErrorInNearby = true;
      });
      _getLocationStart();
      return;
    } else if (status.isDenied) {
      print("Here is else part");
      messageDialog(PERMISSION_NOT_GRANTED,
          "We required location permission to server you nearby doctors.");
      setState(() {
        isErrorInNearby = true;
      });
    }
  }

  callApi({double? latitude, double? longitude}) async {
    print("lat is : $latitude");
    print("lon is : $longitude");
    final response = await get(Uri.parse(
            "$SERVER_ADDRESS/api/nearbydoctor?lat=${latitude}&lon=${longitude}"))
        .catchError((e) {
      setState(() {
        isErrorInNearby = true;
      });
      messageDialog(ERROR, UNABLE_TO_LOAD_DATA_FORM_SERVER);
    });

    print("API : " + response.request!.url.toString());

    final jsonResponse = jsonDecode(response.body);
    print(jsonResponse.toString());
    if (response.statusCode == 200 && jsonResponse['status'] == 1) {
      //print([0].name);
      if (mounted) {
        setState(() {
          lat = latitude.toString();
          lon = longitude.toString();
          nearbyDoctorsClass = NearbyDoctorsClass.fromJson(jsonResponse);
          print("Finished");
          list2.addAll(nearbyDoctorsClass!.data!.nearbyData!);
          list2.removeWhere((element) => element.id == currentId);

          // list3.clear();
          // for (int i = 0; i < list2.length; i++) {
          //   fetchDoctorDetails(list2[i].id);
          // }
          nextUrl = nearbyDoctorsClass!.data!.nextPageUrl!;

          print(nextUrl);
          print(list2[8].name);
          print(list2[8].consultationFee);
          isNearbyLoading = false;
        });
      }
    } else {
      setState(() {
        isErrorInNearby = true;
      });
      messageDialog(ERROR, UNABLE_TO_LOAD_DATA_FORM_SERVER);
    }
  }

  // fetchDoctorDetails(id) async {
  //   // setState(() {
  //   //   isNearbyLoading = true;
  //   // });
  //   final response =
  //       await get(Uri.parse("$SERVER_ADDRESS/api/viewdoctor?doctor_id=${id}"))
  //           .catchError((e) {
  //     print("ERROR ${e.toString()}");
  //     setState(() {
  //       isErrorInNearby = true;
  //     });
  //   });

  //   print(response.request);

  //   if (response.statusCode == 200) {
  //     final jsonResponse = jsonDecode(response.body);
  //     doctorDetailsClass = DoctorDetailsClass.fromJson(jsonResponse);
  //     list3.add(doctorDetailsClass!.data!);
  //     // print(doctorDetailsClass!.data!.avgratting);
  //     // print(id);
  //     print("-------------------------------------------------------------");
  //     for (int i = 0; i < list3.length; i++) {
  //       DetailsClass.Data currentData = list3[i];
  //       print('$i, ${currentData.name.toString()}');
  //       // Access properties of currentData as needed
  //     }
  //     print("-------------------------------------------------------------");
  //     setState(() {
  //       isNearbyLoading = false;
  //       //doctorDetailsClass.data.avgratting = '3';
  //     });
  //   }
  // }

  int count = 0;

  messageDialog(String s1, String s2) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(s1, style: Theme.of(context).textTheme.bodyText1),
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
                    var status = await Permission.location.status;
                    print("Status : ${status}");
                    if (!status.isGranted && s1 == PERMISSION_NOT_GRANTED) {
                      Map<Permission, PermissionStatus> statuses = await [
                        Permission.location,
                      ].request();
                      print(
                          "statuses  --:  ${statuses[Permission.location]!.isDenied}");
                      if (statuses[Permission.location]!.isGranted) {
                        _getLocationStart();
                        // setState(() {
                        //   isErrorInNearby = false;
                        // });
                        print("call this function _getLocationStart");
                      } else if (count == 0) {
                        _getLocationStart();
                        count++;
                        setState(() {});
                      }
                      // else{
                      //   messageDialog(PERMISSION_NOT_GRANTED, "User denied permissions to access the device's location.");
                      // }
                      // We didn't ask for permission yet or the permission has been denied before but not permanently.
                    }

//
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

  _loadMoreFunc() async {
    if (nextUrl != "null") {
      print('loading : $lat');
      print("$nextUrl&lat=${lat}&lon=${lon}");
      print("object   === $nextUrl&lat=${lat}&lon=${lon}");

      final response = await get(Uri.parse("$nextUrl&lat=${lat}&lon=${lon}"));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        //print([0].name);
        // print(nearbyDoctorsClass.data.nearbyData);
        setState(() {
          nearbyDoctorsClass = NearbyDoctorsClass.fromJson(jsonResponse);
          print("Finished");
          nextUrl = nearbyDoctorsClass!.data!.nextPageUrl!;
          print(nextUrl);
          list2.addAll(nearbyDoctorsClass!.data!.nearbyData!);
          list2.removeWhere((element) => element.id == currentId);
          // list3.clear();
          // for (int i = 0; i < list2.length; i++) {
          //   fetchDoctorDetails(list2[i].id);
          // }
        });
      }
    }
  }
}
