import 'dart:convert';

import 'package:appcode3/main.dart';
import 'package:appcode3/modals/FilterClass.dart';
import 'package:appcode3/views/DetailsPage.dart';
import 'package:appcode3/views/Doctor/DoctorTabScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http; // Update import statement
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
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
              icon: Icon(
                Icons.home_sharp,
                color: WHITE,
              ),
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
                          childAspectRatio: .92,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 15,
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
                            data.motto,
                            data.avgrating,
                            data.city,
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
    motto,
    avgRating,
    city,
    totalReview,
    imgs,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DetailsPage(id.toString(), true)),
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
              padding: EdgeInsets.only(
                top: 8,
                left: 3,
                right: 3,
              ),
              height: MediaQuery.of(context).size.height *
                  0.35, // Adjusted height to accommodate additional content
              width: MediaQuery.of(context).size.height * 0.43,
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
                                fit: BoxFit
                                    .fitWidth, // Make the image responsive
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
                              fit: BoxFit.fitWidth,
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
                            '\৳' + consultationFee + "/h",
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
              height: MediaQuery.of(context).size.height * .04,
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
                                      // MediaQuery.of(context).size.width * 0.035,
                                      16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.001),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                totalReview,
                                style: GoogleFonts.poppins(
                                  color: BLACK,
                                  fontSize:
                                      // MediaQuery.of(context).size.width * 0.035,
                                      14,
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
                                  // MediaQuery.of(context).size.width * 0.035,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.008),
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
