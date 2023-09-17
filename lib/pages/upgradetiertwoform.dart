import 'dart:convert';

import 'package:faspay/pages/phonescreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'homepage.dart';
class UpgradePage extends StatefulWidget {
  const UpgradePage({Key? key}) : super(key: key);

  @override
  _UpgradePageState createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  late String _dateOfBirth;
  late String _bvn;
  late String _email;
  bool show_preogress=false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null)
      setState(() {
        _dateController.text = DateFormat.yMd().format(picked);

      });
  }

  void _submitBVN() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }
  var phone;
  var tokn;
  var trnx_pin_active;
  @override
  void initState() {
    super.initState();
    my_session();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Upgrade Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Please enter your information to upgrade your account to second tier: This will allow you to make transactions above NGN 100,000NGN daily',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                        hintText: "Date of Birth",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        prefixIcon: IconButton(
                          onPressed: () => _selectDate(context),
                          icon: Icon(Icons.calendar_month),
                        ),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(

                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                        hintText: "BVN",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        prefixIcon: Icon(
                          Icons.dialpad,
                        ),
                      ),
                      maxLength: 11,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your BVN';
                        }
                        // You can add more validation rules here if needed
                        return null;
                      },
                      onSaved: (value) {
                        _bvn = value!;
                      },
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                        hintText: "Email Address",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        prefixIcon: Icon(
                          Icons.email,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        // You can add more validation rules here if needed
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                    ),
                    const SizedBox(height: 32.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () {
                       // successDialog(context);
                        if (_formKey.currentState!.validate()) {
                          // Save the form fields
                          _formKey.currentState!.save();
                          show_preogress = true;
                       _upgradeAccount();
                        }
                      },
                      child: Text('Submit'),
                    ),
                  ],
                ),
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
                  ))),
        ],
      ),
    );
  }

  Future<void> _upgradeAccount() async {

    FocusScope.of(context).requestFocus(new FocusNode());
    var url = "https://a2ctech.net/api/faspay/to_tier2.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": phone,
      "token": tokn,
      "mail": _email,
      "dob": _dateController.text,
      "bvn": _bvn,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      if (data["status"] == "true") {
        successDialog(context);
        //	mail 	phone 	f_name 	s_name 	o_name 	nin 	pass 	token 	qr_code 	op_date 	date_of_birth 	tier
        setState(() {


        });

      } else {

        // logout();
      }
      setState(() {
        //show_preogress = false;.
      });
    }
  }
  Future<void> my_session() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
     phone = prefs.getString("phone");
    tokn = prefs.getString("token");
     trnx_pin_active=prefs.getString("trnx_pin_active");
    if (phone == null) {
      logout();
    } else {

    }
  }
  Future<void> logout() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("phone");

    goto_phone_screen(context);
  }
  void goto_phone_screen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PhoneScreen()),
    );
  }

  void successDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: Text(
              "Congratulations!",
              style: TextStyle(
                color: Colors.blue.shade900,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )),
            content: Text(
              "Check your email for a confirmation link",
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 12,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        phoneNumber: phone.toString(), token: tokn.toString(), checkPin: trnx_pin_active.toString(),),
                    ),
                  );
                },
                child: Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          );
        });
  }

  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
}
