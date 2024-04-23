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
        // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.0),
        child: Column(
          children: [
            /// New For Spacing Issue

            GridView.builder(
              shrinkWrap: true,
              // physics: ClampingScrollPhysics(),
              physics: ScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: .92,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 15),
              itemCount: list2.length,
              itemBuilder: (BuildContext ctx, index) {
                var data = list2[index];

                print(
                    'Name is ${list2[index].name} and ratings are ${list2[index].avgrating}');
                print(list2[index].images);
                print("Watching all citys! ${list2[index].city}");

                return nearByGridWidget(
                  data.image,
                  data.name,
                  data.departmentName,
                  data.id,
                  data.consultationFee,
                  data.aboutme,
                  data.motto,
                  data.avgrating,
                  data.city,
                  data.images,
                  data.totalreview,
                );
              },
            ),

            nextUrl == "null"
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: CircularProgressIndicator(
                      color: const Color.fromARGB(255, 243, 103, 9),
                    ),
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

  Widget nearByGridWidget(img, name, dept, id, consultationFee, aboutMe, motto,
      avgRating, city, imgs, totalReview) {
    print("This is the city of the doctor: $city");
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailsPage(id.toString(), true)),
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
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height *
                  0.35, // Adjusted height to accommodate additional content
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  // Image Carousel
                  CarouselSlider.builder(
                    carouselController: sliderController,
                    itemCount: imgs != null ? imgs.length + 1 : 1,
                    itemBuilder: (context, index, realIndex) {
                      if (index == 0) {
                        // Fixed image
                        return Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                            ),
                            child: AspectRatio(
                              aspectRatio: MediaQuery.of(context).size.width *
                                  10 /
                                  MediaQuery.of(context).size.height *
                                  .5,
                              child: CachedNetworkImage(
                                imageUrl: img,
                                fit: BoxFit.fill, // Make the image responsive
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
                          ),
                        );
                      } else {
                        // Rest of the images from imgs
                        var imgIndex = index - 1;
                        return ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          child: AspectRatio(
                            aspectRatio: MediaQuery.of(context).size.width *
                                10 /
                                MediaQuery.of(context).size.height *
                                .5,
                            child: CachedNetworkImage(
                              imageUrl: imgs[imgIndex],
                              fit: BoxFit.fill,
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
                      }
                    },
                    options: CarouselOptions(
                      viewportFraction: 1,
                      height: MediaQuery.of(context).size.height * 0.35,
                      initialPage: 0,
                      reverse: false,
                      autoPlay: false,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentPage = index;
                        });
                      },
                    ),
                  ),

                  Positioned(
                    top: 30, // Adjust the top position as needed
                    right: 0, // Adjust the left position as needed
                    child: Container(
                      width: 60.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 94, 0).withOpacity(0.8),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                      ),
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '\$' + consultationFee + "/h",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Additional Content
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          name.toString().toUpperCase(),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            backgroundColor: Color.fromARGB(94, 194, 191, 191),
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        city == null
                            ? Container()
                            : Text(
                                city.toString().toUpperCase(),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  backgroundColor:
                                      Color.fromARGB(94, 194, 191, 191),
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ],
                    ),
                  ),

                  // Indicator dots
                  Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01),
                    width: MediaQuery.of(context).size.width * 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        imgs!.isNotEmpty ? (imgs!.length + 1) : (1),
                        (index) {
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
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            // Rest of your content
            motto == null
                ? Container(
                    height: MediaQuery.of(context).size.height * .05,
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * .05,
                    child: Center(
                      child: Text(
                        motto.toString().length >= 30
                            ? motto.toString().substring(0, 30) + "..."
                            : motto.toString(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 18,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
            Divider(
              height: 1,
              color: Colors.grey,
            ),
            Container(
              alignment: Alignment.center,
              transformAlignment: Alignment.center,
              height: MediaQuery.of(context).size.height * .055,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Reviews",
                                style: GoogleFonts.poppins(
                                  color: LIGHT_GREY_TEXT,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.018,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                totalReview,
                                style: GoogleFonts.poppins(
                                  color: BLACK,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                "Ratings",
                                style: GoogleFonts.poppins(
                                  color: LIGHT_GREY_TEXT,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.width * 0.035),
                          avgRating != 'null'
                              ? StarRating(double.parse(avgRating))
                              : StarRating(0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        //     Column(
        //   children: [
        //     Container(
        //       height: MediaQuery.of(context).size.height * .21,
        //       child: Stack(
        //         alignment: Alignment.topRight,
        //         children: [
        //           // -------------------------------------

        //           CarouselSlider.builder(
        //             carouselController: sliderController,
        //             itemCount: imgs != null
        //                 ? imgs.length + 1
        //                 : 1, // Add 1 to account for the fixed image
        //             itemBuilder: (context, index, realIndex) {
        //               if (index == 0) {
        //                 print("realIndex is $realIndex");
        //                 // int individualPage = 0;
        //                 // currentPage = 0;
        //                 // Display the fixed image at the beginning
        //                 return Container(
        //                   child: ClipRRect(
        //                     borderRadius: BorderRadius.only(
        //                       topLeft: Radius.circular(8),
        //                       topRight: Radius.circular(8),
        //                     ),
        //                     child: CachedNetworkImage(
        //                       imageUrl: img,
        //                       fit: BoxFit.fill,
        //                       width: double.infinity,
        //                       placeholder: (context, url) => Container(
        //                         color: Theme.of(context).primaryColorLight,
        //                         child: Center(
        //                           child: Image.asset(
        //                             "assets/homeScreenImages/user_unactive.png",
        //                             height: 50,
        //                             width: 50,
        //                           ),
        //                         ),
        //                       ),
        //                       errorWidget: (context, url, err) => Container(
        //                         color: Theme.of(context).primaryColorLight,
        //                         child: Center(
        //                           child: Image.asset(
        //                             "assets/homeScreenImages/user_unactive.png",
        //                             height: 50,
        //                             width: 50,
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 );
        //               } else {
        //                 // Display the rest of the images from imgs
        //                 var imgIndex = index - 1; // Adjust the index for imgs
        //                 // currentPage = imgIndex;
        //                 return ClipRRect(
        //                   borderRadius: BorderRadius.only(
        //                     topLeft: Radius.circular(8),
        //                     topRight: Radius.circular(8),
        //                   ),
        //                   child: CachedNetworkImage(
        //                     imageUrl: imgs[imgIndex], // Use the image from imgs
        //                     fit: BoxFit.fill,
        //                     width: double.infinity,
        //                     placeholder: (context, url) => Container(
        //                       color: Theme.of(context).primaryColorLight,
        //                       child: Center(
        //                         child: Image.asset(
        //                           "assets/homeScreenImages/user_unactive.png",
        //                           height: 50,
        //                           width: 50,
        //                         ),
        //                       ),
        //                     ),
        //                     errorWidget: (context, url, err) => Container(
        //                       color: Theme.of(context).primaryColorLight,
        //                       child: Center(
        //                         child: Image.asset(
        //                           "assets/homeScreenImages/user_unactive.png",
        //                           height: 50,
        //                           width: 50,
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 );
        //               }
        //             },
        //             options: CarouselOptions(
        //               viewportFraction: 1,
        //               height: 250.0,
        //               initialPage: 0,
        //               reverse: false,
        //               autoPlay: false, // Set to false for manual control
        //               enableInfiniteScroll: false, // Disable infinite scroll
        //               onPageChanged: (index, reason) {
        //                 setState(() {
        //                   currentPage = index;
        //                 });
        //               },
        //             ),
        //           ),

        //           Container(
        //             // margin: EdgeInsets.only(top: 10),
        //             margin: EdgeInsets.only(
        //                 top: MediaQuery.of(context).size.height * 0.01),
        //             // color: Colors.black,
        //             width: MediaQuery.sizeOf(context).width * 1,
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: List.generate(
        //                   imgs!.isNotEmpty ? (imgs!.length + 1) : (1), (index) {
        //                 // index < 0 ? currentPage = 0 : {};
        //                 print(currentPage);
        //                 return Container(
        //                   margin: EdgeInsets.symmetric(horizontal: 5),
        //                   width: 8,
        //                   height: 8,
        //                   decoration: BoxDecoration(
        //                     shape: BoxShape.circle,
        //                     color: currentPage == index
        //                         ? Colors.orange
        //                         : Colors.grey,
        //                   ),
        //                 );
        //               }),
        //             ),
        //           ),

        //           Container(
        //             height: MediaQuery.sizeOf(context).height * 0.70,
        //             width: MediaQuery.sizeOf(context).width * 1,
        //             margin: EdgeInsets.only(
        //                 top: MediaQuery.of(context).size.height * 0.17),
        //             child: Text(
        //               name.toString().toUpperCase(),
        //               maxLines: 2,
        //               textAlign: TextAlign.center,
        //               overflow: TextOverflow.ellipsis,
        //               style: GoogleFonts.poppins(
        //                 // color: Color.fromARGB(255, 255, 94, 0)
        //                 //     .withOpacity(0.8),
        //                 color: Colors.white,
        //                 backgroundColor: Color.fromARGB(94, 194, 191, 191),
        //                 fontSize: 18,
        //                 fontWeight: FontWeight.w700,
        //               ),
        //             ),
        //           ),
        //           Container(
        //             width: MediaQuery.sizeOf(context).width * 1,
        //             // margin: EdgeInsets.only(top: 180),
        //             margin: EdgeInsets.only(
        //                 top: MediaQuery.of(context).size.height * 0.2),
        //             child: Text(
        //               city.toString().toUpperCase(),
        //               maxLines: 2,
        //               textAlign: TextAlign.center,
        //               overflow: TextOverflow.ellipsis,
        //               style: GoogleFonts.poppins(
        //                 // color: Color.fromARGB(255, 255, 94, 0)
        //                 //     .withOpacity(0.8),
        //                 color: Colors.white,
        //                 backgroundColor: Color.fromARGB(94, 194, 191, 191),
        //                 fontSize: 15,
        //                 fontWeight: FontWeight.w500,
        //               ),
        //             ),
        //           ),

        //           Container(
        //             width: 60.0, // Fixed width
        //             height: 40.0, // Fixed height
        //             // margin: EdgeInsets.only(top: 20),
        //             margin: EdgeInsets.only(
        //                 top: MediaQuery.of(context).size.height * 0.03),
        //             decoration: BoxDecoration(
        //                 color: Color.fromARGB(255, 255, 94, 0).withOpacity(0.8),
        //                 borderRadius: BorderRadius.only(
        //                   topLeft: Radius.circular(5),
        //                   bottomLeft: Radius.circular(5),
        //                 )),
        //             child: Center(
        //               child: Text(
        //                 '\$' + consultationFee + "/h",
        //                 style: TextStyle(
        //                   color: Colors.white,
        //                   fontSize:
        //                       MediaQuery.of(context).size.width * 0.05 / 2.00,
        //                   fontWeight: FontWeight.bold,
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //     SizedBox(
        //       height: 50,
        //     ),
        //     motto == null
        //         ? Container(
        //             height: MediaQuery.of(context).size.height * .03,
        //           )
        //         : Container(
        //             height: MediaQuery.of(context).size.height * .03,
        //             child: Center(
        //               child: Text(
        //                 motto.toString().length >= 30
        //                     ? motto.toString().substring(0, 30) + "..."
        //                     : motto.toString(),
        //                 style: GoogleFonts.poppins(
        //                     fontWeight: FontWeight.w500,
        //                     //color: LIGHT_GREY_TEXT,
        //                     color: Colors.black,
        //                     fontSize: 18),
        //                 textAlign: TextAlign.center,
        //                 //textAlignVertical: TextAlignVertical.center,
        //               ),
        //             ),
        //           ),
        //     Divider(
        //       height: 10,
        //       color: Colors.grey,
        //     ),
        //     Container(
        //       alignment: Alignment.bottomCenter,
        //       transformAlignment: Alignment.bottomCenter,
        //       height: MediaQuery.of(context).size.height * .035,
        //       // padding: EdgeInsets.only(left: 30, right: 30),
        //       child: Row(
        //           crossAxisAlignment: CrossAxisAlignment.center,
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Container(
        //               width: MediaQuery.of(context).size.width * 0.4,
        //               child: Column(
        //                 children: [
        //                   Text(
        //                     "Reviews",
        //                     style: GoogleFonts.poppins(
        //                       color: LIGHT_GREY_TEXT,
        //                       fontSize: 9.5,
        //                       fontWeight: FontWeight.w500,
        //                     ),
        //                   ),
        //                   Text(
        //                     totalReview,
        //                     style: GoogleFonts.poppins(
        //                       color: BLACK,
        //                       fontSize: 12.5,
        //                       fontWeight: FontWeight.w500,
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             Container(
        //               width: MediaQuery.of(context).size.width * 0.4,
        //               child: Column(
        //                 children: [
        //                   Text(
        //                     "Ratings",
        //                     style: GoogleFonts.poppins(
        //                       color: LIGHT_GREY_TEXT,
        //                       fontSize: 9.5,
        //                       fontWeight: FontWeight.w500,
        //                     ),
        //                   ),
        //                   SizedBox(
        //                     height: 4,
        //                   ),
        //                   avgRating != 'null'
        //                       ? StarRating(double.parse(avgRating))
        //                       : StarRating(0)
        //                 ],
        //               ),
        //             ),
        //           ]),
        //     )
        //   ],
        // ),
      ),
    );
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
          size: MediaQuery.of(context).size.width * 0.035,
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
        // ignore: body_might_complete_normally_catch_error
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
          print(nearbyDoctorsClass!.data!.nearbyData![0].city);
          print("Finished");
          list2.addAll(nearbyDoctorsClass!.data!.nearbyData!);
          list2.removeWhere((element) => element.id == currentId);

          // list3.clear();
          // for (int i = 0; i < list2.length; i++) {
          //   fetchDoctorDetails(list2[i].id);
          // }
          nextUrl = nearbyDoctorsClass!.data!.nextPageUrl!;

          print(nextUrl);
          // print(list2[8].name);
          // print(list2[8].consultationFee);
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
