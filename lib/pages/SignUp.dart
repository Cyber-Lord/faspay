import 'package:faspay/pages/utils/reusable_widget.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';

class Sign_up extends StatefulWidget {
  const Sign_up({Key? key, required this.phoneNumber}) : super(key: key);
final String phoneNumber;
  @override
  State<Sign_up> createState() => _Sign_upState();
}

class _Sign_upState extends State<Sign_up> {
  final TextEditingController _accountName = TextEditingController();
  var size, height, width;


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

               Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Let's Create Your Account",style: TextStyle(fontSize: 30),),
                     SizedBox(height:10),
                      Textform(_accountName,"First Name","Please enter your First name",TextInputType.text,false),
                      SizedBox(height:10),
                      SizedBox(height:10),
                      Textform(_accountName,"Surname","Please enter your Surname",TextInputType.text,false),
                      SizedBox(height:10),

                      Textform(_accountName,"Other Name","Please enter your Other name",TextInputType.text,false),
                      SizedBox(height:10),


                      Textform(_accountName,"NIN ","Please enter your NIN",TextInputType.text,false),
                      SizedBox(height:10),
                      DateTimeFormField(
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(color: Colors.black45),
                          errorStyle: TextStyle(color: Colors.redAccent),
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.event_note),
                          labelText: 'Only time',
                        ),
                        mode: DateTimeFieldPickerMode.time,
                        autovalidateMode: AutovalidateMode.always,
                        validator: (DateTime? e) {
                          return (e?.day ?? 0) == 1
                              ? 'Please not the first day'
                              : null;
                        },
                        onDateSelected: (DateTime value) {
                          print(value);
                        },
                      ),

                    ],
                  ),
                ),

            ],
          ),
        ),
      ],
    );
  }
}

