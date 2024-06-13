// import 'dart:async';
// import 'dart:convert';

// import 'package:appcode3/main.dart';
// import 'package:appcode3/views/Doctor/DoctorTabScreen.dart';
// // import 'package:appcode3/views/Doctor/loginAsDoctor.dart';
// import 'package:appcode3/views/UnRegisteredHomePage.dart';
// import 'package:connectycube_sdk/connectycube_chat.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../VideoCall/utils/pref_util.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   bool isTokenAvailable = false;
//   String? token;
//   // FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

//   getToken() async {
//     SharedPreferences.getInstance().then((pref) {
//       getCC();
//       if (pref.getBool("isTokenExist") ?? false) {
//         Timer(Duration(seconds: 2), () {
//           if (pref.getBool("isLoggedInAsDoctor") ?? false) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => DoctorTabsScreen()),
//             );
//           }
//           // else if(pref.getBool("isLoggedIn") ?? false) {
//           //   Navigator.pushReplacement(context,
//           //       MaterialPageRoute(builder: (context) => TabsScreen())
//           //   );
//           // }
//           else {
//             Navigator.pushReplacement(
//               context,
//               // MaterialPageRoute(builder: (context) => LoginAsDoctor()),
//               MaterialPageRoute(builder: (context) => UnRegisteredHomePage()),
//             );
//           }
//         });
//       } else {
//         print("value is null");
//         Timer(Duration(seconds: 2), () {
//           Navigator.pushReplacement(
//             context,
//             // MaterialPageRoute(builder: (context) => LoginAsDoctor()),
//             MaterialPageRoute(builder: (context) => UnRegisteredHomePage()),
//           );
//         });
//       }
//     });
//   }

//   getCC() {
//     SharedPrefs.getUser().then((value) {
//       if (value != null) {
//         print('${value.fullName}');
//         print('${value.login}');
//         print('${value.password}');
//         print('${value.id}');
//         if (value.id != null) {
//           _loginToCC(context, value);
//         }
//       } else {
//         print("Value is null");
//       }
//     });
//   }

//   _loginToCC(BuildContext context, CubeUser user) async {
//     if (CubeSessionManager.instance.isActiveSessionValid() &&
//         CubeSessionManager.instance.activeSession!.user != null) {
//       if (CubeChatConnection.instance.isAuthenticated()) {
//         print('---------> go to opponents screen');
//       } else {
//         print('---------> something wrong open login cube cc');
//         _loginToCubeChat(context, user);
//       }
//     } else {
//       createSession(user).then((cubeSession) {
//         print('---------> create session create suceessfully');
//         _loginToCubeChat(context, user);
//       }).catchError((exception) {
//         print(exception);
//         // _processLoginError(exception);
//       });
//     }
//   }

//   void _loginToCubeChat(BuildContext context, CubeUser user) {
//     CubeChatConnection.instance.login(user).then((cubeUser) async {
//       SharedPrefs.saveNewUser(user);
//       print('----------> go to opponents screen');
//     }).catchError((exception) {
//       print(exception);
//       // _processLoginError(exception);
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getToken();
//   }

//   storeToken() async {
//     final response =
//         await post(Uri.parse("$SERVER_ADDRESS/api/savetoken"), body: {
//       "token": token,
//       "type": "1",
//       // ignore: body_might_complete_normally_catch_error
//     }).catchError((e) {
//       Timer(Duration(seconds: 2), () {
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => TabsScreen()));
//       });
//     });
//     if (response.statusCode == 200) {
//       final jsonResponse = jsonDecode(response.body);
//       if (jsonResponse['success'] == "1") {
//         Timer(Duration(seconds: 2), () {
//           SharedPreferences.getInstance().then((pref) {
//             pref.setBool("isTokenExist", true);
//             print("token stored");
//             Navigator.pushReplacement(
//                 context, MaterialPageRoute(builder: (context) => TabsScreen()));
//           });
//         });
//       }
//     } else {
//       print("token not stored");
//       Timer(Duration(seconds: 2), () {
//         Navigator.pushReplacement(
//             context, MaterialPageRoute(builder: (context) => TabsScreen()));
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: WHITE,
//       body: Stack(
//         children: [
//           Image.asset(
//             "assets/splash_bg.png",
//             fit: BoxFit.fill,
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//           ),
//           Padding(
//             padding: const EdgeInsets.all(85),
//             child: Center(
//               child: Image.asset(
//                 "assets/splash_icon.png",
//                 fit: BoxFit.fill,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // FirebaseMessaging().getToken().then((value){
// //   //Toast.show(value, context, duration: 2);
// //   print(value);
// //   setState(() {
// //     token = value;
// //   });
// //
// // }).catchError((e){
// //   print("token not generated "+ e.toString());
// //   Timer(Duration(seconds: 2),(){
// //     Navigator.pushReplacement(context,
// //         MaterialPageRoute(builder: (context) => TabsScreen())
// //     );
// //   });
// // });

