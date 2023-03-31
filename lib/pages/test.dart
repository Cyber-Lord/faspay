import 'package:faspay/pages/qrscan.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';
class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        insetPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.all(10),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        title: Center(
          child: Row(
            children: [
              Icon(
                Icons.error,color: Colors.red,
              ),
              Text(
                'Error',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        content: const Text('Invalid Payment Destination in QR Code'),
        actions: [
          TextButton(
            onPressed: (){
              goto_dashbord( context);
            },
            child: const Text('Rescan',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
          ),
          TextButton(
            onPressed: (){
              goto_rescan( context);
            },
            child: const Text('Close',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
          ),
        ],
      ),
    );
  }
  void goto_dashbord(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
    );
  }
  void goto_rescan(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRScanner()),
    );
  }
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.all(10),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          title: Center(
            child: Text(
              'Notification',
              style: TextStyle(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          actions: [

          ],
        );
      },
    );
  }
}
