import 'dart:convert';
import 'dart:math';
import 'package:faspay/pages/cardrequestpage.dart';
import 'package:faspay/pages/dashboard.dart';
import 'package:faspay/pages/homepage.dart';
import 'package:faspay/pages/phonescreen.dart';
import 'package:faspay/pages/resetpinpage.dart';
import 'package:faspay/pages/setpinpage.dart';
import 'package:faspay/pages/variables.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:confirmation_success/confirmation_success.dart';
import 'package:http/http.dart' as http;
import 'package:passcode_screen/keyboard.dart';
import 'package:printing/printing.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_pin_code_widget/flutter_pin_code_widget.dart';
import 'package:pinput/pin_put/pin_put.dart';

class AccountHistory {
  String sender_name;
  String rcva_name;
  double amount;
  String type;
  String dte;
  String trnx_id;
  bool isHidden;
  String sender_s_name;
  String sender_o_name;
  String rcva_s_name;
  String rcva_o_name;
  String Beneficiary_account;
  String tittle_name;

  AccountHistory({
    required this.sender_name,
    required this.rcva_name,
    required this.amount,
    required this.type,
    required this.dte,
    required this.trnx_id,
    required this.sender_s_name,
    required this.sender_o_name,
    required this.rcva_s_name,
    required this.rcva_o_name,
    required this.Beneficiary_account,
    required this.tittle_name,
    this.isHidden = true,
  });
}

// ignore: must_be_immutable
class CardPage extends StatefulWidget {
  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  final List<AccountHistory> _accountData = [];

  final _formKey = GlobalKey<FormState>();

  var size, height, width;

  late String _fullName;
  late String _email;
  late String _phoneNumber;
  late String _address;

  bool check_card = false;
  bool page_loader = false;
  bool visable_card_request = false;
  bool show_preogress = false;
  bool isGrey = false;
  bool card_is_active = false;
  bool _show_pin = false;
  bool isFundCard = false;
  bool isWithdraw = false;
  bool default_pin = false;
  bool _new_pin = false;
  bool _confirm_pin = false;
  bool _isPinVisible = false;
  bool isActive = false;
  bool show_card_activation_panel = false;
  bool isDefault_pin = false;
  bool invalid_default_pin = false;
  bool _pin_create_succss = false;
  bool finished_page_load = false;
  bool change_card_pin = false;
  bool show_success_widget=false;

  double main_account_balance = 0;
  double balance = 0;
  double amount = 0.0, current_card_balance = 0.0;

  TextEditingController txt_full_name = TextEditingController();
  TextEditingController txt_mail = TextEditingController();
  TextEditingController txt_phone = TextEditingController();
  TextEditingController txt_state = TextEditingController();
  TextEditingController txt_lga = TextEditingController();
  TextEditingController txt_ward = TextEditingController();
  TextEditingController txt_near_by = TextEditingController();
  TextEditingController _oldPinController = TextEditingController();
  TextEditingController _newPinController = TextEditingController();
  TextEditingController _confirmPinController = TextEditingController();
  TextEditingController _voucherPinController = TextEditingController();
  TextEditingController _voucherAmountController = TextEditingController();
  TextEditingController set_new_pin = TextEditingController();

  String my_num = "", my_token = "";
  String trnx_pin = "";
  String _action = "";
  String current_card_no = "0";
  String current_card_status = "";
  String trnx_mode = "";
  String _errorMessage = '';
  String? _voucher;
  String _first_pin = "";
  String _second_pin = "";
  String pin_title = "Enter the PIN on the card envelope";

  List<Card> cardList = [];

  int hold_index = 0;
  int currentCardIndex = 0;

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

  void _generateVoucher() {
    var rng = new Random();
    var codeUnits = new List.generate(3, (index) {
      return rng.nextInt(26) + 65; // A-Z
    });
    setState(() {
      var rng = new Random();
      rng.nextInt(3);
      _voucher = new String.fromCharCodes(codeUnits);
      _voucher = "${_voucher}" + rng.nextInt(1000).toString();
    });
  }

  @override
  void initState() {
    my_session();
    super.initState();
  }

  void dispose() {
    _oldPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    _voucherPinController.dispose();
    _voucherAmountController.dispose();

    super.dispose();
  }

