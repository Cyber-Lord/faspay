import 'dart:async';
import 'dart:convert';

import 'package:faspay/pages/registerScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OtpPage extends StatefulWidget {
  const OtpPage({Key? key, required this.phoneNumber}) : super(key: key);
  final String phoneNumber;

  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  List<TextEditingController> _controllers = [];
  final _formKey = GlobalKey<FormState>();
  Timer? _timer;
  int _remainingSeconds = 60;
  String hold_otp = "";
  bool show_preogress = false;
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
    resent_otp();
    _remainingSeconds = 30;
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        ListView(
          children: [
            Container(
              height: 50,
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: (() {}),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 10),
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

                    // Text(widget.phoneNumber),
                  ],
                ),
              ),
            ),
          ],
        ),
        Visibility(
            visible: show_preogress,
            child: Container(
                color: Colors.black.withOpacity(0.5),
                child: ListView(
                  children: const [
                    LinearProgressIndicator(
                      semanticsLabel: 'Linear progress indicator',
                    )
                  ],
                ))),
      ],
    ));
  }

  bool change_color = false;
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
          filled: true, //<-- SEE HERE
          // fillColor: change_color == true ? Colors.green : Colors.red,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                width: 1,
                color: change_color == true
                    ? Colors.green
                    : Colors.red), //<-- SEE HERE
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();

            hold_otp = hold_otp + _controllers[index].text;
            //_showToast(context,hold_otp);
            // change_color = !change_color;
            if (hold_otp.toString().length == 6) {
              // _showToast(context,"6 digit");
              show_preogress = true;
              change_color = true;
              otp_verification();
              hold_otp = "";
              // _buildOtpDigitField();
            }
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
          setState(() {});
        },
        validator: (value) {
          if (value!.isEmpty) {
            // return '';
          }
          return null;
        },
      ),
    );
  }

  bool _isOtpValid() {
    return _formKey.currentState?.validate() ?? false;
  }

  void reset_validation() {
    _controllers[0].text = "";
    _controllers[1].text = "";
    _controllers[2].text = "";
    _controllers[3].text = "";
    _controllers[4].text = "";
    _controllers[5].text = "";
    change_color = false;
    //_showToast(context,hold_otp);
  }

  Future resent_otp() async {
    var url = "https://a2ctech.net/api/faspay/otp.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": widget.phoneNumber,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
//print(data["token"]);

      setState(() {
        show_preogress = false;
      });
    }
  }

  Future otp_verification() async {
    var url = "https://a2ctech.net/api/faspay/verify_otp.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": widget.phoneNumber,
      "otp": hold_otp,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      print(data["status"]);
      if (data["status"] == "true") {
        _to_reg_page(context);
      } else {
        reset_validation();
        _showToast(context, "Invalid OTP");
      }
      setState(() {
        show_preogress = false;
      });
    } else {
      print(response.statusCode);
    }
  }

  void _to_reg_page(BuildContext context) {
    //String textToSend = textFieldController.text;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterScreen(
          phoneNumber: widget.phoneNumber,
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          msg,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        action:
            SnackBarAction(label: '', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
