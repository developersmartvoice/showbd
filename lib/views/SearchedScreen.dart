import 'dart:convert';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/modals/FilterClass.dart';
import 'package:appcode3/modals/SearchDoctorClass.dart';
import 'package:appcode3/modals/SpecialityClass.dart';
import 'package:appcode3/views/FilteredGuidesScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchedScreen extends StatefulWidget {
  // const SearchedScreen({super.key})

  @override
  _SearchedScreenState createState() => _SearchedScreenState();
}

class _SearchedScreenState extends State<SearchedScreen> {
  bool isLoggedIn = false;
  bool isSearching = false;
  bool isLoading = false;
  bool isErrorInLoading = false;
  int? currentId;
  FilterClass? _filterClass;
  SearchDoctorClass? searchDoctorClass;
  // List<DoctorData> _newData = [];
  String nextUrl = "";
  bool isLoadingMore = false;
  String searchKeyword = "";
  ScrollController _scrollController = ScrollController();
  // TextEditingController _textController = TextEditingController();
  SpecialityClass? specialityClass;
  List<String> departmentList = [];
  double priceRange = 100;
  List<String> selectedLanguages = [];
  List<String> selectedActivities = [];
  int selectedGender = 0; // 0: None, 1: Male, 2: Female
  int? filterFees;
  String? filterGender;
  bool isFeesSelected = false;
  bool isLanguageSelected = false;
  bool isActivitiesSelected = false;
  bool isGenderSelected = false;
  bool saveFilterSettings = false;
  bool isFilterLoading = false;

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

