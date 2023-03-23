import 'package:faspay/pages/accountscreen.dart';
import 'package:faspay/pages/billscreen.dart';
import 'package:faspay/pages/qrcodescannerscreen.dart';
import 'package:flutter/material.dart';
import 'package:faspay/pages/dashboard.dart';
import 'package:faspay/pages/secondpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.phoneNumber,required this.token}) : super(key: key);
  final String phoneNumber;
  final String token;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String my_num="",my_token="";
  void initState() {
    my_session();
    super.initState();
  }
  final List<Widget> _children = [
    Dashboard(),
    SecondPage(),
    BillScreen(),
    AccountScreen(),
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
          onPressed: () {},
        ),
        actions: [
          SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: (() {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QRCodeScannerScreen()),
              );
            }),
            icon: Icon(
              Icons.qr_code_2,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          IconButton(
            onPressed: (() {my_session();}),
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
              Icons.payments,
              color: Colors.white,
            ),
            label: 'Bills',
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
  Future<void> my_session() async{
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs =await SharedPreferences.getInstance();
    var email=prefs.getString("phone");
    my_num=email!;
    print(my_num);

  }

}
