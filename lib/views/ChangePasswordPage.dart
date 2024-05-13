import 'dart:convert';

import 'package:appcode3/main.dart';
import 'package:appcode3/views/Doctor/loginAsDoctor.dart';
import 'package:connectycube_sdk/connectycube_sdk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

// ignore: must_be_immutable
class ChangePasswordPage extends StatefulWidget {
  String email;

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

  String? ccId;
  String? ccIdint;
  String? ccOldPass;

  bool ccPassChanged = false;
  bool dbPassChanged = false;

  getCcIdandPass() async {
    final response = await get(Uri.parse(
        "$SERVER_ADDRESS/api/get_connectcube_id?email=${widget.email}"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 1) {
        setState(() {
          ccId = jsonResponse['login_id'].toString();
          ccIdint = jsonResponse['connectycube_user_id'].toString();
          ccOldPass = jsonResponse['connectycube_password'].toString();
          print("here is ccId: $ccId and ccOldPass: $ccOldPass");
        });
      }
    } else {
      print("Can't able to get the old password");
    }
  }

  changePassword() async {
    final response = await get(Uri.parse(
        "$SERVER_ADDRESS/api/change_password_email?email=${widget.email}&new_password=$newPassword"));
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 1) {
        setState(() {
          dbPassChanged = true;
        });
        print(jsonResponse['message']);
      } else {
        print("You got error in changing password: ${jsonResponse['error']}");
      }
    }
  }

  updateCcPassword() async {
    createSession().then((cubeSession) {
      CubeUser user = CubeUser(
          login: ccIdint, password: newPassword, oldPassword: ccOldPass);

      updateUser(user).then((updatedUser) {
        setState(() {
          ccPassChanged = true;
        });
        changePassword();
      }).catchError((error) {
        print(
            "ConnectyCube got some errors on password changing for you! $error");
      });
    }).catchError((error) {
      print(
          "ConnectyCube got some errors on creating a session for you! $error");
    });

    // -----------------------
    // CubeUser user =
    //     CubeUser(login: ccId, password: newPassword, oldPassword: ccOldPass);

    // updateUser(user).then((updatedUser) {
    //   setState(() {
    //     ccPassChanged = true;
    //   });
    //   changePassword();
    // }).catchError((error) {
    //   print(
    //       "ConnectyCube got some errors on password changing for you! $error");
    // });
    // ------------------

    // resetPassword(widget.email).then((voidResult) {
    //   print("Mail sent to your email!");
    // }).catchError((error) {
    //   print("ConnectyCube got some errors on reseting! $error");
    // });

    // CubeUser user = CubeUser(login: ccId, password: ccOldPass);

    // createSession(user).then((cubeSession) {
    //   print("What is inside the cubeSession: ${cubeSession}");
    //   print("This is from cubeSession: ${cubeSession.userId}");
    //   CubeUser user =
    //       CubeUser(login: ccId, password: newPassword, oldPassword: ccOldPass);

    //   updateUser(user).then((updatedUser) {
    //     setState(() {
    //       ccPassChanged = true;
    //     });
    //     changePassword();
    //   }).catchError((error) {
    //     print(
    //         "ConnectyCube got some errors on password changing for you! $error");
    //   });
    // }).catchError((error) {
    //   print(
    //       "ConnectyCube got some errors on creating a session for you! $error");
    // });
  }

  @override
  void initState() {
    super.initState();
    getCcIdandPass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _confirmNewPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _changePassword,
                child: Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changePassword() {
    newPassword = _newPasswordController.text;
    confirmNewPassword = _confirmNewPasswordController.text;

    // Check if both passwords match
    if (newPassword != confirmNewPassword) {
      _showMessageDialog('error', 'Passwords do not match.');
      return;
    } else {
      _showMessageDialog('Progessing', 'Please wait for a moment!');
      // changePassword();
      updateCcPassword();
      if (ccPassChanged && dbPassChanged) {
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
                          MaterialPageRoute(
                              builder: (context) => LoginAsDoctor()));
                    },
                    child: Text("OK"),
                  )
                ],
              );
            });
      }
    }

    // Perform the password change logic here
    // For example, call an API to change the password

    // After changing the password, you can navigate to a different screen
    // Navigator.pushReplacementNamed(context, '/home');
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

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }
}
