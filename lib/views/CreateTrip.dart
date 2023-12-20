import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateTrip extends StatefulWidget {
  const CreateTrip({super.key});

  @override
  State<CreateTrip> createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
  String location = 'Where are you going?';
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String numberOfPeople = "Just me";
  String gender = 'Select type of local';

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
          datePickedStart = true;
        } else {
          endDate = picked;
          datePickedEnd = true;
        }
      });
    }
  }

  Future<void> _selectNumberOfPeople(BuildContext context) async {
    String result = numberOfPeople; // Initialize with a default value

    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * .26,
            child: Column(
              children: [
                ListTile(
                  title: Text('Just me'),
                  onTap: () {
                    result = 'Just me';
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Two people'),
                  onTap: () {
                    result = 'Two people';
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('Three people'),
                  onTap: () {
                    result = 'Three people';
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text('More than three'),
                  onTap: () {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Trip',
              style: Theme.of(context).textTheme.headline5!.apply(
                  color: Theme.of(context).backgroundColor,
                  fontWeightDelta: 5)),
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
                    child: Row(
                      children: [
                        Text(
                          'Destination:  ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16.0,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            location.toUpperCase(),
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: location == 'Where are you going?'
                                    ? Colors.lightBlue
                                    : Color.fromARGB(255, 255, 84, 5),
                                fontSize: 20),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, color: Colors.lightBlue),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16.0),
                InkWell(
                  onTap: () => _selectDate(context, true),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: DATE_FROM.toUpperCase(),
                      labelStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: datePickedStart
                              ? Color.fromARGB(255, 255, 84, 5)
                              : Colors.lightBlue,
                          fontSize: 24),
                    ),
                    child: Text(
                      '${startDate.day.toString().padLeft(2, '0')} ${_getMonthAbbreviation(startDate.month)} ${startDate.year}',
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                InkWell(
                  onTap: () => _selectDate(context, false),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: DATE_TO.toUpperCase(),
                      // labelStyle: TextStyle(fontSize: 18)
                      labelStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: datePickedEnd
                              ? Color.fromARGB(255, 255, 84, 5)
                              : Colors.lightBlue,
                          fontSize: 24),
                    ),
                    child: Text(
                      '${endDate.day.toString().padLeft(2, '0')} ${_getMonthAbbreviation(endDate.month)} ${endDate.year}',
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                InkWell(
                  onTap: () => _selectNumberOfPeople(context),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: PEOPLE.toUpperCase(),
                      labelStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: !peoplePicked
                              ? Colors.lightBlue
                              : Color.fromARGB(255, 255, 84, 5),
                          fontSize: 24),
                    ),
                    child: Text(numberOfPeople),
                  ),
                ),
                SizedBox(height: 16.0),
                // Add the last input field and button here

                InkWell(
                  onTap: () {
                    // Implement the logic for the last input field
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TypeSelectionPage(
                          onGenderSelected: (selectedGender) {
                            if (selectedGender != null) {
                              setState(() {
                                gender = selectedGender;
                                genderPicked = true;
                              });
                            }
                          },
                        ),
                      ),
                    );
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: LOOKING_LOCAL.toUpperCase(),
                      labelStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: genderPicked
                            ? Color.fromARGB(255, 255, 84, 5)
                            : Colors.lightBlue,
                        fontSize: 24,
                      ),
                    ),
                    child: Text(gender),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * .09),

                ElevatedButton.icon(
                  onPressed: () {
                    // Handle the Create Trip button click
                    // You can implement the logic to create the trip here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: locationPicked &&
                            datePickedStart &&
                            datePickedEnd &&
                            peoplePicked &&
                            genderPicked
                        ? Color.fromARGB(255, 255, 84, 5)
                        : Colors.lightBlue,
                    fixedSize: Size(MediaQuery.of(context).size.width * .5,
                        50), // Set the width and height here
                  ),
                  icon: Icon(Icons.travel_explore),
                  label: Text(
                    'Create Trip',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        color: WHITE,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
          title: Text('Search Location'),
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
