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

// ignore: must_be_immutable
class CardPage extends StatefulWidget {
  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  double balance = 0;
  var size, height, width;
  final _formKey = GlobalKey<FormState>();
  late String _fullName;
  late String _email;
  late String _phoneNumber;
  late String _address;
  bool check_card=false;
  bool visable_card_request = false;
  bool show_preogress = false;
  TextEditingController txt_full_name = TextEditingController();
  TextEditingController txt_mail = TextEditingController();
  TextEditingController txt_phone = TextEditingController();
  TextEditingController txt_state = TextEditingController();
  TextEditingController txt_lga = TextEditingController();
  TextEditingController txt_ward = TextEditingController();
  TextEditingController txt_near_by = TextEditingController();

  String my_num = "", my_token = "";
  List<Card> cardList = [
    Card('Debit Card', '1234', '02/25', 500.0),
    Card('Credit Card', '5678', '03/26', 1000.0),
  ];

  int currentCardIndex = 0;
  int hold_index = 0;
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
          Visibility(
            visible: false,
              child:  Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
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
                                  myindex = currentCardIndex;
                                  hold_index = currentCardIndex;
                                  print(currentCardIndex);
                                });
                              },
                              onPanDown: (x) {
                                setState(() {
                                  currentCardIndex = index;
                                  print(currentCardIndex);
                                });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: MediaQuery.of(context).size.height * 0.3,
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
                                        'assets/images/card_bg.png',
                                        // color: Colors.blue.shade900,
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            currentCardIndex == index
                                                ? 'Card No. 1234567890'
                                                : 'Card No. **********',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                    ? '02/25'
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
                                                    fontWeight: FontWeight.bold,
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
                                                    fontWeight: FontWeight.bold,
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
                                                color: Colors.grey.withOpacity(0.3),
                                                spreadRadius: 1,
                                                blurRadius: 3,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          height: 50,
                                          width: MediaQuery.of(context).size.width *
                                              0.42,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                myindex = currentCardIndex;
                                              });
                                              if (currentCardIndex == myindex) {
                                                print(myindex);
                                                _showDialog(context, balance);
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(13.0),
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
                                                color: Colors.grey.withOpacity(0.3),
                                                spreadRadius: 1,
                                                blurRadius: 3,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          height: 50,
                                          width: MediaQuery.of(context).size.width *
                                              0.42,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                visable_card_request = true;
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(13.0),
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
                                                color: Colors.grey.withOpacity(0.3),
                                                spreadRadius: 1,
                                                blurRadius: 3,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          height: 50,
                                          width: MediaQuery.of(context).size.width *
                                              0.42,
                                          child: GestureDetector(
                                            child: Padding(
                                              padding: const EdgeInsets.all(13.0),
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
                                                color: Colors.grey.withOpacity(0.3),
                                                spreadRadius: 1,
                                                blurRadius: 3,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          height: 50,
                                          width: MediaQuery.of(context).size.width *
                                              0.42,
                                          child: GestureDetector(
                                            onTap: () {
                                              showSuccessAnimation(context);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(13.0),
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
                                                color: Colors.grey.withOpacity(0.3),
                                                spreadRadius: 1,
                                                blurRadius: 3,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          height: 50,
                                          width: MediaQuery.of(context).size.width *
                                              0.42,
                                          // color: Colors.blue.shade900,
                                          child: GestureDetector(
                                            onTap: () {
                                              print("Voucher");
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(13.0),
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
                                                color: Colors.grey.withOpacity(0.3),
                                                spreadRadius: 1,
                                                blurRadius: 3,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          height: 50,
                                          width: MediaQuery.of(context).size.width *
                                              0.42,
                                          // color: Colors.blue.shade900,
                                          child: GestureDetector(
                                            onTap: () {
                                              print("About Fascard");
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(13.0),
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
                                      width: MediaQuery.of(context).size.width,
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
              ), ),
         check_card?
         Padding(
           padding: const EdgeInsets.all(8.0),
           child: SingleChildScrollView(
             child: Column(
               children: [
                 Container(
                   height: MediaQuery.of(context).size.height * 0.3,
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
                             myindex = currentCardIndex;
                             hold_index = currentCardIndex;
                             print(currentCardIndex);
                           });
                         },
                         onPanDown: (x) {
                           setState(() {
                             currentCardIndex = index;
                             print(currentCardIndex);
                           });
                         },
                         child: Container(
                           width: MediaQuery.of(context).size.width * 0.9,
                           height: MediaQuery.of(context).size.height * 0.3,
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
                                   'assets/images/card_bg.png',
                                   // color: Colors.blue.shade900,
                                 ),
                               ),
                               Column(
                                 mainAxisAlignment:
                                 MainAxisAlignment.spaceEvenly,
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Padding(
                                     padding: EdgeInsets.all(16.0),
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.spaceBetween,
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
                                     padding: const EdgeInsets.symmetric(
                                         horizontal: 20),
                                     child: Text(
                                       currentCardIndex == index
                                           ? 'Card No. 1234567890'
                                           : 'Card No. **********',
                                       style: TextStyle(
                                         color: Colors.white,
                                         fontSize: 20,
                                         fontWeight: FontWeight.bold,
                                       ),
                                     ),
                                   ),
                                   Padding(
                                     padding: const EdgeInsets.symmetric(
                                         horizontal: 20),
                                     child: Row(
                                       mainAxisAlignment:
                                       MainAxisAlignment.spaceBetween,
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
                                               ? '02/25'
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
                                               fontWeight: FontWeight.bold,
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
                                               fontWeight: FontWeight.bold,
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
                                           color: Colors.grey.withOpacity(0.3),
                                           spreadRadius: 1,
                                           blurRadius: 3,
                                           offset: Offset(0, 4),
                                         ),
                                       ],
                                     ),
                                     height: 50,
                                     width: MediaQuery.of(context).size.width *
                                         0.42,
                                     child: GestureDetector(
                                       onTap: () {
                                         setState(() {
                                           myindex = currentCardIndex;
                                         });
                                         if (currentCardIndex == myindex) {
                                           print(myindex);
                                           _showDialog(context, balance);
                                         }
                                       },
                                       child: Padding(
                                         padding: const EdgeInsets.all(13.0),
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
                                           color: Colors.grey.withOpacity(0.3),
                                           spreadRadius: 1,
                                           blurRadius: 3,
                                           offset: Offset(0, 4),
                                         ),
                                       ],
                                     ),
                                     height: 50,
                                     width: MediaQuery.of(context).size.width *
                                         0.42,
                                     child: GestureDetector(
                                       onTap: () {
                                         setState(() {
                                           visable_card_request = true;
                                         });
                                       },
                                       child: Padding(
                                         padding: const EdgeInsets.all(13.0),
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
                                           color: Colors.grey.withOpacity(0.3),
                                           spreadRadius: 1,
                                           blurRadius: 3,
                                           offset: Offset(0, 4),
                                         ),
                                       ],
                                     ),
                                     height: 50,
                                     width: MediaQuery.of(context).size.width *
                                         0.42,
                                     child: GestureDetector(
                                       child: Padding(
                                         padding: const EdgeInsets.all(13.0),
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
                                           color: Colors.grey.withOpacity(0.3),
                                           spreadRadius: 1,
                                           blurRadius: 3,
                                           offset: Offset(0, 4),
                                         ),
                                       ],
                                     ),
                                     height: 50,
                                     width: MediaQuery.of(context).size.width *
                                         0.42,
                                     child: GestureDetector(
                                       onTap: () {
                                         showSuccessAnimation(context);
                                       },
                                       child: Padding(
                                         padding: const EdgeInsets.all(13.0),
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
                                           color: Colors.grey.withOpacity(0.3),
                                           spreadRadius: 1,
                                           blurRadius: 3,
                                           offset: Offset(0, 4),
                                         ),
                                       ],
                                     ),
                                     height: 50,
                                     width: MediaQuery.of(context).size.width *
                                         0.42,
                                     // color: Colors.blue.shade900,
                                     child: GestureDetector(
                                       onTap: () {
                                         print("Voucher");
                                       },
                                       child: Padding(
                                         padding: const EdgeInsets.all(13.0),
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
                                           color: Colors.grey.withOpacity(0.3),
                                           spreadRadius: 1,
                                           blurRadius: 3,
                                           offset: Offset(0, 4),
                                         ),
                                       ],
                                     ),
                                     height: 50,
                                     width: MediaQuery.of(context).size.width *
                                         0.42,
                                     // color: Colors.blue.shade900,
                                     child: GestureDetector(
                                       onTap: () {
                                         print("About Fascard");
                                       },
                                       child: Padding(
                                         padding: const EdgeInsets.all(13.0),
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
                                 width: MediaQuery.of(context).size.width,
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
         :Padding(
             padding:EdgeInsets.all(10),
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
           children: [
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
                icon: Icon( // <-- Icon
                Icons.credit_card,
                  size: 24.0,
                     ),
                 label: Text('Request Card'),
                 style: ElevatedButton.styleFrom(
                   backgroundColor: Colors.blue.shade900, // background (button) color
                   foregroundColor: Colors.white, // foreground (text) color
                 ),// <-- Text
    ),
  ],
)
           ],
         )
         ),

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
        ],
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
    var url = "https://a2ctech.net/api/faspay/card_request.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": phone,
      "token": token,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);

      setState(() {
        //show_preogress = false;.
      });
    }
  }
  _showDialog(BuildContext context, double balance) {
    double amount = 0.0;
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
                if (amount > balance) {
                  // Show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: Amount is greater than balance'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
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
