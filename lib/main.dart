import 'package:faspay/pages/Splshscreen.dart';
import 'package:faspay/pages/homepage.dart';
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
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          //color set to transperent or set your own color
          statusBarIconBrightness: Brightness.dark,
          //set brightness for icons, like dark background light icons
        )
    );
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
      home: Splshscreen(
        //qr_coder: "qqqqqq",
      ),
    );
  }
//xxx bbc

}
