import 'package:flutter/material.dart';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class MottoSettingsPage extends StatefulWidget {
  //const NameSettingsPage({super.key});

  @override
  State<MottoSettingsPage> createState() => _MottoSettingsPageState();
  late final String id;
  late final String motto;
  //late final String aboutMe;
  //late final String city;

  MottoSettingsPage(this.id, this.motto);
}

class _MottoSettingsPageState extends State<MottoSettingsPage> {
  late TextEditingController _controller;
  String enteredValue = '';
  bool isValueChanged = false;
  bool loading = false;
  void updatingMotto() async {
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/updateMotto"), body: {
      "id": widget.id,
      "motto": enteredValue,
    });
    print("$SERVER_ADDRESS/api/updateMotto");
    // print(response.body);
    if (response.statusCode == 200) {
      print("Motto Updated");
      setState(() {
        loading = false;
        Navigator.of(context).pop(true);
      });
    } else {
      print("Motto Not Updated");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.motto);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Motto',
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
                  setState(() {
                    loading = true;
                  });
                  updatingMotto();
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
                  fontSize: 20,
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
                child: CircularProgressIndicator(),
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
                            MOTTO_PAGE_1,
                            textAlign:
                                TextAlign.justify, // Align text to center
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            MOTTO_PAGE_2,
                            textAlign:
                                TextAlign.justify, // Align text to center
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
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
                              if (enteredValue != widget.motto) {
                                isValueChanged = true;
                              } else {
                                isValueChanged = false;
                              }
                            },
                          );
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Add Your Motto",
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
