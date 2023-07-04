import 'dart:convert';
import 'dart:math';
import 'package:faspay/pages/homepage.dart';
import 'package:faspay/pages/transfer.dart';
import 'package:faspay/pages/utils/mediaqury.dart';
import 'package:faspay/pages/withdrawalpage.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:faspay/pages/depositpage.dart';
import 'package:faspay/pages/phonescreen.dart';
import 'package:faspay/pages/transferpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:io';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'custome_tab.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

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
  String mode_of_trnx;

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
    required this.mode_of_trnx,
    this.isHidden = true,
  });
}

class Dashboard extends StatefulWidget {
  //const Dashboard({super.key});
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<AccountHistory> _accountData = [];

  String accNo = "";
  double balance = 0;
  String my_num = "", my_token = "";
  String name = "";
  String first_pin = "";
  String _second_pin = "";
  String pin_subTitle = "Enter a 4-digit PIN";
  bool trnx_pin_status = true;
  bool _pin_create_succss = false;

  TextEditingController _amountController = TextEditingController();
  TextEditingController set_new_pin = TextEditingController();
  late double depositAmount = 0;

  Future<void> generatePDF(BuildContext context, AccountHistory account) async {
    final pdf = pw.Document();

    final assetImg = await rootBundle.load('assets/images/logo.svg');
    final img = PdfImage.file(
      pdf.document,
      bytes: assetImg.buffer.asUint8List(),
    );

    // Add page
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(40),
        header: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.center,
            margin: const pw.EdgeInsets.only(bottom: 20.0, top: 20.0),
            child: pw.Column(
              children: [
                pw.Text(
                  'Transaction Receipt',
                  style: pw.TextStyle(
                    color: PdfColors.blue900,
                    fontSize: 32.0,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Divider(
                  color: PdfColors.black,
                  thickness: 2.0,
                ),
                pw.SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 30.0),
            child: pw.Column(
              children: [
                pw.Divider(
                  color: PdfColors.black,
                  thickness: 2.0,
                ),
                pw.SizedBox(
                  height: 10,
                ),
                pw.Text(
                  'Date & Time Generated: ${DateTime.now().toLocal().toString()}',
                  style: pw.TextStyle(
                    fontSize: 20.0,
                    color: PdfColors.blue900,
                  ),
                ),
              ],
            ),
          );
        },
        build: (pw.Context context) => <pw.Widget>[
          // Add logo
          pw.Positioned(
            child: pw.Transform.rotate(
              angle: 15,
              child: pw.Text(
                'FASPAY',
                style: pw.TextStyle(
                  color: PdfColors.grey200,
                  fontSize: 50.0,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
          ),
          // pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Container(
                width: 250,
                child: pw.Text(
                  'Sender: ',
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 20.0,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Container(
                width: 150,
                child: pw.Text(
                  '${account.sender_name + " " + account.sender_s_name + " " + account.sender_o_name}',
                  style: pw.TextStyle(
                    color: PdfColors.blue900,
                    fontSize: 20.0,
                    // fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Container(
                width: 250,
                child: pw.Text(
                  'Beneficiary Name:',
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 20.0,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Container(
                width: 150,
                child: pw.Text(
                  '${account.rcva_name + " " + account.rcva_s_name + " " + account.rcva_o_name}',
                  style: pw.TextStyle(
                    color: PdfColors.blue900,
                    fontSize: 20.0,
                    // fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Container(
                width: 250,
                child: pw.Text(
                  'Account Number:',
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 20.0,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Container(
                width: 150,
                child: pw.Text(
                  '${account.Beneficiary_account}',
                  style: pw.TextStyle(
                    color: PdfColors.blue900,
                    fontSize: 20.0,
                    // fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Container(
                width: 250,
                child: pw.Text(
                  'Transaction Type:',
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 20.0,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Container(
                width: 150,
                child: pw.Text(
                  '${account.type}',
                  style: pw.TextStyle(
                    color: PdfColors.blue900,
                    fontSize: 20.0,
                    // fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Container(
                width: 250,
                child: pw.Text(
                  'Description:',
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 20.0,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Container(
                width: 150,
                child: pw.Text(
                  'Description',
                  style: pw.TextStyle(
                    color: PdfColors.blue900,
                    fontSize: 20.0,
                    // fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Container(
                width: 250,
                child: pw.Text(
                  'Transaction Reference:',
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 20.0,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Container(
                width: 150,
                child: pw.Text(
                  '${account.trnx_id}',
                  style: pw.TextStyle(
                    color: PdfColors.blue900,
                    fontSize: 20.0,
                    // fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Container(
                width: 250,
                child: pw.Text(
                  'Transaction Amount:',
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 20.0,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Container(
                width: 150,
                child: pw.Text(
                  '${account.amount}',
                  style: pw.TextStyle(
                    color: PdfColors.blue900,
                    fontSize: 20.0,
                    // fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Container(
                width: 250,
                child: pw.Text(
                  'Effective On:',
                  style: pw.TextStyle(
                    color: PdfColors.black,
                    fontSize: 20.0,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Container(
                width: 200,
                child: pw.Text(
                  '${account.dte}',
                  style: pw.TextStyle(
                    color: PdfColors.blue900,
                    fontSize: 20.0,
                    // fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(
            height: 20,
          ),
          pw.Positioned(
            child: pw.Transform.rotate(
              angle: 15,
              child: pw.Align(
                alignment: pw.Alignment.bottomCenter,
                child: pw.Text(
                  'FASPAY',
                  style: pw.TextStyle(
                    color: PdfColors.grey200,
                    fontSize: 50.0,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    final Uint8List bytes = await pdf.save();
    await Printing.sharePdf(
      bytes: bytes,
      filename: account.sender_name + '.pdf',
      subject: 'Transaction Receipt',
    );
  }

  bool show_preogress = true;
  final currencyFormatter = NumberFormat('#,##0.00');
  var size, height, width;
  @override
  void initState() {
    my_session();
    super.initState();
  }

  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return RefreshIndicator(
        color: Colors.blue.shade900,
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 3));
          setState(() {
            show_preogress = true;
          });
          my_session();
        },
        child: Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: height * 0.25,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 12.0, right: 12, top: 6),
                      child: Container(
                        // height: MediaQuery.of(context).size.height / 4,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 3,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height / 200,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 8.0, left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w100,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Icon(
                                        Icons.verified,
                                        color: Colors.green,
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    accNo,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w100,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 20),
                              child: Text(
                                "N" + currencyFormatter.format(balance),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: 20,
                                right: 20,
                                top: 20,
                                bottom: 10,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _showDialog(context);
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              10,
                                      width:
                                          MediaQuery.of(context).size.width / 4,
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
                                      // color: Colors.blue,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center, //Center Row contents horizontally,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add_circle,
                                            size: height / 25,
                                            color: Colors.blue.shade900,
                                          ),
                                          Text(
                                            "Deposit",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue.shade900,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Navigator.of(context).pop();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Transfer(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              10,
                                      width:
                                          MediaQuery.of(context).size.width / 4,
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
                                      // color: Colors.green,
                                      child: GestureDetector(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center, //Center Row contents horizontally,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.arrow_circle_up,
                                              size: height / 25,
                                              color: Colors.blue.shade900,
                                            ),
                                            Text(
                                              "Transfer",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.blue.shade900,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              WithdrawalForm(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              10,
                                      width:
                                          MediaQuery.of(context).size.width / 4,
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
                                      // color: Colors.yellow,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center, //Center Row contents horizontally,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.arrow_circle_down,
                                            size: 35,
                                            color: Colors.blue.shade900,
                                          ),
                                          Text(
                                            "Withdraw",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue.shade900,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Center(
                    child: Text(
                      "Financial Records",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: _accountData.length != 0
                        ? Padding(
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
                                      borderRadius: BorderRadius.circular(8.0),
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
                                              account.amount.toStringAsFixed(2),
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                if (account.mode_of_trnx ==
                                                    "Card Deposit") ...[
                                                  IconButton(
                                                      icon: Icon(
                                                        Icons.wallet,
                                                        color: Colors.green,
                                                      ),
                                                      onPressed: () {})
                                                ] else ...[
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.picture_as_pdf,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () =>
                                                        generatePDF(
                                                            context, account),
                                                  )
                                                ],
                                                // IconButton(
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
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: 40,
                              ),
                              Icon(
                                Icons.history,
                                size: 80,
                                color: Colors.blue.shade900,
                              ),
                              Center(
                                child: Text(
                                  "No Recent Transactions",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
              if (trnx_pin_status)
                ...[]
              else ...[
                Container(
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
                                    "One more thing,",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "To get started, please kindly set a transaction PIN below.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                      textBaseline: TextBaseline.alphabetic,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  PinPut(
                                    controller: set_new_pin,
                                    // focusNode: focu,
                                    autofocus: true,
                                    keyboardAppearance: Brightness.light,
                                    obscureText: "*",
                                    onChanged: (value) {
                                      if (value.length == 4) {
                                        if (first_pin == "") {
                                          first_pin = value;
                                          set_new_pin.clear();
                                          print(first_pin);
                                          setState(() {
                                            pin_subTitle =
                                                "Confirm 4-digit PIN";
                                          });
                                        } else if (first_pin.isNotEmpty &&
                                            _second_pin == "") {
                                          _second_pin = value;
                                          if (first_pin == _second_pin) {
                                            print("correct pin");
                                            save_new_pin();
                                            setState(() {
                                              show_preogress = true;
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      new FocusNode());
                                            });
                                          } else {
                                            setState(() {
                                              pin_subTitle =
                                                  "Enter a 4-digit PIN";
                                              set_new_pin.clear();
                                              first_pin = "";
                                              _second_pin = "";
                                              print("not correct");
                                            });
                                          }
                                        } else if (first_pin.isNotEmpty &&
                                            _second_pin.isNotEmpty) {
                                          _second_pin = value;
                                          if (first_pin == _second_pin) {
                                            print("correct pin");
                                            save_new_pin();
                                            setState(() {
                                              pin_subTitle = "Please wait";
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                      new FocusNode());
                                              show_preogress = true;
                                            });
                                          } else {
                                            setState(() {
                                              pin_subTitle =
                                                  "Enter a 4-digit PIN";
                                              set_new_pin.clear();
                                              first_pin = "";
                                              _second_pin = "";
                                              print("not correct");
                                            });
                                          }
                                        }
                                        value = "";
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
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border:
                                                Border.all(color: Colors.blue))
                                        .copyWith(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border:
                                                Border.all(color: Colors.blue)),
                                    selectedFieldDecoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        border: Border.all(color: Colors.blue)),
                                    followingFieldDecoration: BoxDecoration(
                                      border: Border.all(color: Colors.blue),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ).copyWith(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    pin_subTitle,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (_pin_create_succss) ...[
                SuccessContainer(context),
              ] else
                ...[],
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
        ));
  }

  Widget SuccessContainer(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _pin_create_succss = false;
          update_session(context);
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
        name = data["f_name"];
        String bal = data["balance"];
        balance = double.parse(bal);
        accNo = data["phone"];

        if (data["trnx_pin_status"] == "true") {
          trnx_pin_status = true;
        } else {
          trnx_pin_status = false;
        }
        show_preogress = false;
        fetch_transaction();
      } else {
        show_preogress = false;
        logout();
      }
      setState(() {
        //show_preogress = false;.
      });
    }
  }

  Future<void> my_session() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var phone = prefs.getString("phone");
    var tokn = prefs.getString("token");
    print(my_num);
    if (phone == null) {
      logout();
    } else {
      my_num = phone!;
      my_token = tokn!;

      get_customer_details(phone, my_token);
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

  String number_format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
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
              'Enter Amount',
              style: TextStyle(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
              right: 12.0,
            ),
            child: TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  depositAmount = double.tryParse(value)!;
                });
              },
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
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
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                labelText: 'Amount',
                hintText: 'Enter amount',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
          ),
          actions: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: height / 300,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                    ),
                    onPressed: () {
                      setState(() {
                        show_preogress = true;
                      });
                      card_deposit();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          // <-- Icon
                          Icons.credit_card,
                          size: 24.0,
                        ),
                        Text(
                          'Card',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ), // <-- Text
                        SizedBox(
                          width: 5,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: height / 300,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          // <-- Icon
                          Icons.qr_code,
                          size: 24.0,
                        ),
                        Text(
                          'QR Code',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      if (depositAmount < 1) {
                        _showToast(context, "Invalid Amount");
                      } else {
                        qr_payment_request();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future qr_payment_request() async {
    var url = "https://a2ctech.net/api/faspay/request_payment_qr.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": my_num,
      "token": my_token,
      "amount": depositAmount.toString(),
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      print(data["status"]);
      if (data["status"] == "true") {
        Navigator.of(context).pop();
        showQRCode(context, data["code"]);
      } else {}
      setState(() {
        show_preogress = false;
      });
    } else {
      print(response.statusCode);
    }
  }

  Future save_new_pin() async {
    var url = "https://a2ctech.net/api/faspay/_set_transaction_pin.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": my_num,
      "token": my_token,
      "pin": first_pin,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      print(data["status"]);
      if (data["status"] == "true") {
 setState(() {
   _pin_create_succss = true;

 });
       // get_customer_details(my_num, my_token);
      } else {}
      setState(() {
        show_preogress = false;
      });
    } else {
      print(response.statusCode);
    }
  }

  Future card_deposit() async {
    var url = "https://a2ctech.net/api/faspay/card_deposit.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": my_num,
      "token": my_token,
      "amount": depositAmount.toString(),
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      print(data["status"]);
      if (data["status"] == "true") {
        _launchURL(context, data["trnx_id"]);
      } else {}
      setState(() {
        show_preogress = false;
      });
    } else {
      print(response.statusCode);
    }
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
            _accountData.add(new AccountHistory(
                sender_name: "System Deposit",
                rcva_name: "System Deposit",
                amount: double.parse(data["amount"]),
                type: data["trnx_type"],
                dte: data["dte"],
                trnx_id: data["tranx_id"],
                sender_s_name: "System Deposit",
                sender_o_name: "System Deposit",
                rcva_s_name: "System Deposit",
                rcva_o_name: "System Deposit",
                Beneficiary_account: "System Deposit",
                tittle_name: "Card Deposit",
                mode_of_trnx: data["mode_of_trnx"]));
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
                tittle_name: data["sender"][0]["f_name"],
                mode_of_trnx: data["mode_of_trnx"]));
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
              tittle_name: data["rcver"][0]["f_name"],
              mode_of_trnx: data["mode_of_trnx"]));
        }
      }

      setState(() {
        show_preogress = false;
      });
    } else {
      print(response.statusCode);
    }
  }
  Future<void> update_session(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("trnx_pin_active", "true");
    goto_dashboard( context, "false");
  }
  void goto_dashboard(BuildContext context,String is_pen_set) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            HomePage(phoneNumber: '', token: 'token', checkPin: "true",),
      ),
    );
  }
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
Future<void> _launchURL(BuildContext context, String trnx_id) async {
  final theme = Theme.of(context);
  try {
    await launch(
      'https://myphp0101.azurewebsites.net/?ref=' + trnx_id,
      customTabsOption: CustomTabsOption(
        toolbarColor: theme.primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        animation: CustomTabsSystemAnimation.slideIn(),
        extraCustomTabs: const <String>[
          // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
          'org.mozilla.firefox',
          // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
          'com.microsoft.emmx',
        ],
      ),
      safariVCOption: SafariViewControllerOption(
        preferredBarTintColor: theme.primaryColor,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
  }
}

void _showToast(BuildContext context, String msg) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
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

void showQRCode(BuildContext context, String data) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: MediaQuery.of(context).size.height - 150,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Scan the QR Code below',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
            ),
            SizedBox(height: 10),
            Divider(
              height: 2,
              color: Colors.blue.shade900,
            ),
            Expanded(
              child: Center(
                  child: QrImage(
                data: data,
                size: 200.0,
                version: QrVersions.auto,
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue.shade900,
              )),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      phoneNumber: "",
                      token: "", checkPin: '',
                    ),
                  ),
                );
              },
              child: Container(
                height: 50,
                color: Colors.blue.shade900,
                child: Center(
                  child: Text(
                    "DONE",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );

}
