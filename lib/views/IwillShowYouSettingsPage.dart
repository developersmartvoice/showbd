import 'package:flutter/material.dart';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class IwillShowYouSettingsPage extends StatefulWidget {
  //const NameSettingsPage({super.key});

  @override
  State<IwillShowYouSettingsPage> createState() =>
      _IwillShowYouSettingsPageState();
  late final String id;
  late final String iwillshowyou;
  //late final String aboutMe;
  //late final String city;

  IwillShowYouSettingsPage(this.id, this.iwillshowyou);
}

class _IwillShowYouSettingsPageState extends State<IwillShowYouSettingsPage> {
  late TextEditingController _controller;
  String enteredValue = '';
  bool isValueChanged = false;
  bool loading = false;
  void updatingIWillShowYou() async {
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/updateIWillShowYou"), body: {
      "id": widget.id,
      "I_will_show_you": enteredValue,
    });
    print("$SERVER_ADDRESS/api/updateIWillShowYou");
    // print(response.body);
    if (response.statusCode == 200) {
      print("IWillShowYou Updated");
      setState(() {
        loading = false;
        Navigator.of(context).pop(true);
      });
    } else {
      print("IWillShowYou Not Updated");
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.iwillshowyou != 'null' ? widget.iwillshowyou : '');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('I will show you',
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
                  updatingIWillShowYou();
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
                        IWILLSHOWYOU_PAGE_1,
                        textAlign: TextAlign.justify, // Align text to center
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          fontWeight: FontWeight.w900,
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
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.025,
                          fontWeight: FontWeight.w200,
                        ),
                        onChanged: (value) {
                          setState(
                            () {
                              enteredValue = value;
                              if (enteredValue != widget.iwillshowyou) {
                                isValueChanged = true;
                              } else {
                                isValueChanged = false;
                              }
                            },
                          );
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Add I will show you",
                          hintStyle: TextStyle(color: Colors.grey),
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
