import 'package:flutter/material.dart';
import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class PhoneNumberPage extends StatefulWidget {
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
            fontSize: 20,
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
                    height: 120,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 10,
                          top: 20,
                          child: InkWell(),
                        ),
                        Expanded(
                          child: Container(
                            height: 120, // Increased the height from 160 to 200
                            padding: EdgeInsets.all(5),
                            alignment: Alignment.topLeft,
                            child: Text(
                              PHONE_PAGE,
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Adding space before Divider and TextField
                  // SizedBox(height: 40),
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
          : Center(
              child: CircularProgressIndicator(
                  color: const Color.fromARGB(255, 243, 103, 9)),
            ),
    );
  }
}
