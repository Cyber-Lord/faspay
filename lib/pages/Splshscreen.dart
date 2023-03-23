import 'dart:async';
import 'package:faspay/pages/phonescreen.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';
import 'utils/colornotifir.dart';
import 'utils/mediaqury.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Splshscreen extends StatefulWidget {
  const Splshscreen({Key? key}) : super(key: key);

  @override
  State<Splshscreen> createState() => _SplshscreenState();
}

class _SplshscreenState extends State<Splshscreen> {
  late ColorNotifier notifier;
String? my_num,token;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    my_session();
    if(my_num==null){
      Timer(
        const Duration(seconds: 5),
            () => Navigator.pushReplacement(
          context,

          MaterialPageRoute(
            builder: (context) => const PhoneScreen(),
          ),
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, //Center Row contents horizontally,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Image.asset("assets/images/logo.png", height: height / 4.5),

          ],
        ),
      ),
    );
  }

  Future<void> my_session() async{
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs =await SharedPreferences.getInstance();
    var phone=prefs.getString("phone");
    var tokn=prefs.getString("token");
   // my_num=email!;

    //print(my_num);
   // prefs.remove("phone");
   // print(my_num);
    if(phone==null){

    }else{
      my_num=phone!;
      token=tokn!;
    }

    print(my_num.toString()+token.toString());
  }
}