import 'dart:convert';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/modals/SearchDoctorClass.dart';
import 'package:appcode3/modals/SpecialityClass.dart';
import 'package:appcode3/views/DetailsPage.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchedScreen extends StatefulWidget {
  // String keyword;

  // SearchedScreen(this.keyword);
  SearchedScreen();

  @override
  _SearchedScreenState createState() => _SearchedScreenState();
}

class _SearchedScreenState extends State<SearchedScreen> {
  bool isLoggedIn = false;
  bool isSearching = false;
  bool isLoading = false;
  bool isErrorInLoading = false;
  int? currentId;
  SearchDoctorClass? searchDoctorClass;
  List<DoctorData> _newData = [];
  String nextUrl = "";
  bool isLoadingMore = false;
  String searchKeyword = "";
  ScrollController _scrollController = ScrollController();
  TextEditingController _textController = TextEditingController();
  SpecialityClass? specialityClass;
  List<String> departmentList = [];
  double priceRange = 100;
  List<String> selectedLanguages = [];
  List<String> selectedActivities = [];
  int selectedGender = 0; // 0: None, 1: Male, 2: Female
  bool saveFilterSettings = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _onChanged(widget.keyword);
    // _textController.text = widget.keyword;
    // searchKeyword = widget.keyword;
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     //print("Loadmore");
    //     _loadMoreFunc();
    //   }
    // });
    SharedPreferences.getInstance().then((pref) {
      setState(() {
        isLoggedIn = pref.getBool("isLoggedInAsDoctor") ?? false;
        currentId = int.parse(pref.getString("userId").toString());
        // print("this is to see the keys");
        print("ID: ${currentId}");
        // print("keysss: ${pref.getString("userId")}");
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
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
    return Scaffold(
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
              : SingleChildScrollView(
                  controller: _scrollController,
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).hintColor),
                          ),
                        )
                      : Column(
                          children: [
                            header(),
                            // upCommingAppointments(),
                            body(),
                            isLoadingMore
                                ? Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text("Loading..."),
                                      ],
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                ),
          header(),
        ],
      ),
    );
  }

  // Widget upCommingAppointments() {
  //   return Container(
  //     margin: EdgeInsets.fromLTRB(16, 0, 16, 5),
  //     child: ListView.builder(
  //       itemCount: _newData.length,
  //       shrinkWrap: true,
  //       padding: EdgeInsets.all(0),
  //       physics: ClampingScrollPhysics(),
  //       itemBuilder: (context, index) {
  //         return Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             appointmentListWidget(
  //               _newData[index].image,
  //               _newData[index].name,
  //               _newData[index].departmentName.toString(),
  //               _newData[index].address,
  //               _newData[index].id,
  //             ),
  //             ENABLE_ADS
  //                 ? (index + 1) % 4 == 0 && index != 0
  //                     ? customAds.nativeAds(id: AD_TYPE)
  //                     : Container()
  //                 : Container()
  //           ],
  //         );
  //       },
  //     ),
  //   );
  // }

  // Widget appointmentListWidget(img, name, department, address, id) {
  //   return InkWell(
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => DetailsPage(id.toString())),
  //       );
  //     },
  //     child: Container(
  //       //height: 90,
  //       margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
  //       padding: EdgeInsets.all(8),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10),
  //         color: WHITE,
  //       ),
  //       child: Row(
  //         children: [
  //           ClipRRect(
  //             borderRadius: BorderRadius.circular(15),
  //             child: CachedNetworkImage(
  //               imageUrl: img,
  //               height: 70,
  //               width: 70,
  //               fit: BoxFit.cover,
  //               placeholder: (context, url) => Container(
  //                 color: Theme.of(context).primaryColorLight,
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(20.0),
  //                   child: Image.asset(
  //                     "assets/homeScreenImages/user_unactive.png",
  //                     height: 20,
  //                     width: 20,
  //                   ),
  //                 ),
  //               ),
  //               errorWidget: (context, url, err) => Container(
  //                   color: Theme.of(context).primaryColorLight,
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(20.0),
  //                     child: Image.asset(
  //                       "assets/homeScreenImages/user_unactive.png",
  //                       height: 20,
  //                       width: 20,
  //                     ),
  //                   )),
  //             ),
  //           ),
  //           SizedBox(
  //             width: 10,
  //           ),
  //           Expanded(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Container(
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         name,
  //                         style: GoogleFonts.poppins(
  //                             color: BLACK,
  //                             fontSize: 13,
  //                             fontWeight: FontWeight.w500),
  //                       ),
  //                       Text(
  //                         department,
  //                         style: GoogleFonts.poppins(
  //                             color: BLACK,
  //                             fontSize: 11,
  //                             fontWeight: FontWeight.w400),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 // SizedBox(height: 10,),
  //                 Container(
  //                   child: Text(
  //                     address.toString(),
  //                     style: GoogleFonts.poppins(
  //                         color: LIGHT_GREY_TEXT,
  //                         fontSize: 10,
  //                         fontWeight: FontWeight.w400),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           SizedBox(
  //             width: 10,
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget header() {
    return Stack(
      children: [
        Image.asset(
          "assets/homeScreenImages/header_bg.png",
          height: MediaQuery.of(context).size.height * 0.16,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
        ),
        SafeArea(
          child: Container(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  Text(
                    "Filters",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: WHITE,
                        fontSize: 22),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Apply",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: BLACK,
                            fontSize: 20),
                      )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget body() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildSlider('Price Range', priceRange, (value) {
              setState(() {
                priceRange = value.toDouble();
              });
            }),
            SizedBox(height: 16),
            _buildMultiSelect('Languages', selectedLanguages,
                ['English', 'Bengali', 'Hindi', 'Urdu'], (value) {
              setState(() {
                selectedLanguages = value;
              });
            }),
            SizedBox(height: 16),
            _buildMultiSelect('Activities', selectedActivities, [
              'Translation & Interpretation',
              'Pick Up & Driving Tours',
              'Shopping',
              'Nightlife & Bars',
              'Food & Resturants',
              'Arts & Museums',
              'Sports & Recreation',
              'History & Culture',
              'Exploration & Sightseeing'
            ], (value) {
              setState(() {
                selectedActivities = value;
              });
            }),
            SizedBox(height: 16),
            _buildRadioButtons(
                'Gender', selectedGender, ['None', 'Male', 'Female'], (value) {
              setState(() {
                selectedGender = value;
              });
            }),
            SizedBox(height: 16),
            _buildCheckbox(
                'Save my filter settings for future use', saveFilterSettings,
                (value) {
              setState(() {
                saveFilterSettings = value;
              });
            }),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _clearFilters,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(190, 255, 115,
                          0)), // Set the background color to orange
                ),
                child: Text('Clear Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: BLACK, fontSize: 18),
        ),
        Slider(
          value: value,
          min: 0,
          max: 100,
          onChanged: (double newValue) {
            onChanged(newValue.round()); // Round the double value to an integer
          },
          activeColor: Color.fromARGB(190, 255, 115, 0),
        ),
        Text('Selected Fees: ${value.round()}'),
      ],
    );
  }

  Widget _buildMultiSelect(String label, List<String> selectedValues,
      List<String> options, ValueChanged<List<String>> onChanged) {
    return Container(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, color: BLACK, fontSize: 18),
          ),
          SizedBox(
            height: 10,
          ),
          Wrap(
            spacing: 12.0,
            children: options.map((option) {
              return FilterChip(
                label: Text(option),
                selected: selectedValues.contains(option),
                onSelected: (selected) {
                  List<String> newSelectedValues = List.from(selectedValues);
                  if (selected) {
                    newSelectedValues.add(option);
                  } else {
                    newSelectedValues.remove(option);
                  }
                  onChanged(newSelectedValues);
                },
                selectedColor: Color.fromARGB(190, 255, 115, 0),
                labelStyle: TextStyle(
                  color: selectedValues.contains(option)
                      ? Colors.white
                      : Colors.black, // Set font color based on selection
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioButtons(String label, int selectedValue,
      List<String> options, ValueChanged<int> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: BLACK, fontSize: 18),
        ),
        Column(
          children: options.asMap().entries.map((entry) {
            int index = entry.key;
            String option = entry.value;
            return Row(
              children: [
                Radio(
                  value: index,
                  groupValue: selectedValue,
                  onChanged: (value) {
                    onChanged(value as int);
                  },
                  activeColor: Color.fromARGB(190, 255, 115, 0),
                ),
                Text(option),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCheckbox(
      String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (newValue) {
            onChanged(newValue!);
          },
          activeColor: Color.fromARGB(190, 255, 115, 0),
        ),
        Text(label),
      ],
    );
  }

  void _clearFilters() {
    setState(() {
      priceRange = 100;
      selectedLanguages = [];
      selectedActivities = [];
      selectedGender = 0;
      saveFilterSettings = false;
    });
  }

  _onChanged(String value) async {
    if (value.length == 0) {
      setState(() {
        _newData.clear();
        isErrorInLoading = false;
        isSearching = false;
        print("length 0");
        print(_newData);
      });
    } else {
      setState(() {
        isLoading = true;
        isSearching = true;
      });
      final response =
          await get(Uri.parse("$SERVER_ADDRESS/api/searchdoctor?term=$value"))
              .catchError((e) {
        setState(() {
          isLoading = false;
          isErrorInLoading = true;
        });
      });
      try {
        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          searchDoctorClass = SearchDoctorClass.fromJson(jsonResponse);
          //print([0].name);
          setState(() {
            _newData.clear();
            //print(searchDoctorClass.data.doctorData);
            _newData.addAll(searchDoctorClass!.data!.doctorData!);
            _newData.removeWhere((element) => element.id == currentId);
            nextUrl = searchDoctorClass!.data!.links!.last.url!;
            print(nextUrl);
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          isLoading = false;
          isErrorInLoading = true;
        });
      }
    }
  }

  // _loadMoreFunc() async {
  //   if (nextUrl == null) {
  //     return;
  //   }
  //   setState(() {
  //     isLoadingMore = true;
  //   });
  //   print(searchKeyword);
  //   final response = await get(Uri.parse("$nextUrl&term=$searchKeyword"));
  //   if (response.statusCode == 200) {
  //     final jsonResponse = jsonDecode(response.body);
  //     searchDoctorClass = SearchDoctorClass.fromJson(jsonResponse);
  //     //print([0].name);
  //     setState(() {
  //       //print(searchDoctorClass.data.doctorData);
  //       _newData.addAll(searchDoctorClass!.data!.doctorData!);
  //       isLoadingMore = false;
  //       nextUrl = searchDoctorClass!.data!.links!.last.url!;
  //       print(nextUrl);
  //     });
  //   }
  // }

  _onSubmit(String value) async {
    if (value.length == 0) {
      setState(() {
        _newData.clear();

        isSearching = false;
        print("length 0");
        print(_newData);
      });
    } else {
      setState(() {
        isLoading = true;
        isSearching = true;
      });
      final response =
          await get(Uri.parse("$SERVER_ADDRESS/api/searchdoctor?term=$value"));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        searchDoctorClass = SearchDoctorClass.fromJson(jsonResponse);
        //print([0].name);
        setState(() {
          _newData.clear();
          //print(searchDoctorClass.data.doctorData);
          _newData.addAll(searchDoctorClass!.data!.doctorData!);
          nextUrl = searchDoctorClass!.data!.links!.last.url!;
          print(nextUrl);
          isLoading = false;
        });
      }
    }
  }
}
