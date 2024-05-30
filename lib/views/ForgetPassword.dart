import 'dart:convert';
import 'package:appcode3/main.dart';
import 'package:appcode3/views/VerifyCodePage.dart';
import 'package:connectycube_sdk/connectycube_core.dart';
// import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

import '../en.dart';

class ForgetPassword extends StatefulWidget {
  // String id;
  // ForgetPassword(this.id);

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  String id = "2";
  String email = "";
  final formKey = GlobalKey<FormState>();
  String? animationName;
  String? error;
  bool isEmailCorrect = true;
  bool isLoading = false;
  // String? code;
  bool validateEmail(String email) {
    // Regular expression for email validation
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "assets/moreScreenImages/header_bg.png",
          height: 140,
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
        ),
        SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              flexibleSpace: header(),
              leading: Container(),
              elevation: 0,
            ),
            body: body(),
          ),
        ),
      ],
    );
  }

  body() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40,
            ),
            Image.asset(
              "assets/forget.gif",
              height: 200,
              width: 200,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    ENTER_THE_EMAIL_ADDRESS_ASSOCIATED_WITH_YOUR_ACCOUNT,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 60,
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Color.fromARGB(255, 243, 103, 9),
                  style: BorderStyle.solid,
                ),
              ),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                    left: 10,
                  ),
                  border: InputBorder.none,
                  hintText: ENTER_YOUR_EMAIL,
                  hintStyle: GoogleFonts.poppins(
                    color: Color.fromARGB(255, 243, 103, 9),
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                  errorText: !isEmailCorrect ? ENTER_VALID_EMAIL_ADDRESS : null,
                ),
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Color.fromARGB(255, 243, 103, 9),
                ),
                onChanged: (val) {
                  setState(() {
                    isEmailCorrect = true;
                    email = val;
                  });
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            button()
          ],
        ),
      ),
    );
  }

  Widget header() {
    return Stack(
      children: [
        Image.asset(
          "assets/moreScreenImages/header_bg.png",
          height: 60,
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          height: 60,
          child: Row(
            children: [
              SizedBox(
                width: 15,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(
                  "assets/moreScreenImages/back.png",
                  height: 25,
                  width: 22,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                FORGET_PASSWORD,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: WHITE, fontSize: 22),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget button() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 50,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 20),
        //width: MediaQuery.of(context).size.width,
        child: InkWell(
          onTap: () {
            //print(date);

            // if (formKey.currentState!.validate()) {
            //   formKey.currentState!.save();
            //   sendEmail();
            //   // sendCcReset();
            // }
            setState(() {
              isEmailCorrect = validateEmail(email);
              isLoading = true;
            });
            if (isEmailCorrect) {
              sendEmail();
            }
            isLoading ? dialog() : null;
          },
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  "assets/moreScreenImages/header_bg.png",
                  height: 50,
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Center(
                child: Text(
                  SUBMIT,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, color: WHITE, fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void dialog() {
    showDialog(
        context: context,
        builder: (builder) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.transparent,
              ),
              padding: EdgeInsets.all(16),
              child: Image.asset(
                'assets/loading.gif', // Example image URL
                width: 120,
                height: 120,
              ),
            ),
          );
        });
  }

  sendCcReset() async {
    resetPassword(email).then((voidResult) {}).catchError((error) {});
  }

  sendEmail() async {
    // processingDialog(PLEASE_WAIT_WHILE_PROCESSING);
    final response = await get(Uri.parse(
            "$SERVER_ADDRESS/api/forgotpassword?type=${id}&email=$email"))
        // ignore: body_might_complete_normally_catch_error
        .catchError((e) {
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
      messageDialog(ERROR, e.toString(), 0);
      print("e $e");
    });
    print(response.request);
    print(response.body);
    final jsonResponse = jsonDecode(response.body);
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200 && jsonResponse['success'] == 1) {
      // setState(() {
      //   code = jsonResponse['code'].toString();
      //   print(code);
      // });
      print("if");
      Navigator.pop(context);
      messageDialog(SUCCESSFUL, jsonResponse['msg'], 1);
    } else {
      print("else");
      Navigator.pop(context);
      messageDialog("UNSUCCESSFUL", jsonResponse['msg'], 0);
    }
  }

  processingDialog(message) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(LOADING),
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: const Color.fromARGB(255, 243, 103, 9),
                  strokeWidth: 2,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(color: LIGHT_GREY_TEXT, fontSize: 14),
                  ),
                )
              ],
            ),
          );
        });
  }

  messageDialog(String s1, String s2, int i) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(
              s1,
              style: GoogleFonts.comfortaa(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s2,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                  ),
                )
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  // Navigator.pop(context);
                  if (i == 1 && id == "1") {
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => LoginAsUser()
                    //     )
                    // );
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else if (i == 1 && id == "2") {
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => LoginAsUser()
                    //     )
                    // );
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => VerifyCodePage(
                                  email: email,
                                  // code: code!,
                                )));
                  } else {
                    Navigator.pop(context);
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                // color: Theme.of(context).primaryColor,
                child: Text(
                  OK,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: BLACK,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
