import 'dart:convert';

import 'package:appcode3/main.dart';
import 'package:appcode3/views/ChangePasswordPage.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Code'),
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
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _verifyCode();
                  });
                },
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Verify Code'),
              ),
            ],
          ),
        ),
      ),
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

  @override
  void dispose() {
    // Dispose text field controllers
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
