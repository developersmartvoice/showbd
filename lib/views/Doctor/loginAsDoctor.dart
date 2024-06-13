import 'dart:convert';

import 'package:appcode3/en.dart';
import 'package:appcode3/main.dart';
import 'package:appcode3/views/Doctor/DoctorTabScreen.dart';
// import 'package:connectycube_sdk/connectycube_chat.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import '../../VideoCall/utils/pref_util.dart';
import '../ForgetPassword.dart';
import 'RegisterAsDoctor.dart';

class LoginAsDoctor extends StatefulWidget {
  @override
  _LoginAsDoctorState createState() => _LoginAsDoctorState();
}

class _LoginAsDoctorState extends State<LoginAsDoctor>
    with SingleTickerProviderStateMixin {
  String emailAddress = "";
  String pass = "";
  bool isPhoneNumberError = false;
  bool isPasswordError = false;
  String passErrorText = "";
  String token = "";
  bool isTokenPresent = false;
  bool passView = true;

  AnimationController? _controller;
  Animation<double>? _animation;

  // getToken() async {
  //   await SharedPreferences.getInstance().then((pref) async {
  //     if (pref.getBool("isTokenExist") ?? false) {
  //       String? tokenLocal = await FirebaseMessaging.instance.getToken();
  //       setState(() {
  //         print("1-> token retrieved");
  //         token = tokenLocal!;
  //         print("Is token created?: $token");
  //       });
  //     }
  //   });
  // }

  // storeToken() async {
  //   setState(() {
  //     print("Stored token is called this mean no token fetched!");
  //   });
  //   dialog();
  //   await FirebaseMessaging.instance.getToken().then((value) async {
  //     //Toast.show(value, context, duration: 2);
  //     print("This is value from FirebaseMessaging instance!: $value");
  //     setState(() {
  //       token = value!;
  //       print("Seeing the token which is same as value: $token");
  //     });

  //     final response =
  //         await post(Uri.parse("$SERVER_ADDRESS/api/savetoken"), body: {
  //       "token": token,
  //       "type": "1",
  //       // ignore: body_might_complete_normally_catch_error
  //     }).catchError((e) {
  //       Navigator.pop(context);
  //       messageDialog(ERROR, UNABLE_TO_SAVE_TOKEN_TO_SERVER);
  //     });
  //     print('return code');
  //     print(response.statusCode);
  //     if (response.statusCode == 200) {
  //       Navigator.pop(context);
  //       final jsonResponse = jsonDecode(response.body);
  //       print('toek body response ${response.body}');
  //       if (jsonResponse['success'].toString() == "1") {
  //         SharedPreferences.getInstance().then((pref) {
  //           pref.setBool("isTokenExist", true);
  //           print("token stored");
  //         });
  //         //Navigator.pop(context);
  //         loginInto();
  //       }
  //     } else {
  //       print('token response status code -> ${response.statusCode}');
  //       print('token response body -> ${response.body}');
  //       Navigator.pop(context);
  //       print("token not stored");
  //       messageDialog(ERROR, response.body.toString());
  //       // Navigator.pushReplacement(context,
  //       //     MaterialPageRoute(builder: (context) => TabsScreen())
  //       // );
  //     }
  //   }).catchError((e) {
  //     Navigator.pop(context);
  //     print("token not accessed");
  //     messageDialog(ERROR, UNABLE_TO_SAVE_TOKEN_TO_SERVER);
  //   });
  //   setState(() {
  //     token = "";
  //   });
  // }

  // loginInto() async {
  //   setState(() {
  //     print("LoginInto is called that means no need to store any token!");
  //   });
  //   if (EmailValidator.validate(emailAddress) == false) {
  //     setState(() {
  //       isPhoneNumberError = true;
  //     });
  //   } else {
  //     dialog();
  //     //Toast.show("Logging in..", context, duration: 2);
  //     String url =
  //         "$SERVER_ADDRESS/api/doctorlogin?email=$emailAddress&password=$pass&token=$token";
  //     var response = await post(Uri.parse(url), body: {
  //       'email': emailAddress,
  //       'password': pass,
  //       'token': token,
  //       // ignore: body_might_complete_normally_catch_error
  //     }).catchError((e) {
  //       Navigator.pop(context);
  //       messageDialog(ERROR, UNABLE_TO_LOAD_DATA_FORM_SERVER);
  //     });
  //     try {
  //       print(response.statusCode);
  //       print(response.body);
  //       print('print response success');

  //       var jsonResponse = await jsonDecode(response.body);
  //       if (jsonResponse['success'].toString() == "0") {
  //         setState(() {
  //           Navigator.pop(context);
  //           isPasswordError = true;
  //           passErrorText = EITHER_MOBILE_NUMBER_OR_PASSWORD_IS_INCORRECT;
  //         });
  //       } else {
  //         print('success coming else');
  //         String? token = await firebaseMessaging.getToken();
  //         FirebaseDatabase.instance
  //             .ref()
  //             .child('100' + jsonResponse['register']['doctor_id'].toString())
  //             .update({
  //           "name": jsonResponse['register']['name'],
  //           "image": jsonResponse['register']['image'],
  //         }).then((value) async {
  //           FirebaseDatabase.instance
  //               .ref()
  //               .child("100" + jsonResponse['register']['doctor_id'].toString())
  //               .child("TokenList")
  //               .set({
  //             "device": token.toString(),
  //           }).then((value) async {
  //             print('then call');
  //             await SharedPreferences.getInstance().then((pref) {
  //               pref.setBool("isLoggedInAsDoctor", true);
  //               pref.setString(
  //                   "userId", jsonResponse['register']['doctor_id'].toString());
  //               pref.setString("name", jsonResponse['register']['name']);
  //               pref.setString(
  //                   "phone",
  //                   jsonResponse['register']['phone'] == null
  //                       ? ""
  //                       : jsonResponse['register']['phone'].toString());
  //               pref.setString("email", jsonResponse['register']['email']);
  //               pref.setString("token", token.toString());
  //               pref.setString(
  //                   "myCCID",
  //                   jsonResponse['register']['connectycube_user_id']
  //                       .toString());
  //               pref.setString("userIdWithAscii",
  //                   '100' + jsonResponse['register']['doctor_id'].toString());
  //             });
  //             Navigator.of(context).popUntil((route) => route.isFirst);
  //             Navigator.pushReplacement(context,
  //                 MaterialPageRoute(builder: (context) => DoctorTabsScreen()));

  //             CubeUser user = CubeUser(
  //               id: int.tryParse(
  //                   jsonResponse['register']['connectycube_user_id']),
  //               login: jsonResponse['register']['login_id'],
  //               fullName: jsonResponse['register']['name']
  //                   .toString()
  //                   .replaceAll(" ", ""),
  //               password: pass,
  //             );
  //             _loginToCC(context, user);
  //           }).catchError((onError) {
  //             print('firebasse db error $onError');
  //           });
  //         }).catchError((onError) {
  //           print('firebasse db error $onError');
  //         });
  //       }
  //       // setState(() {
  //       //   Navigator.push(context,
  //       //       MaterialPageRoute(builder: (context) => DoctorTabsScreen()));
  //       // });
  //     } catch (e) {
  //       Navigator.pop(context);
  //       messageDialog(ERROR, UNABLE_TO_LOAD_DATA_FORM_SERVER);
  //     }
  //   }
  // }

  getToken() async {
    await SharedPreferences.getInstance().then((pref) async {
      if (pref.getBool("isTokenExist") ?? false) {
        String? tokenLocal = await FirebaseMessaging.instance.getToken();
        setState(() {
          print("1-> token retrieved");
          token = tokenLocal!;
          print("Is token created?: $token");
        });
      }
    });
  }

  storeToken() async {
    setState(() {
      print("Stored token is called this mean no token fetched!");
    });
    dialog();
    await FirebaseMessaging.instance.getToken().then((value) async {
      //Toast.show(value, context, duration: 2);
      print("This is value from FirebaseMessaging instance!: $value");
      setState(() {
        token = value!;
        print("Seeing the token which is same as value: $token");
      });

      final response =
          await post(Uri.parse("$SERVER_ADDRESS/api/savetoken"), body: {
        "token": token,
        "type": "1",
        // ignore: body_might_complete_normally_catch_error
      }).catchError((e) {
        Navigator.pop(context);
        messageDialog(ERROR, UNABLE_TO_SAVE_TOKEN_TO_SERVER);
      });
      print('return code');
      print(response.statusCode);
      if (response.statusCode == 200) {
        Navigator.pop(context);
        final jsonResponse = jsonDecode(response.body);
        print('token body response ${response.body}');
        if (jsonResponse['success'].toString() == "1") {
          SharedPreferences.getInstance().then((pref) {
            pref.setBool("isTokenExist", true);
            print("token stored");
          });
          // Navigator.pop(context);
          loginInto();
        }
      } else {
        print('token response status code -> ${response.statusCode}');
        print('token response body -> ${response.body}');
        Navigator.pop(context);
        print("token not stored");
        messageDialog(ERROR, response.body.toString());
      }
    }).catchError((e) {
      Navigator.pop(context);
      print("token not accessed");
      messageDialog(ERROR, UNABLE_TO_SAVE_TOKEN_TO_SERVER);
    });
    setState(() {
      token = "";
    });
  }

  loginInto() async {
    setState(() {
      print("loginInto is called that means no need to store any token!");
    });
    if (EmailValidator.validate(emailAddress) == false) {
      setState(() {
        isPhoneNumberError = true;
      });
    } else {
      dialog();
      //Toast.show("Logging in..", context, duration: 2);
      String url =
          "$SERVER_ADDRESS/api/doctorlogin?email=$emailAddress&password=$pass&token=$token";
      var response = await post(Uri.parse(url), body: {
        'email': emailAddress,
        'password': pass,
        'token': token,
        // ignore: body_might_complete_normally_catch_error
      }).catchError((e) {
        Navigator.pop(context);
        messageDialog(ERROR, UNABLE_TO_LOAD_DATA_FORM_SERVER);
      });
      try {
        print(response.statusCode);
        print(response.body);
        print('print response success');

        var jsonResponse = await jsonDecode(response.body);
        if (jsonResponse['success'].toString() == "0") {
          setState(() {
            Navigator.pop(context);
            isPasswordError = true;
            passErrorText = EITHER_MOBILE_NUMBER_OR_PASSWORD_IS_INCORRECT;
          });
        } else {
          print('success coming else');
          String? token = await firebaseMessaging.getToken();
          FirebaseDatabase.instance
              .ref()
              .child('100' + jsonResponse['register']['doctor_id'].toString())
              .update({
            "name": jsonResponse['register']['name'],
            "image": jsonResponse['register']['image'],
          }).then((value) async {
            FirebaseDatabase.instance
                .ref()
                .child("100" + jsonResponse['register']['doctor_id'].toString())
                .child("TokenList")
                .set({
              "device": token.toString(),
            }).then((value) async {
              print('then call');
              await SharedPreferences.getInstance().then((pref) {
                pref.setBool("isLoggedInAsDoctor", true);
                pref.setString(
                    "userId", jsonResponse['register']['doctor_id'].toString());
                pref.setString("name", jsonResponse['register']['name']);
                pref.setString(
                    "phone",
                    jsonResponse['register']['phone'] == null
                        ? ""
                        : jsonResponse['register']['phone'].toString());
                pref.setString("email", jsonResponse['register']['email']);
                pref.setString("token", token.toString());
                pref.setString("userIdWithAscii",
                    '100' + jsonResponse['register']['doctor_id'].toString());
              });
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => DoctorTabsScreen()));
            }).catchError((onError) {
              print('firebase db error $onError');
            });
          }).catchError((onError) {
            print('firebase db error $onError');
          });
        }
      } catch (e) {
        Navigator.pop(context);
        messageDialog(ERROR, UNABLE_TO_LOAD_DATA_FORM_SERVER);
      }
    }
  }

  // login cc
  // _loginToCC(BuildContext context, CubeUser user) {
  //   if (CubeSessionManager.instance.isActiveSessionValid() &&
  //       CubeSessionManager.instance.activeSession!.user != null) {
  //     if (CubeChatConnection.instance.isAuthenticated()) {
  //       SharedPrefs.getUser().then((value) async {
  //         try {
  //           if (value!.id != null) {
  //             Navigator.of(context).popUntil((route) => route.isFirst);
  //             Navigator.pushReplacement(context,
  //                 MaterialPageRoute(builder: (context) => DoctorTabsScreen()));
  //           }
  //         } catch (e) {
  //           await deleteSession();
  //           Navigator.pop(context);
  //           messageDialog(ERROR, PLEASE_TRY_AGAIN);
  //         }
  //       });
  //     } else {
  //       _loginToCubeChat(context, user);
  //     }
  //   } else {
  //     createSession(user).then((cubeSession) {
  //       _loginToCubeChat(context, user);
  //     }).catchError((exception) {
  //       print(exception);
  //       messageDialog(ERROR, PLEASE_TRY_AGAIN);
  //     });
  //   }
  // }

  // void _loginToCubeChat(BuildContext context, CubeUser user) {
  //   CubeChatConnection.instance.login(user).then((cubeUser) {
  //     SharedPrefs.saveNewUser(user);
  //     SharedPrefs.getUser().then((value) {
  //       if (value!.id != null) {
  //         Navigator.of(context).popUntil((route) => route.isFirst);
  //         Navigator.pushReplacement(context,
  //             MaterialPageRoute(builder: (context) => DoctorTabsScreen()));
  //       }
  //     });

  //     // _goSelectOpponentsScreen(context, cubeUser);
  //   }).catchError((exception) {
  //     print(exception);
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    SharedPreferences.getInstance().then((pref) {
      setState(() {
        isTokenPresent = pref.getBool("isTokenExist") ?? false;
        print("See what this printing true or false? $isTokenPresent");
      });
    });
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();

    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    );

    // _controller!.forward();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
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
            body: SingleChildScrollView(
              child: loginForm(),
            ),
          ),
        )
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
              Center(
                child: Text(
                  GUIDE_LOGIN,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: WHITE,
                      fontSize: MediaQuery.of(context).size.width * 0.05),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget bottom() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DO_NOT_HAVE_AN_ACCOUNT,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width *
                    0.02, // Adjust font size dynamically
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterAsDoctor()),
                );
              },
              child: Text(
                " $REGISTER_NOW",
                style: GoogleFonts.poppins(
                  // color: AMBER,
                  color: Color.fromARGB(255, 243, 103, 9),
                  fontSize: MediaQuery.of(context).size.width *
                      0.03, // Adjust font size dynamically
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget loginForm() {
    return Container(
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: WHITE,
      ),
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 100, 20, 0),
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _animation!,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation!.value,
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      50 * (1 - _animation!.value),
                    ),
                    child: Image.asset(
                      "assets/login_new.png",
                      height: 180,
                      width: 180,
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            AnimatedBuilder(
              animation: _animation!,
              builder: (context, child) {
                return Opacity(
                  opacity: _animation!.value,
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      50 * (1 - _animation!.value),
                    ),
                    child: Text(
                      "Login to connect with locals!",
                      softWrap: true,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 243, 103, 9),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 50),
            Container(
              width: MediaQuery.of(context).size.width - 30,
              height: 60,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          width: 3,
                          color: Color.fromARGB(255, 243, 103, 9),
                        ),
                      ),
                    ),
                    width: 80,
                    child: Image.asset(
                      "assets/email.png",
                      height: 30,
                      width: 30,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 130,
                    padding: EdgeInsets.only(left: 8),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: ENTER_YOUR_EMAIL,
                        hintStyle: GoogleFonts.poppins(
                          color: Color.fromARGB(255, 243, 103, 9),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                        errorText: isPhoneNumberError
                            ? ENTER_VALID_EMAIL_ADDRESS
                            : null,
                      ),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 243, 103, 9),
                        fontSize: 12,
                      ),
                      onChanged: (val) {
                        setState(() {
                          emailAddress = val;
                          isPhoneNumberError = false;
                          isPasswordError = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              // decoration: BoxDecoration(
              //   border: Border.all(
              //     width: 2,
              //     color: Color.fromARGB(255, 243, 103, 9),
              //     style: BorderStyle.solid,
              //   ),
              // ),
              width: MediaQuery.of(context).size.width - 30,
              height: 60,
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          width: 3,
                          color: Color.fromARGB(255, 243, 103, 9),
                        ),
                      ),
                    ),
                    width: 80,
                    child: Image.asset(
                      "assets/key.png",
                      height: 30,
                      width: 30,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 130,
                    padding: EdgeInsets.only(left: 8),
                    child: TextField(
                      obscureText: passView,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: PASSWORD_STR,
                        hintStyle: GoogleFonts.poppins(
                          color: Color.fromARGB(255, 243, 103, 9),
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),

                        errorText: isPasswordError ? passErrorText : null,
                        // errorStyle: TextStyle(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              passView = !passView;
                            });
                          },
                          icon: Icon(
                            passView ? Icons.visibility : Icons.visibility_off,
                            color: Color.fromARGB(255, 243, 103, 9),
                          ),
                        ),
                      ),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Color.fromARGB(255, 243, 103, 9),
                      ),
                      onChanged: (val) {
                        setState(() {
                          pass = val;
                          isPasswordError = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgetPassword()),
                    );
                  },
                  child: Text(
                    FORGET_PASSWORD,
                    style: TextStyle(
                        color: BLACK,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              height: 100,
              child: InkWell(
                onTap: () {
                  isTokenPresent ? loginInto() : storeToken();
                },
                child: Image.asset("assets/login.png"),
              ),
            ),
            SizedBox(height: 20),
            bottom(),
          ],
        ),
      ),
    );
  }

  dialog() {
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
      },
    );
  }

  messageDialog(String s1, String s2) {
    Navigator.pop(context);
    return showDialog(
      context: context,
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
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).hintColor,
              ),
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
      },
    );
  }
}
