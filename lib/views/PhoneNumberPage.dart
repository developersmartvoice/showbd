import 'package:flutter/material.dart';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class PhoneNumberPage extends StatefulWidget {
  // const PhoneNumberPage(String phone, {super.key});

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();

  late final String id;
  late final String phone;

  PhoneNumberPage(this.id, this.phone);
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  late TextEditingController _controller;
  String enteredValue = '';
  bool isValueChanged = false;
  bool loading = false;
  void updatingPhone() async {
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/updatePhoneNo"), body: {
      "id": widget.id,
      "phoneno": enteredValue,
    });
    print("$SERVER_ADDRESS/api/updatePhoneNo");
    // print(response.body);
    if (response.statusCode == 200) {
      print("Phone No. Updated");
      setState(() {
        Navigator.of(context).pop(true);
        loading = false;
      });
    } else {
      print("Phone No. Not Updated");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.phone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Phone',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 243, 103, 9),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                if (isValueChanged && enteredValue.length == 11) {
                  updatingPhone();
                  setState(() {
                    loading = true;
                  });
                } else {
                  _controller.clear();
                }
              },
              child: Text(
                'Save',
                style: GoogleFonts.poppins(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        body: !loading
            ? Container(
                color: LIGHT_GREY_SCREEN_BACKGROUND,
                child: Column(
                  children: [
                    Container(
                      height: 90,
                      //color: Colors.white,
                      child: Stack(children: [
                        Positioned(
                          left:
                              10, // Adjust the position of the button as needed
                          top:
                              20, // Adjust the position of the button as needed
                          child: InkWell(),
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          alignment: Alignment.topLeft,
                          child: Text(
                            PHONE_PAGE,
                            textAlign:
                                TextAlign.justify, // Align text to center
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ]),
                    ),
                    Divider(
                      height: 2,
                      color: Colors.grey,
                    ),
                    Container(
                      color: Colors.white,
                      child: TextField(
                        controller: _controller,
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        onChanged: (value) {
                          setState(() {
                            enteredValue = value;
                            if (enteredValue != widget.phone) {
                              isValueChanged = true;
                            } else {
                              isValueChanged = false;
                            }
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter 11 digits Phone No.",
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Divider(
                      height: 2,
                      color: Colors.grey,
                    ),
                  ],
                ),
              )
            : Container(
                alignment: Alignment.center,
                transformAlignment: Alignment.center,
                child: CircularProgressIndicator(
                    color: const Color.fromARGB(255, 243, 103, 9)),
              ));
  }
}
