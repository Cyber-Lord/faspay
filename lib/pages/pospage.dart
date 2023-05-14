import 'package:flutter/material.dart';
import 'package:passcode_screen/keyboard.dart';

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
  final TextEditingController _oldPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordsMatch = true;

  bool _isPinVisible = false;
  bool _isTransferEnabled = false;
  DateTime _startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _endDate = DateTime.now();
  bool isLocked = false;
  String _errorMessage = '';

  void _changePin() {
    String oldPin = _oldPinController.text;
    String newPin = _newPinController.text;
    String confirmPin = _confirmPinController.text;

    if (oldPin.isEmpty || newPin.isEmpty || confirmPin.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter all PINs';
      });
      return;
    }

    if (newPin.length != 4 || confirmPin.length != 4) {
      setState(() {
        _errorMessage = 'PINs must be 4 digits long';
      });
      return;
    }

    if (newPin != confirmPin) {
      setState(() {
        _errorMessage = 'New PIN and Confirm PIN do not match';
      });
      return;
    }

    Navigator.of(context).pop();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null && selectedDate != _startDate) {
      setState(() {
        _startDate = selectedDate;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null && selectedDate != _endDate) {
      setState(() {
        _endDate = selectedDate;
      });
    }
  }

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

  void _addUser() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Column(
                children: [
                  Text(
                    'Register User',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
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
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 15,
                    ),
                    labelText: 'Phone Number',
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.phone,
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
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 15,
                    ),
                    labelText: 'Password',
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  keyboardType: TextInputType.phone,
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
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 15,
                    ),
                    labelText: 'Confirm Password',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _passwordsMatch = value == _passwordController.text;
                    });
                  },
                ),
                SizedBox(height: 8.0),
                if (!_passwordsMatch)
                  Text(
                    'Passwords do not match.',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: _passwordsMatch
                    ? () {
                        final phone = _phoneController.text;
                        final password = _passwordController.text;

                        Navigator.of(context).pop();
                        print(phone);
                        print(password);
                      }
                    : null,
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _requestStatement() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Request Statement',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'Select date range:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Start Date:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                    onPressed: () => _selectStartDate(context),
                    child: Text(
                      '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'End Date:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.blue.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                    onPressed: () => _selectEndDate(context),
                    child: Text(
                      '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        contentPadding:
                            EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
                        title: Center(
                          child: Text(
                            "Request Received",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        content: SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              Icon(
                                Icons.check_circle,
                                color: Colors.blue.shade900,
                                size: 80,
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Statement request was successfully received. You will receive an email shortly.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text(
                                      'Close',
                                      style: TextStyle(
                                        color: Colors.blue.shade900,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _enterPIN(
      bool value, String title, String message, String buttonMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.fromLTRB(25, 25, 25, 10),
          title: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _pinController,
                  obscureText: true,
                  enableSuggestions: false,
                  maxLength: 4,
                  keyboardType: TextInputType.number,
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
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 15,
                    ),
                    labelText: "Enter PIN",
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 4,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: TextButton(
                        onPressed: (() {
                          Navigator.of(context).pop();
                          _toggleTransfer(value);
                        }),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: (() {
                          Navigator.of(context).pop();
                          _toggleTransfer(value);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Container(
                                  height: 200,
                                  width: 100,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Transfer Enabled",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue.shade900,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Icon(
                                        Icons.check_circle,
                                        size: 100,
                                        color: Colors.blue.shade900,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text(
                                            'Close',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                        child: Text(
                          buttonMessage,
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                  onPressed: () {
                    _addUser();
                  },
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
                  onPressed: () {
                    Navigator.of(context).pop();
                    _resetPIN(context, true);
                  },
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
                  onPressed: () {
                    setState(() {
                      isLocked = !isLocked;
                    });
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Container(
                              height: 100,
                              width: 100,
                              child: Column(
                                children: [
                                  Icon(
                                    !isLocked ? Icons.lock : Icons.lock_open,
                                    size: 50,
                                    color: Colors.blue.shade900,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    !isLocked
                                        ? "Device Locked"
                                        : "Device Unlocked",
                                    style: TextStyle(
                                      color: Colors.blue.shade900,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          isLocked ? Icons.lock : Icons.lock_open,
                          color: Colors.blue.shade900,
                        ),
                        title: Text(
                          isLocked ? 'Lock Device' : 'Unlock Device',
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
                        activeColor: Colors.blue.shade900,
                        value: _isTransferEnabled,
                        onChanged: (value) {
                          setState(
                            () {
                              _isTransferEnabled = value;
                            },
                          );
                          if (value) {
                            Navigator.of(context).pop();
                            _enterPIN(
                              value,
                              "Enable Transfer",
                              "Please enter your transaction PIN to enable transfer on this device. Do note that once this is enabled, the device can be used to send money to third party users.",
                              "Enable",
                            );
                          } else {
                            Navigator.of(context).pop();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(
                                      child: Text(
                                        "Success",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue.shade900,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    content: SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              3.3,
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 15),
                                          Icon(
                                            Icons.check_circle,
                                            color: Colors.blue.shade900,
                                            size: 100,
                                          ),
                                          SizedBox(height: 15),
                                          Text(
                                            "Transfer has been disabled on this device",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey.shade600,
                                              // fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 15),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: TextButton(
                                              onPressed: (() {
                                                Navigator.of(context).pop();
                                              }),
                                              child: Text(
                                                "Done",
                                                style: TextStyle(
                                                  color: Colors.blue.shade900,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
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
                      Navigator.of(context).pop();
                      _requestStatement();
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

  void _resetPIN(BuildContext context, bool isPin) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // use StatefulBuilder to access setState inside the dialog
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Reset Device PIN",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "X",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    height: 2,
                    color: Colors.black,
                  ),
                ],
              ),
              content: Container(
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "To reset your device PIN, you need to enter your old PIN and then enter your new PIN twice.",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _oldPinController,
                        obscureText: !_isPinVisible,
                        enableSuggestions: false,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 15),
                          labelText: "Enter old PIN",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _newPinController,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        obscureText: !_isPinVisible,
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 15),
                          labelText: "Enter new PIN",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _confirmPinController,
                        obscureText: !_isPinVisible,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
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
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 15,
                          ),
                          labelText: "Confirm new PIN",
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Checkbox(
                            value: _isPinVisible,
                            onChanged: (bool? value) {
                              setState(() {
                                _isPinVisible = value ?? false;
                              });
                            },
                          ),
                          Text(
                            _isPinVisible ? 'Hide' : 'Show',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                        ],
                      ),
                      if (_errorMessage.isNotEmpty)
                        Text(
                          _errorMessage,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                  ),
                  onPressed: (() {
                    _changePin();
                    Navigator.of(context).pop();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Container(
                              height: 100,
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: Colors.blue.shade900,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Please wait...",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }),
                  child: Text('Save'),
                ),
              ],
            );
          },
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
                      fontWeight: FontWeight.bold,
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
                      size: 25.0,
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
