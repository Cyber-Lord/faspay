import 'dart:io';

import 'package:faspay/pages/dashboard.dart';
import 'package:faspay/pages/phonescreen.dart';
import 'package:faspay/pages/qrscan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';

class Qr_result extends StatefulWidget {
  const Qr_result({Key? key, this.qr_coder,}) : super(key: key);
final qr_coder;
  @override
  State<Qr_result> createState() => _Qr_resultState();
}

class _Qr_resultState extends State<Qr_result> {

  var size, height, width;
  final currencyFormatter = NumberFormat('#,##0.00');
  String qr_code="";
  bool show_preogress=true;
  bool show_details=false;
  bool show_qr_not_found=false;
  String account_no="";
  String amount="";
  String account_name="";
  double amount_to_send=0;
  double trnx_fee=0;
  double balance=0;
  String my_num = "", my_token = "";
  @override

  void initState() {
    my_session();
    super.initState();
  }

  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    final currencyFormatter = NumberFormat('#,##0.00');
    return Scaffold(
      appBar: AppBar(
title: Text("Payment"),
      ),
      body:Container(
        color: Colors.black.withOpacity(0.5),
        child: Stack(
          children: [
            Visibility(
              visible: show_details,
                child:Expanded(child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Material(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      child:
                      Container(
                        height: 410,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: ListView(
                            children: [
                              Stack(

                                children: [
                                  Expanded(
                                    child:  Align(
                                      alignment: Alignment.center,
                                      child: Text("Payment",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                                    ),),
                                  Expanded(
                                    child:  Align(
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
                                          onTap: (){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => HomePage(
                                                    phoneNumber: "",
                                                    token: "",
                                                  )),
                                            );
                                          },
                                          child: Icon(Icons.close),
                                        )

                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(height:30,),
                                  Row(
                                    children: [
                                      Text("Account Number",style: TextStyle(fontSize: 13),),
                                      Expanded(
                                        child:  Align(
                                          alignment: Alignment.topRight,
                                          child: Text(account_no,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                                        ),),

                                    ],
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(height:20,),
                                  Row(
                                    children: [
                                      Text("Name",style: TextStyle(fontSize: 13),),
                                      Expanded(
                                        child:  Align(
                                          alignment: Alignment.topRight,
                                          child: Text(account_name,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                                        ),),

                                    ],
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(height:20,),
                                  Row(
                                    children: [
                                      Text("Amount",style: TextStyle(fontSize: 13),),
                                      Expanded(
                                        child:  Align(
                                          alignment: Alignment.topRight,
                                          child: Text("NGN"+currencyFormatter.format(amount_to_send),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                                        ),),

                                    ],
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  SizedBox(height:20,),
                                  Row(
                                    children: [
                                      Text("Fee",style: TextStyle(fontSize: 13),),
                                      Expanded(
                                        child:  Align(
                                          alignment: Alignment.topRight,
                                          child: Text("NGN"+currencyFormatter.format(trnx_fee),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                                        ),),

                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 10,),
                              Material(
                                borderRadius: BorderRadius.circular(20),
                                color: Color(0xFFf9f8f4),
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if(amount_to_send>balance)
                                        Text("insufficient funds",style: TextStyle(fontSize:20,color: Colors.red,fontStyle: FontStyle.italic,fontFamily: 'Corms'),),
                                      // Visibility(child: Text("NGN"+currencyFormatter.format(balance))),
                                      Text("Balance",style:TextStyle(fontSize: 14,fontWeight: FontWeight.bold) ,),
                                      Text("NGN"+currencyFormatter.format(balance))

                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 30,),
                              if(amount_to_send>balance)
                                OutlinedButton(

                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade600,
                                      foregroundColor: Colors.white
                                    //<-- SEE HERE
                                  ),
                                  onPressed:null,
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text("Pay now"),
                                  ),
                                ),
                              if(amount_to_send<balance)
                                OutlinedButton(

                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade900,
                                      foregroundColor: Colors.white
                                    //<-- SEE HERE
                                  ),
                                  onPressed: () {
                                    _showLockScreen(
                                      context,
                                      opaque: false,
                                      cancelButton: Text(
                                        'Cancel',
                                        style: const TextStyle(fontSize: 16, color: Colors.white),
                                        semanticsLabel: 'Cancel',
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text("Pay now"),
                                  ),
                                ),

                            ],
                          ),
                        ),
                      ),
                    )
                  //last one
                ),
                ),

            ),
            Visibility(
                visible: show_preogress,
                child:    Container(

                    color: Colors.black.withOpacity(0.5),
                    child: ListView(
                      children: const [
                        LinearProgressIndicator(
                          semanticsLabel: 'Linear progress indicator',
                        )
                      ],
                    )
                )

            ),
            Visibility(
              visible: show_qr_not_found,
              child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.all(10),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              title: Center(
                child: Row(
                  children: [
                    Icon(
                      Icons.error,color: Colors.red,
                    ),
                    Text(
                      'Error',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
              content: const Text('Invalid Payment Destination in QR Code'),
              actions: [
                TextButton(
                  onPressed: (){
                    goto_dashbord( context);
                  },
                  child: const Text('Close',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                ),
                TextButton(
                  onPressed: (){
                    goto_rescan( context);
                  },
                  child: const Text('Rescan',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                ),
              ],
            ),)
          ],
        ),
      ),

    );
  }
  void goto_dashbord(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage(phoneNumber: "phoneNumber", token: "token")),
    );
  }
  void goto_rescan(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRScanner()),
    );
  }
  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.all(10),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          title: Center(
            child: Text(
              'Notification',
              style: TextStyle(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          actions: [

          ],
        );
      },
    );
  }
  Future pay_now(phone, token) async {
    show_preogress = true;
    print("phone"+token);
    FocusScope.of(context).requestFocus(new FocusNode());
    var url = "https://a2ctech.net/api/faspay/new_qr_transfer.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": phone,
      "token": token,
      "qr_code": widget.qr_coder,
      "amount": amount,
      "to": account_no,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      if (data["status"] == "true") {

        show_preogress = false;
        goto_dashbord( context);
      } else {

        show_preogress = false;
        // logout();
      }
      setState(() {

        //show_preogress = false;.
      });
    }

  }
  Future get_payment_request(phone, token) async {
    show_preogress = true;
    FocusScope.of(context).requestFocus(new FocusNode());
    var url = "https://a2ctech.net/api/faspay/get_request_payment.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": phone,
      "token": token,
      "qr_code": widget.qr_coder,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      if (data["status"] == "true") {
        account_name = data["full_name"];
        String bal = data["balance"];
        balance = double.parse(bal);
        account_no=data["account"];
        amount_to_send=double.parse(data["amount"]);
        trnx_fee=double.parse(data["fee"]);
        amount=data["amount"];
        show_preogress = false;
        show_details=true;
      } else {
        show_qr_not_found=true;
        show_preogress = false;
        // logout();
      }
      setState(() {

        //show_preogress = false;.
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
  Future<void> my_session() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var phone = prefs.getString("phone");
    var tokn = prefs.getString("token");

    if (phone == null) {
      logout();
    } else {

     // get_payment_request(phone, tokn);
      //get_customer_details(phone, my_token);
      setState(() {
        my_num = phone!;
        my_token = tokn!;
        print("nums"+my_token);
        get_payment_request(my_num, my_token);

      });
    }
  }

  String getCurrency(context) {
    var format = NumberFormat.simpleCurrency(locale: Platform.localeName, name: 'NGN');
    return format.currencySymbol;
  }
   currency() {
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: Platform.localeName,name: "NGN");
 return format.currencySymbol;
  }
  void open_pass_code(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
    );
  }
  //***********************************
  final StreamController<bool> _verificationNotifier =
  StreamController<bool>.broadcast();

  bool isAuthenticated = false;
  _showLockScreen(
      BuildContext context, {
        required bool opaque,
        CircleUIConfig? circleUIConfig,
        KeyboardUIConfig? keyboardUIConfig,
        required Widget cancelButton,
        List<String>? digits,
      }) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
                title: Text(
                  'Enter Transaction PIN',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
                circleUIConfig: circleUIConfig,
                keyboardUIConfig: keyboardUIConfig,
                passwordEnteredCallback: _onPasscodeEntered,
                cancelButton: cancelButton,
                deleteButton: Text(
                  'Delete',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  semanticsLabel: 'Delete',
                ),
                shouldTriggerVerification: _verificationNotifier.stream,
                backgroundColor: Colors.black.withOpacity(0.8),
                cancelCallback: _onPasscodeCancelled,
                digits: digits,
                passwordDigits: 6,
                bottomWidget: _buildPasscodeRestoreButton(),
              ),
        ));
  }

  _onPasscodeEntered(String enteredPasscode) {
    bool isValid = storedPasscode == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      setState(() {
        pay_now(my_num, my_token);
        this.isAuthenticated = isValid;
      });
    }
  }

  _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  _buildPasscodeRestoreButton() => Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      margin: const EdgeInsets.only(bottom: 10.0, top: 20.0),
      child: TextButton(
        child: Text(
          "Reset passcode",
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w300),
        ),
        onPressed: _resetAppPassword,
        // splashColor: Colors.white.withOpacity(0.4),
        // highlightColor: Colors.white.withOpacity(0.2),
        // ),
      ),
    ),
  );

  _resetAppPassword() {
    Navigator.maybePop(context).then((result) {
      if (!result) {
        return;
      }
      _showRestoreDialog(() {
        Navigator.maybePop(context);
        //TODO: Clear your stored passcode here
      });
    });
  }

  _showRestoreDialog(VoidCallback onAccepted) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Reset passcode",
            style: const TextStyle(color: Colors.black87),
          ),
          content: Text(
            "Passcode reset is a non-secure operation!\n\nConsider removing all user data if this action performed.",
            style: const TextStyle(color: Colors.black87),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: Text(
                "Cancel",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
            TextButton(
              child: Text(
                "I understand",
                style: const TextStyle(fontSize: 18),
              ),
              onPressed: onAccepted,
            ),
          ],
        );
      },
    );
  }
//**************************************
}
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
const storedPasscode = '123456';
