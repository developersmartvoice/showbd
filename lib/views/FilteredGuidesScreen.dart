// import 'dart:convert';

// import 'package:appcode3/main.dart';
// import 'package:appcode3/modals/FilterClass.dart';
// // import 'package:appcode3/modals/NearbyDoctorClass.dart';
// import 'package:appcode3/views/DetailsPage.dart';
// import 'package:appcode3/views/Doctor/DoctorTabScreen.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // ignore: must_be_immutable
// class FilteredGuidesScreen extends StatefulWidget {
//   FilterClass filterClass;
//   String? body;

//   FilteredGuidesScreen(this.filterClass,this.body);
//   @override
//   State<FilteredGuidesScreen> createState() => _FilteredGuidesScreen();
// }

// class _FilteredGuidesScreen extends State<FilteredGuidesScreen> {
//   FilterClass? _filterClassFilter;
//   List<NearbyDataFilter> list2 = [];
//   String? currentId;
//   String nextUrl = "";
//   CarouselController sliderController = CarouselController();
//   int currentPage = 0;
//   bool isLoadingMore = false;

//   ScrollController _scrollController = ScrollController(); // Step 1

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     SharedPreferences.getInstance().then(
//       (value) {
//         currentId = value.getString("userId");
//       },
//     );
//     setState(() {
//       _filterClassFilter = widget.filterClass;
//       list2.addAll(_filterClassFilter!.data!.nearbyDataFilter!);
//       list2.removeWhere((element) => element.id == currentId);
//       nextUrl = _filterClassFilter!.data!.nextPageUrl!;
//     });
//     _scrollController.addListener(_scrollListener); // Step 2
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_scrollListener); // Step 6
//     super.dispose();
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels ==
//         _scrollController.position.maxScrollExtent) {
//       // Step 3: Check if the user has reached the end of the scroll view
//       // Step 4: If the end is reached, load the next URL
//       _loadNextPage();
//     }
//   }

//   void _loadNextPage() async {
//     // if (!isLoadingMore) {
//     //   setState(() {
//     //     isLoadingMore = true;
//     //   });
//     //   // Load the next URL and update the list of items accordingly
//     //   // Example:
//     //   // final response = await get(Uri.parse(nextUrl));
//     //   // final data = jsonDecode(response.body);
//     //   // Update list2 with the new data
//     //   // nextUrl = data['next_page_url'];
//     //   setState(() {
//     //     isLoadingMore = false;
//     //   });
//     // }
//      if (nextUrl != "null") {
//       // print('loading : $lat');
//       // print("$nextUrl&lat=${lat}&lon=${lon}");
//       // print("object   === $nextUrl&lat=${lat}&lon=${lon}");

//       final response = await get(Uri.parse("$nextUrl&${widget.body}"));

