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
  String? postValue;
  bool isValueChanged = false;
  bool loading = false;
  bool correctValue = true;
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
        loading = false;
        Navigator.of(context).pop(true);
      });
    } else {
      print("Hourly Rate Not Updated");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.consultationfees != '0' ? widget.consultationfees : "0");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hourly Rate',
          // style: GoogleFonts.robotoCondensed(
          //   color: Colors.white,
          //   fontSize: 25,
          //   fontWeight: FontWeight.w700,
          // ),
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
              if (isValueChanged) {
                if (correctValue) {
                  setState(() {
                    loading = true;
                  });
                  updatingConsultationFees();
                }
              } else {
                // Navigator.pop(context);
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
      body: loading
          ? Container(
              alignment: Alignment.center,
              transformAlignment: Alignment.center,
              child: CircularProgressIndicator(
                color: const Color.fromARGB(255, 243, 103, 9),
              ),
            )
          : Container(
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
                            fontSize: MediaQuery.of(context).size.width * 0.025,
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
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width * 0.025,
                        fontWeight: FontWeight.w200,
                      ),
                      onChanged: (value) {
                        setState(
                          () {
                            enteredValue = value;
                            if (enteredValue != widget.consultationfees) {
                              isValueChanged = true;
                              if (double.parse(enteredValue) <= 5000) {
                                correctValue = true;
                                postValue = enteredValue;
                              } else {
                                correctValue = false;
                              }
                            } else {
                              isValueChanged = false;
                            }
                          },
                        );
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Add your hourly fees",
                        hintStyle: TextStyle(color: Colors.grey),
                        errorText: correctValue
                            ? null
                            : "Fees can't be greater than 5000৳",
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
