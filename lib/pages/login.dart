import 'package:faspay/pages/otppage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'homepage.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.phoneNumber, required this.name})
      : super(key: key);
  final String phoneNumber;
  final String name;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _isButtonEnabled = false;
  bool show_preogress = false;
  bool surgest_login = false;
  bool correct_pass_checker = false;
  bool trnx_pin_active=false;

  String token = "";
  String _errorMessage = '';
  String _reseterrorMessage = '';
  bool _isPinVisible = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_onTextChanged);
  }

  void _verifyPassword(String password) {
    if (password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a password';
        print(_errorMessage);
      });
    }
    if (password.length < 8) {
      setState(() {
        _errorMessage = 'Incorrect Password';
        print(_errorMessage);
      });
    }
    if (!password.contains(RegExp(r'[a-zA-Z]'))) {
      setState(() {
        _errorMessage = 'Incorrect Password';
        print(_errorMessage);
      });
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      setState(() {
        _errorMessage = 'Incorrect Password';
        print(_errorMessage);
      });
    }
    return null;
  }

  void showError() {
    setState(() {
      _hasError = false;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              "Error",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            )),
            content: Text(
              "You can not reset another user's password, Please close this window and enter your correct phone number.",
              style: TextStyle(
                fontFamily: "Times New Roman",
                fontSize: 12,
                color: Colors.grey.shade700,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _resetPassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Center(
              child: Text(
                "Reset Password",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "To reset your password, Please kindly enter your phone number below and follow the instructions that will be sent to the phone number.",
                    style: TextStyle(
                      fontFamily: "Times New Roman",
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    maxLength: 11,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade900,
                    ),
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
                        color: Colors.blue.shade900,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                      prefixText: "+234 - ",
                      prefixStyle: TextStyle(
                        color: Colors.blue.shade900,
                      ),
                      labelText: 'Phone Number',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone Number is required';
                      }
                      return null;
                    },
                    // onChanged: (value) => _phoneNumber = value,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  if (_reseterrorMessage.isNotEmpty)
                    Text(
                      _reseterrorMessage,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        if (_phoneNumberController.text != widget.phoneNumber) {
                          setState(() {
                            _hasError = true;
                            _reseterrorMessage =
                                "You can not reset another user's password";
                            _phoneNumberController.text = "";
                            print(_reseterrorMessage);
                          });
                        }
                        if (_phoneNumberController.text.isEmpty) {
                          setState(() {
                            _hasError = true;
                            _phoneNumberController.text = "";
                            _reseterrorMessage = "Phone Number is required";
                            print(_reseterrorMessage);
                          });
                        }
                        ;

                        !_hasError
                            ? setState(() {
                                _phoneNumberController.text = "";
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OtpPage(
                                      phoneNumber: widget.phoneNumber,
                                      isNewUser: false,
                                    ),
                                  ),
                                );
                                _hasError = false;
                                _reseterrorMessage = "";
                              })
                            : showError();
                        // _phoneNumberController.text = "";
                      },
                      child: Container(
                        color: Colors.blue.shade900,
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            "Reset Password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 120.0,
                              width: 120.0,
                              // color: Colors.blue.shade900,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              "Welcome back, " + widget.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: Text(
                              "To use AlleyPay, please enter your account password",
                              style: TextStyle(
                                fontFamily: "Times New Roman",
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: _textEditingController,
                            obscureText: !_isPinVisible,
                            enableSuggestions: false,
                            autocorrect: false,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
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
                                color: Colors.blue.shade900,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 15.0,
                                horizontal: 15,
                              ),
                              labelText: 'Password',
                            ),
                            onChanged: (value) {
                              _onTextChanged();
                            },
                            validator: ((value) {
                              print(value);
                              _verifyPassword(value!);
                              return null;
                            }),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_errorMessage.isNotEmpty)
                                Text(
                                  _errorMessage,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              TextButton(
                                onPressed: (() {
                                  _resetPassword(context);
                                }),
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                checkColor: Colors.blue.shade900,
                                value: _isPinVisible,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _isPinVisible = value ?? false;
                                  });
                                },
                              ),
                              Text('Show Password'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: _isButtonEnabled
                              ? Colors.blue.shade900
                              : Colors.grey,
                        ),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              show_preogress = true;
                              _verifyPassword(_textEditingController.text);
                              login(widget.phoneNumber,
                                  _textEditingController.text);
                            });
                          },
                          child: Text(
                            'PROCEED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      )
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  void goto_dashboard(BuildContext context,String is_pen_set) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            HomePage(phoneNumber: widget.phoneNumber, token: token, checkPin: is_pen_set,),
      ),
    );
  }

  Future login(mail, pass) async {
    var url = "https://a2ctech.net/api/faspay/login.php";
    var response;
    response =
        await http.post(Uri.parse(url), body: {"mail": mail, "pass": pass});

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);

      if (data["status"] == "true") {
        token = data["token"];
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("phone", widget.phoneNumber);
        pref.setString("token", token);
        pref.setString("trnx_pin_active", data["trnx_pin_active"]);
        //trnx_pin_active=data["trnx_pin_active"];
        goto_dashboard(context,data["trnx_pin_active"]);
        // _showToast(context,"Invalid Login Details");/
      }
    } else {
      print(response.statusCode);

      setState(() {
        correct_pass_checker = true;
      });
    }
    setState(() {
      show_preogress = false;
    });
  }

  void _showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
        action:
            SnackBarAction(label: '', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  void _onTextChanged() {
    setState(() {
      _isButtonEnabled = _textEditingController.text.length >= 4;
    });
  }
}
