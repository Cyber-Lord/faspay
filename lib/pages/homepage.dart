import 'dart:convert';

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
import 'package:http/http.dart' as http;
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
  //	mail 	phone 	f_name 	s_name 	o_name 	nin 	pass 	token 	qr_code 	op_date 	date_of_birth 	tier
  late String mail;
  late String f_name;
  late String s_name;
  late String o_name;
  late String nin;
  late String op_date;
  late String date_of_birth;
  late String tier;



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
                    email: mail,
                    name: f_name.toString()+" "+s_name.toString()+" "+o_name.toString(),
                    // tier: VerificationTier.basic,
                    tier: VerificationTier.advanced,
                    bvn: "1234567890",
                    dob: date_of_birth,
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
    var tokn = prefs.getString("token");
//    trnx_pin_active=prefs.getString("trnx_pin_active")!;
    print("pem pem"+trnx_pin_active.toString()
    );

    print(my_num);
    if (phone == null) {
      logout();
    } else {
      my_num = phone;
      get_customer_details(phone, tokn);
    }
  }

  Future<void> logout() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("phone");

    goto_phone_screen(context);
  }
  Future get_customer_details(phone, token) async {

    FocusScope.of(context).requestFocus(new FocusNode());
    var url = "https://a2ctech.net/api/faspay/profile_info.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": phone,
      "token": token,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      if (data["status"] == "true") {
        //	mail 	phone 	f_name 	s_name 	o_name 	nin 	pass 	token 	qr_code 	op_date 	date_of_birth 	tier
setState(() {
  mail = data["mail"];
  f_name = data["f_name"];
  s_name = data["s_name"];
  o_name = data["o_name"];
  nin = data["nin"];
  op_date = data["op_date"];
  date_of_birth = data["date_of_birth"];
  tier = data["tier"];

});

      } else {

       // logout();
      }
      setState(() {
        //show_preogress = false;.
      });
    }
  }



  void goto_phone_screen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PhoneScreen()),
    );
  }
}
