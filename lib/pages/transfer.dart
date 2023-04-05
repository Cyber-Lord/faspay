import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:faspay/pages/phonescreen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'homepage.dart';

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
  String my_num = "", my_token = "";
  String account_name = "";
  String account_no = "";
  late Timer _timer;
  final List<AccountHistory> _accountData = [];

  final TextEditingController _accountNumberController =
      TextEditingController();
  TextEditingController txt_in_account_n0 = TextEditingController();
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
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
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
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 15.0, horizontal: 15),
                                  hintText: "E.g 8012345678",
                                  labelText: "Account number",
                                  border: InputBorder.none,
                                  counterText: ""),
                              onTap: () {
                                size_transaction_container = true;
                              },
                              // onTapOutside: (e) {
                              //   FocusScope.of(context)
                              //       .requestFocus(new FocusNode());
                              //   _timer = new Timer(
                              //       const Duration(milliseconds: 400), () {
                              //     setState(() {
                              //       size_transaction_container = false;
                              //     });
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
                            : height / 2.5,
                        //height: height-242,
                        child: Column(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  itemCount: _accountData.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final AccountHistory account =
                                        _accountData[index];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          account.isHidden = !account.isHidden;
                                          account_no = account.account_no_his;
                                          verify_account_no(my_num, my_token);
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
                                              color:
                                                  Colors.grey.withOpacity(0.3),
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
                                                      account.account_no_his +
                                                      ")",
                                                  style: TextStyle(
                                                    fontSize: 14.0,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Reference No: FASPAY/${account.trnx_id}",
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Icon(
                                                      account.amount >= 0
                                                          ? Icons.arrow_back
                                                          : Icons.arrow_forward,
                                                      color: account.amount >= 0
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ) // IconButton(
                                                    //   onPressed: () {
                                                    //     Share.share(
                                                    //         'Here is my account history: ${account.name}, ${account.amount}');
                                                    //   },
                                                    //   icon: Icon(Icons.share),
                                                    // ),
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
                          ],
                        ),
                      ))
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
                        'Confirm Account Owner',
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
                            Text('Contact Not on FasPay'),
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
          )
        ],
      ),
    );
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
      //print(response.body);
      // print(data["x"]);

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
      // print(response.body);

      if (data["phone"] == "true") {
        account_name = data["account_name"];

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
                      "Confirm Receiver's Account",
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
                                  "Please confirm receiver's information before sending any money. Kindly note that funds sent cannot be reversed."))
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
                        "Account No.",
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
                        "Account Name.",
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
                      onPressed: () {},
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
