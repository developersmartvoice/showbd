// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'views/Doctor/DoctorAppointmentDetails.dart';
// import 'views/UserAppointmentDetails.dart';

// class NotificationHelper {
//   String? title;
//   String? body;
//   String? payload;
//   String? id;
//   String? type;
//   BuildContext? context;
//   FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

//   NotificationHelper() {
//     initialize();
//     print("\n\nPayload : $payload");
//   } // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

//   Future<void> checkNotificationStatus(String id) async {
//     final notifications = await flutterLocalNotificationsPlugin!
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.getActiveNotifications();

//     bool notificationShown = notifications!.any((notification) =>
//         notification.id == id &&
//         notification.channelId == 'channel_id'); // Replace with your channel ID

//     print('Notification with ID $id is shown: $notificationShown');

//     if (notificationShown) {
//       await flutterLocalNotificationsPlugin!.cancel(int.parse(id));
//     }
//   }

//   initialize() async {
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     // const AndroidInitializationSettings initializationSettingsAndroid =
//     //     AndroidInitializationSettings('@mipmap/launcher_icon');
//     // final IOSInitializationSettings initializationSettingsIOS =
//     // IOSInitializationSettings(
//     //     onDidReceiveLocalNotification: onDidReceiveLocalNotification);

//     // final InitializationSettings initializationSettings = InitializationSettings(
//     //     android: initializationSettingsAndroid,
//     //     iOS: initializationSettingsIOS);
//     // flutterLocalNotificationsPlugin!.initialize(initializationSettings,
//     //     onSelectNotification: onSelectNotification);

//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/launcher_icon');
//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);
//     await flutterLocalNotificationsPlugin!.initialize(initializationSettings,
//         onSelectNotification: onSelectNotification);
//   }

//   showNotification(
//       {String? title,
//       String? body,
//       String? payload,
//       String? id,
//       BuildContext? context2}) async {
//     context = context2;
//     AndroidNotificationDetails androidPlatformChannelSpecifics =
//         new AndroidNotificationDetails(
//       id!,
//       'MeetLocal',
//       importance: Importance.max,
//       priority: Priority.high,
//       showWhen: true,
//     );
//     NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin!.show(
//       0,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: payload,
//     );
//   }

//   Future onSelectNotification(String? payload) async {
//     print("Called");
//     if (payload != null) {
//       print('\n\nnotification payload: $payload');

//       if (payload.split(":")[0] == "user_id") {
//         print("In Payload");
//         await Navigator.push(
//           context!,
//           MaterialPageRoute(
//               builder: (context) =>
//                   UserAppointmentDetails(payload.split(":")[1].toString())),
//         );
//       } else if (payload.split(":")[0] == "doctor_id") {
//         await Navigator.push(
//           context!,
//           MaterialPageRoute(
//               builder: (context) =>
//                   DoctorAppointmentDetails(payload.split(":")[1].toString())),
//         );
//         // } else if (payload.split(":")[0].toString() == '0') {
//         //   int ccId = int.parse(payload.split(":")[1].toString());
//         // Navigator.push(context!,
//         //   MaterialPageRoute(builder: (context) =>
//         //       ChatScreen(
//         //           payload.split(":")[3].toString(),
//         //           payload.split(":")[2].toString(),
//         //           ccId,
//         //           true)),
//         // );
//       }
//     }
//     // await Navigator.push(
//     //   context,
//     //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
//     // );
//   }

//   Future onDidReceiveLocalNotification(
//       int? id, String? title, String? body, String? payload) async {
//     // display a dialog with the notification details, tap ok to go to another page
//     // showDialog(
//     //   context: context,
//     //   builder: (BuildContext context) => CupertinoAlertDialog(
//     //     title: Text(title),
//     //     content: Text(body),
//     //     actions: [
//     //       CupertinoDialogAction(
//     //         isDefaultAction: true,
//     //         child: Text('Ok'),
//     //         onPressed: () async {
//     //           Navigator.of(context, rootNavigator: true).pop();
//     //           //await Navigator.push(
//     //           // context,
//     //           // MaterialPageRoute(
//     //           //   builder: (context) => SecondScreen(payload),
//     //           // ),
//     //           //);
//     //         },
//     //       )
//     //     ],
//     //   ),
//     // );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'views/Doctor/DoctorAppointmentDetails.dart';
import 'views/UserAppointmentDetails.dart';

class NotificationHelper {
  String? title;
  String? body;
  String? payload;
  String? id;
  String? type;
  BuildContext? context;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationHelper()
      : flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin() {
    initialize();
  }

  Future<void> checkNotificationStatus(String id) async {
    final notifications = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.getActiveNotifications();

    if (notifications != null) {
      bool notificationShown = notifications.any((notification) =>
          notification.id == int.parse(id) &&
          notification.channelId == 'channel_id');

      print('Notification with ID $id is shown: $notificationShown');

      if (notificationShown) {
        await flutterLocalNotificationsPlugin.cancel(int.parse(id));
      }
    }
  }

  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> showNotification(
      {required String title,
      required String body,
      required String payload,
      required String id,
      BuildContext? context2}) async {
    context = context2;
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      id,
      'MeetLocal',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      int.parse(id),
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> onSelectNotification(String? payload) async {
    if (payload != null && context != null) {
      List<String> parts = payload.split(":");
      if (parts.length >= 2) {
        String type = parts[0];
        String id = parts[1];

        if (type == "user_id") {
          await Navigator.push(
            context!,
            MaterialPageRoute(builder: (context) => UserAppointmentDetails(id)),
          );
        } else if (type == "doctor_id") {
          await Navigator.push(
            context!,
            MaterialPageRoute(
                builder: (context) => DoctorAppointmentDetails(id)),
          );
        }
      }
    }
  }

  Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // Handle iOS local notification received
  }
}
