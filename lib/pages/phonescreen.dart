import 'dart:convert';
//import 'dart:html';

import 'package:faspay/pages/otppage.dart';
import 'package:faspay/pages/registerScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});

  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  bool _isButtonEnabled = false;
  bool show_preogress = false;
  bool surgest_login = false;
  bool correct_pass_checker = false;


  final _formKey = GlobalKey<FormState>();
  String? _phoneNumber;
  String name = "";
  String otp="";

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textEditingController.removeListener(_onTextChanged);
    _textEditingController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isButtonEnabled = _textEditingController.text.length >= 11;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Welcome",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
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
                                "Enter your mobile number.",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                textAlign: TextAlign.center,
                                "To use AlleyPay, Please enter your mobile number.",
                                style: TextStyle(
                                  fontFamily: "Times New Roman",
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: _textEditingController,
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
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 15),
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
                              onChanged: (value) => _phoneNumber = value,
                            ),
                          ],
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
                              });
                              login(_textEditingController.text);
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
            SafeArea(
              child: Center(
                child: Visibility(
                    visible: surgest_login,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          surgest_login = false;
                        });
                      },
                      child: Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Center(
                              child: Container(
                            padding: EdgeInsets.all(15),
                            child: Material(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              elevation: 18.0,
                              color: Colors.white,
                              clipBehavior: Clip.antiAlias, // Add This
                              child: Container(
                                padding: EdgeInsets.all(15),
                                height: MediaQuery.of(context).size.height / 4,
                                child: ListView(
                                  children: [
                                    Container(
                                      // decoration: BoxDecoration(
                                      //   border: Border.all(
                                      //     color: Colors.grey.shade700,
                                      //     strokeAlign: StrokeAlign.inside,
                                      //     width: 0.5,
                                      //   ),
                                      // ),
                                      height: 40,
                                      width: MediaQuery.of(context).size.width,
                                      child: Center(
                                        child: Text(
                                          "Account Found",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue.shade900,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "An account associated with this phone number was found on AlleyPay.",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    MaterialButton(
                                      color: Colors.blue.shade900,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      height: 50.0,
                                      child: new Text(
                                        'Login Now',
                                        style: new TextStyle(
                                          fontSize: 16.0,
                                          // fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onPressed: () {
                                        goto_login(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ))),
                    )),
              ),
            ),
          ],
        ));
  }

  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  void hide_ww() {
    setState(() {
      surgest_login = false;
    });
  }

  Future login(phone) async {
    show_preogress = true;
    FocusScope.of(context).requestFocus(new FocusNode());
    var url = "https://a2ctech.net/api/faspay/otp.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": phone,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      if (data["phone"] == "true") {
        name = data["name"];
        show_preogress = false;
        surgest_login = true;
      } else {
        otp=data["otp_code"].toString();
        goto_otp(context);
        show_preogress = false;
      }
      setState(() {
        //show_preogress = false;.
      });
    }
  }

  void goto_login(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => Login(
                phoneNumber: _textEditingController.text,
                name: name,
              )),
    );
  }

  void goto_otp(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OtpPage(
                phoneNumber: _textEditingController.text,
                isNewUser: true, cons_otp: otp,
              )),
    );
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
}
