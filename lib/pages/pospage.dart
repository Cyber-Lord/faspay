import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:faspay/pages/phonescreen.dart';
import 'package:flutter/material.dart';
import 'package:passcode_screen/keyboard.dart';
import 'utils/reusable_widget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart';
class POSPage extends StatefulWidget {
  @override
  _POSPageState createState() => _POSPageState();
}

class _POSPageState extends State<POSPage> {

  List<Map<String, dynamic>> posTerminals=[];

  List<String> _userList = [
    '0801234',
    '0901234',
    '0701234',
  ];

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _oldPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _accountName = TextEditingController();
  final TextEditingController _trnx_pin_controller=TextEditingController();

  //new user controller
  final TextEditingController _new_user_f_name=TextEditingController();
  final TextEditingController _new_user_s_name=TextEditingController();
  final TextEditingController _new_user_phone=TextEditingController();
  final TextEditingController _new_user_pass=TextEditingController();
  final TextEditingController _new_user_confirm_pass=TextEditingController();



  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  DateTime _startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _endDate = DateTime.now();

  bool isLocked = false;
  bool show_preogress = false;
  bool _passwordsMatch = true;
  bool _isPinVisible = false;
  bool _isTransferEnabled = false;
  bool bool_terminal_request=false;
  bool insufficient_Funds=false;
  bool invalid_trnx_pin=false;
  bool show_trnx_panel=false;
  bool show_user_alreadyExit=false;
  bool show_new_operator_added=false;
  bool terminal_load_index=false;
  bool show_pin_widget_for_new_user=false;
  bool hide_terminal_request=false;
  bool terminal_status=false;
  bool default_pin_is_correct=false;
  bool confim_new_pin=false;
  bool activate_new_terminal_pin=false;

  String _errorMessage = '';
  String my_num = "", my_token = "";
  String user_id="";
  String trnx_pin="";
  String _new_user_notification="default text";
  String terminal_id="";
  String new_pin_msg="Enter a Default Activation PIN";
  String new_pin_tittle="Activate Your Terminal";
  String new_pin_err_msg="Invalid Default Pin";
  String hold_new_pin="";
  String hold_new_pin_confirmation="";


  double terminal_price=0;
  double hold_balance=0;

  int terminal_index=-1;
  int new_pin_counta=0;

  var size, height, width;
  final _formKey = GlobalKey<FormState>();