  getFiltersDoctors() async {
    String body = getBodyParameter();
    if (body.isNotEmpty) {
      print("This body is from Inside the condition!: $body");
      final response = await post(Uri.parse("$SERVER_ADDRESS/api/filterdoctor"),
          headers: {'Content-Type': 'application/json'}, body: body);
      // print(getBodyParameter());
      // print(response);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("Total Found: ${jsonResponse['data']['total']}");
        setState(() {
          _filterClass = FilterClass.fromJson(jsonResponse);
          // print("Total Found: ${_filterClass!.data!.total}");
          isFilterLoading = false;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) =>
                      FilteredGuidesScreen(_filterClass!, body))));
        });
      }
    }
  }

  String getBodyParameter() {
    if (isFeesSelected &&
        isActivitiesSelected &&
        isLanguageSelected &&
        isGenderSelected) {
      Map<String, dynamic> requestBody = {
        'consultation_fees': filterFees,
        'gender': filterGender,
        'languages': selectedLanguages,
        'services': selectedActivities,
      };
      print(jsonEncode(requestBody));
      // return jsonEncode(requestBody);
      return requestBody.toString();
    } else if (isFeesSelected && isLanguageSelected && isActivitiesSelected) {
      Map<String, dynamic> requestBody = {
        'consultation_fees': filterFees,
        'languages': selectedLanguages,
        'services': selectedActivities,
      };
      print(jsonEncode(requestBody));
      // return jsonEncode(requestBody);
      return requestBody.toString();
    } else if (isFeesSelected && isLanguageSelected && isGenderSelected) {
      Map<String, dynamic> requestBody = {
        'consultation_fees': filterFees,
        'gender': filterGender,
        'languages': selectedLanguages,
      };
      print(jsonEncode(requestBody));
      // return jsonEncode(requestBody);
      return requestBody.toString();
    } else if (isFeesSelected && isActivitiesSelected && isGenderSelected) {
      Map<String, dynamic> requestBody = {
        'consultation_fees': filterFees,
        'gender': filterGender,
        'services': selectedActivities,
      };
      print(jsonEncode(requestBody));
      // return jsonEncode(requestBody);
      return requestBody.toString();
    } else if (isLanguageSelected && isActivitiesSelected && isGenderSelected) {
      Map<String, dynamic> requestBody = {
        'gender': filterGender,
        'languages': selectedLanguages,
        'services': selectedActivities,
      };
      print(jsonEncode(requestBody));
      // return jsonEncode(requestBody);
      return requestBody.toString();
    } else if (isFeesSelected && isLanguageSelected) {
      Map<String, dynamic> requestBody = {
        'consultation_fees': filterFees,
        'languages': selectedLanguages,
      };
      print(jsonEncode(requestBody));
      // return jsonEncode(requestBody);
      return requestBody.toString();
    } else if (isFeesSelected && isActivitiesSelected) {
      Map<String, dynamic> requestBody = {
        'consultation_fees': filterFees,
        'services': selectedActivities,
      };
      print(jsonEncode(requestBody));
      // return jsonEncode(requestBody);
      return requestBody.toString();
    } else if (isFeesSelected && isGenderSelected) {
      Map<String, dynamic> requestBody = {
        'consultation_fees': filterFees,
        'gender': filterGender,
      };
      print(jsonEncode(requestBody));
      // return jsonEncode(requestBody);
      return requestBody.toString();
    } else if (isLanguageSelected && isActivitiesSelected) {
      Map<String, dynamic> requestBody = {
        'languages': selectedLanguages,
        'services': selectedActivities,
      };
      print(jsonEncode(requestBody));
      // return jsonEncode(requestBody);
      return requestBody.toString();
    } else if (isLanguageSelected && isGenderSelected) {
      Map<String, dynamic> requestBody = {
        'gender': filterGender,
        'languages': selectedLanguages,
      };
      print(jsonEncode(requestBody));
      // return jsonEncode(requestBody);
      return requestBody.toString();
    } else if (isActivitiesSelected && isGenderSelected) {
      Map<String, dynamic> requestBody = {
        'gender': filterGender,
        'services': selectedActivities,
      };
      print(jsonEncode(requestBody));
      // return jsonEncode(requestBody);
      return requestBody.toString();
    } else if (isFeesSelected) {
      Map<String, dynamic> requestBody = {
        'consultation_fees': filterFees,
      };
      print(jsonEncode(requestBody));
      // return jsonEncode(requestBody);
      return requestBody.toString();
    } else if (isLanguageSelected) {
      Map<String, dynamic> requestBody = {
        'languages': selectedLanguages,
      };
      // print(jsonEncode(requestBody));
      print(requestBody.toString());
      return requestBody.toString();
    } else if (isActivitiesSelected) {
      Map<String, dynamic> requestBody = {
        'services': selectedActivities,
      };
      print(jsonEncode(requestBody));
      // return jsonEncode(requestBody);
      return requestBody.toString();
    } else if (isGenderSelected) {
      Map<String, dynamic> requestBody = {
        'gender': filterGender,
      };
      print(jsonEncode(requestBody));
      // return jsonEncode(requestBody);
      return requestBody.toString();
    } else {
      return '';
    }
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
    return SafeArea(
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
                : SingleChildScrollView(
                    controller: _scrollController,
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: const Color.fromARGB(255, 243, 103, 9),
                              valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).hintColor),
                            ),
                          )
                        : Column(
                            children: [
                              header(),
                              // upCommingAppointments(),
                              isFilterLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: const Color.fromARGB(
                                            255, 243, 103, 9),
                                      ),
                                    )
                                  : body()
                              // isLoadingMore
                              //     ? Padding(
                              //         padding: const EdgeInsets.all(20.0),
                              //         child: Row(
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.center,
                              //           children: [
                              //             CircularProgressIndicator(
                              //               strokeWidth: 2,
                              //             ),
                              //             SizedBox(
                              //               width: 5,
                              //             ),
                              //             Text("Loading..."),
                              //           ],
                              //         ),
                              //       )
                              //     : Container()
                            ],
                          ),
                  ),
            header(),
          ],
        ),
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
          height: MediaQuery.of(context).size.height * 0.08,
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
                        fontSize: MediaQuery.of(context).size.width * 0.04),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                      onTap: () {
                        // Navigator.pop(context);
                        setState(() {
                          print("Filter Fees: $filterFees");
                          print("Languages Selected: $selectedLanguages");
                          print("Activities Selected: $selectedActivities");
                          print("Gender: $filterGender");
                          if (isFeesSelected ||
                              isLanguageSelected ||
                              isActivitiesSelected ||
                              isGenderSelected) {
                            setState(() {
                              isFilterLoading = true;
                            });
                            getFiltersDoctors();
                          } else {
                            print("No Value Selected");
                          }
                        });
                      },
                      child: Text(
                        "Apply",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: const Color.fromARGB(255, 12, 88, 150),
                          fontSize: MediaQuery.of(context).size.width * 0.03,
                        ),
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
        padding: const EdgeInsets.all(0),
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
                if (selectedLanguages.isNotEmpty) {
                  setState(() {
                    isLanguageSelected = true;
                  });
                } else {
                  setState(() {
                    isLanguageSelected = false;
                  });
                }
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
                if (selectedActivities.isNotEmpty) {
                  setState(() {
                    isActivitiesSelected = true;
                  });
                } else {
                  setState(() {
                    isActivitiesSelected = false;
                  });
                }
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
            SizedBox(height: 15),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _clearFilters();
                  setState(() {
                    filterGender = null;
                    filterFees = null;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(190, 255, 115,
                          0)), // Set the background color to orange
                ),
                child: Text(
                  'Clear Filters',
                  style: TextStyle(color: WHITE),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, ValueChanged<int> onChanged) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 18.0), // Adjust the left padding as needed
            child: Text(
              label,
              style: GoogleFonts.robotoCondensed(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // Divider(
          //   height: 10,
          //   color: Colors.grey,
          // ),
          Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 17.0), // Adjust the left padding as needed
                      child: Text(
                        'Free',
                        style: GoogleFonts.robotoCondensed(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                    ),
                    Text(
                      '100',
                      style: GoogleFonts.robotoCondensed(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                // SliderTheme(
                //   data: SliderThemeData(
                //     //trackHeight: 5, // Change the height of the track
                //     thumbShape: RoundSliderThumbShape(
                //       enabledThumbRadius: 10, // Change the size of the thumb
                //     ),
                //   ),
                //   child: Slider(
                //     value: value,
                //     min: 0,
                //     max: 100,
                //     onChanged: (double newValue) {
                //       onChanged(
                //           newValue.round()); // Round the double value to an integer
                //     },
                //     activeColor: Color.fromARGB(190, 255, 115, 0),
                //   ),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     Text(
                //       '100',
                //       style: GoogleFonts.robotoCondensed(
                //           fontSize: 20, fontWeight: FontWeight.w500),
                //     ),
                //   ],
                // ),
                Column(
                  children: [
                    SliderTheme(
                      data: SliderThemeData(
                        //trackHeight: 5, // Change the height of the track
                        thumbShape: RoundSliderThumbShape(
                          enabledThumbRadius:
                              10, // Change the size of the thumb
                        ),
                      ),
                      child: Slider(
                        value: value,
                        min: 0,
                        max: 100,
                        onChanged: (double newValue) {
                          onChanged(newValue
                              .round()); // Round the double value to an integer
                          setState(() {
                            filterFees = newValue.round();
                            print("filter Fees are: $filterFees");
                            if (filterFees != null) {
                              isFeesSelected = true;
                            } else {
                              isFeesSelected = false;
                            }
                          });
                        },
                        activeColor: Color.fromARGB(190, 255, 115, 0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Selected Fees: ${value.round()}',
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          // Divider(
          //   height: 10,
          //   color: Colors.grey,
          // ),
        ],
      ),
    );
  }

  Widget _buildMultiSelect(String label, List<String> selectedValues,
      List<String> options, ValueChanged<List<String>> onChanged) {
    return Container(
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.start,

            children: [
          Column(
            children: [
              Container(
                color: LIGHT_GREY_SCREEN_BACKGROUND,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 18.0), // Adjust the left padding as needed
                      child: Text(
                        label,
                        style: GoogleFonts.robotoCondensed(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Wrap(
                spacing: 12.0,
                children: options.map((option) {
                  String mappedOption = mapOption(option);
                  return FilterChip(
                    label: Text(option),
                    selected: selectedValues.contains(mappedOption),
                    onSelected: (selected) {
                      List<String> newSelectedValues =
                          List.from(selectedValues);
                      String mappedOption = mapOption(option);
                      if (selected) {
                        newSelectedValues.add(mappedOption);
                      } else {
                        newSelectedValues.remove(mappedOption);
                      }
                      onChanged(newSelectedValues);
                      // if (selectedLanguages.isNotEmpty) {
                      //   isLanguageSelected = true;
                      // } else {
                      //   isLanguageSelected = false;
                      // }
                    },
                    selectedColor: Color.fromARGB(190, 255, 115, 0),
                    labelStyle: TextStyle(
                      color: selectedValues.contains(mappedOption)
                          ? Colors.white
                          : Colors.black, // Set font color based on selection
                    ),
                  );
                }).toList(),
              ),
              Divider(
                height: 20,
                color: Colors.grey,
              ),
            ],
          )
        ]));
  }

  String mapOption(String option) {
    switch (option) {
      case 'Translation & Interpretation':
        return 'translation';
      case 'Pick Up & Driving Tours':
        return 'pick';
      case 'Shopping':
        return 'shopping';
      case 'Nightlife & Bars':
        return 'nightlife';
      case 'Food & Resturants':
        return 'food';
      case 'Arts & Museums':
        return 'art';
      case 'Sports & Recreation':
        return 'sports';
      case 'History & Culture':
        return 'history';
      case 'Exploration & Sightseeing':
        return 'exploration';
      case 'English':
        return 'english';
      case 'Bengali':
        return 'bengali';
      case 'Hindi':
        return 'hindi';
      case 'Urdu':
        return 'urdu';
      default:
        return option;
    }
  }

  Widget _buildRadioButtons(String label, int selectedValue,
      List<String> options, ValueChanged<int> onChanged) {
    return Container(
      color: LIGHT_GREY_SCREEN_BACKGROUND,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 18.0), // Adjust the left padding as needed
            child: Text(
              label,
              style: GoogleFonts.robotoCondensed(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width * 0.04,
              ),
            ),
          ),
          Container(
            color: WHITE,
            child: Column(
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
                        setState(() {
                          switch (value) {
                            case 0:
                              filterGender = "none";
                              break;
                            case 1:
                              filterGender = "male";
                              break;
                            case 2:
                              filterGender = "female";
                              break;
                            default:
                              filterGender = "none";
                          }
                          if (filterGender != null) {
                            isGenderSelected = true;
                          } else {
                            isGenderSelected = false;
                          }
                        });
                      },
                      activeColor: Color.fromARGB(190, 255, 115, 0),
                    ),
                    Text(option),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
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
        Flexible(
          child: Text(
            label,
            style: GoogleFonts.robotoCondensed(
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              fontSize: MediaQuery.of(context).size.width * 0.035,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _clearFilters() {
    setState(() {
      isFeesSelected = false;
      isGenderSelected = false;
      isLanguageSelected = false;
      isActivitiesSelected = false;
      priceRange = 100;
      selectedLanguages = [];
      selectedActivities = [];
      selectedGender = 0;
      saveFilterSettings = false;
    });
  }

  // _onSubmit(String value) async {
  //   if (value.length == 0) {
  //     setState(() {
  //       _newData.clear();

  //       isSearching = false;
  //       print("length 0");
  //       print(_newData);
  //     });
  //   } else {
  //     setState(() {
  //       isLoading = true;
  //       isSearching = true;
  //     });
  //     final response =
  //         await get(Uri.parse("$SERVER_ADDRESS/api/searchdoctor?term=$value"));
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       searchDoctorClass = SearchDoctorClass.fromJson(jsonResponse);
  //       //print([0].name);
  //       setState(() {
  //         _newData.clear();
  //         //print(searchDoctorClass.data.doctorData);
  //         _newData.addAll(searchDoctorClass!.data!.doctorData!);
  //         nextUrl = searchDoctorClass!.data!.links!.last.url!;
  //         print(nextUrl);
  //         isLoading = false;
  //       });
  //     }
  //   }
  // }
}
