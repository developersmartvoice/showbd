import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class GenderSettingsPage extends StatefulWidget {
  @override
  State<GenderSettingsPage> createState() => _GenderSettingsPageState();
  late final String id;
  late final String gender;

  GenderSettingsPage(this.id, this.gender);
}

class _GenderSettingsPageState extends State<GenderSettingsPage> {
  String selectedGender = "";
  // String enteredValue = '';
  bool isGenderSelected = false;
  bool isValueChanged = false;
  void updatingGender() async {
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/updateGender"), body: {
      "id": widget.id,
      "gender": selectedGender,
    });
    print("$SERVER_ADDRESS/api/updateGender");
    print(response.body);
    if (response.statusCode == 200) {
      print("Gender Updated");
      setState(() {
        Navigator.of(context).pop(true);
      });
    } else {
      print("Gender Not Updated");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gender',
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
              if (isGenderSelected) {
                updatingGender();
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("You didn't change the anything!"),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("OK"))
                      ],
                    );
                  },
                );
              }
            },
            child: Text(
              'Save',
              style: GoogleFonts.robotoCondensed(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.03,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: LIGHT_GREY_SCREEN_BACKGROUND,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              alignment: Alignment.topLeft,
              child: Text(
                GENDER_PAGE,
                textAlign: TextAlign.justify, // Align text to center
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.width * 0.035,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              color: Colors.white,
              child: DropdownSearch<String>(
                items: [
                  'Male',
                  'Female',
                  'Other',
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!.toLowerCase();
                    if (selectedGender.isNotEmpty) {
                      isGenderSelected = true;
                      // if (selectedGender == 'Male') {}
                    } else {
                      isGenderSelected = false;
                    }
                  });
                },
                selectedItem: isGenderSelected
                    ? selectedGender
                    : widget.gender != 'null'
                        ? widget.gender
                        : "Select your gender",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
