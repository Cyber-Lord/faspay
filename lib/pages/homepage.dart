import 'package:faspay/pages/accountscreen.dart';
import 'package:faspay/pages/billscreen.dart';
import 'package:flutter/material.dart';
import 'package:faspay/pages/dashboard.dart';
import 'package:faspay/pages/secondpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

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
        // backgroundColor: Colors.blue.shade900,
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
            onPressed: (() {}),
            icon: Icon(
              Icons.qr_code_2,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          IconButton(
            onPressed: (() {}),
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
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.person,
          //   ),
          //   label: 'Account',
          // ),
        ],
      ),
    );
  }
}
