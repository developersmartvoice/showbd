import 'dart:convert';
import 'package:appcode3/main.dart';
import 'package:appcode3/views/Doctor/loginAsDoctor.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ChangePasswordPage extends StatefulWidget {
  final String email;

  ChangePasswordPage({required this.email});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  String? newPassword;
  String? confirmNewPassword;

  bool dbPassChanged = false;
  bool passView = true;
  bool passViewConfirm = true;
  bool isLoading = false;

  // changePassword() async {
  //   final response = await get(Uri.parse(
  //       "$SERVER_ADDRESS/api/change_password_email?email=${widget.email}&new_password=$newPassword"));
  //   if (response.statusCode == 200) {
  //     final jsonResponse = jsonDecode(response.body);
  //     if (jsonResponse['status'] == 1) {
  //       setState(() {
  //         dbPassChanged = true;
  //         isLoading = false;
  //       });
  //       print(jsonResponse['message']);
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text("Success"),
  //             content: Text("Password Updated Successfully!"),
  //             actions: [
  //               TextButton(
  //                 onPressed: () {
  //                   Navigator.of(context).popUntil((route) => route.isFirst);
  //                   Navigator.pushReplacement(
  //                     context,
  //                     MaterialPageRoute(builder: (context) => LoginAsDoctor()),
  //                   );
  //                 },
  //                 child: Text("OK"),
  //               )
  //             ],
  //           );
  //         },
  //       );
  //     } else {
  //       print("Error in changing password: ${jsonResponse['error']}");
  //     }
  //   } else {
  //     print("Failed to change the password");
  //   }
  // }

  Future<void> changePassword() async {
    final response = await http.post(
      Uri.parse("$SERVER_ADDRESS/api/change_password_email"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': widget.email,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 1) {
        setState(() {
          dbPassChanged = true;
          isLoading = false;
        });
        print(jsonResponse['message']);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Password Updated Successfully!"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginAsDoctor()),
                    );
                  },
                  child: Text("OK"),
                )
              ],
            );
          },
        );
      } else {
        print("Error in changing password: ${jsonResponse['error']}");
      }
    } else {
      print("Failed to change the password");
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
            backgroundColor: WHITE,
            appBar: AppBar(
              backgroundColor: Colors.white,
              flexibleSpace: header(),
              leading: Container(),
              elevation: 0,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Image.asset(
                      "assets/secure.gif",
                      height: 200,
                      width: 200,
                    ),
                    SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Color.fromARGB(255, 243, 103, 9),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: TextField(
                        controller: _newPasswordController,
                        obscureText: passView,
                        keyboardType: TextInputType.text,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: 10,
                          ),
                          hintText: 'New Password',
                          // hintTextDirection: ,
                          hintStyle: GoogleFonts.poppins(
                            color: Color.fromARGB(255, 243, 103, 9),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passView = !passView;
                              });
                            },
                            icon: Icon(
                              passView
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color.fromARGB(255, 243, 103, 9),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Color.fromARGB(255, 243, 103, 9),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: TextField(
                        controller: _confirmNewPasswordController,
                        obscureText: passViewConfirm,
                        keyboardType: TextInputType.text,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: 10,
                          ),
                          hintText: 'Confirm New Password',
                          // hintTextDirection: ,
                          hintStyle: GoogleFonts.poppins(
                            color: Color.fromARGB(255, 243, 103, 9),
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                passViewConfirm = !passViewConfirm;
                              });
                            },
                            icon: Icon(
                              passViewConfirm
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color.fromARGB(255, 243, 103, 9),
                            ),
                          ),
                        ),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Color.fromARGB(255, 243, 103, 9),
                        ),
                      ),
                    ),
                    // TextField(
                    //   controller: _confirmNewPasswordController,
                    //   obscureText: true,
                    //   decoration: InputDecoration(
                    //     labelText: 'Confirm New Password',
                    //   ),
                    // ),
                    SizedBox(height: 40),
                    // ElevatedButton(
                    //   onPressed: _changePassword,
                    //   child: Text('Change Password'),
                    // ),
                    Container(
                      height: 50,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          isLoading ? dialog() : null;
                          _changePassword();
                        },
                        child: Text(
                          "Change Password",
                          style: TextStyle(
                            color: WHITE,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            // letterSpacing: 2,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 243, 103, 9),
                          ),
                          shape: MaterialStatePropertyAll(
                            BeveledRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              side: BorderSide(
                                  width: 1,
                                  color: WHITE,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                  style: BorderStyle.solid),
                            ),
                          ),
                        ),
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
                "Change Password",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: WHITE, fontSize: 22),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _changePassword() {
    newPassword = _newPasswordController.text;
    confirmNewPassword = _confirmNewPasswordController.text;

    // Check if both passwords match
    if (newPassword != confirmNewPassword) {
      print("Not Matched");
      setState(() {
        isLoading = false;
      });
      _showMessageDialog('error', 'Passwords do not match.');
      return;
    } else {
      // _showMessageDialog('Progressing', 'Please wait for a moment!');
      print("Pass Matched");
      changePassword();
    }
  }

  void _showMessageDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            title == 'error'
                ? TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  )
                : Container(),
          ],
        );
      },
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
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }
}
