import 'dart:async';

import 'package:faspay/pages/registerScreen.dart';
import 'package:flutter/material.dart';

class OtpPage extends StatefulWidget {
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  List<TextEditingController> _controllers = [];
  final _formKey = GlobalKey<FormState>();
  Timer? _timer;
  int _remainingSeconds = 60;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      _controllers.add(TextEditingController());
    }
    _startTimer();
  }

  @override
  void dispose() {
    for (int i = 0; i < 6; i++) {
      _controllers[i].dispose();
    }
    _timer!.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer!.cancel();
        }
      });
    });
  }

  void _resendOtp() {
    _remainingSeconds = 30;
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Color.fromARGB(255, 18, 98, 109),
        leading: IconButton(
          onPressed: (() {}),
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: (() {}),
            icon: Icon(Icons.question_answer),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter the 6 digit code sent to your mobile number",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildOtpDigitField(0),
                          _buildOtpDigitField(1),
                          _buildOtpDigitField(2),
                          _buildOtpDigitField(3),
                          _buildOtpDigitField(4),
                          _buildOtpDigitField(5),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _remainingSeconds > 0
                      ? Text(
                          'Resend OTP in $_remainingSeconds seconds',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : TextButton(
                          onPressed: _resendOtp,
                          child: Text(
                            'Resend OTP',
                            style: TextStyle(
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ),
                  SizedBox(height: 20),
                ],
              ),
              Column(
                children: [
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: _isOtpValid() ? Colors.blue.shade900 : Colors.grey,
                    ),
                    child: TextButton(
                      onPressed: _isOtpValid()
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()),
                              );
                              // print(_controllers);
                            }
                          : null,
                      child: Text(
                        'VERIFY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpDigitField(int index) {
    return SizedBox(
      width: 50,
      child: TextFormField(
        controller: _controllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
          setState(() {});
        },
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a digit';
          }
          return null;
        },
      ),
    );
  }

  bool _isOtpValid() {
    return _formKey.currentState?.validate() ?? false;
  }
}
