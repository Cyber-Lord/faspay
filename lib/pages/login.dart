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
  bool _isButtonEnabled = false;
  bool show_preogress = false;
  bool surgest_login = false;
  bool correct_pass_checker = false;
  String? _phoneNumber;
  String token = "";
  String _errorMessage = '';
  bool _isPinVisible = false;

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
                          Center(
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 200.0,
                              // color: Colors.blue.shade900,
                            ),
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
                              "To use FasPay, please enter your account password",
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
                              })),
                          // SizedBox(
                          //   height: 5,
                          // ),
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
                                  // setState(() {
                                  //   surgest_login = true;
                                  // });
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
                  ))),
        ],
      ),
    );
  }

  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  void goto_dashboard(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              HomePage(phoneNumber: widget.phoneNumber, token: token)),
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
        goto_dashboard(context);
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