import 'dart:async';
import 'dart:convert';

import 'package:appcode3/main.dart';
import 'package:appcode3/views/Doctor/DoctorTabScreen.dart';
import 'package:appcode3/views/UnRegisteredHomePage.dart';
import 'package:connectycube_sdk/connectycube_chat.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../VideoCall/utils/pref_util.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isTokenAvailable = false;
  String? token;

  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    getToken();
  }

  void requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      getFCMToken();
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
      getFCMToken();
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void getFCMToken() async {
    FirebaseMessaging.instance.getToken().then((fcmToken) {
      setState(() {
        token = fcmToken;
      });
      storeToken();
    }).catchError((e) {
      print("Failed to get FCM token: $e");
    });
  }

  getToken() async {
    SharedPreferences.getInstance().then((pref) {
      getCC();
      if (pref.getBool("isTokenExist") ?? false) {
        Timer(Duration(seconds: 2), () {
          if (pref.getBool("isLoggedInAsDoctor") ?? false) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DoctorTabsScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UnRegisteredHomePage()),
            );
          }
        });
      } else {
        Timer(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UnRegisteredHomePage()),
          );
        });
      }
    });
  }

  getCC() {
    SharedPrefs.getUser().then((value) {
      if (value != null) {
        print('${value.fullName}');
        print('${value.login}');
        print('${value.password}');
        print('${value.id}');
        if (value.id != null) {
          _loginToCC(context, value);
        }
      } else {
        print("Value is null");
      }
    });
  }

  _loginToCC(BuildContext context, CubeUser user) async {
    if (CubeSessionManager.instance.isActiveSessionValid() &&
        CubeSessionManager.instance.activeSession!.user != null) {
      if (CubeChatConnection.instance.isAuthenticated()) {
        print('---------> go to opponents screen');
      } else {
        print('---------> something wrong open login cube cc');
        _loginToCubeChat(context, user);
      }
    } else {
      createSession(user).then((cubeSession) {
        print('---------> create session create suceessfully');
        _loginToCubeChat(context, user);
      }).catchError((exception) {
        print(exception);
      });
    }
  }

  void _loginToCubeChat(BuildContext context, CubeUser user) {
    CubeChatConnection.instance.login(user).then((cubeUser) async {
      SharedPrefs.saveNewUser(user);
      print('----------> go to opponents screen');
    }).catchError((exception) {
      print(exception);
    });
  }

  storeToken() async {
    final response =
        await post(Uri.parse("$SERVER_ADDRESS/api/savetoken"), body: {
      "token": token,
      "type": "1",
      // ignore: body_might_complete_normally_catch_error
    }).catchError((e) {
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => UnRegisteredHomePage()));
      });
    });
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == "1") {
        Timer(Duration(seconds: 2), () {
          SharedPreferences.getInstance().then((pref) {
            pref.setBool("isTokenExist", true);
            print("token stored");
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => UnRegisteredHomePage()));
          });
        });
      }
    } else {
      print("token not stored");
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => UnRegisteredHomePage()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset(
            "assets/splash_bg.png",
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
          Padding(
            padding: const EdgeInsets.all(85),
            child: Center(
              child: Image.asset(
                "assets/splash_icon.png",
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
