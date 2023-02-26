import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _bvn;

  String? _validateBVNRequired(String value) {
    return value.isEmpty ? 'BVN Is Required' : null;
  }

  void _submitBVN() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Registeration Page"),
      //   leading: Icon(Icons.arrow_back),
      // ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/logo.png',
                height: 200.0,
                // color: Colors.blue.shade900,
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  "Welcome to Faspay!",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(255, 57, 120, 172),
                    // fontWeight: FontWeight.bold,
                    fontFamily: "Times New Roman",
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              // Text(
              //   textAlign: TextAlign.left,
              //   "To use Faspay, Please enter your 11 digit BVN to get started",
              //   style: TextStyle(
              //     fontSize: 14,
              //     fontFamily: "Arial",
              //     color: Color.fromARGB(255, 57, 120, 172),
              //   ),
              // ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                  prefixIcon: Icon(Icons.numbers),
                  label: Text("Please enter your BVN"),
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
                onSaved: (value) => _bvn = value,
              ),
              SizedBox(
                height: 320,
              ),
              Container(
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
            ],
          ),
        ),
      ),
    );
  }
}
