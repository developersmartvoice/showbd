import 'dart:convert';

// import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/views/ChangePasswordPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class VerifyCodePage extends StatefulWidget {
  final String email;

  VerifyCodePage({required this.email});

  @override
  _VerifyCodePageState createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  List<TextEditingController> _controllers =
      []; // List to hold text field controllers
  String? _verificationCode; // Code received via email
  bool _isLoading = false;
  String? id;

  getDoctorIdByEmail() async {
    final response = await get(
        Uri.parse("$SERVER_ADDRESS/api/get_doctor_id?email=${widget.email}"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 1) {
        setState(() {
          id = jsonResponse['doctor_id'].toString();
          print("ID is found!: $id");
          getVerificationCode();
        });
      } else {
        // Handle error if doctor ID not found
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse['error']);
      }
    }
  }

  getVerificationCode() async {
    final response =
        await get(Uri.parse("$SERVER_ADDRESS/api/get_latest_code?user_id=$id"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 1) {
        setState(() {
          _verificationCode = jsonResponse['latest_code'];
          print("Verification code is Found! : $_verificationCode");
        });
      } else {
        // Handle error if verification code not found
        final jsonResponse = jsonDecode(response.body);
        print(jsonResponse['error']);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getDoctorIdByEmail();
    // Initialize text field controllers
    for (int i = 0; i < 6; i++) {
      _controllers.add(TextEditingController());
    }
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
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Please enter the verification code sent to ${widget.email}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        6,
                        (index) => _buildCodeDigitField(index),
                      ),
                    ),
                    SizedBox(height: 40),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     setState(() {
                    //       _isLoading = true;
                    //       _verifyCode();
                    //     });
                    //   },
                    //   child: _isLoading
                    //       ? CircularProgressIndicator()
                    //       : Text('Verify Code'),
                    // ),
                    Container(
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          // if (_formKey.currentState!.validate()) {
                          //   registerUser();
                          // }
                          setState(() {
                            _isLoading = true;
                            _verifyCode();
                          });
                          _isLoading ? dialog() : null;
                        },
                        child: Text(
                          "VERIFY",
                          style: TextStyle(
                            color: WHITE,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                              Color.fromARGB(255, 243, 103, 9),
                            ),
                            shape:
                                MaterialStatePropertyAll(BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              side: BorderSide(
                                  width: 1,
                                  color: WHITE,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  style: BorderStyle.solid),
                            ))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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
                "Verification",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: WHITE, fontSize: 22),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCodeDigitField(int digitIndex) {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: _controllers[digitIndex],
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0),
        decoration: InputDecoration(
          counter: Offstage(),
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.length == 1) {
            // Move focus to the next digit field
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }

  void _verifyCode() {
    String enteredCode =
        _controllers.map((controller) => controller.text).join();
    setState(() {
      _isLoading = false;
    });
    if (enteredCode.length != 6) {
      // Check if the entered code has 6 digits
      _showSnackBar('Please enter a 6-digit code.');
      return;
    } else if (enteredCode != _verificationCode) {
      _showSnackBar('Invalid verification code.');
      return;
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChangePasswordPage(
                    email: widget.email,
                  )));
    }

    // Perform actions after code verification, e.g., navigate to next screen
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
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

  @override
  void dispose() {
    // Dispose text field controllers
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
