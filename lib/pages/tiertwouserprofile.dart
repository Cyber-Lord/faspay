import 'package:faspay/pages/upgradetierthreeform.dart';
import 'package:faspay/pages/upgradetiertwoform.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

enum VerificationTier {
  basic,
  intermediate,
  advanced,
}

class TierTwoUserProfile extends StatefulWidget {
  final String name;
  final String email;
  final String bvn;
  final String dob;
  final VerificationTier tier;
  final String phoneNumber;

  TierTwoUserProfile(
      {required this.name,
      required this.email,
      required this.bvn,
      required this.dob,
      required this.tier,
      required this.phoneNumber});

  @override
  _TierTwoUserProfileState createState() => _TierTwoUserProfileState();
}

class _TierTwoUserProfileState extends State<TierTwoUserProfile> {
  final _formKey = GlobalKey<FormState>();
  File _image = File('');
  bool _editing = true;

  bool _isBiometricEnabled = false;
  TextEditingController _oldPinController = TextEditingController();
  TextEditingController _newPinController = TextEditingController();
  TextEditingController _confirmPinController = TextEditingController();
  String _errorMessage = '';
  bool _isPinVisible = false;

  void _toggleBiometric(bool value) {
    setState(() {
      _isBiometricEnabled = value;
    });
  }

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

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 16,
                ),
                Center(
                  child: GestureDetector(
                    onTap: _editing ? _getImage : null,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              _image != null ? FileImage(_image) : null,
                          child: _image == null
                              ? Icon(Icons.camera_alt, size: 50)
                              : null,
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(Icons.edit, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Verification Status: ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    _getTierBadge(),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  enabled: false,
                  initialValue: widget.email,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    labelText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  initialValue: widget.phoneNumber,
                  enabled: false,
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    labelText: 'Date of Birth',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.datetime,
                  enabled: false,
                  initialValue: widget.dob,
                ),
                TextFormField(
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    labelText: 'BVN',
                    labelStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    prefixIcon: Icon(Icons.credit_card),
                  ),
                  keyboardType: TextInputType.number,
                  enabled: false,
                  initialValue: widget.bvn,
                ),
                SizedBox(
                  height: 16,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    elevation: 1,
                  ),
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => TierThreeUpgradePage()),
                    // );
                  },
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.verified_user,
                          color: Colors.blue.shade900,
                        ),
                        title: Text(
                          'Upgrade Account',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
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
                Divider(
                  height: 2,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey.shade300,
                  ),
                  height: 50,
                  width: double.infinity,
                  // color: Colors.grey.shade300,
                  child: Center(
                    child: Text(
                      "Security Settings",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    // elevation: 1,
                  ),
                  onPressed: () {
                    print("Reset Password");
                  },
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.password,
                          color: Colors.blue.shade900,
                        ),
                        title: Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade900,
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
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {
                    _changePIN(context);
                  },
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.pin,
                          color: Colors.blue.shade900,
                        ),
                        title: Text(
                          'Reset Transaction PIN',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade900,
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
                Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.fingerprint,
                        color: Colors.blue.shade900,
                      ),
                      title: Text(
                        'Biometric Authentication',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      trailing: Switch(
                        value: _isBiometricEnabled,
                        onChanged: _toggleBiometric,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _editing ? Colors.blue.shade900 : Colors.red,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text(_editing ? 'Save' : 'Edit'),
                  onPressed: _editing
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _editing = false;
                            });
                          }
                        }
                      : () {
                          setState(() {
                            _editing = true;
                          });
                        },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getTierBadge() {
    switch (widget.tier) {
      case VerificationTier.basic:
        return Badge(
          icon: Icon(
            Icons.verified_user,
            color: Colors.yellow,
            size: 20,
          ),
          // color: Colors.yellow,
          text: 'Tier 1',
        );
      case VerificationTier.intermediate:
        return Badge(
          icon: Icon(
            Icons.verified_user,
            color: Colors.orange,
            size: 20,
          ),
          // color: Colors.orange,
          text: 'Tier 2',
        );
      case VerificationTier.advanced:
        return Badge(
          icon: Icon(
            Icons.verified_user,
            color: Colors.green,
            size: 20,
          ),
          // color: Colors.green,
          text: 'Tier 3',
        );
      default:
        return Badge(
          // color: Colors.grey,
          icon: Icon(
            Icons.pending,
            color: Colors.red,
            size: 20,
          ),
          text: 'Unverified',
        );
    }
  }

  void _changePIN(BuildContext context) {
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
                        'Reset Transaction PIN',
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
                        "Dear ${widget.name} Please kindly enter your old PIN and new PIN below:",
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
                          labelText: 'Old PIN',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _newPinController,
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
                          labelText: 'New PIN',
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _confirmPinController,
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
                            vertical: 15.0,
                            horizontal: 15,
                          ),
                          labelText: 'Confirm PIN',
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
                          Text('Show PIN'),
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
                  onPressed: _changePin,
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class Badge extends StatelessWidget {
  // final Color color;
  final String text;
  final Icon icon;

  const Badge({Key? key, required this.text, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        // color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: icon,
    );
  }
}
