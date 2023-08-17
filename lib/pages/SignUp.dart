import 'package:faspay/pages/utils/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';

import 'SetPassword.dart';

class Sign_up extends StatefulWidget {
  const Sign_up({Key? key, required this.phoneNumber}) : super(key: key);
final String phoneNumber;
  @override
  State<Sign_up> createState() => _Sign_upState();
}

class _Sign_upState extends State<Sign_up> {
  final TextEditingController _accountName = TextEditingController();
  final TextEditingController _fName = TextEditingController();
  final TextEditingController _sName = TextEditingController();
  final TextEditingController _oName = TextEditingController();
  final TextEditingController _nin = TextEditingController();
  final TextEditingController _dob = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  var size, height, width;
  DateTime? selectedDate;
bool err_msg_bool=false;
bool check_date_of_birth_value=false;
String err_msg="Select your date of birth";
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Stack(

      children: [
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Basic Info",
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
                   child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Form(
                        key:_formKey ,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Let's Create Your Account",style: TextStyle(fontSize: 35),),
                           SizedBox(height:10),
                            Textform_sign_up(_fName,"First Name","Please enter your First name",TextInputType.text,false,true),
                            SizedBox(height:10),
                            Textform_sign_up(_sName,"Surname","Please enter your Surname",TextInputType.text,false,true),
                            SizedBox(height:10),

                            Textform_sign_up(_oName,"Other Name","Please enter your Other name",TextInputType.text,false,false),
                            SizedBox(height:10),
                            Textform_sign_up(_nin,"NIN ","Please enter your NIN",TextInputType.number,false,true),
                            SizedBox(height:10),
                            DateTimeField(

                                decoration:  InputDecoration(
                                    hintStyle: TextStyle(color: Colors.blue.shade900),
                                    errorStyle: TextStyle(color: Colors.redAccent),
                                    border: OutlineInputBorder(),
                                    suffixIcon: Icon(Icons.event_note,color: Colors.blue.shade900,),
                                    labelText: 'Date of Birth',
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue.shade900,
                                      ),
                                    )
                                    //hintText: 'Please select your birthday date and time'
                                    ),
                                selectedDate: selectedDate,
                                onDateSelected: (DateTime value) {
                                  setState(() {
                                    selectedDate = value;
                                    err_msg_bool=false;
                                    check_date_of_birth_value=true;
                                    print("date is "+selectedDate.toString());

                                  });
                                }),
                            SizedBox(height:10),
                            if(err_msg_bool)...[
                              Text(
                                err_msg,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              )
                            ],
                            SizedBox(height:10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade900,
                                ),
                                onPressed:(){
                                  if(_nin.text.length==11){

                                   if(check_date_of_birth_value){
                                     setState(() {
                                       err_msg_bool=false;
                                       err_msg="Select your date of birth";
                                     });
                                   }else{
                                     setState(() {
                                       err_msg="Select your date of birth";
                                       err_msg_bool=true;
                                     });
                                   }
                                  }else{
                                    setState(() {
                                      err_msg="Invalid NIN Number";
                                      err_msg_bool=true;
                                    });
                                  }

                                  if (_formKey.currentState!.validate() && !err_msg_bool) {
                                    setState(() {
                                      navigate_to_setPass();
                                    });
                                  } else {
                                    setState(() {
                                     // navigate_to_setPass();
                                    });
                                  }

                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'Next',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )

                          ],
                        ),
                      ),
                    ),
                 ),
               ),

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
            SetPassword(phoneNumber: widget.phoneNumber, fName: _fName.text, sName: _sName.text, oName: _oName.text, nin: _nin.text, dob: _dob.text,),
      ),
    );
  }
}

