import 'package:appcode3/main.dart';
import 'package:flutter/material.dart';

class UnRegisterFilterPage extends StatefulWidget {
  const UnRegisterFilterPage({super.key});

  @override
  State<UnRegisterFilterPage> createState() => _UnRegisterFilterPageState();
}

class _UnRegisterFilterPageState extends State<UnRegisterFilterPage> {
  int _selectedValue = 1;
  double filterFees = 5000;
  String? city;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: WHITE,
        backgroundColor: Color.fromARGB(255, 243, 103, 9),
        centerTitle: true,
        title: Text(
          "Filter",
          style: TextStyle(
            color: WHITE,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Gender",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Radio<int>(
                        value: 1,
                        groupValue: _selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                        activeColor: Color.fromARGB(255, 243, 103, 9),
                      ),
                      // SizedBox(
                      //   width: 5,
                      // ),
                      Image.asset("assets/fm.png"),
                      SizedBox(
                        width: 10,
                      ),
                      Text("All"),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int>(
                        value: 2,
                        groupValue: _selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                        activeColor: Color.fromARGB(255, 243, 103, 9),
                      ),
                      Image.asset("assets/male-user.png"),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Male"),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<int>(
                        value: 3,
                        groupValue: _selectedValue,
                        onChanged: (int? value) {
                          setState(() {
                            _selectedValue = value!;
                          });
                        },
                        activeColor: Color.fromARGB(255, 243, 103, 9),
                      ),
                      Image.asset("assets/female.png"),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Female"),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Fees",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Slider(
                value: filterFees,
                onChanged: (value) {
                  setState(() {
                    filterFees = value;
                  });
                },
                activeColor: Color.fromARGB(255, 243, 103, 9),
                min: 0,
                max: 5000,
                divisions: 1000,
                label: filterFees.round().toString(),
              ),
              Text(
                "Selected Fees: ${filterFees.round().toString()}",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "City",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // TextField(
              //   // controller: _searchController,
              //   // onChanged: (value) {
              //   //   // Filter the cities based on the entered text
              //   //   setState(() {
              //   //     city = suggestedCities
              //   //         .where((c) =>
              //   //             c.toLowerCase().contains(value.toLowerCase()))
              //   //         ;
              //   //   });
              //   // },
              //   decoration: InputDecoration(
              //     prefixIcon: Icon(Icons.search_sharp),
              //     prefixIconColor: Colors.lightBlue,
              //     hintText: 'Search city...',
              //   ),
              // ),
              DropdownButton<String>(
                hint: Text('Select a value'),
                value: city,
                onChanged: (String? newValue) {
                  setState(() {
                    city = newValue;
                  });
                },
                items: suggestedCities.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
