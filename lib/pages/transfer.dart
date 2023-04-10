import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:faspay/pages/phonescreen.dart';
import 'package:faspay/pages/transferpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'homepage.dart';
import 'package:flutter_pin_code_widget/flutter_pin_code_widget.dart';

class Transfer extends StatefulWidget {
  const Transfer({Key? key}) : super(key: key);

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  //final List<AccountHistory> _accountData = [];
  var size, height, width;
  bool show_preogress = false;
  bool size_transaction_container = false;
  bool show_confirm_info = false;
  bool show_account_not_found = false;
  bool progress_bar_load_transaction = true;
  bool _show_amount_panel = false;
  bool _account_history_visable = true;
  bool _show_pin = false;
  String trnx_pin = "";
  String my_num = "", my_token = "";
  String account_name = "";
  String account_no = "";
  double balance = 0;
  double hold_amount = 0;
  bool allow_proceed_btn = true;
  double amount_to_send = 0;
  late Timer _timer;
  final List<AccountHistory> _accountData = [];
  final currencyFormatter = NumberFormat('#,##0.00');
  final TextEditingController _accountNumberController =
      TextEditingController();
  TextEditingController txt_in_account_n0 = TextEditingController();
  TextEditingController txt_amount = TextEditingController();
  TextEditingController note = TextEditingController();
  @override
  void initState() {
    my_session();
    super.initState();
  }

  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      backgroundColor: Color(0xFFf1f1f9),
      appBar: AppBar(
        title: Text("To FasPay"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  phoneNumber: '',
                  token: '',
                ),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Material(
                    elevation: 5,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.search,
                            size: 30,
                          ),
                          new Flexible(
                            child: new TextField(
                              controller: txt_in_account_n0,
                              maxLength: 10,
                              keyboardType: TextInputType.phone,

                              onTap: () {
                                size_transaction_container = true;
                              },

                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 15),
                                hintText: "E.g 8012345678",
                                labelText: "Account number",
                                border: InputBorder.none,
                                counterText: "",
                              ),

                              // onTapOutside: (e){
                              //   FocusScope.of(context).requestFocus(new FocusNode());
                              //   _timer = new Timer(const Duration(milliseconds: 400), () {
                              //    setState(() {
                              //      size_transaction_container=false;
                              //    });
                              //   });
                              // },
                              onChanged: (e) {
                                if (e.length == 10) {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                  show_preogress = true;
                                  account_no = e;
                                  verify_account_no(my_num, my_token);
                                  _timer = new Timer(
                                      const Duration(milliseconds: 400), () {
                                    setState(() {
                                      size_transaction_container = false;
                                    });
                                  });
                                }
                              },
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                _selectContact();
                              },
                              child: Icon(
                                Icons.contacts,
                                size: 30,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Recents",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ),
                  Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          height: size_transaction_container != true
                              ? height - 242
                              //?height/3
                              : height / 2.5,
                          //height: height-242,
                          child: Stack(
                            children: [
                              Visibility(
                                  visible: progress_bar_load_transaction,
                                  child: Container(
                                      child: ListView(
                                    children: const [
                                      LinearProgressIndicator(
                                        semanticsLabel:
                                            'Linear progress indicator',
                                      )
                                    ],
                                  ))),
                              Column(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Visibility(
                                        visible: _account_history_visable,
                                        child: ListView.builder(
                                          physics:
                                              AlwaysScrollableScrollPhysics(),
                                          itemCount: _accountData.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final AccountHistory account =
                                                _accountData[index];
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  account.isHidden =
                                                      !account.isHidden;
                                                  account_no =
                                                      account.account_no_his;
                                                  verify_account_no(
                                                      my_num, my_token);
                                                });
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 8.0),
                                                padding: EdgeInsets.all(16.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
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
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          account.name +
                                                              "(" +
                                                              account
                                                                  .account_no_his +
                                                              ")",
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          account.amount
                                                              .toStringAsFixed(
                                                                  2),
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: account
                                                                        .amount >=
                                                                    0
                                                                ? Colors.green
                                                                : Colors.red,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 8.0),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Processed on:",
                                                              style: TextStyle(
                                                                fontSize: 12.0,
                                                                color: Colors
                                                                    .grey[600],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                width: 4.0),
                                                            Text(
                                                              account.dte,
                                                              style: TextStyle(
                                                                fontSize: 12.0,
                                                                color: Colors
                                                                    .grey[600],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          "Reference No: FASPAY/${account.trnx_id}",
                                                          style: TextStyle(
                                                            fontSize: 12.0,
                                                            color: Colors
                                                                .grey[600],
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Icon(
                                                              account.amount >=
                                                                      0
                                                                  ? Icons
                                                                      .arrow_back
                                                                  : Icons
                                                                      .arrow_forward,
                                                              color:
                                                                  account.amount >=
                                                                          0
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .red,
                                                            )
                                                          ],
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
                            ],
                          )))
                ],
              ),
            ),
          ),
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
          Visibility(child: _verify_account()),
          Visibility(
            visible: show_account_not_found,
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0))),
                insetPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.all(10),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                title: Center(
                  child: Row(
                    children: [
                      Text(
                        'Confirm Beneficiary',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      )
                    ],
                  ),
                ),
                content: Container(
                  height: 40,
                  child: Column(
                    children: [
                      Divider(),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, //Center Row contents horizontally,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error,
                              color: Colors.red,
                            ),
                            Text('Account Not found'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      show_account_not_found = false;
                    },
                    child: const Text(
                      'Close',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
              visible: _show_amount_panel,
              child: Container(
                color: Color(0xFFf1f1f9),
                child: Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 130,
                            width: width,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Color(0xFFf65433),
                                    backgroundImage: AssetImage(
                                        'assets/images/profile_icon.png'),
                                  ),
                                  Text("To"),
                                  Text(
                                    account_name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text("(" + account_no + ")")
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(20),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              child: Column(
                                children: [
                                  TextFormField(
                                    onTap: () {
                                      size_transaction_container = true;
                                    },
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                    keyboardType:
                                        TextInputType.numberWithOptions(),
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "0.00 NGN",
                                    ),
                                    controller: txt_amount,
                                    onChanged: (val) {
                                      if (val == "") {
                                        setState(() {
                                          hold_amount = 0;
                                        });
                                      } else {
                                        hold_amount = double.parse(val);

                                        print(hold_amount);
                                        setState(() {
                                          if (hold_amount > balance) {
                                            allow_proceed_btn = true;
                                            print(allow_proceed_btn);
                                          } else {
                                            allow_proceed_btn = false;
                                            print(allow_proceed_btn);
                                          }
                                        });
                                      }
                                    },
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'),
                                      ),
                                      FilteringTextInputFormatter.deny(
                                        RegExp(
                                            r'^0+'), //users can't type 0 at 1st position
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Text(
                                    "Available Balance:" +
                                        "N" +
                                        currencyFormatter.format(balance),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.green,
                                    ),
                                  ),
                                  if (hold_amount > balance)
                                    Text(
                                      "insufficient funds",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  TextField(
                                    controller: note,
                                    maxLength: 50,
                                    decoration: InputDecoration(
                                      hintText: "Note",
                                      prefixIcon: Icon(Icons.edit_note),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Flexible(
                          child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: width,
                            child: proceed_btn(),
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
              )),
          Visibility(
            visible: _show_pin,
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'NGN' + currencyFormatter.format(hold_amount),
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "to " +
                        account_name.toString() +
                        "(" +
                        account_no.toString() +
                        ")",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 100),
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
                         // print("pinner" + pin);
                          _show_pin = false;
                          transfer_fund(my_num, my_token);
                        }
                        // check the PIN length and check different PINs with 4,5.. length.
                      },
                      onEnter: (pin, _) {
                        showSuccessAnimation(context);
                        // callback user pressed enter
                        print(pin);
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
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
                SizedBox(
                  height: 15,
                ),
                TextButton(
                  onPressed: (() {
                    // Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Transfer(),
                      ),
                    );
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

  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>WIDGET>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Widget proceed_btn() {
    setState(() {
      if (hold_amount < balance) {
        print("balance is greater");
      } else {
        print("balance is less");
      }
    });
    if (hold_amount < balance) {
      if (hold_amount > 5) {
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.blue.shade900,
          ),
          onPressed: () {
            setState(() {
              _show_pin = true;
              _show_amount_panel = false;
            });
          },
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Proceed",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )),
        );
      } else {
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.grey.shade400,
          ),
          onPressed: null,
          child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Proceed",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )),
        );
      }
    } else {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.grey.shade400,
        ),
        onPressed: null,
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Proceed",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            )),
      );
    }
  }

  //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future fetch_transaction() async {
    var url = "https://a2ctech.net/api/faspay/fetch_transaction.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": my_num,
      "token": my_token,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      progress_bar_load_transaction = false;
      for (var data in data) {
        //print(data["rcver"][0]["f_name"]);
        _accountData.add(new AccountHistory(
            name: data["sender"][0]["f_name"] +
                " " +
                data["sender"][0]["s_name"] +
                " " +
                data["sender"][0]["o_name"],
            amount: double.parse(data["amount"]),
            type: data["trnx_type"],
            dte: data["dte"],
            trnx_id: data["tranx_id"],
            account_no_his: data["sender"][0]["phone"]));
      }

      setState(() {
        show_preogress = false;
      });
    } else {
      print(response.statusCode);
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
        fetch_transaction();
      });
    }
  }

  Future verify_account_no(phone, token) async {
    show_preogress = true;
    FocusScope.of(context).requestFocus(new FocusNode());
    var url = "https://a2ctech.net/api/faspay/account_no_verify.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": phone,
      "token": token,
      "account": account_no,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);

      if (data["phone"] == "true") {
        account_name = data["account_name"];
        balance = double.parse(data["my_account"]["balance"]);
        trnx_pin = data["my_account"]["my_pin"];
        show_preogress = false;
        show_confirm_info = true;
      } else {
        txt_in_account_n0.text = "";
        show_account_not_found = true;
        show_preogress = false;
        // logout();
      }
      setState(() {
        //show_preogress = false;.
      });
    }
  }

  Widget _verify_account() {
    return Visibility(
      visible: show_confirm_info,
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.all(10),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            title: Center(
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Information Confirmed",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              show_confirm_info = false;
                              txt_in_account_n0.text = "";
                            });
                          },
                          child: Icon(Icons.close),
                        )),
                  ),
                ],
              ),
            ),
            content: Container(
              height: 229,
              child: Column(
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFf1f1f9),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                              child: Text(
                                  "Please confirm the receiver's identity before sending any money. Kindly note that, funds sent cannot be reversed."))
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Account No",
                        style: TextStyle(fontSize: 13),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            account_no,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "Account Name",
                        style: TextStyle(fontSize: 13),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Text(
                            account_name,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: width,
                    child: OutlinedButton(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('Confirm',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                          foregroundColor: Colors.white
                          //<-- SEE HERE
                          ),
                      onPressed: () {
                        setState(() {
                          //_account_history_visable=false;
                          _show_amount_panel = true;
                          show_confirm_info = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [],
          ),
        ),
      ),
    );
  }

  Future<void> _selectContact() async {
    PermissionStatus permissionStatus = await Permission.contacts.request();
    if (permissionStatus == PermissionStatus.granted) {
      Contact? contact = await ContactsService.openDeviceContactPicker();
      if (contact != null && contact.phones!.isNotEmpty) {
        _accountNumberController.text = contact.phones!.first.value!;
        account_no = contact.phones!.first.value!;
        print(_accountNumberController.text);
        if (_accountNumberController.text.length < 10) {
          _showToast(context, "Invalid phone number");
        } else {
          setState(() {
            account_no = account_no.replaceAll(" ", "");
            if (account_no.length == "14") {
              account_no = account_no.substring(4);
            } else {
              account_no = account_no.substring(1);
            }

            verify_account_no(my_num, my_token);
          });
        }
      }
    }
  }

  void _showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        backgroundColor: Colors.red.shade900,
        content: Text(
          msg,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        action:
            SnackBarAction(label: '', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  Future transfer_fund(phone, token) async {
    show_preogress = true;
    FocusScope.of(context).requestFocus(new FocusNode());
    var url = "https://a2ctech.net/api/faspay/transfer.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": phone,
      "token": token,
      "to": account_no,
      "amount": hold_amount.toString(),
      "note": note.text,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);

      if (data["status"] == "true") {
        print("DONE!!!");
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
}

class AccountHistory {
  String name;
  double amount;
  String type;
  String dte;
  String trnx_id;
  String account_no_his;
  bool isHidden;

  AccountHistory({
    required this.name,
    required this.amount,
    required this.type,
    required this.dte,
    required this.trnx_id,
    required this.account_no_his,
    this.isHidden = true,
  });
}
