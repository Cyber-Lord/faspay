import 'package:faspay/pages/homepage.dart';
import 'package:faspay/pages/otppage.dart';
import 'package:faspay/pages/phonescreen.dart';
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
        fontFamily: "Times New Roman",
        primaryColor: Color.fromARGB(255, 18, 98, 109),
        canvasColor: Colors.white,
      ),
      home: RegisterScreen(),
    );
  }
}
