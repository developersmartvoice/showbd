import 'package:flutter/material.dart';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class NameSettingsPage extends StatefulWidget {
  //const NameSettingsPage({super.key});

  @override
  State<NameSettingsPage> createState() => _NameSettingsPageState();
  late final String id;
  late final String name;

  NameSettingsPage(this.id, this.name);
}

class _NameSettingsPageState extends State<NameSettingsPage> {
  late TextEditingController _controller;
  String enteredValue = '';
  bool isValueChanged = false;
  bool loading = false;
  void updatingName() async {
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/updateName"), body: {
      "id": widget.id,
      "name": enteredValue,
    });
    print("$SERVER_ADDRESS/api/updateName");
    // print(response.body);
    if (response.statusCode == 200) {
      print("Name Updated");
      setState(() {
        loading = false;
      });
      Navigator.of(context).pop(true);
    } else {
      print("Name Not Updated");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Name',
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.headline5!.apply(
                  color: Theme.of(context).backgroundColor,
                  fontWeightDelta: 1,
                  fontSizeFactor: .8),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 243, 103, 9),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                if (isValueChanged) {
                  setState(() {
                    loading = true;
                  });
                  updatingName();
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("You didn't change the name!"),
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
                style: GoogleFonts.poppins(
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
                      child: Text(
                        NAME_PAGE,
                        textAlign: TextAlign.justify, // Align text to center
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.white,
                      child: TextField(
                        controller: _controller,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        onChanged: (value) {
                          setState(
                            () {
                              enteredValue = value;
                              if (enteredValue != widget.name) {
                                isValueChanged = true;
                              } else {
                                isValueChanged = false;
                              }
                            },
                          );
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter Your Name",
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
