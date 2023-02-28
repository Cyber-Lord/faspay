import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _nin, _phoneNumber, _email;
  TextEditingController _dateController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 200.0,
                    // color: Colors.blue.shade900,
                  ),
                  Center(
                    child: Text(
                      "Welcome to Faspay!",
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 57, 120, 172),
                        fontWeight: FontWeight.bold,
                        fontFamily: "Times New Roman",
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Email Address',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email Address is required';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                      prefixIcon: Icon(Icons.numbers_sharp),
                      label: Text("National Identification Number"),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        // borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'BVN is required';
                      }
                      return null;
                    },
                    onSaved: (value) => _nin = value,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(
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
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone Number is required';
                      }
                      return null;
                    },
                    onSaved: (value) => _phoneNumber = value,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "By signing up, you agreed to our terms of use.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 57, 120, 172),
                      // fontWeight: FontWeight.bold,
                      fontFamily: "Times New Roman",
                    ),
                  ),
                  SizedBox(
                    height: 05,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 57, 120, 172),
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: TextButton(
                          onPressed: () {
                            // if (_formKey.currentState!.validate()) {
                            //   _formKey.currentState!.save();

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => OTPPage()),
                            // );
                            // }
                          },
                          child: Text(
                            'REGISTER',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
}
