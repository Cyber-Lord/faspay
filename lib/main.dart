import 'package:faspay/pages/Splshscreen.dart';
import 'package:faspay/pages/homepage.dart';
import 'package:faspay/pages/otppage.dart';
import 'package:faspay/pages/qr_result.dart';
import 'package:faspay/pages/test.dart';
import 'package:faspay/pages/transfer.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      //color set to transperent or set your own color
      statusBarIconBrightness: Brightness.dark,
      //set brightness for icons, like dark background light icons
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Faspay',

      theme: ThemeData(
        appBarTheme: AppBarTheme(
          // backgroundColor: Color.fromARGB(255, 18, 98, 109),
          backgroundColor: Colors.blue.shade900,
        ),
        fontFamily: "Poppins",
        primaryColor: Colors.blue.shade900,
        canvasColor: Color.fromARGB(255, 250, 252, 251),
      ),
      // home: CardPage(),
      home: Splshscreen(),
    );
  }
//xxx bbc

}

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:intl/intl.dart';
// import 'dart:async';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.dark,
//     ));
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitDown,
//       DeviceOrientation.portraitUp,
//     ]);
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Faspay',
//       theme: ThemeData(
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.blue.shade900,
//         ),
//         fontFamily: "Poppins",
//         primaryColor: Colors.blue.shade900,
//         canvasColor: Color.fromARGB(255, 250, 252, 251),
//       ),
//       home: Splshscreen(),
//     );
//   }
// }

// class Splshscreen extends StatefulWidget {
//   const Splshscreen({Key? key}) : super(key: key);

//   @override
//   _SplshscreenState createState() => _SplshscreenState();
// }

// class _SplshscreenState extends State<Splshscreen> {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   @override
//   void initState() {
//     super.initState();
//     initializeNotifications();
//     scheduleNotification();
//   }

//   Future<void> initializeNotifications() async {
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//         FlutterLocalNotificationsPlugin();
//     flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.getActiveNotifications();
//     tz.initializeTimeZones();
//     await flutterLocalNotificationsPlugin.initialize(
//       InitializationSettings(
//         android: AndroidInitializationSettings('app_icon'),
//       ),
//     );
//   }

//   Future<void> scheduleNotification() async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'channel_id',
//       'channel_name',
//       'channel_description',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     const NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);

//     tz.TZDateTime scheduledDate = tz.TZDateTime.from(
//         DateTime.now().add(const Duration(seconds: 2)), tz.local);

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'Notification Title',
//       'Notification Body',
//       scheduledDate,
//       platformChannelSpecifics,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My App'),
//       ),
//       body: const Center(
//         child: Text('Hello, World!'),
//       ),
//     );
//   }
// }
