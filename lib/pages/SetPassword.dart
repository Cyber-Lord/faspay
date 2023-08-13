import 'package:faspay/pages/registerScreen.dart';
import 'package:flutter/material.dart';
import 'package:password_validated_field/password_validated_field.dart';
class SetPassword extends StatefulWidget {
  const SetPassword({Key? key, required this.phoneNumber}) : super(key: key);
final String phoneNumber;
  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  bool _validPassword = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController txt_pass=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
     centerTitle: true,
        title: Text(
          "Create New Passowrd",
          style: TextStyle(
            fontSize: 18,
            // fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Padding(
             padding: const EdgeInsets.all(15.0),
             child: Container(
               alignment: Alignment.centerLeft,
               child:  Text("Create Your Password",style: TextStyle(fontSize: 40),),
             ),
           ),
            _validPassword
                ? Text(
              "Password Valid!",
              style: TextStyle(fontSize: 22.0),
            )
                : Container(),
            PasswordValidatedFields(
              textEditingController:txt_pass ,
            ), // password validated field from package

            // Button to validate the form
            ElevatedButton(
                onPressed: () {
                  print("pass is here"+txt_pass.text);
                  navigate_to_setPass();
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _validPassword = true;
                    });
                  } else {
                    setState(() {
                      _validPassword = false;
                    });
                  }
                },
                child: Text("Check password!")),
          ],
        ),
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
