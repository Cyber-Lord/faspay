import 'dart:convert';

import 'package:faspay/pages/homepage.dart';
import 'package:faspay/pages/registerScreen.dart';
import 'package:flutter/material.dart';
import 'package:password_validated_field/password_validated_field.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class Confirm_password extends StatefulWidget {
  const Confirm_password({Key? key, required this.phoneNumber, required this.fName, required this.sName, required this.oName, required this.nin, required this.dob, required this.new_pass}) : super(key: key);
  final String phoneNumber;
  final String fName;
  final String sName ;
  final String oName;
  final String nin  ;
  final String dob ;
  final String new_pass;
  @override
  State<Confirm_password> createState() => _Confirm_password();
}

class _Confirm_password extends State<Confirm_password> {
  bool _validPassword = false;
  bool show_preogress = false;
  String token = "";
  final _formKey = GlobalKey<FormState>();
  TextEditingController txt_pass=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Confirm Password",
              style: TextStyle(
                fontSize: 18,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Stack(
            children: [
              Opacity(
                opacity: 0.3,
                child: Image.asset(
                  height: MediaQuery.of(context).size.height,
                  width:
                  MediaQuery.of(context).size.width,
                  'assets/images/bg1.jpg',
                  fit: BoxFit.fill,
                  // color: Colors.blue.shade900,
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child:  Text("Confirm Your Password",style: TextStyle(fontSize: 40),),
                                ),
                              ),
                              _validPassword
                                  ? Text(
                                "password does not match",
                                style: TextStyle(fontSize: 18.0,color: Colors.red),
                              )
                                  : Container(),
                              PasswordValidatedFields(
                                textEditingController:txt_pass ,
                              ), // password validated field from package

                              // Button to validate the form

                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade900,
                            ),
                            onPressed:(){

                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  if(txt_pass.text==widget.new_pass){
                                    print(widget.new_pass+"password is correct "+txt_pass.text);
                                    show_preogress=true;
                                    submit_new_user();
                                    _validPassword = false;
                                  }else{
                                    _validPassword = true;
                                  }

                                });
                              } else {
                                setState(() {
                                  //_validPassword = false;
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Finished',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
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
        ),
      ],
    );
  }
  Future submit_new_user() async {
    var url = "https://a2ctech.net/api/faspay/new_user.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      // 	phone 	f_name 	s_name 	o_name 	nin 	pass
      "phone": widget.phoneNumber,
      "f_name": widget.fName,
      "s_name": widget.sName,
      "o_name": widget.oName,
      "nin": widget.nin,
      "pass": widget.new_pass,
      "date_of_birth": widget.dob,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      print(data["status"]);
      if (data["status"] == "true") {
        token = data["token"];
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("phone", widget.phoneNumber);
        pref.setString("token", token);
        pref.setString("trnx_pin_active", data["trnx_pin_active"]);
        goto_dashboard( context,data["trnx_pin_active"]);
      } else if (data["status"] == "01") {
        _showToast(context, "NIN Number Already Exit");
      } else if (data["status"] == "02") {
        _showToast(context, "Phone Number Already Exit");
      } else {
        _showToast(context, "Invalid OTP");
      }
      setState(() {
        show_preogress = false;
      });
    } else {
      print(response.statusCode);
    }
  }
  void goto_dashboard(BuildContext context,String is_pen_set) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            HomePage(phoneNumber: widget.phoneNumber, token: token, checkPin: is_pen_set,),
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
  void navigate_to_setPass() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RegisterScreen(phoneNumber: widget.phoneNumber,),
      ),
    );
  }
}
