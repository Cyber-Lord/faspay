import 'package:faspay/pages/depositpage.dart';
import 'package:faspay/pages/homepage.dart';
import 'package:faspay/pages/otppage.dart';
import 'package:faspay/pages/phonescreen.dart';
import 'package:faspay/pages/qrcodescannerscreen.dart';
import 'package:faspay/pages/registerScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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
      home: HomePage(),
    );
  }
}
