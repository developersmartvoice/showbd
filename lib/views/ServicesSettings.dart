import 'package:flutter/material.dart';

import 'package:appcode3/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class ServicesSettingsPage extends StatefulWidget {
  //const NameSettingsPage({super.key});
  final String id;
  final List<String> services;

  ServicesSettingsPage(this.id, this.services);

  @override
  State<ServicesSettingsPage> createState() => _ServicesSettingsPageState();
}

class _ServicesSettingsPageState extends State<ServicesSettingsPage> {
  List<String> selectedServices = [];
  bool isValueChanged = false;
  bool isServiceSelected = false;
  // bool isActivitiesSelected = false;
  List<String> selectedLanguages = [];
  bool loading = false;
  bool isChecked = false;
  //late SharedPreferences prefs;
  String selectedService = "";

  // Define your service map
  Map<String, String> serviceMap = {
    "translation": "Translation & Interpretation",
    "shopping": "Shopping",
    "food": "Food & Restaurants",
    "art": "Art & Museums",
    "history": "History & Culture",
    "exploration": "Exploration & Sightseeing",
    "pick": "Pick up & Driving Tours",
    "nightlife": "Nightlife & Bars",
    "sports": "Sports & Recreation"
  };

  @override
  void initState() {
    super.initState();
    // Initialize selected services based on backend values
    selectedServices.addAll(widget.services);
    isServiceSelected = selectedServices.isNotEmpty;
  }

  String enteredValue = '';
  void updatingServices() async {
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/updateServices"), body: {
      "id": widget.id,
      "services": selectedServices.join(','),
    });
    print("$SERVER_ADDRESS/api/updateServices");
    if (response.statusCode == 200) {
      print("Services Updated");
      setState(() {
        loading = false;
      });
      Navigator.of(context).pop(true);
    } else {
      print("Services Not Updated");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Activities',
          style: GoogleFonts.poppins(
            textStyle: Theme.of(context).textTheme.headlineSmall!.apply(
                // color: Theme.of(context).primaryColorDark,
                color: WHITE,
                fontWeightDelta: 1,
                fontSizeFactor: .8),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 243, 103, 9),
        foregroundColor: WHITE,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              print("Checking isServiceSelected: $isServiceSelected");
              if (isServiceSelected) {
                print(selectedServices);
                setState(() {
                  loading = true;
                });
                updatingServices();
              } else {
                // Navigator.pop(context);
              }
            },
            child: Text(
              'Save',
              style: GoogleFonts.robotoCondensed(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.03,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: loading
          ? Container(
              alignment: Alignment.center,
              transformAlignment: Alignment.center,
              child: CircularProgressIndicator(
                color: const Color.fromARGB(255, 243, 103, 9),
              ),
            )
          : Container(
              padding: EdgeInsets.all(10),
              child: ListView(
                children: serviceMap.keys.map((key) {
                  bool isSelected = selectedServices.contains(key);
                  IconData iconData;
                  switch (key) {
                    case 'translation':
                      iconData = Icons.translate;
                      break;
                    case 'shopping':
                      iconData = Icons.shopping_bag_outlined;
                      break;
                    case 'food':
                      iconData = Icons.restaurant;
                      break;
                    case 'art':
                      iconData = Icons.museum_outlined;
                      break;
                    case 'history':
                      iconData = Icons.music_video;
                      break;
                    case 'exploration':
                      iconData = Icons.explore_outlined;
                      break;
                    case 'pick':
                      iconData = Icons.drive_eta_outlined;
                      break;
                    case 'nightlife':
                      iconData = Icons.local_bar_outlined;
                      break;
                    case 'sports':
                      iconData = Icons.sports_kabaddi_outlined;
                      break;
                    default:
                      iconData =
                          Icons.error_outline; // Default icon if key not found
                  }

                  return ListTile(
                    dense: true,
                    leading: Icon(
                      iconData,
                      color:
                          isSelected ? Color.fromARGB(255, 243, 103, 9) : null,
                    ),
                    title: Text(
                      serviceMap[key]!,
                      style: TextStyle(
                        color: isSelected
                            ? Color.fromARGB(255, 243, 103, 9)
                            : null,
                      ),
                    ),
                    selected: isSelected,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedServices.remove(key);
                          print("Checking selectedServices: $selectedServices");
                        } else {
                          selectedServices.add(key);
                          print("Checking selectedServices: $selectedServices");
                        }
                        isServiceSelected = selectedServices.isNotEmpty;
                      });
                    },
                    trailing: isSelected
                        ? Icon(
                            Icons.check,
                            color: Color.fromARGB(255, 243, 103, 9),
                          )
                        : null,
                  );
                }).toList(),
              ),
            ),
    );
  }
}
