import 'dart:developer';
import 'dart:io';

import 'package:faspay/pages/homepage.dart';
import 'package:faspay/pages/phonescreen.dart';
import 'package:faspay/pages/qr_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  Barcode? result;
  bool isScanned = false;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var size, height, width;
  final currencyFormatter = NumberFormat('#,##0.00');
  String qr_code="";
  bool show_preogress=false;
  String account_no="";
  String account_name="";
  String amount_to_send="";
  String trnx_fee="";
  double balance=0;
  String my_num = "", my_token = "";
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS. scanData.code.toString()
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  void initState() {
    my_session();
    if(qr_code==""){

    }else{
      get_payment_request(my_num, my_token);
    }
    super.initState();
  }
  Widget build(BuildContext context) {
    controller?.resumeCamera();
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan QR"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 5, child: _buildQrView(context)),
        ],
      ),

    );

  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.blue.shade900,
        borderRadius: 16,
        borderLength: 32,
        borderWidth: 8,
        cutOutSize: MediaQuery.of(context).size.width * 0.75,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      showDialog(
          context: context,
          builder: (BuildContext context) {

            qr_code=scanData.code.toString();

         //  get_payment_request(my_num, my_token);
            pause_came();

            return    Stack(
                children: [

                  Expanded(child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Material(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        child:
                        Container(
                          height: 390,
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
                                                      token: "", checkPin: '',
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
                                            child: Text("8144449667",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
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
                                            child: Text("Umar Adamu",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
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
                                            child: Text(currencyFormatter.format(2101),style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
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
                                            child: Text(qr_code,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
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

                                        Text("Balance",style:TextStyle(fontSize: 14,fontWeight: FontWeight.bold) ,),
                                        Text(currencyFormatter.format(5102))
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30,),
                                OutlinedButton(

                                  style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade900,
                                      foregroundColor: Colors.white
                                    //<-- SEE HERE
                                  ),
                                  onPressed: (){},
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
                  )

                ],
              )
            ;

          });
    });
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
      //get_customer_details(phone, my_token);
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

  void goto_qr_result(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Qr_result(qr_coder: qr_code,)),
    );
  }

  Future get_payment_request(phone, token) async {
    show_preogress = true;

    FocusScope.of(context).requestFocus(new FocusNode());
    var url = "https://a2ctech.net/api/faspay/get_request_payment.php";
    var response;
    response = await http.post(Uri.parse(url), body: {
      "phone": phone,
      "token": token,
      "qr_code": qr_code,
    });

    var data = json.decode(response.body);
    if (response.statusCode == 200) {
      print(response.body);
      if (data["status"] == "true") {
        account_name = data["full_name"];
        String bal = data["balance"];
        balance = double.parse(bal);
        account_no=data["account"];
        amount_to_send=data["account"];
        show_preogress = false;
        pause_came();
      } else {
        pause_came();
        show_preogress = false;
       // logout();
      }
      setState(() {
        //show_preogress = false;.
      });
    }
    pause_came() ;
  }
void pause_came() async{
  await controller?.pauseCamera();
  goto_qr_result( context);
 // get_payment_request(my_num, my_token);
}
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
