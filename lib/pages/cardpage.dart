import 'dart:convert';

import 'package:faspay/pages/cardrequestpage.dart';
import 'package:faspay/pages/phonescreen.dart';
import 'package:faspay/pages/resetpinpage.dart';
import 'package:faspay/pages/setpinpage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:confirmation_success/confirmation_success.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_pin_code_widget/flutter_pin_code_widget.dart';

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

  double balance = 0;
  var size, height, width;
  final _formKey = GlobalKey<FormState>();
  late String _fullName;
  late String _email;
  late String _phoneNumber;
  late String _address;
  bool check_card = false;
  bool visable_card_request = false;
  bool show_preogress = false;
  double main_account_balance = 0;
  TextEditingController txt_full_name = TextEditingController();
  TextEditingController txt_mail = TextEditingController();
  TextEditingController txt_phone = TextEditingController();
  TextEditingController txt_state = TextEditingController();
  TextEditingController txt_lga = TextEditingController();
  TextEditingController txt_ward = TextEditingController();
  TextEditingController txt_near_by = TextEditingController();
  bool _show_pin = false;
  String my_num = "", my_token = "";
  String trnx_pin = "111111";
  List<Card> cardList = [];
  String _action = "";
  int currentCardIndex = 0;
  String current_card_no = "xx";
  int hold_index = 0;
  String trnx_mode = "";
  double amount = 0.0;
  @override
  void initState() {
    my_session();
    super.initState();
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
                  padding: const EdgeInsets.all(8.0),
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
                                    print(current_card_no);
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
                                      check_card = false;
                                    });
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
                                      check_card = false;
                                    });
                                  }),
                                  child: Text("Withdraw"),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                              bottom: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Recent Transactions",
                              style: TextStyle(
                                fontSize: 18,
                                // fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(),
                        // Expanded(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(12.0),
                        //     child: ListView.builder(
                        //       physics: AlwaysScrollableScrollPhysics(),
                        //       itemCount: _accountData.length,
                        //       itemBuilder: (BuildContext context, int index) {
                        //         final AccountHistory account =
                        //             _accountData[index];
                        //         return GestureDetector(
                        //           onTap: () {
                        //             setState(() {
                        //               account.isHidden = !account.isHidden;
                        //             });
                        //           },
                        //           child: Container(
                        //             margin: EdgeInsets.only(bottom: 8.0),
                        //             padding: EdgeInsets.all(16.0),
                        //             decoration: BoxDecoration(
                        //               color: Colors.white,
                        //               borderRadius: BorderRadius.circular(8.0),
                        //               boxShadow: [
                        //                 BoxShadow(
                        //                   color: Colors.grey.withOpacity(0.3),
                        //                   spreadRadius: 1,
                        //                   blurRadius: 3,
                        //                   offset: Offset(0, 2),
                        //                 ),
                        //               ],
                        //             ),
                        //             child: Column(
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.start,
                        //               children: [
                        //                 Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.spaceBetween,
                        //                   children: [
                        //                     Text(
                        //                       account.tittle_name,
                        //                       style: TextStyle(
                        //                         fontSize: 14.0,
                        //                         fontWeight: FontWeight.bold,
                        //                       ),
                        //                     ),
                        //                     Text(
                        //                       account.type,
                        //                       style: TextStyle(
                        //                         fontSize: 14.0,
                        //                         color: Colors.grey[600],
                        //                         fontWeight: FontWeight.bold,
                        //                       ),
                        //                     ),
                        //                     Text(
                        //                       account.amount.toStringAsFixed(2),
                        //                       style: TextStyle(
                        //                         fontSize: 14.0,
                        //                         fontWeight: FontWeight.bold,
                        //                         color: account.amount >= 0
                        //                             ? Colors.green
                        //                             : Colors.red,
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //                 SizedBox(height: 8.0),
                        //                 Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.spaceBetween,
                        //                   children: [
                        //                     Row(
                        //                       children: [
                        //                         Text(
                        //                           "Processed on:",
                        //                           style: TextStyle(
                        //                             fontSize: 12.0,
                        //                             color: Colors.grey[600],
                        //                           ),
                        //                         ),
                        //                         SizedBox(width: 4.0),
                        //                         Text(
                        //                           account.dte,
                        //                           style: TextStyle(
                        //                             fontSize: 12.0,
                        //                             color: Colors.grey[600],
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ],
                        //                 ),
                        //                 Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.spaceBetween,
                        //                   children: [
                        //                     Text(
                        //                       "Reference No: FASPAY/${account.trnx_id}",
                        //                       style: TextStyle(
                        //                         fontSize: 12.0,
                        //                         color: Colors.grey[600],
                        //                       ),
                        //                     ),
                        //                     Row(
                        //                       mainAxisAlignment:
                        //                           MainAxisAlignment.end,
                        //                       children: [
                        //                         IconButton(
                        //                           icon: Icon(
                        //                             Icons.picture_as_pdf,
                        //                             color: Colors.red,
                        //                           ),
                        //                           onPressed: () {
                        //                             print("Pressed");
                        //                           },
                        //                         ),
                        //                         // IconButton(
                        //                         //   onPressed: () {
                        //                         //     Share.share(
                        //                         //         'Here is my account history: ${account.name}, ${account.amount}');
                        //                         //   },
                        //                         //   icon: Icon(Icons.share),
                        //                         // ),
                        //                       ],
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         );
                        //       },
                        //     ),
                        //   ),
                        // ),
                        Column(
                          children: [
                            Divider(),
                            Padding(
                              padding: EdgeInsets.all(
                                8.0,
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: SizedBox(
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  spreadRadius: 1,
                                                  blurRadius: 3,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.42,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  myindex = currentCardIndex;
                                                });
                                                if (currentCardIndex ==
                                                    myindex) {
                                                  print(myindex);
                                                  _showDialog(context, balance);
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(13.0),
                                                child: Text(
                                                  "Fund Card",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue.shade900,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  spreadRadius: 1,
                                                  blurRadius: 3,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.42,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  visable_card_request = true;
                                                });
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(13.0),
                                                child: Text(
                                                  "Request Card",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue.shade900,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  spreadRadius: 1,
                                                  blurRadius: 3,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.42,
                                            child: GestureDetector(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(13.0),
                                                child: Text(
                                                  "Manage PIN",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue.shade900,
                                                  ),
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.of(context).pop();
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ResetPinPage(),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  spreadRadius: 1,
                                                  blurRadius: 3,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.42,
                                            child: GestureDetector(
                                              onTap: () {
                                                showSuccessAnimation(context);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(13.0),
                                                child: Text(
                                                  "Card Limit",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue.shade900,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  spreadRadius: 1,
                                                  blurRadius: 3,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.42,
                                            // color: Colors.blue.shade900,
                                            child: GestureDetector(
                                              onTap: () {
                                                print("Voucher");
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(13.0),
                                                child: Text(
                                                  "Generate Voucher",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue.shade900,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  spreadRadius: 1,
                                                  blurRadius: 3,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.42,
                                            // color: Colors.blue.shade900,
                                            child: GestureDetector(
                                              onTap: () {
                                                print("About Fascard");
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(13.0),
                                                child: Text(
                                                  "About Fascard",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue.shade900,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  spreadRadius: 1,
                                                  blurRadius: 3,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.42,
                                            // color: Colors.blue.shade900,
                                            child: GestureDetector(
                                              onTap: () {
                                                print("Voucher");
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(13.0),
                                                child: Text(
                                                  "Generate Voucher",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue.shade900,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.grey,
                                                width: 1,
                                              ),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  spreadRadius: 1,
                                                  blurRadius: 3,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            height: 50,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.42,
                                            // color: Colors.blue.shade900,
                                            child: GestureDetector(
                                              onTap: () {
                                                print("About Fascard");
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(13.0),
                                                child: Text(
                                                  "About Fascard",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue.shade900,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Container(
                                        color: Colors.blue.shade900,
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: GestureDetector(
                                          onTap: () {
                                            showSuccessAnimation_card_request(
                                                context);
                                            print("Deactivate");
                                          },
                                          child: Center(
                                            child: Text(
                                              "Deactivate Card",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/nfc_sample.png',
                              height: 300.0,
                              // color: Colors.blue.shade900,
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "About NFC Card",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            )
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                                child: Text(
                              "NFC cards have several advantages over traditional contact-based smart cards, including faster transaction times, increased convenience, and improved security features. They are also more durable and resistant to physical wear and tear, making them ideal for use in high-traffic areas.",
                              style: TextStyle(),
                            ))
                          ]),
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
                              backgroundColor: Colors
                                  .blue.shade900, // background (button) color
                              foregroundColor:
                                  Colors.white, // foreground (text) color
                            ), // <-- Text
                          ),
                        ],
                      )
                    ],
                  )),
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
                                              color: Colors.black,
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showVoucher(context);
        },
        child: Icon(Icons.vpn_key),
        backgroundColor: Colors.blue.shade900,
      ),
    );
  }

  _showVoucher(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text("Voucher")),
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                child: Text(
                  "Your voucher code is FV30P, it will expire in 24hrs",
                ),
              ),
            ),
          ],
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
      });
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
        } else {
          cardList.add(new Card("Debit", data["account_no"], data["expire"],
              double.parse(data["balance"][0]["balance"])));
          setState(() {
            check_card = true;
          });
        }
      }
      get_customer_details(phone, token);
    }
  }

  _showDialog(BuildContext context, double balance) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Enter an amount',
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
                if (amount > main_account_balance) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: Amount is greater than balance'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  _action = "card_top_up";
                  _show_pin = true;

                  Navigator.of(context).pop();
                  // onAmountSelected(amount);
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

  Card(this.type, this.number, this.expiryDate, this.balance);
}
