import 'package:faspay/pages/cardrequestpage.dart';
import 'package:faspay/pages/resetpinpage.dart';
import 'package:faspay/pages/setpinpage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CardPage extends StatefulWidget {
  @override
  State<CardPage> createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  double balance = 100;

  List<Card> cardList = [
    Card('Debit Card', '1234', '02/25', 500.0),
    Card('Credit Card', '5678', '03/26', 1000.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.3,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade900,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            // padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              '**** **** **** 1234',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'VALID THRU',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '02/25',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                          // SizedBox(height: 10),
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
                                    cardList[index].balance.toString(),
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
                        child: Expanded(
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
                                    height: 50,
                                    width: MediaQuery.of(context).size.width *
                                        0.42,
                                    // color: Colors.blue.shade900,
                                    child: GestureDetector(
                                      onTap: () {
                                        _showDialog(context, balance);
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
                                    height: 50,
                                    width: MediaQuery.of(context).size.width *
                                        0.42,
                                    child: GestureDetector(
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
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DebitCardRequestPage(),
                                          ),
                                        );
                                      },
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
                                    height: 50,
                                    width: MediaQuery.of(context).size.width *
                                        0.42,
                                    child: GestureDetector(
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
