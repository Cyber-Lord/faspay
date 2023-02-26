import 'package:flutter/material.dart';

class AccountData {
  String name;
  double amount;
  String type;
  bool isHidden;

  AccountData({
    required this.name,
    required this.amount,
    required this.type,
    this.isHidden = true,
  });
}

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final List<AccountData> _accountData = [
    AccountData(name: 'Checking Account', amount: 1200.0, type: 'Checking'),
    AccountData(name: 'Savings Account', amount: 5000.0, type: 'Savings'),
    AccountData(name: 'Credit Card', amount: -1000.0, type: 'Credit'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
      padding: EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: _accountData.length,
        itemBuilder: (BuildContext context, int index) {
          final AccountData account = _accountData[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                account.isHidden = !account.isHidden;
              });
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 16.0),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    account.name,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        account.type,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                        ),
                      ),
                      Visibility(
                        visible: account.isHidden,
                        child: Text(
                          account.amount.toStringAsFixed(2),
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color:
                                account.amount >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: !account.isHidden,
                    child: Text(
                      '**** **** **** ${account.amount.toStringAsFixed(2).split('.')[0].substring(0, 4)}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: account.amount >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}