  void _changePin() {
    String oldPin = _oldPinController.text;
    String newPin = _newPinController.text;
    String confirmPin = _confirmPinController.text;

    if (oldPin.isEmpty || newPin.isEmpty || confirmPin.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter all PINs';
      });
      return;
    }

    if (newPin.length != 4 || confirmPin.length != 4) {
      setState(() {
        _errorMessage = 'PINs must be 4 digits long';
      });
      return;
    }

    if (newPin != confirmPin) {
      setState(() {
        _errorMessage = 'New PIN and Confirm PIN do not match';
      });
      return;
    }

    Navigator.of(context).pop();
  }

  void lockDevice(int id) {
    setState(() {
      if (posTerminals[id]['isLocked'] == false) {
        setState(() {
          posTerminals[id]['isLocked'] = true;
        });
      } else if (posTerminals[id]['isLocked'] == true) {
        setState(() {
          posTerminals[id]['isLocked'] = false;
        });
      }
    });
  }

  void _selectStartDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      // initialDate: _startDate,
      initialDate: DateTime.now(),

      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null && selectedDate != _startDate) {
      setState(() {
        _startDate = selectedDate;
      });
    }
  }

  void _selectEndDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime.now().subtract(
        Duration(days: 365),
      ),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null && selectedDate != _endDate) {
      setState(() {
        _endDate = selectedDate;
      });
    }
  }

  void _addPOSTerminal() {
    String terminalName = _controller.text;
    setState(() {
      posTerminals.add({
        'name': terminalName,
        'location': '',
        'user': '',
        'online': false,
        'lastSeen': null,
      });
      _controller.clear();
    });
  }

  void _toggleTransfer(bool value) {
    setState(() {
      _isTransferEnabled = value;
    });
  }

  void _deletePOSTerminal(int index) {
    setState(() {
      posTerminals.removeAt(index);
    });
  }

  void removeUser(int index) {
    setState(() {
      _userList.removeAt(index);
    });
  }

  void usersDropDown(int inde) {
    //>>>>>>>>>>>>>>>>>>>>
    String num="07064986532";
    int counta=posTerminals[inde]['user'].length;
    for(int x=0;x<counta;x++){
      print(x);
      print(posTerminals[inde]['user'][x]["f_name"]);
      if(num==posTerminals[inde]['user'][x]["phone"]){
        print("get the number");
      }
    }
    //>>>>>>>>>>>>>>>>>>
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Column(
                children: [
                  Text(
                    'Users',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            content: Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: counta,// posTerminals[index]['name']
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      posTerminals[inde]['user'][index]["f_name"]+"( "+posTerminals[inde]['user'][index]["phone"]+" )",
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        print(posTerminals[inde]['user'][index]["phone"]);
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors.blue.shade900,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _addUser(BuildContext context,int index) {
    bool boolCheckDatas = true;
    bool everything_is_ok=false;
    bool dialog_bg_and_progress_bar=false;
    bool isUserXit=false;


    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context,setState){
               return AlertDialog(
                 backgroundColor: dialog_bg_and_progress_bar ?Colors.grey.shade400:null,
                  title: Center(
                    child: Column(
                      children: [
                        Text(
                          'Register User',
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),
                  ),
                  content: SingleChildScrollView(
                    child: Stack(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Textform(_new_user_f_name,"First Name","",TextInputType.text,false),
                            SizedBox(height: 16.0),
                            Textform(_new_user_s_name,"Surname","",TextInputType.text,false),
                            SizedBox(height: 16.0),
                            Textform(_new_user_phone,"phone Number","",TextInputType.phone,false),
                            SizedBox(height: 16.0),
                            Textform(_new_user_pass,"password","",TextInputType.text,true),
                            SizedBox(height: 16.0),
                            Textform(_new_user_confirm_pass,"confirm password","",TextInputType.text,true),
                            SizedBox(height: 8.0),

                            if (!boolCheckDatas)
                              Text(
                                _new_user_notification,
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                          ],
                        ),
                        Visibility(
                            visible: dialog_bg_and_progress_bar,
                            child: Container(

                                color: Colors.black.withOpacity(0.5),
                                child:LinearProgressIndicator(
                                      semanticsLabel: 'Linear progress indicator',
                                    )
                                )),
                      ],
                    ),
                  ),
                  actions: [
                    Textbtn(btn_cancel_new_user,"Cancel",Colors.red,16,true,boolCheckDatas),

                    TextButton(
                      onPressed: (){
                      if(everything_is_ok){

                      }else{
                        if(_new_user_f_name.text.isEmpty){
                          setState(() {
                            _new_user_notification = "Enter a first name";
                            boolCheckDatas = false;
                            everything_is_ok=false;
                          });
                        }else if(_new_user_s_name.text.isEmpty){
                          setState(() {
                            _new_user_notification = "Enter a Surname";
                            boolCheckDatas = false;
                            everything_is_ok=false;
                          });
                        }else if(_new_user_phone.text.isEmpty) {
                          setState(() {
                            _new_user_notification = "Enter a phone Number";
                            boolCheckDatas = false;
                            everything_is_ok=false;
                          });
                        }else{

                          if(_new_user_phone.text.length==11){
                            //>>>>>>>>>>>>>>>>>>>>>>>>>>
                              if(_new_user_pass.text.isEmpty){
                                setState((){
                                  _new_user_notification = "Enter a Password";
                                  boolCheckDatas = false;
                                  everything_is_ok=false;
                                });
                              }else{
                                if(_new_user_pass.text==_new_user_confirm_pass.text){
                                  String status;
                                  setState((){
                                    everything_is_ok=true;
                                    boolCheckDatas = true;
                                    dialog_bg_and_progress_bar=true;
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    hide_terminal_request=true;
                                    show_pin_widget_for_new_user=true;
                                    terminal_index=index;
                                   // _new_operator_submit(_new_user_phone.text,_new_user_pass.text,_new_user_f_name.text,_new_user_s_name.text,index);
                                  });
                                }else{
                                  setState((){
                                    _new_user_notification = "Password mismatch";
                                    boolCheckDatas = false;
                                    everything_is_ok=false;
                                  });
                                }
                              }

                            //>>>>>>>>>>>>>>>>>>>>>>>>>>


                          }else{
                            setState(() {
                              _new_user_notification = "Invalid phone number";
                              boolCheckDatas = false;
                              everything_is_ok=false;
                            });
                          }
                        }

                      }

                        },
                         child: Text("Register",style: TextStyle(color: Colors.blue.shade900,fontSize: 16,fontWeight: FontWeight.bold),)
                         )
                    /* TextButton(
                onPressed: _passwordsMatch
                    ? () {
                        final phone = _phoneController.text;
                        final password = _passwordController.text;

                        Navigator.of(context).pop();
                        print(phone);
                        print(password);
                      }
                    : null,
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),*/
                  ],
                );
              });
        });
  }

  void _requestStatement() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: ((context, setState) {
            return AlertDialog(
              title: Center(
                child: Text(
                  'Request Statement',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Select date range:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Start Date:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectStartDate(context);
                          });
                        },
                        // onPressed: () => _selectStartDate(context),
                        child: Text(
                          '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'End Date:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.blue.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectEndDate(context);
                          });
                        },

                        // onPressed: () => _selectEndDate(context),
                        child: Text(
                          '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            contentPadding:
                                EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
                            title: Center(
                              child: Text(
                                "Request Received",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blue.shade900,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            content: SizedBox(
                              height: MediaQuery.of(context).size.height / 3,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.blue.shade900,
                                    size: 80,
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    'Statement request was successfully received. You will receive an email shortly.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text(
                                          'Close',
                                          style: TextStyle(
                                            color: Colors.blue.shade900,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }

  void _enterPIN(
      bool value, String title, String message, String buttonMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(25, 25, 25, 10),
          title: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _pinController,
                  obscureText: true,
                  enableSuggestions: false,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
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
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 15,
                    ),
                    labelText: "Enter PIN",
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: TextButton(
                        onPressed: (() {
                          Navigator.of(context).pop();
                          _toggleTransfer(value);
                        }),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: (() {
                          Navigator.of(context).pop();
                          _toggleTransfer(value);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Container(
                                  height: 200,
                                  width: 100,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Transfer Enabled",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue.shade900,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Icon(
                                        Icons.check_circle,
                                        size: 100,
                                        color: Colors.blue.shade900,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text(
                                            'Close',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                        child: Text(
                          buttonMessage,
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _requestPOS() {
    showDialog(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              "Request POS",
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height / 1.8,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Text(
                  "Please kindly enter the following details. Doing so will enable us to process your request.",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _fullNameController,
                  keyboardType: TextInputType.text,
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
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 15,
                    ),
                    labelText: "Account Name",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _fullNameController,
                  keyboardType: TextInputType.text,
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
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 15,
                    ),
                    labelText: "Contact Name",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.number,
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
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 15,
                    ),
                    labelText: "Contact Number",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
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
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 15,
                    ),
                    labelText: "Email",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _addressController,
                  keyboardType: TextInputType.text,
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
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 15,
                    ),
                    labelText: "Contact Address",
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    Container(
                        // width: MediaQuery.of(context).size.width / 2,
                        ),
                    SizedBox(
                      width: 100,
                    ),
                    Container(
                      // width: MediaQuery.of(context).size.width / 2,
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: (() {
                              Navigator.of(context).pop();
                            }),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          TextButton(
                            onPressed: (() {
                              Navigator.of(context).pop();
                            }),
                            child: Text(
                              "Submit",
                              style: TextStyle(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _managePOS(int index,BuildContext context) {
    if(posTerminals[index]['status']=="Pending"){
      setState(() {
        terminal_status=false;
      });
    }else{
      setState(() {
        terminal_status=true;
      });
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return SafeArea(
            child: Container(
              padding: EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Device Settings",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                  SizedBox(height: 5),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      _addUser(context,index);
                    },
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.person_add,
                            color: Colors.blue.shade900,
                          ),
                          title: Text(
                            'Add User',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      usersDropDown(index);
                    },
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.people,
                            color: Colors.blue.shade900,
                          ),
                          title: Text(
                            'Operators',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      if(posTerminals[index]['status']=="Pending"){
                        print("new Activate");
                        setState((){
                          Navigator.of(context).pop();
                          activate_new_terminal_pin=true;
                          hide_terminal_request=true;
                        });
                      }else{
                        print("device is active");
                      }
                      /*
                             Navigator.of(context).pop();
                      _resetPIN(context, true);
                       */
                    },
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            terminal_status?Icons.pin:Icons.point_of_sale_sharp,
                            color: Colors.blue.shade900,
                          ),
                          title: Text(
                            terminal_status?'Reset PIN':"Activate Terminal",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      lockDevice(index);
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Container(
                              height: 100,
                              width: 100,
                              child: Column(
                                children: [
                                  Icon(
                                    posTerminals[index]['isLocked']
                                        ? Icons.lock
                                        : Icons.lock_open,
                                    size: 50,
                                    color: Colors.blue.shade900,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    posTerminals[index]['isLocked']
                                        ? "Device Locked"
                                        : "Device UnLocked",
                                    style: TextStyle(
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            posTerminals[index]['isLocked']
                                ? Icons.lock_open
                                : Icons.lock,
                            color: Colors.blue.shade900,
                          ),
                          title: Text(
                            posTerminals[index]['isLocked']
                                ? 'Unlock Device'
                                : 'Lock Device',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.send_to_mobile,
                          color: Colors.blue.shade900,
                        ),
                        title: Text(
                          'Enable Transfer',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        trailing: Switch(
                          activeColor: Colors.blue.shade900,
                          value: _isTransferEnabled,
                          onChanged: (value) {
                            setState(
                              () {
                                _isTransferEnabled = value;
                              },
                            );
                            if (value) {
                              Navigator.of(context).pop();
                              _enterPIN(
                                value,
                                "Enable Transfer",
                                "Please enter your transaction PIN to enable transfer on this device. Do note that once this is enabled, the device can be used to send money to third party users.",
                                "Enable",
                              );
                            } else {
                              Navigator.of(context).pop();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Center(
                                        child: Text(
                                          "Success",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.blue.shade900,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      content: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                3.3,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          children: [
                                            SizedBox(height: 15),
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.blue.shade900,
                                              size: 100,
                                            ),
                                            SizedBox(height: 15),
                                            Text(
                                              "Transfer has been disabled on this device",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade600,
                                                // fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 15),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: TextButton(
                                                onPressed: (() {
                                                  Navigator.of(context).pop();
                                                }),
                                                child: Text(
                                                  "Done",
                                                  style: TextStyle(
                                                    color: Colors.blue.shade900,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  void _showPOS(String terminalName, int index,BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      posTerminals[index]['name'],
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),//
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Device Information",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Device Location : ",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      posTerminals[index]['location'],
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 14,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),

              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Last Seen: ",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      posTerminals[index]['lastSeen'].toString(),
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 14,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _managePOS(index,context);
                      terminal_id=posTerminals[index]['terminal_id'];

                    },
                    child: Text('Manage Device'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _requestStatement();
                    },
                    child: Text('Request Statement'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _resetPIN(BuildContext context, bool isPin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // use StatefulBuilder to access setState inside the dialog
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Reset Device PIN",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "X",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                ],
              ),
              content: Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "To reset your device PIN, you need to enter your old PIN and then enter your new PIN twice.",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _oldPinController,
                        obscureText: !_isPinVisible,
                        enableSuggestions: false,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
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
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 15),
                          labelText: "Enter old PIN",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _newPinController,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        obscureText: !_isPinVisible,
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
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 15),
                          labelText: "Enter new PIN",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _confirmPinController,
                        obscureText: !_isPinVisible,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
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
                          labelStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 15,
                          ),
                          labelText: "Confirm new PIN",
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Checkbox(
                            value: _isPinVisible,
                            onChanged: (bool? value) {
                              setState(() {
                                _isPinVisible = value ?? false;
                              });
                            },
                          ),
                          Text(
                            _isPinVisible ? 'Hide' : 'Show',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ],
                      ),
                      if (_errorMessage.isNotEmpty)
                        Text(
                          _errorMessage,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                  ),
                  onPressed: (() {
                    _changePin();
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Container(
                              height: 100,
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.blue.shade900,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Please wait...",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }),
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    my_session();
    super.initState();
    //
   // fetchData();

  }
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: Stack(
          children: [
            ListView.builder(
              itemCount: posTerminals.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => _showPOS(posTerminals[index]['name'], index,context),
                  child: Card(
                    child: ListTile(
                      title: Text(
                        posTerminals[index]['name'],
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        posTerminals[index]['location'],
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey.shade300,
                        child: Icon(
                          Icons.tap_and_play,
                          color: Colors.blue.shade900,
                          size: 25.0,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Visibility(
              visible: bool_terminal_request,
              child: AnimatedOpacity(
                opacity: bool_terminal_request ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  color: Colors.white,
                  //color: Colors.black.withOpacity(0.5),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      //color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 32.0),
                                Text(
                                  "Delivery Information",
                                  style: TextStyle(
                                    color: Colors.blue.shade900,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                GestureDetector(
                                  child: Icon(Icons.close),
                                  onTap: () {
                                    setState(() {
                                      bool_terminal_request = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Divider(
                              thickness: 2,
                              color: Colors.grey.shade100,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Request POS",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              "Please kindly enter the following details. Doing so will enable us to process your request.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.grey.shade100,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text("Balance:",style: TextStyle(fontWeight: FontWeight.bold),),
                                        Text("NGN"+hold_balance.toString())
                                      ],
                                    ),
                                    if(insufficient_Funds)...[
                                      Text("Insufficient Funds",style: TextStyle(color: Colors.red,fontSize: 13),)
                                    ]

                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                                child: Material(

                                  color: Colors.white,
                                 // height: height - 315,
                                  child: ListView(
                                    children: [
                                      Form(
                                        key: _formKey,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Textform(_accountName,"Account Name","Please enter your Account name",TextInputType.text,false),

                                              SizedBox(height: 16),
                                              Textform(_addressController,"Location","Please enter your POS Location",TextInputType.text,false),
                                              SizedBox(height: 16),
                                              Textform(_fullNameController,"Contact Name","Please enter your full name",TextInputType.text,false),
                                              SizedBox(height: 16),
                                              Textform(_phoneNumberController,"Contact Phone No","Please enter your phone No",TextInputType.phone,false),
                                              SizedBox(height: 16),
                                              Full_eleveted_width_button(btn_submit,Colors.blue.shade900,Colors.white,"Submit",insufficient_Funds?false:true),

                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

           Visibility(
             visible: show_trnx_panel,
               child: pin_widget(
                 transaction_pin_function,
                 context,
                   _trnx_pin_controller,
                 "Transaction PIN",
                 "Enter your transaction to complete",
                   invalid_trnx_pin?false:true,
                 "url",
                 width,
                 height
               )
           ),
            Visibility(
                visible: show_pin_widget_for_new_user,
                child: pin_widget(
                    _new_operator_process,
                    context,
                    _trnx_pin_controller,
                    "Transaction PIN",
                    "Enter your transaction to complete",
                    invalid_trnx_pin?false:true,
                    "url",
                    width,
                    height
                )
            ),
            Visibility(
                visible: activate_new_terminal_pin,
                child: pin_reset_widget(
                    _terminal_activation,
                    context,
                    _trnx_pin_controller,
                    new_pin_tittle,
                    new_pin_msg,
                    new_pin_err_msg,
                    invalid_trnx_pin?false:true,
                    width,
                    height
                )
            ),
            Visibility(
              visible: show_user_alreadyExit,
              child: user_alreadyExit(),
            ),
            Visibility(
              visible: show_new_operator_added,
              child: SuccessContainer(),
            ),
           //Progress bar
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

      floatingActionButton: bool_terminal_request||hide_terminal_request ?null:FloatingActionButton(
        onPressed: () {
         // _requestPOS();
          setState(() {
            bool_terminal_request=true;

          });
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue.shade900,
      ),
    );
  }
  Widget SuccessContainer() {
    return GestureDetector(
      onTap: () {
        setState(() {
          show_new_operator_added = false;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            child: Container(
              height: MediaQuery.of(context).size.height / 3.4,
              width: MediaQuery.of(context).size.width / 1.5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Success",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Icon(
                      Icons.check_circle,
                      size: 100,
                      color: Colors.blue.shade900,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if(terminal_load_index)...[
                      Text(
                        "New Operator Added Successfully to "+posTerminals[terminal_index]['name'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ]

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget user_alreadyExit() {
    return GestureDetector(
      onTap: () {
        setState(() {
          show_user_alreadyExit = false;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            child: Container(
              height: MediaQuery.of(context).size.height / 3.4,
              width: MediaQuery.of(context).size.width / 1.5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "User Already Exit",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Icon(
                      Icons.error,
                      size: 100,
                      color: Colors.red,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "User Already Exit please use different phone number",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void transaction_pin_function(String value){
if(value.length==4){
  if(value==trnx_pin){
    setState(() {
      show_preogress=true;
      invalid_trnx_pin=false;
      FocusScope.of(context).requestFocus(new FocusNode());
       _terminal_request_submit(_accountName.text,_addressController.text,_fullNameController.text,_phoneNumberController.text);
      _trnx_pin_controller.clear();
    });
  }else{
    setState(() {
      invalid_trnx_pin=true;
      _trnx_pin_controller.clear();
    });
  }
  //_trnx_pin_controller.clear();

}
  }
void btn_submit(){
    setState(() {
      //
      if (_formKey.currentState!
          .validate()) {
        _formKey.currentState!.save();
        setState(() {
          FocusScope.of(context).requestFocus(new FocusNode());
          show_trnx_panel=true;
        });

      } else {}
    });
}
void btn_submit_new_user(bool action){
    //                _new_user_f_name,_new_user_s_name,_new_user_phone,_new_user_pass,_new_user_confirm_pass
  //                _new_user_notification,_passwordsMatch
print("f Name= "+_new_user_f_name.text);
if(_new_user_f_name.text.isEmpty){
 setState(() {
   _new_user_notification="Enter a first name";
   action=false;
 });
}else{
setState(() {
  _new_user_notification="";
  action=true;
});
}
}
void btn_cancel_new_user(bool action){
  Navigator.of(context).pop();
}
void _new_operator_process(String value){

  if(value.length==4){
    if(value==trnx_pin){
      setState(() {
        show_preogress=true;
        invalid_trnx_pin=false;
        FocusScope.of(context).requestFocus(new FocusNode());

        _new_operator_submit(_new_user_phone.text,_new_user_pass.text,_new_user_f_name.text,_new_user_s_name.text);
         _trnx_pin_controller.clear();

      });
    }else{
      setState(() {
        invalid_trnx_pin=true;
        _trnx_pin_controller.clear();
      });
    }
    //_trnx_pin_controller.clear();

  }

}
  void _terminal_activation(String value){

    if(value.length==4){
      if(value==trnx_pin && new_pin_counta==0){
        setState(() {
          default_pin_is_correct=true;
          invalid_trnx_pin=false;
          new_pin_msg="Select New Terminal Pin";
         _trnx_pin_controller.clear();

        });
      }else{
        if(default_pin_is_correct&&!confim_new_pin){
          hold_new_pin=value;
          setState(() {
            invalid_trnx_pin=false;
            confim_new_pin=true;
            print("new pin is"+hold_new_pin);
            new_pin_msg="Confirm New Terminal Pin";
            _trnx_pin_controller.clear();
          });

        }else if(default_pin_is_correct&&confim_new_pin) {
          hold_new_pin_confirmation=value;
          print("confirm new pin"+hold_new_pin_confirmation);
          if(hold_new_pin==hold_new_pin_confirmation){
            print("muna wurin");
           setState(() {
             show_preogress=true;
             FocusScope.of(context).requestFocus(new FocusNode());
           });
          }else{
            setState(() {
              new_pin_msg="Select New Terminal Pin";
              confim_new_pin=false;
              new_pin_err_msg="New And Confirm Pin mismatch";
              invalid_trnx_pin=true;
              _trnx_pin_controller.clear();
            });
          }
        }else{
          setState(() {
            invalid_trnx_pin=true;
            _trnx_pin_controller.clear();
          });
        }

      }
    }

  }
  Future _new_operator_submit(String operator_phone,String pass,String f_name,String s_name) async {
    bool isUserXit = false;
    int list_of_operators = posTerminals[terminal_index]['user'].length;
    for (int x = 0; x < list_of_operators; x++) {
      print(posTerminals[terminal_index]['user'][x]["f_name"]);
      if (_new_user_phone.text == posTerminals[terminal_index]['user'][x]["phone"]) {
          isUserXit = true;
      }
    }

    if (isUserXit) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      setState(() {
        show_user_alreadyExit=true;
      });
    }else{
    String status = "";
    var url = "https://a2ctech.net/api/faspay/_new_terminal_operator.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      //main_account 	tml_account_name 	location 	contact_name 	contact_phone
      "phone": my_num,
      "token": my_token,

      "operator_phone": operator_phone,
      "pass": pass,
      "f_name": f_name,
      "s_name": s_name,
      "terminal_id": terminal_id,

    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      if (data["status"] == "Done") {
        setState(() {
          // my_session();
          fetch_terminals();
         // Navigator.of(context).pop();
          show_preogress=false;
          show_new_operator_added=true;
          terminal_index=terminal_index;
          terminal_load_index=true;
          hide_terminal_request=false;
          status = data["status"];
        });
      } else {}
      setState(() {

      });
    } else {
      print(response.statusCode);
    }
  }
  }

  Future _terminal_request_submit(String tml_account_name,String location,String contact_name,String contact_phone) async {
    show_preogress = true;
    var url = "https://a2ctech.net/api/faspay/_request_terminal.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      //main_account 	tml_account_name 	location 	contact_name 	contact_phone
      "phone": my_num,
      "token": my_token,
      "tml_account_name": tml_account_name,
      "location": location,
      "contact_name": contact_name,
      "contact_phone": contact_phone,
      "user_id": user_id,
      "terminal_price": terminal_price.toString(),
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      if (data["success"] == "true") {
        setState(() {
         // my_session();
          get_customer_details(my_num, my_token);
          show_preogress = false;
          show_trnx_panel=false;
          bool_terminal_request=false;
        });
      } else {}
      setState(() {

      });
    } else {
      print(response.statusCode);
    }
  }
  Future<void> my_session() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var phone = prefs.getString("phone");
    var tokn = prefs.getString("token");

    if (phone == null) {
      logout();
    } else {
      // get_payment_request(phone, tokn);
      get_customer_details(phone, tokn);
      setState(() {
        my_num = phone!;
        my_token = tokn!;
        fetch_terminals();
      });
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

  Future get_customer_details(phone, token) async {
    show_preogress = true;
    FocusScope.of(context).requestFocus(new FocusNode());
    var url = "https://a2ctech.net/api/faspay/user_details.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": phone,
      "token": token,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      if (data["status"] == "true") {
        setState(() {
          hold_balance= double.parse(data["balance"]);
          print(data["price_list"][1]["name"]);
          user_id=data["user_id"];
          terminal_price=double.parse(data["price_list"][1]["amount"]);
          trnx_pin=data["trnxPin"];
print("trnx pin "+trnx_pin);
          if(hold_balance<terminal_price){
            insufficient_Funds=true;
          }
        });
        show_preogress = false;
      } else {
        show_preogress = false;
        logout();
      }

    }
  }
  void fetch_terminals() async {
    try {
      //*************************************************
      var url = "https://a2ctech.net/api/faspay/terminals.php";
      var response;
      response = await http.post(Uri.parse(url), body: {
        "phone": my_num,
        "token": my_token,
      });

      var data = json.decode(response.body);
      if (response.statusCode == 200) {
        posTerminals = (json.decode(response.body) as List)
            .map((item) => item as Map<String, dynamic>)
            .toList();
        print(data);
      } else {
        print(response.statusCode);
       //>>>>>>>>>>>>>>>>>>>>>
        for (int i = 0; i < posTerminals.length; i++) {
          Map<String, dynamic> innerList = posTerminals[i];
          print('Inner list $i:');
          for (int j = 0; j < innerList.length; j++) {
            //String name = innerList[j]['name'];
           // int age = innerList[j]['age'];
           // print('$name is $age years old.');
          }
        }
        //.>>>>>>>>>>>>>>>>>>>>>>>>
      }
//*********************************
    } catch (e) {
      print('Error occurred while fetching data: $e');
    }
  }

}
class Terminals{
  final String id;
  final String isLocked;
  final String name;
  final double location;
  final String user;
  final String lastSeen;

  Terminals(this.id, this.isLocked, this.name, this.location, this.user,
      this.lastSeen);
}
