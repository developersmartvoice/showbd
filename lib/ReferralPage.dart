import 'dart:convert';

import 'package:appcode3/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:share_plus/share_plus.dart';

class ReferralPage extends StatefulWidget {
  final String userId;

  ReferralPage({required this.userId});

  @override
  _ReferralPageState createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  String shareLink =
      "https://play.google.com/store/apps/details?id=smart.lab.meetlocal";
  String? referralCode;
  String? shareMessage;

  fetchReferralCode() async {
    final response = await get(Uri.parse(
        "$SERVER_ADDRESS/api/get_ref_code?doctor_id=${widget.userId}"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        referralCode = jsonResponse["referral_code"]?.toString() ?? "";
      });
      if (referralCode!.isEmpty) {
        generateAndStore();
      }
    }
  }

  generateAndStore() async {
    final response = await get(Uri.parse(
        "$SERVER_ADDRESS/api/generate_store_ref?doctor_id=${widget.userId}"));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        referralCode = jsonResponse["referral_code"]?.toString();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // generateAndStore();
    fetchReferralCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: WHITE,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 243, 103, 9),
          title: Text(
            'Referral Code',
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.headline5!.apply(
                  color: Theme.of(context).backgroundColor,
                  fontWeightDelta: 1,
                  fontSizeFactor: .8),
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: WHITE,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ),
        body: referralCode != null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      // width: 400,
                      // height: 300,
                      child: Image.asset(
                        "assets/referral_new.gif",
                        // fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller:
                                TextEditingController(text: referralCode),
                            style: TextStyle(
                              letterSpacing: 3,
                              fontSize: 20,
                            ),
                            autofocus: true,
                            textAlign: TextAlign.center,
                            readOnly: true,
                            decoration: InputDecoration(
                              // labelText: 'Your Referral Code',
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 243, 103, 9),
                                ),
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.share,
                            color: Color.fromARGB(255, 243, 103, 9),
                          ),
                          onPressed: () {
                            setState(() {
                              shareMessage =
                                  "Check out this app! Download it using the link below\n$shareLink\nand don't forget to insert referral code when registering\nReferral Code: $referralCode";
                            });
                            Share.share(shareMessage!);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Center(child: SingleChildScrollView()));
  }
}
