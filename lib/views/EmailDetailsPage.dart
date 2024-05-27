import 'package:flutter/material.dart';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class EmailDetailsPage extends StatefulWidget {
  //const EmailDetailsPage({super.key});

  @override
  State<EmailDetailsPage> createState() => _EmailDetailsPageState();
  late final String id;
  late final String email;
  EmailDetailsPage(this.id, this.email);
}

class _EmailDetailsPageState extends State<EmailDetailsPage> {
  late TextEditingController _controller;
  String enteredValue = '';
  bool isValueChanged = false;
  bool loading = false;
  void updatingEmail() async {
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/updateEmail"), body: {
      "id": widget.id,
      "email": enteredValue,
    });
    print("$SERVER_ADDRESS/api/updateEmail");
    // print(response.body);
    if (response.statusCode == 200) {
      print("Email Updated");
      setState(() {
        Navigator.of(context).pop(true);
        loading = false;
      });
    } else {
      print("Email Not Updated");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Email',
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
                if (isValueChanged) {
                  updatingEmail();
                  setState(() {
                    loading = true;
                  });
                } else {}
              },
              child: Text(
                'Save',
                style: GoogleFonts.poppins(
                  color: Colors.black,
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
                      height: 100,
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
                          height: 100,
                          padding: EdgeInsets.all(2),
                          alignment: Alignment.center,
                          child: Text(
                            EMAIL_PAGE,
                            textAlign:
                                TextAlign.justify, // Align text to center
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 14,
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
                          fontWeight: FontWeight.w500,
                        ),
                        onChanged: (value) {
                          setState(() {
                            enteredValue = value;
                            if (enteredValue != widget.email) {
                              isValueChanged = true;
                            } else {
                              isValueChanged = false;
                            }
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: widget.email,
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
                  color: const Color.fromARGB(255, 243, 103, 9),
                ),
              ));
  }
}
