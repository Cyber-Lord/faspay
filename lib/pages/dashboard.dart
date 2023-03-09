import 'package:flutter/material.dart';

class AccountHistory {
  String name;
  double amount;
  String type;
  bool isHidden;

  AccountHistory({
    required this.name,
    required this.amount,
    required this.type,
    this.isHidden = true,
  });
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final List<AccountHistory> _accountData = [
    AccountHistory(name: 'Oga Master', amount: 1200.0, type: 'Credit'),
    AccountHistory(name: 'Techie Abba', amount: 5000.0, type: 'Credit'),
    AccountHistory(name: 'Musa Yola', amount: -1000.0, type: 'Debit'),
    AccountHistory(name: 'Techie Abba', amount: 5000.0, type: 'Credit'),
    AccountHistory(name: 'Musa Yola', amount: -1000.0, type: 'Debit'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12, top: 6),
            child: Container(
              height: MediaQuery.of(context).size.height / 4,
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
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 20),
                    child: Row(
                      children: [
                        Text(
                          "John Doe",
                          style: TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.bold,
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 20),
                    child: Text(
                      "N5,250.00",
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 10,
                          width: MediaQuery.of(context).size.width / 4,
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
                          // color: Colors.blue,
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 40,
                              color: Colors.blue.shade900,
                            ),
                            onPressed: (() {}),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 10,
                          width: MediaQuery.of(context).size.width / 4,
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
                          // color: Colors.green,
                          child: IconButton(
                            icon: Icon(
                              Icons.send,
                              size: 40,
                              color: Colors.blue.shade900,
                            ),
                            onPressed: (() {}),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 10,
                          width: MediaQuery.of(context).size.width / 4,
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
                          // color: Colors.yellow,
                          child: IconButton(
                            icon: Icon(
                              Icons.call_received,
                              size: 40,
                              color: Colors.blue.shade900,
                            ),
                            onPressed: (() {}),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          Center(
            child: Text(
              "Financial Records",
              style: TextStyle(
                fontSize: 16,
                // fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      right: 12.0,
                      bottom: 12.0,
                    ),
                    child: ListView.builder(
                      itemCount: _accountData.length,
                      itemBuilder: (BuildContext context, int index) {
                        final AccountHistory account = _accountData[index];
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  account.name,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                          color: account.amount >= 0
                                              ? Colors.green
                                              : Colors.red,
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
                                      color: account.amount >= 0
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
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
          )
        ],
      ),
    );
  }
}
