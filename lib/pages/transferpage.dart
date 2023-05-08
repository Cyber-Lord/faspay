import 'package:faspay/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class BankTransferPage extends StatefulWidget {
  @override
  _BankTransferPageState createState() => _BankTransferPageState();
}

class _BankTransferPageState extends State<BankTransferPage> {
  TextEditingController controller = TextEditingController(text: "");
  final TextEditingController _accountNumberController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _textFocusNode = FocusNode();

  String thisText = "";
  int pinLength = 4;
  bool hasError = false;

  late String errorMessage;
  late String selectedBank = 'Select Destination Bank';
  late String beneficiaryName = 'John Doe';
  double amount = 0.0;
  late String description = 'Salary';

  Future<void> _selectContact() async {
    PermissionStatus permissionStatus = await Permission.contacts.request();
    if (permissionStatus == PermissionStatus.granted) {
      Contact? contact = await ContactsService.openDeviceContactPicker();
      if (contact != null && contact.phones!.isNotEmpty) {
        _accountNumberController.text = contact.phones!.first.value!;
      }
    }
  }

  List<String> banks = [
    'Select Destination Bank',
    'GT Bank',
    'Zenith Bank',
    'Kuda MFB',
    'Wema Bank',
  ];
  @override
  void initState() {
    super.initState();
    _textFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _textFocusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  phoneNumber: "",
                  token: "",
                ),
              ),
            );
          },
        ),
        title: Text('F2F Transfer'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Container(
                //   height: MediaQuery.of(context).size.height * 0.08,
                //   width: MediaQuery.of(context).size.width * 0.8,
                //   decoration: BoxDecoration(
                //     border: Border.all(
                //       color: Colors.grey,
                //       width: 1.0,
                //     ),
                //   ),
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: DropdownButton<String>(
                //       value: selectedBank,
                //       style: TextStyle(
                //         fontSize: 16.0,
                //         color: Colors.black87,
                //       ),
                //       items: banks.map((bank) {
                //         return DropdownMenuItem<String>(
                //           value: bank,
                //           child: Container(
                //             width: MediaQuery.of(context).size.width * 0.8,
                //             child: Text(
                //               bank,
                //               style: TextStyle(
                //                 fontSize: 16.0,
                //                 color: Colors.blue.shade900,
                //               ),
                //             ),
                //           ),
                //         );
                //       }).toList(),
                //       hint: Text(
                //         'Select a Bank',
                //         style: TextStyle(
                //           fontSize: 16.0,
                //           color: Colors.grey,
                //         ),
                //       ),
                //       onChanged: (value) {
                //         setState(() {
                //           selectedBank = value!;
                //         });
                //       },
                //     ),
                //   ),
                // ),
                // SizedBox(height: 16.0),
                Padding(
                  padding: EdgeInsets.all(0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ...

                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _accountNumberController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Account Number',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.contacts),
                            onPressed: _selectContact,
                          ),
                        ],
                      ),
                      // ...
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      beneficiaryName = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Account Name',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _amountController,
                  onChanged: (value) {
                    setState(() {
                      amount = double.parse(value);
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      amount = double.parse(value);
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.text,
                ),
                SizedBox(height: 16.0),
                Container(
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    onPressed: () {
                      showPinDialog(context);
                    },
                    child: Text(
                      'CONTINUE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showPinDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String pin = '';

        return AlertDialog(
          title: Text('Enter PIN to continue'),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              children: [
                Divider(
                  height: 1,
                ),
                SizedBox(height: 16.0),
                Text(
                  "By pressing OK, You agree to send ${beneficiaryName} of ${selectedBank} the sum of NGN${amount} ",
                ),
                SizedBox(height: 16.0),
                PinCodeTextField(
                  autofocus: true,
                  controller: controller,
                  hideCharacter: true,
                  highlight: true,
                  highlightColor: Colors.blue,
                  defaultBorderColor: Colors.blue.shade900,
                  hasTextBorderColor: Colors.green,
                  // pinBoxColor: Colors.blue.shade900,
                  highlightPinBoxColor: Colors.white,
                  maxLength: pinLength,
                  hasError: hasError,
                  maskCharacter: "😎",
                  onTextChanged: (text) {
                    setState(() {
                      hasError = false;
                    });
                  },
                  onDone: (text) {
                    print("DONE $text");
                    print("DONE CONTROLLER ${controller.text}");
                  },
                  pinBoxWidth: 50,
                  pinBoxHeight: 50,
                  // hasUnderline: true,
                  wrapAlignment: WrapAlignment.spaceAround,
                  pinBoxDecoration:
                      ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                  pinTextStyle: TextStyle(fontSize: 22.0),
                  pinTextAnimatedSwitcherTransition:
                      ProvidedPinBoxTextAnimation.scalingTransition,
                  pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
                  highlightAnimation: true,
                  highlightAnimationBeginColor: Colors.black,
                  highlightAnimationEndColor: Colors.white12,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade900,
              ),
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade900,
              ),
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
