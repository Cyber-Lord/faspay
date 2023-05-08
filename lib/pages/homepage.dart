import 'package:faspay/pages/terminalscreen.dart';
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
  const HomePage({Key? key, required this.phoneNumber, required this.token})
      : super(key: key);
  final String phoneNumber;
  final String token;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  late String _fullName;
  late String _email;
  late String _phoneNumber;
  late String _address;

  int _currentIndex = 0;
  String my_num = "", my_token = "";
  void initState() {
    my_session();
    super.initState();
  }

  final List<Widget> _children = [
    Dashboard(),
    CardPage(),
    TerminalScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
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
          },
        ),
        actions: [
          SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: (() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QRScanner()),
              );
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SupportPage()),
              );
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
        onTap: onTabTapped,
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
