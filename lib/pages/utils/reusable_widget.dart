import 'package:flutter/material.dart';

typedef void MyCallback();
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
Widget Textform(TextEditingController frm_id,String placeholder,String requirement_label,TextInputType input_fomart){
  return TextFormField(
    controller: frm_id,
    keyboardType: input_fomart,
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
Widget Full_eleveted_width_button(MyCallback callback,Color background,Color text_color,String title){
  return     ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: background,
      minimumSize: const Size.fromHeight(50), // NEW
    ),
    onPressed: () {
      callback();
    },
    child:Text(
      title,
      style: TextStyle(fontSize: 24,color: text_color),
    ),
  );
}
