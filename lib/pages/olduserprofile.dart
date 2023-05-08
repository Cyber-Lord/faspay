import 'package:faspay/pages/upgradetiertwoform.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

enum VerificationTier {
  basic,
  intermediate,
  advanced,
}

class UserProfilePage extends StatefulWidget {
  final String name;
  final String email;
  final VerificationTier tier;
  final String phoneNumber;

  UserProfilePage(
      {required this.name,
      required this.email,
      required this.tier,
      required this.phoneNumber});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  File _image = File('');
  bool _editing = true;

  bool _isBiometricEnabled = false;

  void _toggleBiometric(bool value) {
    setState(() {
      _isBiometricEnabled = value;
    });
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
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Verification Status: ',
                      style: TextStyle(fontSize: 18),
                    ),
                    _getTierBadge(),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  decoration: InputDecoration(
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
                  decoration: InputDecoration(
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
                  decoration: InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.location_on),
                  ),
                  keyboardType: TextInputType.streetAddress,
                  enabled: _editing,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 16,
                ),

                // TextFormField(
                //   decoration: InputDecoration(
                //     labelText: 'City',
                //     prefixIcon: Icon(Icons.location_city),
                //   ),
                //   keyboardType: TextInputType.streetAddress,
                //   enabled: _editing,
                //   validator: (value) {
                //     if (value!.isEmpty) {
                //       return 'Please enter your city';
                //     }
                //     return null;
                //   },
                // ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UpgradePage()),
                      );
                    },
                    child: Text("Upgrade to Tier 2"),
                  ),
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
