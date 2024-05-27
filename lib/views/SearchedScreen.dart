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
  String nextUrl = "";
  bool isLoadingMore = false;
  String searchKeyword = "";
  ScrollController _scrollController = ScrollController();
  SpecialityClass? specialityClass;
  List<String> departmentList = [];
  double priceRange = 0;
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
    super.initState();

    SharedPreferences.getInstance().then((pref) {
      setState(() {
        isLoggedIn = pref.getBool("isLoggedInAsDoctor") ?? false;
        currentId = int.parse(pref.getString("userId").toString());
        print("ID: ${currentId}");
      });
    });
  }

  getFiltersDoctors() async {
    String body = getBodyParameter();
    if (body.isNotEmpty) {
      print("This body is from Inside the condition!: $body");
      final response = await post(Uri.parse("$SERVER_ADDRESS/api/filterdoctor"),
          headers: {'Content-Type': 'application/json'}, body: body);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("Total Found: ${jsonResponse['data']['total']}");
        setState(() {
          _filterClass = FilterClass.fromJson(jsonResponse);
          isFilterLoading = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) => FilteredGuidesScreen(_filterClass!, body)),
            ),
          );
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
      return jsonEncode(requestBody);
      // return requestBody.toString();
    } else if (isLanguageSelected) {
      Map<String, dynamic> requestBody = {
        'languages': selectedLanguages,
      };
      // print(jsonEncode(requestBody));
      print(requestBody.toString());
      // return requestBody.toString();
      return jsonEncode(requestBody);
    } else if (isActivitiesSelected) {
      Map<String, dynamic> requestBody = {
        'services': selectedActivities,
      };
      print(jsonEncode(requestBody));
      return jsonEncode(requestBody);
      // return requestBody.toString();
    } else if (isGenderSelected) {
      Map<String, dynamic> requestBody = {
        'gender': filterGender,
      };
      print(requestBody.toString());
      return jsonEncode(requestBody);
      // return requestBody.toString();
    } else {
      return '';
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Widget _getAdContainer() {
    return Container();
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
                          SizedBox(height: 20),
                          Text(UNABLE_TO_LOAD_DATA_FORM_SERVER),
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
                              isFilterLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: const Color.fromARGB(
                                            255, 243, 103, 9),
                                      ),
                                    )
                                  : body()
                            ],
                          ),
                  ),
            header(),
          ],
        ),
      ),
    );
  }

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
                  SizedBox(width: 10),
                  Text(
                    "Filters",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: WHITE,
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                    ),
                  ),
                  SizedBox(width: 20),
                  InkWell(
                    onTap: () {
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
                    ),
                  ),
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
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(seconds: 1),
              child: _buildRadioButtons(
                'Gender',
                selectedGender,
                ['All', 'Male', 'Female'],
                (value) {
                  setState(() {
                    selectedGender = value;
                    filterGender = value == 1
                        ? 'Male'
                        : value == 2
                            ? 'Female'
                            : null;
                    isGenderSelected = value != 0;
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: _buildSlider('Price Range', priceRange, (value) {
                setState(() {
                  priceRange = value.toDouble();
                  filterFees = value.toInt();
                  isFeesSelected = true;
                });
              }),
            ),
            SizedBox(height: 16),
            AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(seconds: 1),
              child: _buildMultiSelect('Languages', selectedLanguages,
                  ['English', 'Bengali', 'Hindi', 'Urdu'], (value) {
                setState(() {
                  selectedLanguages = value;
                  isLanguageSelected = selectedLanguages.isNotEmpty;
                });
              }),
            ),
            SizedBox(height: 16),
            AnimatedContainer(
              duration: Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: _buildMultiSelect(
                'Activities',
                selectedActivities,
                [
                  'Translation & Interpretation',
                  'Pick Up & Driving Tours',
                  'Shopping',
                  'Nightlife & Bars',
                  'Food & Resturants',
                  'Arts & Museums',
                  'Sports & Recreation',
                  'History & Culture',
                  'Exploration & Sightseeing'
                ],
                (value) {
                  setState(() {
                    selectedActivities = value;
                    isActivitiesSelected = selectedActivities.isNotEmpty;
                  });
                },
              ),
            ),
            SizedBox(height: 16),
            _buildCheckbox(
                'Save my filter settings for future use', saveFilterSettings,
                (value) {
              setState(() {
                saveFilterSettings = value;
              });
            }),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedGender = 0;
                    priceRange = 0;
                    selectedLanguages = [];
                    selectedActivities = [];
                    saveFilterSettings = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: Color.fromARGB(255, 243, 103, 9),
                    width: 1.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                ),
                child: Text(
                  'Clear All',
                  style: TextStyle(
                    color: Color.fromARGB(255, 243, 103, 9),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButtons(String title, int selectedValue,
      List<String> options, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: options.asMap().entries.map((entry) {
            int idx = entry.key;
            String option = entry.value;
            return Expanded(
              child: Row(
                children: [
                  Radio<int>(
                    value: idx,
                    groupValue: selectedValue,
                    onChanged: (value) => onChanged(value!),
                    activeColor: Color.fromARGB(255, 243, 103, 9),
                  ),
                  if (option == 'All') Image.asset("assets/fm.png"),
                  if (option == 'Male') Image.asset("assets/male-user.png"),
                  if (option == 'Female') Image.asset("assets/female.png"),
                  SizedBox(width: 5),
                  Text(option),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSlider(String title, double value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Slider(
          value: value,
          onChanged: (value) => onChanged(value),
          activeColor: Color.fromARGB(255, 243, 103, 9),
          min: 0,
          max: 5000,
          divisions: 1000,
          label: value.round().toString(),
        ),
      ],
    );
  }

  Widget _buildMultiSelect(String title, List<String> selectedValues,
      List<String> options, Function(List<String>) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 16, vertical: 8), // Adjusted padding
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 8),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
              horizontal: 16, vertical: 8), // Adjusted padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[200],
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (selectedValues.contains(option)) {
                      selectedValues.remove(option);
                    } else {
                      selectedValues.add(option);
                    }
                    onChanged(selectedValues);
                  });
                },
                child: Chip(
                  label: Text(option),
                  backgroundColor: selectedValues.contains(option)
                      ? Color.fromARGB(255, 243, 103, 9)
                      : Colors.transparent,
                  labelStyle: TextStyle(
                    color: selectedValues.contains(option)
                        ? Colors.white
                        : Colors.black,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: Color.fromARGB(255, 243, 103, 9),
                      width: 1.5,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckbox(String title, bool value, Function(bool) onChanged) {
    return CheckboxListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      value: value,
      onChanged: (value) => onChanged(value!),
      activeColor: Color.fromARGB(255, 243, 103, 9),
    );
  }
}