//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(response.body);
//         //print([0].name);
//         // print(nearbyDoctorsClass.data.nearbyData);
//         setState(() {
//           _filterClassFilter = FilterClass.fromJson(jsonResponse);
//           print("Finished");
//           nextUrl = _filterClassFilter!.data!.nextPageUrl!;
//           print(nextUrl);
//           list2.addAll(_filterClassFilter!.data!.nearbyDataFilter!);
//           list2.removeWhere((element) => element.id == currentId);
//           // list3.clear();
//           // for (int i = 0; i < list2.length; i++) {
//           //   fetchDoctorDetails(list2[i].id);
//           // }
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       appBar: AppBar(
//           title: Text("Filtered Result",
//               style: Theme.of(context).textTheme.headline5!.apply(
//                   color: Theme.of(context).backgroundColor,
//                   fontWeightDelta: 5)),
//           backgroundColor: const Color.fromARGB(255, 243, 103, 9),
//           centerTitle: true,
//           actions: [
//             IconButton(
//                 onPressed: () {
//                   setState(() {
//                     list2.clear();
//                   });
//                   Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => DoctorTabsScreen()));
//                 },
//                 icon: Icon(Icons.home_sharp))
//           ]),
//       body: SingleChildScrollView(
//         child: Column(children: [
//           list2.isEmpty
//               ? Container(
//                   child: Text("No Filtered Value Found!"),
//                 )
//               : Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: GridView.builder(
//                     shrinkWrap: true,
//                     physics: ScrollPhysics(),
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 1,
//                         childAspectRatio: 1.25,
//                         crossAxisSpacing: 10,
//                         mainAxisSpacing: 10),
//                     itemCount: list2.length,
//                     itemBuilder: (BuildContext ctx, index) {
//                       var data = list2[index];

//                       print(
//                           'Name is ${list2[index].name} and ratings are ${list2[index].avgrating}');
//                       print(list2[index].aboutme);

//                       return nearByGridWidget(
//                           data.image,
//                           data.name,
//                           data.departmentName,
//                           data.id,
//                           data.consultationFee,
//                           data.aboutme,
//                           data.avgrating,
//                           data.totalreview,
//                           data.images);
//                     },
//                   ),
//                 ),
//           // nextUrl.isEmpty
//           //     ? Container()
//           //     : Padding(
//           //         padding: const EdgeInsets.only(top: 15),
//           //         child: CircularProgressIndicator(),
//           //       ),
//           // isLoadingMore
//           //     ? Padding(
//           //         padding: const EdgeInsets.all(15.0),
//           //         child: LinearProgressIndicator(),
//           //       )
//           //     : Container(
//           //         // height: 50,
//           //         height: 10,
//           //       )
//         ]),
//       ),
//     ));
//   }

//   Widget nearByGridWidget(img, name, dept, id, consultationFee, aboutMe,
//       avgRating, totalReview, imgs) {
//     // if (id == currentId) {
//     //   return Container(height: 0, width: 0);
//     // } else {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => DetailsPage(id.toString())),
//         );
//       },
//       child: Container(
//         // height: 900,
//         decoration: BoxDecoration(
//             // shape: BoxShape.rectangle,
//             color: WHITE,
//             borderRadius: BorderRadius.circular(5),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.25),
//                 spreadRadius: 1,
//                 blurRadius: 5,
//                 offset: Offset(0, 2),
//               ),
//             ]),
//         // constraints: BoxConstraints(
//         //   minHeight: 500.0, // Set the minimum height
//         //   maxHeight: 500.0, // Set the maximum height
//         // ),
//         // padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
//         child: Column(
//           children: [
//             Container(
//               // height: 200,
//               child: Expanded(
//                 child: Container(
//                   child: Stack(
//                     alignment: Alignment.topRight,
//                     children: [
//                       // -------------------------------------

//                       CarouselSlider.builder(
//                         carouselController: sliderController,
//                         itemCount: imgs != null
//                             ? imgs.length + 1
//                             : 1, // Add 1 to account for the fixed image
//                         itemBuilder: (context, index, realIndex) {
//                           if (index == 0) {
//                             print("realIndex is $realIndex");
//                             // int individualPage = 0;
//                             // currentPage = 0;
//                             // Display the fixed image at the beginning
//                             return Container(
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(8),
//                                   topRight: Radius.circular(8),
//                                 ),
//                                 child: CachedNetworkImage(
//                                   imageUrl: img,
//                                   fit: BoxFit.fill,
//                                   width: double.infinity,
//                                   placeholder: (context, url) => Container(
//                                     color: Theme.of(context).primaryColorLight,
//                                     child: Center(
//                                       child: Image.asset(
//                                         "assets/homeScreenImages/user_unactive.png",
//                                         height: 50,
//                                         width: 50,
//                                       ),
//                                     ),
//                                   ),
//                                   errorWidget: (context, url, err) => Container(
//                                     color: Theme.of(context).primaryColorLight,
//                                     child: Center(
//                                       child: Image.asset(
//                                         "assets/homeScreenImages/user_unactive.png",
//                                         height: 50,
//                                         width: 50,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           } else {
//                             // Display the rest of the images from imgs
//                             var imgIndex =
//                                 index - 1; // Adjust the index for imgs
//                             // currentPage = imgIndex;
//                             return ClipRRect(
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(8),
//                                 topRight: Radius.circular(8),
//                               ),
//                               child: CachedNetworkImage(
//                                 imageUrl:
//                                     imgs[imgIndex], // Use the image from imgs
//                                 fit: BoxFit.cover,
//                                 width: double.infinity,
//                                 placeholder: (context, url) => Container(
//                                   color: Theme.of(context).primaryColorLight,
//                                   child: Center(
//                                     child: Image.asset(
//                                       "assets/homeScreenImages/user_unactive.png",
//                                       height: 50,
//                                       width: 50,
//                                     ),
//                                   ),
//                                 ),
//                                 errorWidget: (context, url, err) => Container(
//                                   color: Theme.of(context).primaryColorLight,
//                                   child: Center(
//                                     child: Image.asset(
//                                       "assets/homeScreenImages/user_unactive.png",
//                                       height: 50,
//                                       width: 50,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }
//                         },
//                         options: CarouselOptions(
//                           viewportFraction: 1,
//                           height: 200.0,
//                           initialPage: 0,
//                           reverse: false,
//                           autoPlay: false, // Set to false for manual control
//                           enableInfiniteScroll:
//                               false, // Disable infinite scroll
//                           onPageChanged: (index, reason) {
//                             setState(() {
//                               currentPage = index;
//                             });
//                           },
//                         ),
//                       ),

//                       Container(
//                         margin: EdgeInsets.only(top: 10),
//                         // color: Colors.black,
//                         width: MediaQuery.sizeOf(context).width * 1,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: List.generate(
//                               imgs!.isNotEmpty ? (imgs!.length + 1) : (1),
//                               (index) {
//                             // index < 0 ? currentPage = 0 : {};
//                             print(currentPage);
//                             return Container(
//                               margin: EdgeInsets.symmetric(horizontal: 5),
//                               width: 8,
//                               height: 8,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: currentPage == index
//                                     ? Colors.orange
//                                     : Colors.grey,
//                               ),
//                             );
//                           }),
//                         ),
//                       ),

//                       Container(
//                         width: MediaQuery.sizeOf(context).width * 1,
//                         margin: EdgeInsets.only(top: 150),
//                         child: Text(
//                           name.toString().toUpperCase(),
//                           maxLines: 2,
//                           textAlign: TextAlign.center,
//                           overflow: TextOverflow.ellipsis,
//                           style: GoogleFonts.poppins(
//                             // color: Color.fromARGB(255, 255, 94, 0)
//                             //     .withOpacity(0.8),
//                             color: Colors.white,
//                             backgroundColor: Color.fromARGB(94, 194, 191, 191),
//                             fontSize: 20,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ),

//                       Container(
//                         width: 60.0, // Fixed width
//                         height: 40.0, // Fixed height
//                         margin: EdgeInsets.only(top: 20),
//                         decoration: BoxDecoration(
//                             color: Color.fromARGB(255, 255, 94, 0)
//                                 .withOpacity(0.8),
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(5),
//                               bottomLeft: Radius.circular(5),
//                             )),
//                         child: Center(
//                           child: Text(
//                             '\$' + consultationFee + "/h",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 14.0,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 10,
//             ),
//             Text(
//               aboutMe.toString().length >= 30
//                   ? aboutMe.toString().substring(0, 30) + "..."
//                   : aboutMe.toString(),
//               textAlign: TextAlign.center,
//               style: GoogleFonts.poppins(
//                 color: LIGHT_GREY_TEXT,
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             Divider(
//               height: 30,
//               color: Colors.grey,
//             ),
//             Container(
//               height: 40,
//               // padding: EdgeInsets.only(left: 30, right: 30),
//               child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       width: MediaQuery.of(context).size.width * 0.4,
//                       child: Column(
//                         children: [
//                           Text(
//                             "Reviews",
//                             style: GoogleFonts.poppins(
//                               color: LIGHT_GREY_TEXT,
//                               fontSize: 9.5,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           Text(
//                             totalReview,
//                             style: GoogleFonts.poppins(
//                               color: BLACK,
//                               fontSize: 12.5,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       width: MediaQuery.of(context).size.width * 0.4,
//                       child: Column(
//                         children: [
//                           Text(
//                             "Ratings",
//                             style: GoogleFonts.poppins(
//                               color: LIGHT_GREY_TEXT,
//                               fontSize: 9.5,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                           SizedBox(
//                             height: 4,
//                           ),
//                           avgRating != 'null'
//                               ? StarRating(double.parse(avgRating))
//                               : StarRating(0)
//                         ],
//                       ),
//                     ),
//                   ]),
//             )
//           ],
//         ),
//       ),
//     );
//     // }
//   }

//   Widget StarRating(avgRating) {
//     List<Widget> starWidgets = [];
//     for (int i = 1; i <= 5; i++) {
//       IconData iconData = Icons.star;
//       Color iconColor = i <= avgRating
//           ? Color.fromARGB(255, 255, 94, 0).withOpacity(0.8)
//           : Colors.grey;

//       starWidgets.add(
//         Icon(
//           iconData,
//           color: iconColor,
//           size: 10,
//         ),
//       );
//     }
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: starWidgets,
//     );
//   }
// }

import 'dart:convert';

import 'package:appcode3/modals/FilterClass.dart';
import 'package:appcode3/views/DetailsPage.dart';
import 'package:appcode3/views/Doctor/DoctorTabScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http; // Update import statement
import 'package:shared_preferences/shared_preferences.dart';

class FilteredGuidesScreen extends StatefulWidget {
  FilterClass filterClass;
  String? body;

  FilteredGuidesScreen(this.filterClass, this.body);

  @override
  State<FilteredGuidesScreen> createState() => _FilteredGuidesScreenState();
}

class _FilteredGuidesScreenState extends State<FilteredGuidesScreen> {
  FilterClass? _filterClassFilter;
  List<NearbyDataFilter> list2 = [];
  String? currentId;
  String nextUrl = "";
  CarouselController sliderController = CarouselController();
  int currentPage = 0;
  bool isLoadingMore = false;

  ScrollController _scrollController = ScrollController(); // Step 1

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then(
      (value) {
        currentId = value.getString("userId");
      },
    );
    setState(() {
      _filterClassFilter = widget.filterClass;
      list2.addAll(_filterClassFilter!.data!.nearbyDataFilter!);
      list2.removeWhere((element) => element.id == currentId);
      nextUrl = _filterClassFilter!.data!.nextPageUrl!;
    });
    _scrollController.addListener(_scrollListener); // Step 2
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener); // Step 6
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadNextPage();
    }
  }

  void _loadNextPage() async {
    if (nextUrl != "null") {
      final response = await http.get(Uri.parse("$nextUrl&${widget.body}"));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        setState(() {
          _filterClassFilter = FilterClass.fromJson(jsonResponse);
          nextUrl = _filterClassFilter!.data!.nextPageUrl!;
          list2.addAll(_filterClassFilter!.data!.nearbyDataFilter!);
          list2.removeWhere((element) => element.id == currentId);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Filtered Result",
            style: Theme.of(context).textTheme.headline5!.apply(
                  color: Theme.of(context).backgroundColor,
                  fontWeightDelta: 5,
                ),
          ),
          backgroundColor: const Color.fromARGB(255, 243, 103, 9),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  list2.clear();
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorTabsScreen(),
                  ),
                );
              },
              icon: Icon(Icons.home_sharp),
            )
          ],
        ),
        body: SingleChildScrollView(
          controller: _scrollController, // Step 7
          child: Column(
            children: [
              list2.isEmpty
                  ? Container(
                      alignment: Alignment.center,
                      transformAlignment: Alignment.center,
                      child: Text("No Filtered Value Found!"),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 1.25,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: list2.length,
                        itemBuilder: (BuildContext ctx, index) {
                          var data = list2[index];
                          return nearByGridWidget(
                            data.image,
                            data.name,
                            data.departmentName,
                            data.id,
                            data.consultationFee,
                            data.aboutme,
                            data.avgrating,
                            data.totalreview,
                            data.images,
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget nearByGridWidget(
    img,
    name,
    dept,
    id,
    consultationFee,
    aboutMe,
    avgRating,
    totalReview,
    imgs,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailsPage(id.toString())),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
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
              child: Expanded(
                child: Container(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      CarouselSlider.builder(
                        carouselController: sliderController,
                        itemCount: imgs != null ? imgs.length + 1 : 1,
                        itemBuilder: (context, index, realIndex) {
                          if (index == 0) {
                            return CachedNetworkImage(
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
                            );
                          } else {
                            var imgIndex = index - 1;
                            return CachedNetworkImage(
                              imageUrl: imgs[imgIndex],
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
                            );
                          }
                        },
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200.0,
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
                      Container(
                        margin: EdgeInsets.only(top: 10),
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
                      Container(
                        width: MediaQuery.of(context).size.width * 1,
                        margin: EdgeInsets.only(top: 150),
                        child: Text(
                          name.toString().toUpperCase(),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            backgroundColor: Color.fromARGB(94, 194, 191, 191),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        width: 60.0,
                        height: 40.0,
                        margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          color:
                              Color.fromARGB(255, 255, 94, 0).withOpacity(0.8),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '\$' + consultationFee + "/h",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              aboutMe.toString().length >= 30
                  ? aboutMe.toString().substring(0, 30) + "..."
                  : aboutMe.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
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
                            fontSize: 9.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          totalReview,
                          style: GoogleFonts.poppins(
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
                ],
              ),
            )
          ],
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
          size: 10,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: starWidgets,
    );
  }
}
