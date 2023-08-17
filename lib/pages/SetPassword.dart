import 'package:faspay/pages/registerScreen.dart';
import 'package:flutter/material.dart';
import 'package:password_validated_field/password_validated_field.dart';

import '../Confirm_password.dart';
class SetPassword extends StatefulWidget {
  const SetPassword({Key? key, required this.phoneNumber, required this.fName, required this.sName, required this.oName, required this.nin, required this.dob}) : super(key: key);
final String phoneNumber;
  final String fName;
  final String sName ;
  final String oName;
  final String nin  ;
  final String dob ;
  @override
  State<SetPassword> createState() => _SetPasswordState();
}

class _SetPasswordState extends State<SetPassword> {
  bool _validPassword = false;
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
              "Create New Passowrd",
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
                               inputDecoration: InputDecoration(
                                   hintStyle: TextStyle(color: Colors.blue.shade900),
                                   errorStyle: TextStyle(color: Colors.redAccent),
                                   border: OutlineInputBorder(),
                                   suffixIcon: Icon(Icons.lock,color: Colors.blue.shade900,),
                                   labelText: 'Enter a new Password',
                                   enabledBorder: OutlineInputBorder(
                                     borderSide: BorderSide(
                                       color: Colors.blue.shade900,
                                     ),
                                   )
                                 //hintText: 'Please select your birthday date and time'
                               ),

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
                                 navigate_to_setPass();
                                 print("inccorec");
                                 _validPassword = true;
                               });
                             } else {
                               setState(() {
                                 print("a dai dai ina");
                                 _validPassword = false;
                               });
                             }
                           },
                           child: Padding(
                             padding: const EdgeInsets.all(10.0),
                             child: Text(
                               'Continue',
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
             )
            ],
          ),
        ),
      ],
    );
  }

  void navigate_to_setPass() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Confirm_password(phoneNumber: widget.phoneNumber, fName: widget.fName, sName: widget.sName, oName: widget.oName, nin: widget.nin, dob: widget.dob, new_pass: txt_pass.text,),
      ),
    );
  }
}
