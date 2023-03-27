import 'package:flutter/material.dart';
class Qr_result extends StatefulWidget {
  const Qr_result({Key? key, this.qr_code}) : super(key: key);
final qr_code;
  @override
  State<Qr_result> createState() => _Qr_resultState();
}

class _Qr_resultState extends State<Qr_result> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Container(
        color: Colors.red,
        child: Text(widget.qr_code),
      ),
    );
  }
}
