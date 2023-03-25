import 'package:faspay/pages/dashboard.dart';
import 'package:faspay/pages/homepage.dart';
import 'package:flutter/material.dart';

class SetPinPage extends StatefulWidget {
  @override
  _SetPinPageState createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  late TextEditingController _pinController;
  late TextEditingController _confirmPinController;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
    _confirmPinController = TextEditingController();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _onSaveButtonPressed() {
    String pin = _pinController.text.trim();
    String confirmPin = _confirmPinController.text.trim();

    if (pin.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pin must be 6 digits.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (pin != confirmPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pin does not match.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // Save the pin here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pin saved.'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setup Pin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'You are almost done, Set your transaction PIN below:',
              style: TextStyle(
                fontSize: 14.0,
                // fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              obscureText: true,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue.shade900,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue.shade900,
                  ),
                ),
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                labelText: 'Enter 6-digit PIN',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _confirmPinController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              obscureText: true,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue.shade900,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue.shade900,
                  ),
                ),
                labelStyle: TextStyle(
                  color: Colors.black,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                labelText: 'Confirm 6-digit PIN',
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              height: 50,
              color: Colors.blue.shade900,
              child: GestureDetector(
                onTap: () {
                  // _onSaveButtonPressed();
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        phoneNumber: "",
                        token: "",
                      ),
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    "Save",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
