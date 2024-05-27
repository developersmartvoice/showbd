import 'dart:convert';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/views/Doctor/Tour.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateTrip extends StatefulWidget {
  const CreateTrip({super.key});

  @override
  State<CreateTrip> createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
  String? doctorId;
  String location = 'Where are you going?';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String numberOfPeople = "Just me";
  String gender = 'Select type of local';
  int? durationInDays;
  bool isLoading = false;
  int people = 0;

  bool locationPicked = false;
  bool datePickedStart = false;
  bool datePickedEnd = false;
  bool peoplePicked = false;
  bool genderPicked = false;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? startDate : endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isStartDate ? startDate : endDate)) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
          endDate = picked;
          datePickedStart = true;
        } else {
          endDate = picked;
          datePickedEnd = true;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((pref) {
      setState(() {
        doctorId = pref.getString("userId");
        print(doctorId);
      });
    });
  }

  Future<void> _selectNumberOfPeople(BuildContext context) async {
    String result = numberOfPeople; // Initialize with a default value

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * .3,
            child: Column(
              children: [
                ListTile(
                  title: Text('Just me'),
                  onTap: () {
                    result = 'Just me';
                    people = 1;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Two people'),
                  onTap: () {
                    people = 2;
                    result = 'Two people';
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Three people'),
                  onTap: () {
                    people = 3;
                    result = 'Three people';
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('More than three'),
                  onTap: () {
                    people = 4;
                    result = 'More than three';
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    setState(() {
      numberOfPeople =
          result; // Update the state outside the showModalBottomSheet
      peoplePicked = true;
    });
  }

  Future<void> _lookingForLocals(BuildContext context) async {
    String result = gender; // Initialize with a default value

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * .3,
            child: Column(
              children: [
                ListTile(
                  title: Text('Male'),
                  onTap: () {
                    result = 'Male';
                    //people = 1;
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Female'),
                  onTap: () {
                    //people = 2;
                    result = 'Female';
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Other'),
                  onTap: () {
                    //people = 4;
                    result = 'Other';
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    setState(() {
      gender = result; // Update the state outside the showModalBottomSheet
      genderPicked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            appBar: AppBar(
              title: Text(
                'Create Trip',
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.headline5!.apply(
                      color: Theme.of(context).backgroundColor,
                      fontWeightDelta: 1),
                ),
              ),
              centerTitle: true,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/moreScreenImages/header_bg.png"), // Add your background image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Navigate to the location search page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationSearchPage(),
                          ),
                        ).then((selectedLocation) {
                          if (selectedLocation != null) {
                            setState(() {
                              location = selectedLocation;
                              locationPicked = true;
                            });
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Destination :  ',
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                // Expanded(
                                //   child: Text(
                                //     location.toUpperCase(),
                                //     style: GoogleFonts.poppins(
                                //         fontWeight: FontWeight.w500,
                                //         color: location == 'Where are you going?'
                                //             ? Colors.grey
                                //             : Color.fromARGB(255, 255, 84, 5),
                                //         fontSize: 20),
                                //   ),
                                // ),
                                // Icon(Icons.location_searching_sharp,
                                //     color: Colors.lightBlue),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Icon(Icons.search_sharp,
                                    color: location == 'Where are you going?'
                                        ? Colors.lightBlue
                                        : Color.fromARGB(255, 255, 84, 5)),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    location.toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        color: location ==
                                                'Where are you going?'
                                            ? Colors.grey
                                            : Color.fromARGB(255, 255, 84, 5),
                                        fontSize: 20),
                                  ),
                                ),
                                SizedBox(
                                    width:
                                        5), // Adjust the space between icon and text as needed
                                // Expanded(
                                //     child: Container(
                                //         alignment: Alignment.centerLeft,
                                //         child: !locationPicked
                                //             ? Text("Enter location",
                                //                 style: GoogleFonts.robotoCondensed(
                                //                   fontSize: 18,
                                //                   fontWeight: FontWeight.w500,
                                //                 ))
                                //             : Text(""))),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    Divider(
                      height: 2,
                      color: Colors.grey,
                    ),

                    SizedBox(height: 30.0),
                    Container(
                      child: InkWell(
                        onTap: () => _selectDate(context, true),
                        child: InputDecorator(
                          decoration: InputDecoration(
                              labelText: DATE_FROM.toUpperCase(),
                              labelStyle: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: datePickedStart
                                      ? Color.fromARGB(255, 255, 84, 5)
                                      : Colors.grey,
                                  fontSize: 24),
                              //),
                              errorText: !datePickedStart
                                  ? "Field cannot be empty!"
                                  : ""),
                          child: Text(
                            '${startDate.day.toString().padLeft(2, '0')} ${_getMonthAbbreviation(startDate.month)} ${startDate.year}',
                          ),
                        ),
                      ),
                    ),

                    // Divider(
                    //   height: 50,
                    //   color: Colors.grey,
                    // ),
                    SizedBox(height: 30.0),
                    Container(
                      child: InkWell(
                        onTap: () => _selectDate(context, false),
                        child: InputDecorator(
                          decoration: InputDecoration(
                              labelText: DATE_TO.toUpperCase(),
                              // labelStyle: TextStyle(fontSize: 18)
                              labelStyle: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                  color: datePickedEnd
                                      ? Color.fromARGB(255, 255, 84, 5)
                                      : Colors.grey,
                                  fontSize: 24),
                              //),
                              errorText: !datePickedEnd
                                  ? "Field cannot be empty!"
                                  : ""),
                          child: Text(
                            '${endDate.day.toString().padLeft(2, '0')} ${_getMonthAbbreviation(endDate.month)} ${endDate.year}',
                          ),
                        ),
                      ),
                    ),

                    // Divider(
                    //   height: 20,
                    //   color: Colors.grey,
                    // ),
                    SizedBox(height: 30.0),
                    InkWell(
                      onTap: () => _selectNumberOfPeople(context),
                      child: InputDecorator(
                        decoration: InputDecoration(
                            labelText: PEOPLE.toUpperCase(),
                            labelStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: !peoplePicked
                                    ? Colors.grey
                                    : Color.fromARGB(255, 255, 84, 5),
                                fontSize: 24),
                            //),
                            errorText:
                                !peoplePicked ? "Field cannot be empty!" : ""),
                        child: Text(numberOfPeople),
                      ),
                    ),

                    // Divider(
                    //   height: 20,
                    //   color: Colors.grey,
                    // ),

                    SizedBox(height: 30.0),
                    // Add the last input field and button here

                    InkWell(
                      onTap: ()
                          //() {
                          //   // Implement the logic for the last input field
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context)
                          =>
                          _lookingForLocals(context),

                      //onTap: () => _selectNumberOfPeople(context),
                      // onTap: () => TypeSelectionPage(
                      //   onGenderSelected: (selectedGender) {
                      //     if (selectedGender != null) {
                      //       setState(() {
                      //         gender = selectedGender;
                      //         genderPicked = true;
                      //       });
                      //     }
                      //   },
                      // ),
                      child: InputDecorator(
                        decoration: InputDecoration(
                            //labelText: PEOPLE.toUpperCase(),
                            labelText: LOOKING_LOCAL.toUpperCase(),
                            labelStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              color: genderPicked
                                  ? Color.fromARGB(255, 255, 84, 5)
                                  : Colors.grey,
                              fontSize: 24,
                            ),

                            // labelStyle: GoogleFonts.poppins(
                            //     fontWeight: FontWeight.w500,
                            //     color: !peoplePicked
                            //         ? Colors.grey
                            //         : Color.fromARGB(255, 255, 84, 5),
                            //     fontSize: 24),
                            //),
                            errorText:
                                !genderPicked ? "Field cannot be empty!" : ""),
                        child: Text(gender),
                      ),

                      // onTap: () {
                      //   // Implement the logic for the last input field
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //     builder: (context) => TypeSelectionPage(
                      //         onGenderSelected: (selectedGender) {
                      //           if (selectedGender != null) {
                      //             setState(() {
                      //               gender = selectedGender;
                      //               genderPicked = true;
                      //             });
                      //           }
                      //         },
                      //       ),
                      //     ),
                      //   );
                      // },
                      // child: InputDecorator(
                      //   decoration: InputDecoration(
                      //       labelText: LOOKING_LOCAL.toUpperCase(),
                      //       labelStyle: GoogleFonts.poppins(
                      //         fontWeight: FontWeight.w500,
                      //         color: genderPicked
                      //             ? Color.fromARGB(255, 255, 84, 5)
                      //             : Colors.grey,
                      //         fontSize: 24,
                      //       ),
                      //       //),
                      //       errorText:
                      //           !genderPicked ? "Field cannot be empty!" : ""),
                      //   child: Row(
                      //     //mainAxisAlignment: MainAxisAlignment.end,
                      //     children: [
                      //       SizedBox(
                      //         height: 30,
                      //         child: Text(
                      //           gender,
                      //           style: GoogleFonts.robotoCondensed(
                      //             fontSize: 18,
                      //             fontWeight: FontWeight.w500,
                      //           ),
                      //         ),
                      //       ),
                      //       Column(
                      //         mainAxisAlignment: MainAxisAlignment.end,
                      //         children: [
                      //           IconButton(
                      //             icon: Icon(Icons.arrow_forward_ios_sharp),
                      //             onPressed: () {
                      //               //     Navigator.push(
                      //               //       context,
                      //               //  MaterialPageRoute(
                      //               //           builder: (context) =>
                      //               //          SendOffersScreen()),
                      //               //    );
                      //               // Handle forward button press
                      //             },
                      //           ),
                      //         ],
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ),

                    //SizedBox(height: MediaQuery.of(context).size.height * .09),

                    SizedBox(
                      height: 50,
                    ),

                    // Update the ElevatedButton.icon widget
                    ElevatedButton.icon(
                      onPressed: () {
                        // Handle the Create Trip button click
                        // You can implement the logic to create the trip here
                        if (locationPicked &&
                            datePickedStart &&
                            datePickedEnd &&
                            peoplePicked &&
                            genderPicked) {
                          setState(() {
                            isLoading = true; // Set loading state to true
                          });

                          // Calculate duration in days
                          durationInDays =
                              calculateDurationInDays(startDate, endDate);
                          print(durationInDays);

                          // Call the createTrip function
                          createTrip();
                        } else {
                          // Handle the case where some fields are not selected
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        backgroundColor: locationPicked &&
                                datePickedStart &&
                                datePickedEnd &&
                                peoplePicked &&
                                genderPicked
                            ? Color.fromARGB(255, 255, 84, 5)
                            : Color.fromARGB(255, 185, 199, 206),
                        fixedSize: Size(
                          MediaQuery.of(context).size.width * .5,
                          50,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      icon: isLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: const Color.fromARGB(255, 243, 103, 9),
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Icon(
                              Icons.travel_explore,
                              color: Colors.white,
                            ),
                      label: isLoading
                          ? SizedBox.shrink() // Hide label when loading
                          : Text(
                              'Create Trip',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                color: WHITE,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  int calculateDurationInDays(DateTime start, DateTime end) {
    Duration duration = end.difference(start);
    return duration.inDays;
  }

  void createTrip() async {
    // Prepare the data
    Map<String, dynamic> tripData = {
      "guide_id":
          doctorId, // Replace with the actual guide_id from your frontend
      "location": location,
      "startDate": startDate.toIso8601String(),
      "endDate": endDate.toIso8601String(),
      "duration": durationInDays.toString(),
      "numberOfPeople": people.toString(),
      "gender": gender,
    };

    // Make an HTTP POST request
    // Make sure to replace 'YOUR_API_ENDPOINT' with the actual API endpoint
    var response = await post(
      Uri.parse("$SERVER_ADDRESS/api/createtrip"),
      // headers: {'Content-Type': 'application/json'},
      body: tripData,
    );

    // Check the response
    if (response.statusCode == 201) {
      // Trip created successfully
      var jsonResponse = jsonDecode(response.body);
      print('Trip created: $jsonResponse');
      setState(() {
        isLoading = false;
      });

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Trip created successfully!'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Tour()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Error handling
      print('Failed to create trip. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'Failed to create trip. Status code: ${response.statusCode}'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}

class LocationSearchPage extends StatefulWidget {
  @override
  _LocationSearchPageState createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<String> suggestedCities = [
    'Bagerhat',
    'Bandarban',
    'Barguna',
    'Barishal',
    'Bhola',
    'Bogura',
    'Brahmanbaria',
    'Chandpur',
    'Chattogram',
    'Chuadanga',
    'Comilla',
    'Cox\'s Bazar',
    'Dhaka',
    'Dinajpur',
    'Faridpur',
    'Feni',
    'Gaibandha',
    'Gazipur',
    'Gopalganj',
    'Habiganj',
    'Jamalpur',
    'Jashore (Jessore)',
    'Jhalokathi',
    'Jhenaidah',
    'Joypurhat',
    'Khagrachari',
    'Khulna',
    'Kishoreganj',
    'Kushtia',
    'Lakshmipur',
    'Lalmonirhat',
    'Madaripur',
    'Magura',
    'Manikganj',
    'Meherpur',
    'Moulvibazar',
    'Munshiganj',
    'Mymensingh',
    'Naogaon',
    'Narail',
    'Narayanganj',
    'Narsingdi',
    'Netrokona',
    'Nilphamari',
    'Noakhali',
    'Pabna',
    'Panchagarh',
    'Patuakhali',
    'Pirojpur',
    'Rajbari',
    'Rajshahi',
    'Rangamati',
    'Rangpur',
    'Satkhira',
    'Shariatpur',
    'Sherpur',
    'Sirajganj',
    'Sunamganj',
    'Sylhet',
    'Tangail',
    'Thakurgaon',
    'Jamalpur',
    'Narsingdi',
    'Netrakona',
  ];

  List<String> filteredCities = []; // List to store filtered cities

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search Location',
              style: Theme.of(context).textTheme.headline5!.apply(
                  color: Theme.of(context).backgroundColor,
                  fontWeightDelta: 5)),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/moreScreenImages/header_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  // Filter the cities based on the entered text
                  setState(() {
                    filteredCities = suggestedCities
                        .where((city) =>
                            city.toLowerCase().contains(value.toLowerCase()))
                        .toList();
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search_sharp),
                  prefixIconColor: Colors.lightBlue,
                  hintText: 'Search city...',
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCities.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(filteredCities[index]),
                      onTap: () {
                        Navigator.pop(context, filteredCities[index]);
                      },
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
}

class TypeSelectionPage extends StatefulWidget {
  final ValueChanged<String>? onGenderSelected;

  TypeSelectionPage({Key? key, this.onGenderSelected}) : super(key: key);

  @override
  _TypeSelectionPageState createState() => _TypeSelectionPageState();
}

class _TypeSelectionPageState extends State<TypeSelectionPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text('Gender',
              style: Theme.of(context).textTheme.headline5!.apply(
                  color: Theme.of(context).backgroundColor,
                  fontWeightDelta: 5)),
          backgroundColor: Color.fromARGB(255, 255, 84, 5),
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text('Male'),
              onTap: () {
                widget.onGenderSelected?.call('Male');
                Navigator.pop(context, 'Male');
              },
            ),
            ListTile(
              title: Text('Female'),
              onTap: () {
                widget.onGenderSelected?.call('Female');
                Navigator.pop(context, 'Female');
              },
            ),
            ListTile(
              title: Text('Other'),
              onTap: () {
                widget.onGenderSelected?.call('Other');
                Navigator.pop(context, 'Other');
              },
            ),
          ],
        ),
      ),
    );
  }
}
