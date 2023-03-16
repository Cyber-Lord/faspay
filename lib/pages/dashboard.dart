import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
                // border: Border.all(
                //   // color: Colors.grey,
                //   width: 1,
                // ),
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
                    padding:
                        const EdgeInsets.only(top: 8.0, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            Text(
                              "John Doe",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w100,
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
                        Text(
                          "08140099331",
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
                        GestureDetector(
                          onTap: () {
                            print("Hello");
                          },
                          child: Container(
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
                            child: Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.add_circle,
                                    size: 40,
                                    color: Colors.blue.shade900,
                                  ),
                                  onPressed: (() {
                                    showQRCode(
                                        context, 'https://www.example.com');
                                  }),
                                ),
                                Text("Deposit")
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
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
                            child: Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.arrow_circle_up,
                                    size: 40,
                                    color: Colors.blue.shade900,
                                  ),
                                  onPressed: (() {
                                    print("Send Money");
                                  }),
                                ),
                                Text("Transfer")
                              ],
                            ),
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
                          child: Column(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_circle_right,
                                  size: 40,
                                  color: Colors.blue.shade900,
                                ),
                                onPressed: (() {}),
                              ),
                              Text("Pay")
                            ],
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
                fontWeight: FontWeight.w600,
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
                                    fontSize: 14.0,
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
                                        fontSize: 14.0,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Visibility(
                                      visible: account.isHidden,
                                      child: Text(
                                        account.amount.toStringAsFixed(2),
                                        style: TextStyle(
                                          fontSize: 14.0,
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
                'Scan this to Receive payment',
                style: TextStyle(
                  fontSize: 18,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Divider(),
            SizedBox(height: 10),
            Expanded(
              child: Center(
                child: QrImage(
                  // embeddedImage: AssetImage('assets/images/logo.png'),
                  data: data,
                  version: QrVersions.auto,
                  size: 200.0,
                  foregroundColor: Colors.blue.shade900,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text("You can also transer to: "),
                SizedBox(
                  width: 10,
                ),
                Text("8140099331")
              ],
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
