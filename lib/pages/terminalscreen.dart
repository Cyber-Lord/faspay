import 'package:flutter/material.dart';

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(
          12.0,
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Text(
              "You don't have a POS, Kindly complete your KYC and request for one.",
            ),
            SizedBox(
              height: 10,
            ),
            Icon(
              Icons.important_devices_sharp,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
