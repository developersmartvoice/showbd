import 'dart:convert';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/modals/NearbyDoctorClass.dart';
// import 'package:appcode3/views/DetailsPage.dart';
import 'package:appcode3/views/Doctor/loginAsDoctor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';

class UnRegisteredHomePage extends StatefulWidget {
  const UnRegisteredHomePage({Key? key}) : super(key: key);

  @override
  State<UnRegisteredHomePage> createState() => _UnRegisteredHomePageState();
}

class _UnRegisteredHomePageState extends State<UnRegisteredHomePage>
    with TickerProviderStateMixin {
  NearbyDoctorsClass? nearbyDoctorsClass;
  ScrollController? scrollController = ScrollController();
  bool isErrorInNearby = false;
  bool isNearbyLoading = true;
  bool hasApiBeenCalled = false;
  String? lat;
  String? lon;
  String? nextUrl;
  List<NearbyData> list2 = [];
  int count = 0;
  int currentPage = 0;
  final CarouselController sliderController = CarouselController();

  @override
  void initState() {
    super.initState();
    _getLocationStart();
    scrollController!.addListener(() {
      if (scrollController!.position.pixels ==
          scrollController!.position.maxScrollExtent) {
        _loadMoreFunc();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Add your custom logic here, for example, showing a confirmation dialog
        bool shouldPop = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Are you sure?"),
            content: Text("Do you want to exit the app?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("No"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text("Yes"),
              ),
            ],
          ),
        );
        return shouldPop;
      },
      child: Stack(
        children: [
          Image.asset(
            "assets/moreScreenImages/header_bg.png",
            height: 140,
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
          ),
          SafeArea(
            child: Scaffold(
              floatingActionButton: Stack(
                // mainAxisAlignment: MainAxisAlignment.end,
                alignment: Alignment.bottomRight,
                children: [
                  Positioned(
                    bottom: 80,
                    child: Container(
                      height: 50,
                      width: 50,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          scrollController!.animateTo(
                            0.0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                          // _getLocationStart();
                          print("THIS IS LAT: $lat and LON: $lon");
                          setState(() {
                            isNearbyLoading = true;
                            list2.clear();
                          });
                          callApi(
                              latitude: double.parse(lat!),
                              longitude: double.parse(lat!));
                        },
                        label: Icon(
                          Icons.arrow_upward_sharp,
                          color: Colors.white,
                        ),
                        backgroundColor: Color.fromARGB(255, 243, 103, 9),
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 80,
                    child: Container(
                      height: 50,
                      // width: MediaQuery.of(context).size.width,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (builder) => LoginAsDoctor(),
                            ),
                          );
                        },
                        label: Text(
                          "LOGIN / REGISTER",
                          style: TextStyle(
                            color: WHITE,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 4,
                          ),
                        ),
                        backgroundColor: Color.fromARGB(255, 243, 103, 9),
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              backgroundColor: LIGHT_GREY_SCREEN_BACKGROUND,
              appBar: AppBar(
                backgroundColor: Color.fromARGB(255, 243, 103, 9),
                automaticallyImplyLeading: false,
                title: Text(
                  "MEET LOCAL",
                  style: TextStyle(
                    color: WHITE,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 5,
                  ),
                ),
              ),
              body: isNearbyLoading
                  ? Center(
                      // child: CircularProgressIndicator(
                      //   color: Color.fromARGB(255, 243, 103, 9),
                      // ),
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Image.asset("assets/loading.gif"),
                      ),
                    )
                  : list2.isNotEmpty
                      ? ListView.builder(
                          controller: scrollController,
                          itemCount: list2.length,
                          itemBuilder: (context, index) {
                            final item = list2[index];
                            return nearByGridWidget(
                              item.image,
                              item.name,
                              item.departmentName,
                              item.id,
                              item.consultationFee,
                              item.aboutme,
                              item.motto,
                              item.avgrating,
                              item.city,
                              item.images,
                              item.totalreview.toString(),
                            );
                          },
                        )
                      : Center(
                          child: Text("No nearby doctors found."),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  void _getLocationStart() async {
    setState(() {
      isErrorInNearby = false;
      isNearbyLoading = true;
    });

    var status = await Permission.location.status;
    if (status.isDenied) {
      await [Permission.location].request();
    }
    status = await Permission.location.status;

    if (status.isGranted && !hasApiBeenCalled) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        callApi(latitude: position.latitude, longitude: position.longitude);
      });
      hasApiBeenCalled = true;
    } else if (status.isPermanentlyDenied) {
      messageDialog(PERMISSION_NOT_GRANTED,
          "We required location permission to serve you nearby doctors.");
      setState(() {
        isErrorInNearby = true;
      });
      _getLocationStart();
      return;
    } else if (status.isDenied) {
      messageDialog(PERMISSION_NOT_GRANTED,
          "We required location permission to serve you nearby doctors.");
      setState(() {
        isErrorInNearby = true;
      });
    }
  }

  callApi({double? latitude, double? longitude}) async {
    final response = await get(Uri.parse(
            "$SERVER_ADDRESS/api/nearbydoctor?lat=${latitude}&lon=${longitude}"))
        // ignore: body_might_complete_normally_catch_error
        .catchError((e) {
      setState(() {
        isErrorInNearby = true;
      });
      messageDialog(ERROR, UNABLE_TO_LOAD_DATA_FORM_SERVER);
    });

    final jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200 && jsonResponse['status'] == 1) {
      if (mounted) {
        setState(() {
          lat = latitude.toString();
          lon = longitude.toString();
          nearbyDoctorsClass = NearbyDoctorsClass.fromJson(jsonResponse);
          list2.addAll(nearbyDoctorsClass!.data!.nearbyData!);
          nextUrl = nearbyDoctorsClass!.data!.nextPageUrl!;
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
                    if (!status.isGranted && s1 == PERMISSION_NOT_GRANTED) {
                      Map<Permission, PermissionStatus> statuses = await [
                        Permission.location,
                      ].request();
                      if (statuses[Permission.location]!.isGranted) {
                        _getLocationStart();
                      } else if (count == 0) {
                        _getLocationStart();
                        count++;
                        setState(() {});
                      }

                      Navigator.pop(context);
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child:
                      Text(OK, style: Theme.of(context).textTheme.bodyText1)),
            ],
          );
        });
  }

  _loadMoreFunc() async {
    if (nextUrl != "null") {
      final response = await get(Uri.parse("$nextUrl&lat=${lat}&lon=${lon}"));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          nearbyDoctorsClass = NearbyDoctorsClass.fromJson(jsonResponse);
          nextUrl = nearbyDoctorsClass!.data!.nextPageUrl!;
          list2.addAll(nearbyDoctorsClass!.data!.nearbyData!);
        });
      }
    }
  }

  Widget nearByGridWidget(
    String? img,
    String? name,
    String? dept,
    int? id,
    String? consultationFee,
    String? aboutMe,
    String? motto,
    String? avgRating,
    String? city,
    List<String>? imgs,
    String? totalReview,
  ) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, double _opacity, child) {
        return Opacity(
          opacity: _opacity,
          child: Transform.translate(
            offset: Offset(0.0, 100 * (1 - _opacity)),
            child: child,
          ),
        );
      },
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            // MaterialPageRoute(
            //   builder: (context) => DetailsPage(id.toString(), true),
            // ),
            MaterialPageRoute(
              builder: (builder) => LoginAsDoctor(),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 10),
          decoration: BoxDecoration(
            color: WHITE,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: 8,
                  left: 3,
                  right: 3,
                ),
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.height * 0.43,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    CarouselSlider.builder(
                      carouselController: sliderController,
                      itemCount: imgs != null ? imgs.length + 1 : 1,
                      itemBuilder: (context, index, realIndex) {
                        if (index == 0) {
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
                                  imageUrl: img!,
                                  fit: BoxFit.fitWidth,
                                  placeholder: (context, url) => Container(
                                    color: Theme.of(context).primaryColorLight,
                                    child: Center(
                                      child: Image.asset(
                                        "assets/homeScreenImages/user_unactive.png",
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.35,
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.41,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, err) => Container(
                                    color: Theme.of(context).primaryColorLight,
                                    child: Center(
                                      child: Image.asset(
                                        "assets/homeScreenImages/user_unactive.png",
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.35,
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.41,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
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
                                imageUrl: imgs![imgIndex],
                                fit: BoxFit.fitWidth,
                                placeholder: (context, url) => Container(
                                  color: Theme.of(context).primaryColorLight,
                                  child: Center(
                                    child: Image.asset(
                                      "assets/homeScreenImages/user_unactive.png",
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.35,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.41,
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
                      top: 30,
                      right: 0,
                      child: Container(
                        width: 60.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          color:
                              Color.fromARGB(255, 255, 94, 0).withOpacity(0.8),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          ),
                        ),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '\৳' + consultationFee! + "/h",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            name!.toUpperCase(),
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              backgroundColor:
                                  Color.fromARGB(94, 194, 191, 191),
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.035,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          city == null
                              ? Container()
                              : Text(
                                  city.toUpperCase(),
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    backgroundColor:
                                        Color.fromARGB(94, 194, 191, 191),
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01),
                      width: MediaQuery.of(context).size.width * 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          imgs!.isNotEmpty ? (imgs.length + 1) : (1),
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
              motto == null
                  ? Container(
                      height: MediaQuery.of(context).size.height * .05,
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * .05,
                      child: Center(
                        child: Text(
                          motto.length >= 30
                              ? motto.substring(0, 30) + "..."
                              : motto,
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.006,
                            ),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  totalReview!,
                                  style: GoogleFonts.poppins(
                                    color: BLACK,
                                    fontSize: 14,
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.008,
                            ),
                            avgRating != 'null'
                                ? StarRating(double.parse(avgRating!))
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
        ),
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
          size: MediaQuery.of(context).size.width * 0.04,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: starWidgets,
    );
  }
}
