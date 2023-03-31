import 'package:flutter/material.dart';

class ResetPinPage extends StatefulWidget {
  @override
  _ResetPinPageState createState() => _ResetPinPageState();
}

class _ResetPinPageState extends State<ResetPinPage> {
  late TextEditingController _oldPinController;
  late TextEditingController _newPinController;
  late TextEditingController _confirmPinController;

  @override
  void initState() {
    super.initState();
    _oldPinController = TextEditingController();
    _newPinController = TextEditingController();
    _confirmPinController = TextEditingController();
  }

  @override
  void dispose() {
    _oldPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _onSaveButtonPressed() {
    String oldPin = _oldPinController.text.trim();
    String newPin = _newPinController.text.trim();
    String confirmPin = _confirmPinController.text.trim();

    if (oldPin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Old pin must be 4 digits.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (newPin.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New pin must be 4 digits.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else if (newPin != confirmPin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New pin does not match.'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      // TODO: reset the pin
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Pin reset.'),
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
        title: Text('Reset Pin'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Enter your old and new transaction pins:',
              style: TextStyle(
                fontSize: 16.0,
                // fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _oldPinController,
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
                labelText: 'Enter old 4-digit PIN',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _newPinController,
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
                labelText: 'Enter new 4-digit PIN',
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
                labelText: 'Enter new 4-digit confirm PIN',
              ),
            ),
            SizedBox(height: 16.0),
            Container(
              height: 50,
              color: Colors.blue.shade900,
              child: GestureDetector(
                onTap: () {
                  // _onSaveButtonPressed();
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
