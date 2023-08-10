import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';

typedef void MyCallback();
typedef TextChangedCallback = void Function(String);
typedef TextChangedCallback_int = void Function(int);
typedef Textbtn_with_boo_p = void Function(bool);


Widget TextField_function(TextEditingController txt_field,String hint){
  return  TextField(
    controller: txt_field,
    onChanged: (value){
      print(value);
    },
    enableSuggestions: false,
    autocorrect: false,
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
      labelStyle: const TextStyle(
        color: Colors.grey,
        fontSize: 12,
      ),
      contentPadding: const EdgeInsets.symmetric(
          vertical: 15.0, horizontal: 15),
      labelText: hint,
    ),
  );
}
Widget Textform(TextEditingController frm_id,String placeholder,String requirement_label,TextInputType input_fomart,bool isPassword){
  return TextFormField(
    controller: frm_id,
    keyboardType: input_fomart,
    obscureText: isPassword,
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blue.shade900,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide:
        BorderSide(color: Colors.red),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.blue.shade900,
        ),
      ),
      labelStyle: TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
      contentPadding:
      EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 15),
      labelText: placeholder,
    ),
    validator: (value) {
      if (value!.isEmpty) {
        return requirement_label;
      }
      return null;
    },
    onSaved: (value) {
      // _fullName = value!;
    },
  );
}
Widget Full_eleveted_width_button(MyCallback callback,Color background,Color text_color,String title,bool btn_status){
  return     ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: background,
      minimumSize: const Size.fromHeight(50), // NEW
    ),

    onPressed: btn_status?callback:null,
    child:Text(
      title,
      style: TextStyle(fontSize: 19,color: text_color,fontWeight: FontWeight.bold),
    ),
  );
}
Widget Textbtn( Textbtn_with_boo_p callback,String tittle,Color text_color,double font_size,bool enableButton,bool btnAction){
  return TextButton(
    onPressed: () => callback(btnAction),
    child: Text(
      tittle,
      style: TextStyle(
        color: enableButton?text_color:Colors.grey.shade200,
        fontSize: font_size,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
Widget pin_widget(TextChangedCallback onTextChanged,BuildContext context, TextEditingController pinController,
    String title,String message,bool invalid_trnx_pin, var url,var width,var height) {
  return Container(
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(40),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                width: width,
                child: Column(
                  children: [
                    Icon(
                      Icons.lock,
                      size: 80,
                      color: Colors.blue.shade900,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    PinPut(
                      controller: pinController,
                      // focusNode: focu,
                      autofocus: true,
                      keyboardAppearance: Brightness.light,
                      obscureText: "*",
                      onChanged: onTextChanged,
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: "Gilroy Bold",
                          fontSize: height / 40),
                      fieldsCount: 4,
                      eachFieldWidth: width / 6.5,
                      withCursor: false,
                      submittedFieldDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.blue))
                          .copyWith(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.blue)),
                      selectedFieldDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.blue)),
                      followingFieldDecoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ).copyWith(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),

                      if(!invalid_trnx_pin)...[
                        Text(
                          "Invalid Transaction PIN",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        )
              ]


                  ],
                ),
              ),
            ),
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
Widget otp_pin(TextChangedCallback onTextChanged,BuildContext context, TextEditingController pinController,
    String title,String message,bool invalid_trnx_pin, var url,var width,var height,int counta,MyCallback btn_resend_otp) {



  return Container(
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(40),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                width: width,
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/otp_pix.png",
                      height: height / 4,
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    PinPut(
                      controller: pinController,
                      // focusNode: focu,
                      autofocus: true,
                      keyboardAppearance: Brightness.light,
                      obscureText: "*",
                      onChanged: onTextChanged,
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: "Gilroy Bold",
                          fontSize: height / 40),
                      fieldsCount: 4,
                      eachFieldWidth: width / 6.5,
                      withCursor: false,
                      submittedFieldDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.blue))
                          .copyWith(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.blue)),
                      selectedFieldDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.blue)),
                      followingFieldDecoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ).copyWith(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),

                    if(!invalid_trnx_pin)...[
                      Text(
                        "Invalid Transaction PIN",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      )
                    ],
                    //>>>>>>>>>>>>>>>>>>>>>>>>>

                    counta > 0
                        ? Text(
                      'Resend again in $counta seconds',
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: Colors.red.shade900,
                      ),
                    )
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                      ),
                      onPressed: btn_resend_otp,
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    //>>>>>>>>>>>>>>>>>>>>>>>>>


                  ],
                ),
              ),
            ),
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}
Widget pin_reset_widget(TextChangedCallback onTextChanged,BuildContext context, TextEditingController pinController,
    String title,String message,String error_msg,bool invalid_trnx_pin,var width,var height) {
  return Container(
    color: Colors.white,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.all(40),
          child: Material(
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                width: width,
                child: Column(
                  children: [
                    Icon(
                      Icons.lock,
                      size: 80,
                      color: Colors.blue.shade900,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    PinPut(
                      controller: pinController,
                      // focusNode: focu,
                      autofocus: true,
                      keyboardAppearance: Brightness.light,
                      obscureText: "*",
                      onChanged: onTextChanged,
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: "Gilroy Bold",
                          fontSize: height / 40),
                      fieldsCount: 4,
                      eachFieldWidth: width / 6.5,
                      withCursor: false,
                      submittedFieldDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.blue))
                          .copyWith(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.blue)),
                      selectedFieldDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.blue)),
                      followingFieldDecoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ).copyWith(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),

                    if(!invalid_trnx_pin)...[
                      Text(
                        error_msg,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      )
                    ]


                  ],
                ),
              ),
            ),
            color: Colors.white,
          ),
        ),
      ],
    ),
  );
}