  Widget build(BuildContext context) {
    int myindex = 0;
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      body: Stack(
        children: [
          check_card
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                    left: 4.0,
                    right: 4.0,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 220,
                          width: MediaQuery.of(context).size.width,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: cardList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                // set the current card index on tap
                                onTap: () {
                                  setState(() {
                                    currentCardIndex = index;
                                    current_card_no = cardList[index].number;
                                    current_card_status =
                                        cardList[index].card_status;
                                    current_card_balance =
                                        cardList[index].balance;
                                    print("Card Balance" +
                                        current_card_balance.toString());
                                  });
                                },
                                onPanDown: (x) {
                                  setState(() {
                                    currentCardIndex = index;
                                    current_card_no = cardList[index].number;
                                    print(current_card_no.replaceAll(' ', ''));
                                  });
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: currentCardIndex == index
                                        ? Colors.blue.shade900
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Opacity(
                                        opacity: 0.5,
                                        child: Image.asset(
                                          height: 200,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          'assets/images/card_bg.png',
                                          // color: Colors.blue.shade900,
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Debit Card',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.wifi,
                                                  color: Colors.white,
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Card No. ",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                    currentCardIndex == index
                                                        ? '' +
                                                            cardList[index]
                                                                .number
                                                        : ' **********',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  currentCardIndex == index
                                                      ? 'VALID THRU'
                                                      : '**********',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  currentCardIndex == index
                                                      ? cardList[index]
                                                          .expiryDate
                                                      : '*****',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(),
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Center(
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Balance: ",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    currentCardIndex == index
                                                        ? cardList[index]
                                                            .balance
                                                            .toString()
                                                        : '*****',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                            // height: 5,
                            ),
                        Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width,
                          // color: Colors.yellow,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade900,
                                    minimumSize: Size(120, 70),
                                  ),
                                  onPressed: (() {
                                    setState(() {
                                      isFundCard = true;
                                      isWithdraw = false;
                                      myindex = currentCardIndex;
                                      _action = "card_top_up";
                                    });
                                    if (currentCardIndex == myindex) {
                                      current_card_status =
                                          cardList[currentCardIndex]
                                              .card_status;
                                      if (current_card_status == "Pending") {
                                        show_card_activation_panel = true;
                                        // _activate_card(context, true);
                                      } else {
                                        _showDialog(
                                            context, balance, isFundCard);
                                      }
                                    }
                                  }),
                                  child: Text("Fund Card"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade900,
                                    minimumSize: Size(120, 70),
                                  ),
                                  onPressed: (() {
                                    setState(() {
                                      isWithdraw = true;
                                      isFundCard = false;
                                      myindex = currentCardIndex;
                                      _action = "card_withdraw";
                                    });
                                    if (currentCardIndex == myindex) {
                                      print(myindex);
                                      _showDialog(context, balance, isWithdraw);
                                    }
                                  }),
                                  child: Text("Withdraw"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 30,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border(),
                          ),
                          child: Center(
                            child: Text(
                              "Recent Transactions",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SingleChildScrollView(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width,
                            // color: Colors.red,

                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: ListView.builder(
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: _accountData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final AccountHistory account =
                                      _accountData[index];
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        account.isHidden = !account.isHidden;
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 8.0),
                                      padding: EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                account.tittle_name,
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                account.type,
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.grey[600],
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                account.amount
                                                    .toStringAsFixed(2),
                                                style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: account.amount >= 0
                                                      ? Colors.green
                                                      : Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8.0),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    "Processed on:",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                  SizedBox(width: 4.0),
                                                  Text(
                                                    account.dte,
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Reference No: FASPAY/${account.trnx_id}",
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: page_loader
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    child: Image.asset(
                                      fit: BoxFit.contain,
                                      'assets/images/nfc.png',
                                    ),
                                  ),
                                ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "What is Fascard?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Fascard is an advanced NFC enabled debit card that facilitates quick payments using NFC technology. Fascard supports tap to pay, deposits and withdrawals. Order a Fascard today for free and enjoy speedy, safe and secure transactions.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      visable_card_request = true;
                                    });
                                  },
                                  icon: Icon(
                                    // <-- Icon
                                    Icons.credit_card,
                                    size: 24.0,
                                  ),
                                  label: Text('Request Card'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue
                                        .shade900, // background (button) color
                                    foregroundColor:
                                        Colors.white, // foreground (text) color
                                  ), // <-- Text
                                ),
                              ],
                            )
                          ],
                        )
                      : Column()),
          Visibility(
            visible: visable_card_request,
            child: AnimatedOpacity(
              opacity: visable_card_request ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
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
                                    visable_card_request = false;
                                  });
                                },
                              ),
                            ],
                          ),
                          Divider(
                            thickness: 2,
                            color: Colors.green,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Tell us where to deliver your card",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            "Please enter your delivery address, do ensure that the address is correct before submitting this form. \nThank You!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          Flexible(
                              child: Container(
                            height: height - 315,
                            child: ListView(
                              children: [
                                Form(
                                  key: _formKey,
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextFormField(
                                          controller: txt_full_name,
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
                                            labelText: 'Full Name',
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your full name';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _fullName = value!;
                                          },
                                        ),
                                        SizedBox(height: 16),
                                        TextFormField(
                                          controller: txt_mail,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.blue.shade900,
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
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
                                            labelText: 'Email',
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your email';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _email = value!;
                                          },
                                        ),
                                        SizedBox(height: 16),
                                        TextFormField(
                                          controller: txt_phone,
                                          keyboardType: TextInputType.number,
                                          maxLength: 11,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.blue.shade900,
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
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
                                            labelText: 'Phone Number',
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your phone number';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _phoneNumber = value!;
                                          },
                                        ),
                                        SizedBox(height: 16),
                                        TextFormField(
                                          controller: txt_state,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.blue.shade900,
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
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
                                            labelText: 'State',
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your State';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _address = value!;
                                          },
                                        ),
                                        SizedBox(height: 32),
                                        TextFormField(
                                          controller: txt_lga,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.blue.shade900,
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
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
                                            labelText: 'LGA',
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your LGA';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _address = value!;
                                          },
                                        ),
                                        SizedBox(height: 32),
                                        TextFormField(
                                          controller: txt_ward,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.blue.shade900,
                                              ),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
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
                                            labelText: 'Ward',
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your ward';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _address = value!;
                                          },
                                        ),
                                        SizedBox(height: 32),
                                        TextFormField(
                                          controller: txt_near_by,
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
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 15.0,
                                                    horizontal: 15),
                                            labelText: 'Nearest Landmark',
                                          ),
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter a nearest landmark';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) {
                                            _address = value!;
                                          },
                                        ),
                                        SizedBox(height: 32),
                                        Container(
                                          color: Colors.blue.shade900,
                                          height: 50,
                                          child: GestureDetector(
                                            onTap: (() {
                                              // showSuccess(context);
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                _formKey.currentState!.save();
                                                // Submit
                                                card_request(my_num, my_token);
                                              } else {}
                                            }),
                                            child: Center(
                                              child: Text(
                                                "Submit",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
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
          // transaction pin
          Visibility(
            visible: _show_pin,
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 5),
                  const SizedBox(height: 100),
                  Icon(
                    Icons.lock,
                    size: 53,
                  ),
                  const Text(
                    'Enter your transaction pin complete',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: PinCodeWidget(
                      buttonColor: Colors.white,
                      numbersStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      minPinLength: 6,
                      maxPinLength: 6,
                      deleteButtonColor: Colors.white,
                      borderSide: const BorderSide(color: Colors.white),
                      deleteIconColor: Colors.black,
                      onPressColorAnimation: Colors.red,
                      onChangedPin: (String pin) {
                        if (pin == trnx_pin) {
                          _show_pin = false;
                          if (_action == "card_top_up") {
                            current_card_no = cardList[currentCardIndex].number;
                            print("trancmode " + current_card_no);
                            transfer_fund(my_num, my_token);
                          } else if (_action == "card_withdraw") {
                            current_card_no = cardList[currentCardIndex].number;
                            print("trancmode " + current_card_no);
                            withdraw_fund(my_num, my_token);
                          }

                          //transfer_fund(my_num, my_token);
                        }
                        // check the PIN length and check different PINs with 4,5.. length.
                      },
                      onEnter: (pin, _) {
                        // callback user pressed enter
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // card request
          Visibility(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isGrey = false;
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Material(
                                      borderRadius: BorderRadius.circular(5),
                                      child: Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            TextButton.icon(
                                              onPressed: () {
                                                setState(() {
                                                  visable_card_request = true;
                                                  isGrey = false;
                                                });
                                              },
                                              icon: Icon(
                                                // <-- Icon
                                                Icons.add,
                                                size: 24.0,
                                                color: Colors.blue.shade900,
                                              ),
                                              label: Text(
                                                'Request Card',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            TextButton.icon(
                                              onPressed: () {
                                                _showDebitCardSettings(
                                                    context, cardList[currentCardIndex].card_status);
                                                isGrey = false;
                                              },
                                              icon: Icon(
                                                // <-- Icon
                                                Icons.settings,
                                                size: 24.0,
                                                color: Colors.blue.shade900,
                                              ),
                                              label: Text('Card Management',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .black)), // <-- Text
                                            ),
                                            TextButton.icon(
                                              onPressed: () {
                                                isGrey = false;
                                                _generateVoucher();
                                                VoucherBottomSheet(context);
                                              },
                                              icon: Icon(
                                                // <-- Icon
                                                Icons.card_giftcard,
                                                size: 24.0,
                                                color: Colors.blue.shade900,
                                              ),
                                              label: Text('Generate Voucher',
                                                  style: TextStyle(
                                                      color: Colors
                                                          .black)), // <-- Text
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 80,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            visible: isGrey,
          ),
          // set card pin
          if (finished_page_load == true) ...[
            if(!check_card)...[

            ]else...[
              Visibility(
                visible: show_card_activation_panel,
                child: pin(
                    context,
                    set_new_pin,
                    Variable.cardactivation,
                    Variable.card_message,
                    cardList[currentCardIndex].card_pin,
                    Variable.set_card_pin_url),
              ),
            ]

          ],

          // change card pin

          if (finished_page_load == true) ...[
    if(!check_card)...[

    ]else...[
      Visibility(
        visible: change_card_pin,
        child: pin(
            context,
            set_new_pin,
            Variable.reset_pin_title,
            Variable.reset_pin_info,
            cardList[currentCardIndex].card_pin,
            Variable.set_card_pin_url),
      ),
      ]

          ],

          Visibility(
            visible: show_success_widget,
              child: SuccessContainer(),
          ),
          //progress bar
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
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              if (isGrey) {
                isGrey = false;
              } else {
                isGrey = true;
              }
            });
          },
          backgroundColor: Colors.blue.shade900,
          child: Icon(
            Icons.miscellaneous_services_sharp,
            size: 32.0,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget done_widget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _pin_create_succss = false;
        });
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Material(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            child: Icon(
              Icons.done,
              size: 100,
            ),
          ),
        ),
      ),
    );
  }

  Future save_new_pin(account, var url) async {
    //"https://a2ctech.net/api/faspay/_set_card_pin.php"
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": my_num,
      "token": my_token,
      "pin": _first_pin,
      "account": account,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      print(data["status"]);
      if (data["status"] == "true") {
 setState(() {
   show_success_widget=true;
   show_card_activation_panel=false;
   change_card_pin=false;
 });
      } else {}
      setState(() {
        show_preogress = false;
      });
    } else {
      print(response.statusCode);
    }
  }
  Widget SuccessContainer() {
    return GestureDetector(
      onTap: () {
        setState(() {
          show_success_widget = false;
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
                    Text(
                      "Your PIN has been set successfully. Tap outside the box to continue.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue.shade900,
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
  Future<void> _showWarningDialog(BuildContext context, bool isFrozen) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.warning,
                        size: 30,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Warning',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  !isFrozen
                      ? 'Are you sure you want to freeze this Card? Once frozen, you can not be able to use this card for any transaction until this process is reverserd.'
                      : 'Are you sure you want to unfreeze this Card? ',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                setState(
                  () {
                    isActive = !isActive;
                    if(isFrozen==true){
                      _freeze_and_unfreeze_card("Active");
                    }else{
                      _freeze_and_unfreeze_card("Freeze");
                    }

                  },
                );
                Navigator.of(context).pop();
                _showSuccessDialog(context, isFrozen);
              },
              child: isFrozen ? Text('UnFreeze') : Text('Freeze'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: !isFrozen ? Colors.blue.shade900 : Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Widget pin(BuildContext context, TextEditingController pinController,
      String title, String message, String old_pin, var url) {
//https://a2ctech.net/api/faspay/_set_card_pin.php
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
                        onChanged: (v) {
                          if (v.length == 4) {
                            if (v == old_pin) {
                              setState(() {
                                isDefault_pin = true;
                                _first_pin = "";
                                pinController.clear();
                                print("xcccc");
                                pin_title = "Enter new PIN";
                                invalid_default_pin = false;
                              });
                            } else if (isDefault_pin == true) {
                              if (_first_pin == "") {
                                print("1st pin");
                                _first_pin = v;
                                pinController.clear();
                                print(_first_pin);
                                setState(() {
                                  pin_title = "Confirm new PIN";
                                });
                              } else if (_first_pin.isNotEmpty &&
                                  _second_pin == "") {
                                _second_pin = v;
                                if (_first_pin == _second_pin) {
                                  print("correct pin");

                                  save_new_pin(cardList[currentCardIndex].number, url);
                                  setState(() {
                                    show_preogress = true;

                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                  });
                                } else {
                                  setState(() {
                                    pin_title = "Enter PIN from envelope";
                                    pinController.clear();
                                    _first_pin = "";
                                    _second_pin = "";
                                    print("not correct");
                                  });
                                }
                              } else if (_first_pin.isNotEmpty &&
                                  _second_pin.isNotEmpty) {
                                _second_pin = v;
                                if (_first_pin == _second_pin) {
                                  print("correct pin");
                                  save_new_pin(cardList[currentCardIndex].number, url);
                                  setState(() {
                                    pin_title = "Please wait";
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    show_preogress = true;
                                  });
                                } else {
                                  setState(() {
                                    pin_title = "Enter 4-digit PIN";
                                    pinController.clear();
                                    _first_pin = "";
                                    _second_pin = "";
                                    print("not correct");
                                  });
                                }
                              }
                              v = "";
                            } else {
                              setState(() {
                                invalid_default_pin = true;
                                pinController.clear();
                                print("invalid Default pin");
                              });
                            }
                          }
                        },
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
                      Text(
                        pin_title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                      if (invalid_default_pin == true) ...[
                        Text(
                          "Invalid Default PIN",
                          style: TextStyle(
                              fontSize: 18,
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

  void _changePIN(BuildContext context, bool isPIN) {
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
                        'Reset PIN',
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
                        "Please enter your old PIN and new PIN below:",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _oldPinController,
                        maxLength: isPIN ? 4 : 25,
                        keyboardType:
                            isPIN ? TextInputType.number : TextInputType.text,
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
                          labelText: 'Old PIN',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLength: isPIN ? 4 : 25,
                        keyboardType:
                            isPIN ? TextInputType.number : TextInputType.text,
                        controller: _newPinController,
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
                          labelText: 'New PIN',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        maxLength: isPIN ? 4 : 25,
                        keyboardType:
                            isPIN ? TextInputType.number : TextInputType.text,
                        controller: _confirmPinController,
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
                            vertical: 15.0,
                            horizontal: 15,
                          ),
                          labelText: 'Confirm PIN',
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
                          Text('Show PIN'),
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
                  onPressed: _changePin,
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _activate_card(BuildContext context, bool isPIN) {
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
                        'Activate Card',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      Expanded(
                          child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "X",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                  Divider(),
                ],
              ),
              content: Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    //crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Before you fund your card, please enter the PIN from the card envelope and your preferred PIN below:",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _oldPinController,
                        maxLength: isPIN ? 4 : 25,
                        keyboardType:
                            isPIN ? TextInputType.number : TextInputType.text,
                        obscureText: !_isPinVisible,
                        enableSuggestions: false,
                        autocorrect: false,
                        onChanged: (txt) {
                          if (txt.length == 4) {
                            print("is ok");

                            setState(() {
                              default_pin = true;
                            });
                          } else {
                            print("not working");
                            setState(() {
                              default_pin = false;
                            });
                          }
                        },
                        decoration: default_pin
                            ? InputDecoration(
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
                                labelText: 'Default PIN',
                              )
                            : InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red.shade900,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.red.shade900,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 15),
                                labelText: 'Default PIN',
                              ),
                      ),
                      TextFormField(
                        maxLength: isPIN ? 4 : 25,
                        keyboardType:
                            isPIN ? TextInputType.number : TextInputType.text,
                        controller: _newPinController,
                        obscureText: !_isPinVisible,
                        enableSuggestions: false,
                        autocorrect: false,
                        onChanged: (txt) {
                          if (txt.length == 4) {
                            setState(() {
                              _new_pin = true;
                            });
                          } else {
                            setState(() {
                              _new_pin = false;
                            });
                          }
                        },
                        decoration: _new_pin
                            ? InputDecoration(
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
                                labelText: 'Default PIN',
                              )
                            : InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red.shade900,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2,
                                    color: Colors.red.shade900,
                                  ),
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 15),
                                labelText: 'Default PIN',
                              ),
                      ),
                      TextFormField(
                        maxLength: isPIN ? 4 : 25,
                        keyboardType:
                            isPIN ? TextInputType.number : TextInputType.text,
                        controller: _confirmPinController,
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
                            vertical: 15.0,
                            horizontal: 15,
                          ),
                          labelText: 'Confirm PIN',
                        ),
                      ),
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
                          Text('Show PIN'),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: Text('Cancel'),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade900,
                            ),
                            onPressed: _changePin,
                            child: Padding(
                              padding: EdgeInsets.all(6),
                              child: Text('Save'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

// Create a function to show the success dialog
  Future<void> _showSuccessDialog(BuildContext context, bool isFrozen) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap a button to close the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Success!',
              style: TextStyle(
                color: Colors.blue.shade900,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Icon(Icons.check_circle, color: Colors.blue.shade900, size: 80),
                SizedBox(
                  height: 20,
                ),
                !isFrozen
                    ? Center(
                        child: Text(
                          'Your card is temporarily blocked.',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : Center(
                        child: Text(
                          "Your card is now active.",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showDebitCardSettings(BuildContext context, String status) {
    bool isFrozen;
    if(status=="Freeze"){
      isFrozen=true;
    }else{
      isFrozen=false;
    }
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
                      'Card Management',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                "Card Details",
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
                      "Available Balance : ",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "NGN " + cardList[currentCardIndex].balance.toString(),
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Card Number : ",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      cardList[currentCardIndex].number,
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Expiry Date : ",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      cardList[currentCardIndex].expiryDate,
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                      setState(() {
                        Navigator.of(context).pop();
                        change_card_pin = true;
                      });
                      // _changePIN(context, true);
                    },
                    child: Text('Reset PIN'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showWarningDialog(context, isFrozen);
                    },
                    child: Text(isFrozen ? 'UnFreeze Card' : "Freeze Card"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isFrozen ? Colors.blue.shade900 : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void VoucherBottomSheet(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Wrap(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 30.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Transaction Voucher',
                                style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          height: 2,
                          color: Colors.blue.shade900,
                        ),
                        SizedBox(height: 15.0),
                        Text(
                          "Please kindly use the voucher below to complete your transaction when requested.",
                          style: TextStyle(
                            fontSize: 12.0,
                            // fontWeight: FontWeight.bold,
                            color: Colors.grey.shade900,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Container(
                          child: Column(
                            children: [
                              Text(
                                _voucher ?? "",
                                style: TextStyle(
                                  color: Colors.blue.shade900,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10.0),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _voucherAmountController,
                                obscureText: false,
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
                                  labelText: 'Amount',
                                ),
                              ),
                              SizedBox(height: 16.0),
                              TextFormField(
                                maxLength: 4,
                                keyboardType: TextInputType.number,
                                controller: _voucherPinController,
                                obscureText: false,
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
                                  labelText: 'Voucher PIN',
                                ),
                              ),
                              SizedBox(height: 16.0),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade900,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();

                                  generate_voucher(my_num, my_token,
                                      cardList[currentCardIndex].number);
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text("Activate Voucher"),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
        fetch_cards(my_num, my_token);
        fetch_transaction();
      });
    }
  }

  Future generate_voucher(phone, token, account) async {
    show_preogress = true;
    FocusScope.of(context).requestFocus(new FocusNode());
    var url = "https://a2ctech.net/api/faspay/_save_voucher.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": phone,
      "token": token,
      "account": account,
      "amount": _voucherAmountController.text,
      "v_pin": _voucherPinController.text,
      "v_code": _voucher,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);

      if (data["status"] == "Done") {
        // print("DONE!!!");
        showSuccessAnimation_voucher(
            context, _voucher.toString(), _voucherPinController.text);
        show_preogress = false;
        _voucherAmountController.text = "";
        _voucherPinController.text = "";
      } else {
        show_preogress = false;
        showFailsAnimation(context);
        // logout();
      }
      setState(() {});
    }
  }

  Future transfer_fund(phone, token) async {
    show_preogress = true;
    FocusScope.of(context).requestFocus(new FocusNode());
    var url = "https://a2ctech.net/api/faspay/internal_transfer.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": phone,
      "token": token,
      "to": current_card_no,
      "amount": amount.toString(),
      "mode": trnx_mode,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);

      if (data["status"] == "true") {
        // print("DONE!!!");
        showSuccessAnimation(context);
        show_preogress = false;
      } else {
        show_preogress = false;
        // logout();
      }
      setState(() {});
    }
  }

  Future withdraw_fund(phone, token) async {
    show_preogress = true;
    FocusScope.of(context).requestFocus(new FocusNode());
    var url = "https://a2ctech.net/api/faspay/withdraw_from_card.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": phone,
      "token": token,
      "to": current_card_no,
      "amount": amount.toString(),
      "mode": trnx_mode,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);

      if (data["status"] == "true") {
        // print("DONE!!!");
        showSuccessAnimation(context);
        show_preogress = false;
      } else {
        show_preogress = false;
        // logout();
      }
      setState(() {});
    }
  }

  Future<void> logout() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("phone");

    goto_phone_screen(context);
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
        String bal = data["balance"];
        print(bal);
        main_account_balance = double.parse(bal);
        show_preogress = false;
        finished_page_load = true;
      } else {
        show_preogress = false;
        logout();
      }
      setState(() {
        //show_preogress = false;.
      });
    }
  }

  void goto_phone_screen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PhoneScreen()),
    );
  }

  Future fetch_transaction() async {
    var url = "https://a2ctech.net/api/faspay/fetch_transaction.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": my_num,
      "token": my_token,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      // print(data["x"]);

      for (var data in data) {
        //print(data["rcver"][0]["f_name"]);
        String my_account = my_num.substring(1);
        if (my_account == data["rcver_account"]) {
          if (data["mode_of_trnx"] == "Card Deposit") {
          } else {
            _accountData.add(new AccountHistory(
                sender_name: data["sender"][0]["f_name"],
                rcva_name: data["rcver"][0]["f_name"],
                amount: double.parse(data["amount"]),
                type: data["trnx_type"],
                dte: data["dte"],
                trnx_id: data["tranx_id"],
                sender_s_name: data["sender"][0]["s_name"],
                sender_o_name: data["sender"][0]["o_name"],
                rcva_s_name: data["rcver"][0]["s_name"],
                rcva_o_name: data["rcver"][0]["o_name"],
                Beneficiary_account: data["rcver_account"],
                tittle_name: data["sender"][0]["f_name"]));
          }
        } else {
          _accountData.add(new AccountHistory(
              sender_name: data["sender"][0]["f_name"],
              rcva_name: data["rcver"][0]["f_name"],
              amount: double.parse(data["amount"]),
              type: data["trnx_type"],
              dte: data["dte"],
              trnx_id: data["tranx_id"],
              sender_s_name: data["sender"][0]["s_name"],
              sender_o_name: data["sender"][0]["o_name"],
              rcva_s_name: data["rcver"][0]["s_name"],
              rcva_o_name: data["rcver"][0]["o_name"],
              Beneficiary_account: data["rcver_account"],
              tittle_name: data["rcver"][0]["f_name"]));
        }
      }

      setState(() {
        show_preogress = false;
      });
    } else {
      print(response.statusCode);
    }
  }

  void showSuccessAnimation_card_request(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height / 2.5,
            width: MediaQuery.of(context).size.height - 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Icon(
                  Icons.credit_card,
                  color: Colors.green,
                  size: 80,
                ),
                SizedBox(height: 20),
                Text(
                  "Card Request Submit Successful!",
                  style: TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "will reach you shortly ",
                  style: TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: (() {
                    Navigator.pop(context);
                    visable_card_request = false;
                  }),
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showSuccessAnimation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height / 3,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 80,
                ),
                SizedBox(height: 20),
                Text(
                  "Transaction Successful!",
                  style: TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: (() {
                    Navigator.pop(context);
                    cardList.clear();
                    fetch_cards(my_num, my_token);
                    setState(() {});
                  }),
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showSuccessAnimation_voucher(
      BuildContext context, String v_code, String v_pin) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height / 3,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      SizedBox(
                          // height: 10,
                          ),
                      Icon(
                        Icons.check_circle,
                        color: Colors.blue.shade900,
                        size: 80,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Successful",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Divider(),
                      Row(
                        children: [
                          Text("Voucher Code: "),
                          Text(
                            v_code,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text("Voucher PIN:     "),
                          Text(
                            v_pin,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: (() {
                    Navigator.pop(context);
                    cardList.clear();
                    fetch_cards(my_num, my_token);
                    setState(() {});
                  }),
                  child: Text(
                    "DONE",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showFailsAnimation(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            height: MediaQuery.of(context).size.height / 3,
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                  size: 80,
                ),
                SizedBox(height: 20),
                Text(
                  "Fail Try Again!",
                  style: TextStyle(
                    fontSize: 20,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: (() {
                    Navigator.pop(context);
                    cardList.clear();
                    fetch_cards(my_num, my_token);
                    setState(() {});
                  }),
                  child: Text(
                    "OK",
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future card_request(phone, token) async {
    show_preogress = true;
    FocusScope.of(context).requestFocus(new FocusNode());
    var url = "https://a2ctech.net/api/faspay/card_request.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": phone,
      "token": token,
      "txt_full_name": txt_full_name.text,
      "txt_mail": txt_mail.text,
      "txt_phone": txt_phone.text,
      "txt_state": txt_state.text,
      "txt_lga": txt_lga.text,
      "txt_ward": txt_ward.text,
      "txt_near_by": txt_near_by.text,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);

      if (data["success"] == "true") {
        print("DONE!!!");
        showSuccessAnimation_card_request(context);

        show_preogress = false;
      } else {
        show_preogress = false;
        // logout();
      }
      setState(() {
        //show_preogress = false;.
      });
    }
  }

  Future fetch_cards(phone, token) async {
    show_preogress = true;
    FocusScope.of(context).requestFocus(new FocusNode());
    var url = "https://a2ctech.net/api/faspay/fetch_cards.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": phone,
      "token": token,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      for (var data in data) {
        if (data["card_checker"] == "false") {
          check_card = false;
          page_loader = true;
        } else {
          cardList.add(new Card(
              "Debit",
              data["account_no"],
              data["expire"],
              double.parse(data["balance"][0]["balance"]),
              data["status"],
              data["card_pin"]));
          setState(() {
            check_card = true;
            page_loader = true;
          });
        }
      }
      get_customer_details(phone, token);
    }
  }
  Future _freeze_and_unfreeze_card(String take_action) async {
    var url = "https://a2ctech.net/api/faspay/_freez_card.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": my_num,
      "token": my_token,
      "action": take_action,
      "account": cardList[currentCardIndex].number,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      print(data["status"]);
      if (data["status"] == "true") {
        setState(() {
          my_session();

        });
        // get_customer_details(my_num, my_token);
      } else {}
      setState(() {

      });
    } else {
      print(response.statusCode);
    }
  }

  _showDialog(BuildContext context, double balance, bool isWithdraw) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Enter an Amount',
            style: TextStyle(
              color: Colors.blue.shade900,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextFormField(
            keyboardType: TextInputType.number,
            onChanged: (value) {
              amount = double.tryParse(value) ?? 0.0;
            },
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
                fontSize: 14,
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
              labelText: 'Amount',
              hintText: 'Enter amount',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Discard',
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Proceed',
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                if (_action == "card_top_up") {
                  if (amount > main_account_balance) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: Amount is greater than balance'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    _show_pin = isWithdraw;
                    Navigator.of(context).pop();
                  }
                } else if (_action == "card_withdraw") {
                  if (amount > current_card_balance) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: Amount is greater than balance'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    _show_pin = isWithdraw;
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }
}

class Card {
  final String type;
  final String number;
  final String expiryDate;
  final double balance;
  final String card_status;
  final String card_pin;

  Card(this.type, this.number, this.expiryDate, this.balance, this.card_status,
      this.card_pin);
}
