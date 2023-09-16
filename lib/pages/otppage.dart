import 'dart:async';
import 'dart:convert';

import 'package:faspay/pages/login.dart';
import 'package:faspay/pages/registerScreen.dart';
import 'package:faspay/pages/utils/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'SetPassword.dart';
import 'SignUp.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({
    Key? key,
    required this.phoneNumber,
    required this.isNewUser, required this.cons_otp,
  }) : super(key: key);
  final String phoneNumber;
  final bool isNewUser;
  final String cons_otp;

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
  TextEditingController _oldPinController = TextEditingController();
  TextEditingController _newPinController = TextEditingController();
  TextEditingController _confirmPinController = TextEditingController();

  TextEditingController otp_txt_in=TextEditingController();

  String _errorMessage = '';
  bool _isPinVisible = false;
  bool invalid_trnx_pin=false;
  bool is_otp_resend=false;

  var size, height, width;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 6; i++) {
      _controllers.add(TextEditingController());
    }
    _startTimer();
  }

  void _changePassword() {
    String oldPin = _oldPinController.text;
    String newPin = _newPinController.text;
    String confirmPin = _confirmPinController.text;

    if (oldPin.isEmpty || newPin.isEmpty || confirmPin.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter all PINs';
      });
      return;
    }

    if (newPin.length != 4 || confirmPin.length != 4) {
      setState(() {
        _errorMessage = 'PINs must be 4 digits long';
      });
      return;
    }

    if (newPin != confirmPin) {
      setState(() {
        _errorMessage = 'New PIN and Confirm PIN do not match';
      });
      return;
    }

    Navigator.of(context).pop();
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
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    if(is_otp_resend){

    }else{
      hold_otp= widget.cons_otp;
    }
   //
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text(
            "Phone Verification",
            style: TextStyle(
              fontSize: 18,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Stack(
          children: [
            Visibility(
                visible: true,
                child: SingleChildScrollView(
                  child: otp_pin(
                      _terminal_activation,
                      context,
                      otp_txt_in,
                      "Verification Code",
                      "A 4 digit code was sent to your mobile number, fill it below to continue.",
                      invalid_trnx_pin?false:true,
                      "",
                      width,
                      height,
                      _remainingSeconds,
                      btn_resend_otp
                  ),
                )
            ),
            Visibility(
              visible: false,
                child: ListView(
                  children: [
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
                                  "A 6 digit code was sent to your mobile number, fill it below to continue.",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  'Resend again in $_remainingSeconds seconds',
                                  style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.red.shade900,
                                  ),
                                )
                                    : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade900,
                                  ),
                                  onPressed: _resendOtp,
                                  child: Text(
                                    'Resend OTP',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
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
                ),),
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
              color: change_color == true ? Colors.green : Colors.grey,
            ), //<-- SEE HERE
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
void btn_resend_otp(){
    setState(() {
      resent_otp();
      _remainingSeconds=60;
      _startTimer();
     // print("otp is"+hold_otp);

    });
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
        is_otp_resend=true;
        hold_otp=data["otp_code"].toString();
        //print("otp holder"+hold_otp);
        show_preogress = false;
      });
    }
  }
  void _terminal_activation(String value){
    if(value.length==4){
      if(value==hold_otp){
        setState(() {
         // show_preogress=true;
          invalid_trnx_pin=false;
          navigate_to_setPass();
          otp_txt_in.clear();

        });
      }else{
        setState(() {
          invalid_trnx_pin=true;
          otp_txt_in.clear();
        });
      }
    }

  }
  void navigate_to_setPass() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Sign_up(phoneNumber: widget.phoneNumber,),
      ),
    );
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
        _changeAccPassword(
            context,
            "Reset Password",
            "Please kindly enter a new password for your account",
            "New Password",
            "Confirm New Password",
            false);
        // _showToast(context, "Invalid OTP");
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

  void _changeAccPassword(BuildContext context, String title, String message,
      String label2, label3, bool isPin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // use StatefulBuilder to access setState inside the dialog
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "X",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                ],
              ),
              content: Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _newPinController,
                        obscureText: !_isPinVisible,
                        enableSuggestions: false,
                        autocorrect: false,
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
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 15),
                          labelText: label2,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _confirmPinController,
                        obscureText: !_isPinVisible,
                        enableSuggestions: false,
                        autocorrect: false,
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
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 15,
                          ),
                          labelText: label3,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Checkbox(
                            value: _isPinVisible,
                            onChanged: (bool? value) {
                              setState(() {
                                _isPinVisible = value ?? false;
                              });
                            },
                          ),
                          Text(
                            _isPinVisible ? 'Hide' : 'Show',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ],
                      ),
                      if (_errorMessage.isNotEmpty)
                        Text(
                          _errorMessage,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                  ),
                  onPressed: (() {
                    _changePassword();
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Login(
                          phoneNumber: widget.phoneNumber,
                          name: widget.phoneNumber.toString(),
                        ),
                      ),
                    );
                  }),
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
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
