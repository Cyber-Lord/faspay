import 'package:flutter/material.dart';

class WithdrawalForm extends StatefulWidget {
  @override
  _WithdrawalFormState createState() => _WithdrawalFormState();
}

class _WithdrawalFormState extends State<WithdrawalForm> {
  final _formKey = GlobalKey<FormState>();
  String _bankName = '';
  String _accountName = '';
  String _accountNumber = '';
  String _amount = '';
  List<String> _bankList = [
    'Access Bank',
    'First Bank of Nigeria',
    'Guaranty Trust Bank',
    'United Bank for Africa',
    'Zenith Bank',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Withdraw Funds'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Bank Name',
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 15,
                    ),
                    hintText: 'Bank Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  items: _bankList
                      .map((bank) => DropdownMenuItem<String>(
                            value: bank,
                            child: Text(bank),
                          ))
                      .toList(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your bank.';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _bankName = value!;
                    });
                  },
                  value: _bankName.isEmpty ? null : _bankName,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  maxLength: 10,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 15,
                    ),
                    hintText: "10 digit account number",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    labelText: 'Account Number',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your account number.';
                    }
                    if (value.length != 10) {
                      return 'Account number must be 10 digits.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _accountNumber = value!;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Account Name',
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 15,
                    ),
                    hintText: 'Account Name',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your account name.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _accountName = value!;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Amount (NGN)',
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 15,
                    ),
                    hintText: 'Amount (NGN)',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the amount you want to withdraw.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid amount.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _amount = value!;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // Submit withdrawal request to Fintech API
                      // ...

                      // Display success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          content: Text(
                            'Withdrawal request submitted successfully.',
                          ),
                        ),
                      );
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
