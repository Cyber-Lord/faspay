import 'package:faspay/pages/pospage.dart';

import 'package:faspay/pages/cardpage.dart';
import 'package:faspay/pages/phonescreen.dart';
import 'package:faspay/pages/qrscan.dart';
import 'package:faspay/pages/supprtpage.dart';
import 'package:faspay/pages/userprofile.dart';
// import 'package:faspay/pages/userprofile.dart';
import 'package:flutter/material.dart';
import 'package:faspay/pages/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.phoneNumber, required this.token, required this.checkPin})
      : super(key: key);
  final String phoneNumber;
  final String token;
  final String checkPin;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  late String _fullName;
  late String _email;
  late String _phoneNumber;
  late String _address;
  String trnx_pin_active="false";

  int _currentIndex = 0;
  String my_num = "", my_token = "";
  void initState() {
    my_session();
    super.initState();
    trnx_pin_active=widget.checkPin;
print(widget.checkPin.toString()+" kala sak");
  }

  final List<Widget> _children = [


    Dashboard(),
    CardPage(),
    POSPage(),
  ];

  void onTabTapped(int index,String ispin_active) {
    setState(() {
      if(ispin_active=="false"){
      }else{
        _currentIndex = index;
      }

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        leading: IconButton(
          icon: Icon(Icons.person),
          color: Colors.white,
          onPressed: () {
            if(trnx_pin_active=="false"){

            }else{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfile(
                    email: "John@doe.com",
                    name: "John Doe",
                    // tier: VerificationTier.basic,
                    tier: VerificationTier.advanced,
                    bvn: "1234567890",
                    dob: "01/01/2000",
                    phoneNumber: my_num,
                  ),
                ),
              );
            }

          },
        ),
        actions: [
          SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: (() {
              if(trnx_pin_active=="false"){

              }else{
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRScanner()),
                );
              }

            }),
            icon: Icon(
              Icons.qr_code_scanner_sharp,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          IconButton(
            onPressed: (() {
              if(trnx_pin_active=="false"){

              }else{
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupportPage()),
                );
              }

            }),
            icon: Icon(
              Icons.support_agent_sharp,
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue.shade900,

       onTap: (_currentIndex){
         onTabTapped(_currentIndex,trnx_pin_active);
       },
        fixedColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,

        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.dashboard,
              color: Colors.white,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.credit_card,
              color: Colors.white,
            ),
            label: 'Cards',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.important_devices_sharp,
              color: Colors.white,
            ),
            label: 'Terminal',
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Future<void> my_session() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var phone = prefs.getString("phone");
//    trnx_pin_active=prefs.getString("trnx_pin_active")!;
    print("pem pem"+trnx_pin_active.toString()
    );

    print(my_num);
    if (phone == null) {
      logout();
    } else {
      my_num = phone;
    }
  }

  Future<void> logout() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("phone");

    goto_phone_screen(context);
  }

  void goto_phone_screen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PhoneScreen()),
    );
  }
}
