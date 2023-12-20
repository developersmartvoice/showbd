import 'package:flutter/material.dart';

class CreateTrip extends StatefulWidget {
  const CreateTrip({super.key});

  @override
  State<CreateTrip> createState() => _CreateTripState();
}

class _CreateTripState extends State<CreateTrip> {
  String location = "";
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String numberOfPeople = "Just me";

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
        } else {
          endDate = picked;
        }
      });
    }
  }

  Future<void> _selectNumberOfPeople(BuildContext context) async {
    String result = 'Just me'; // Initialize with a default value

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Trips'),
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Where are you going?',
                    hintText: 'Enter Location',
                  ),
                  onTap: () {
                    // Navigate to the location search page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LocationSearchPage()),
                    ).then((selectedLocation) {
                      if (selectedLocation != null) {
                        setState(() {
                          location = selectedLocation;
                        });
                      }
                    });
                  },
                ),
                SizedBox(height: 16.0),
                InkWell(
                  onTap: () => _selectDate(context, true),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Select a date from',
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
                      labelText: 'Select a date to',
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
                      labelText: 'Number of people',
                    ),
                    child: Text(numberOfPeople),
                  ),
                ),
                SizedBox(height: 16.0),
                // Add the last input field and button here
                // ...

                ElevatedButton(
                  onPressed: () {
                    // Handle the Create Trip button click
                    // You can implement the logic to create the trip here
                  },
                  child: Text('Create Trip'),
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
  // Replace with actual suggestions

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search Location'),
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
        body: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  // Implement the logic to suggest cities based on user input
                  // Update the 'suggestedCities' list accordingly
                },
                decoration: InputDecoration(
                  hintText: 'Search city...',
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: suggestedCities.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(suggestedCities[index]),
                      onTap: () {
                        Navigator.pop(
                            context,
                            suggestedCities[
                                index]); // Return the selected location to the previous page
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
