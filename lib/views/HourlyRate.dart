import 'package:flutter/material.dart';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class HourlyRateSettingsPage extends StatefulWidget {
  //const NameSettingsPage({super.key});

  @override
  State<HourlyRateSettingsPage> createState() => _HourlyRateSettingsPageState();
  late final String id;
  late final String consultationfees;
  //late final String aboutMe;
  //late final String city;

  HourlyRateSettingsPage(this.id, this.consultationfees);
}

class _HourlyRateSettingsPageState extends State<HourlyRateSettingsPage> {
  late TextEditingController _controller;
  String enteredValue = '';
  bool isValueChanged = false;
  void updatingConsultationFees() async {
    final response = await post(
        Uri.parse("$SERVER_ADDRESS/api/updateConsultationFees"),
        body: {
          "id": widget.id,
          "consultation fees": enteredValue,
        });
    print("$SERVER_ADDRESS/api/updateConsultationFees");
    // print(response.body);
    if (response.statusCode == 200) {
      print("Hourly Rate Updated");
      setState(() {
        Navigator.of(context).pop(true);
      });
    } else {
      print("Hourly Rate Not Updated");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.consultationfees);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hourly Rate',
              // style: GoogleFonts.robotoCondensed(
              //   color: Colors.white,
              //   fontSize: 25,
              //   fontWeight: FontWeight.w700,
              // ),
              style: Theme.of(context).textTheme.headline5!.apply(
                  color: Theme.of(context).backgroundColor,
                  fontWeightDelta: 5)),
          backgroundColor: const Color.fromARGB(255, 243, 103, 9),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                if (isValueChanged) {
                  updatingConsultationFees();
                } else {
                  // Navigator.pop(context);
                }
              },
              child: Text(
                'Save',
                style: GoogleFonts.robotoCondensed(
                  color: Colors.black,
                  fontSize: 20,
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
                child: Column(
                  children: [
                    Text(
                      HOURLY_RATE_PAGE,
                      textAlign: TextAlign.justify, // Align text to center
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Text(
                    //   MOTTO_PAGE_2,
                    //   style: TextStyle(
                    //     color: Colors.black,
                    //     fontSize: 12,
                    //     fontWeight: FontWeight.w200,
                    //   ),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                child: TextField(
                  controller: _controller,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w200,
                  ),
                  onChanged: (value) {
                    setState(
                      () {
                        enteredValue = value;
                        if (enteredValue != widget.consultationfees) {
                          isValueChanged = true;
                        } else {
                          isValueChanged = false;
                        }
                      },
                    );
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: widget.consultationfees,
                    hintStyle: TextStyle(color: Colors.black),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
