import 'package:flutter/material.dart';

class POSPage extends StatefulWidget {
  @override
  _POSPageState createState() => _POSPageState();
}

class _POSPageState extends State<POSPage> {
  List<Map<String, dynamic>> posTerminals = [
    {
      'id': 001,
      'name': 'Shoprite Desk 1',
      'location': 'Lagos, Nigeria',
      'user': 'Zahra Adamu',
      'lastSeen': DateTime.now().subtract(Duration(hours: 2)),
    },
    {
      'id': 002,
      'name': 'Shoprite Desk 2',
      'location': 'Lagos, Nigeria',
      'user': 'Adamu Umar',
      'lastSeen': DateTime.now().subtract(Duration(days: 1)),
    },
    {
      'id': 003,
      'name': 'Shoprite Desk 3',
      'location': 'Abuja, Nigeria',
      'user': 'Abba Amrah',
      'lastSeen': DateTime.now().subtract(Duration(minutes: 30)),
    },
    {
      'id': 004,
      'name': 'Shoprite Desk 4',
      'location': 'Abuja, Nigeria',
      'user': 'Amrah Abba',
      'lastSeen': DateTime.now().subtract(Duration(hours: 6)),
    },
  ];

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  bool _isTransferEnabled = false;

  void _addPOSTerminal() {
    String terminalName = _controller.text;
    setState(() {
      posTerminals.add({
        'name': terminalName,
        'location': '',
        'user': '',
        'online': false,
        'lastSeen': null,
      });
      _controller.clear();
    });
  }

  void _toggleTransfer(bool value) {
    setState(() {
      _isTransferEnabled = value;
    });
  }

  void _deletePOSTerminal(int index) {
    setState(() {
      posTerminals.removeAt(index);
    });
  }

  void _managePOSTerminal(int index) {
    showGeneralDialog(
        context: context,
        pageBuilder: ((context, animation, secondaryAnimation) {
          return AlertDialog(
            title: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Manage POS Terminal",
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 18,
                      // fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            content: Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Text("data"),
                ],
              ),
            ),
          );
        }));
  }

  void _managePOS(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Center(
                  child: Text(
                    "Device Settings",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                ),
                SizedBox(height: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {},
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.person_add,
                          color: Colors.blue.shade900,
                        ),
                        title: Text(
                          'Add User',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {},
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.pin,
                          color: Colors.blue.shade900,
                        ),
                        title: Text(
                          'Reset PIN',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {},
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.lock,
                          color: Colors.blue.shade900,
                        ),
                        title: Text(
                          'Lock Device',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.send_to_mobile,
                        color: Colors.blue.shade900,
                      ),
                      title: Text(
                        'Enable Transfer',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      trailing: Switch(
                        value: _isTransferEnabled,
                        onChanged: (value) {
                          setState(
                            () {
                              _isTransferEnabled = value;
                            },
                          );
                          if (value) {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(
                                    child: Text(
                                      "Enable Transfer",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.blue.shade900,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  content: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      children: [
                                        SizedBox(height: 10),
                                        Text(
                                          "Please enter your transaction PIN to enable transfer on this device",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                        TextFormField(
                                          controller: _pinController,
                                          obscureText: true,
                                          enableSuggestions: false,
                                          autocorrect: false,
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
                                              fontSize: 12,
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              vertical: 15.0,
                                              horizontal: 15,
                                            ),
                                            labelText: "Enter PIN",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue.shade900,
                                      ),
                                      onPressed: (() {
                                        Navigator.of(context).pop();
                                      }),
                                      child: Text("Enable"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPOS(String terminalName, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      posTerminals[index]['name'],
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Device Information",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Device Location : ",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      posTerminals[index]['location'],
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 14,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Device Manager : ",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      posTerminals[index]['user'],
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 14,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Last Seen: ",
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      posTerminals[index]['lastSeen'].toString(),
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 14,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _managePOS(index);
                    },
                    child: Text('Manage Device'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                    ),
                    onPressed: () {
                      // _changePIN(context, true);
                    },
                    child: Text('Request Statement'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: posTerminals.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => _showPOS(posTerminals[index]['name'], index),
              child: Card(
                child: ListTile(
                  title: Text(
                    posTerminals[index]['name'],
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  subtitle: Text(
                    posTerminals[index]['location'],
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade900,
                    child: Icon(
                      Icons.important_devices_sharp,
                      color: Colors.white,
                      size: 32.0,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add POS Terminal'),
                content: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Enter terminal name',
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Add'),
                    onPressed: () {
                      _addPOSTerminal();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue.shade900,
      ),
    );
  }
}
