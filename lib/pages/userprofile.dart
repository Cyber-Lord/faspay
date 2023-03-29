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

  UserProfilePage(
      {required this.name, required this.email, required this.tier});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  File _image = File('');
  bool _editing = true;

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
        title: Text('Profile'),
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
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          _image != null ? FileImage(_image) : null,
                      child: _image == null
                          ? Icon(Icons.camera_alt, size: 50)
                          : null,
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
                  decoration: InputDecoration(labelText: 'Email'),
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
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.phone,
                  enabled: _editing,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Address'),
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
                ElevatedButton(
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
          icon: "Icons.verified_user",
          color: Colors.yellow,
          text: 'Tier 1',
        );
      case VerificationTier.intermediate:
        return Badge(
          icon: "Icons.verified_user",
          color: Colors.orange,
          text: 'Tier 2',
        );
      case VerificationTier.advanced:
        return Badge(
          icon: "Icons.verified_user",
          color: Colors.green,
          text: 'Tier 3',
        );
      default:
        return Badge(
          color: Colors.grey,
          icon: "Icons.verified_user",
          text: 'Unverified',
        );
    }
  }
}

class Badge extends StatelessWidget {
  final Color color;
  final String text;
  final String icon;

  const Badge(
      {Key? key, required this.color, required this.text, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        Icons.verified_user,
        size: 20,
        color: Colors.white,
      ),
      // child: Text(
      //   text,
      //   style: TextStyle(
      //     color: Colors.white,
      //     fontSize: 16,
      //   ),
      // ),
    );
  }
}
