import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DepositMoneyPage extends StatefulWidget {
  final double amount;
  DepositMoneyPage(this.amount);

  @override
  _DepositMoneyPageState createState() => _DepositMoneyPageState();
}

class _DepositMoneyPageState extends State<DepositMoneyPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderNameController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _amountController = TextEditingController();

  late double _amount;

  @override
  void initState() {
    super.initState();
    _amount = widget.amount;
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderNameController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _depositMoney() {
    if (_formKey.currentState!.validate()) {
      // Perform deposit operation here
      final cardNumber = _cardNumberController.text;
      final cardHolderName = _cardHolderNameController.text;
      final expiryDate = _expiryDateController.text;
      final cvv = _cvvController.text;
      final amount = double.parse(_amountController.text);
      // Perform deposit operation with the above details
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fund Wallet'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text(
              "You are about to deposit the sum of " +
                  _amount.toString() +
                  " to your wallet, kindly enter your card details to continue.",
              style: TextStyle(
                fontStyle: FontStyle.normal,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
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
                  color: Colors.grey,
                  fontSize: 14,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                labelText: 'Card Number',
                hintText: 'Enter your debit card number',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your card number';
                }
                if (value.length != 16) {
                  return 'Card number should have 16 digits';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _cardHolderNameController,
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
                labelText: 'Card Holder Name',
                hintText: 'Enter your name as on the card',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your card holder name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _expiryDateController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                      // Format the input as MM/YY
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final oldText = oldValue.text;
                        final newText = newValue.text;

                        if (newText.length > oldText.length) {
                          if (newText.length == 3 && !newText.contains('/')) {
                            return TextEditingValue(
                              text: '$oldText/',
                              selection: TextSelection.collapsed(offset: 4),
                            );
                          } else if (newText.length == 2 &&
                              !newText.contains('/')) {
                            return TextEditingValue(
                              text: '$newText/',
                              selection: TextSelection.collapsed(offset: 3),
                            );
                          }
                        }

                        return newValue;
                      }),
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
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                      labelText: 'Expiry Date',
                      hintText: 'MM/YY',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter expiry date';
                      }
                      // if (value.length != 5 || !value.contains('/')) {
                      //   return 'Expiry date should be in MM/YY format';
                      // }
                      final parts = value.split('/');
                      final month = int.tryParse(parts[0]) ?? 0;
                      final year = int.tryParse(parts[1]) ?? 0;
                      final now = DateTime.now();
                      final expiry = DateTime(2000 + year, month);
                      if (expiry.isBefore(now)) {
                        return 'Card has expired';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
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
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15.0, horizontal: 15),
                      labelText: 'CVV',
                      hintText: 'Enter CVV number',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter CVV number';
                      }
                      if (value.length != 3) {
                        return 'CVV should have 3 digits';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(height: 32),
            GestureDetector(
              onTap: () {
                _depositMoney();
              },
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
