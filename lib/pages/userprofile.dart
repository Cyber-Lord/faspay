import 'package:faspay/pages/phonescreen.dart';
import 'package:faspay/pages/testCamera.dart';
import 'package:faspay/pages/upgradetierthreeform.dart';
import 'package:faspay/pages/upgradetiertwoform.dart';
import 'package:faspay/pages/upload_profile_pix.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum VerificationTier {
  basic,
  intermediate,
  advanced,
}

class UserProfile extends StatefulWidget {
  final String name;
  final String email;
  final String bvn;
  final String dob;
  final VerificationTier tier;
  final String phoneNumber;
  final String nin;
  final String kyc_status;
  final String img_url;

  UserProfile(
      {required this.name,
      required this.email,
      required this.bvn,
      required this.dob,
      required this.tier,
      required this.phoneNumber,
        required this.nin,
        required this.kyc_status, required this.img_url});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _formKey = GlobalKey<FormState>();
  File _image = File('');
  bool _editing = true;
  bool isTier1 = false;
  bool isTier2 = false;
  bool isTier3 = false;

  bool _isBiometricEnabled = false;
  TextEditingController _oldPinController = TextEditingController();
  TextEditingController _newPinController = TextEditingController();
  TextEditingController _confirmPinController = TextEditingController();
  String _errorMessage = '';
  bool _isPinVisible = false;

  String img_url="";

  void initState() {
    super.initState();
    _getTierBadge();
    if(widget.img_url==""){
      img_url='https://a2ctech.net/api/faspay/pix/default_pix.png';
    }else{
      img_url=widget.img_url;
    }
  }

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

  void goto_phone_screen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PhoneScreen()),
    );
  }

  Future<void> logout() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("phone");

    goto_phone_screen(context);
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
            onPressed: () {
              logout();
            },
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
                   // onTap: _editing ? _getImage : null,
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => New_profile_pix(

                        ),
                      ),);

                    },
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:NetworkImage(img_url),
                          child: _image == null
                              ? Icon(Icons.camera_alt, size: 50)
                              : null,
                          backgroundColor: Colors.white,
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
                    labelText: 'NIN',
                    prefixIcon: Icon(
                      FontAwesomeIcons.idCard,
                      // color: Colors.blue.shade900,
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,

                  enabled: false,
                  initialValue: widget.nin,
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
                Visibility(
                  visible: !isTier1,
                    child:  TextFormField(
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
                        prefixIcon: Icon(
                          Icons.email,
                          // color: Colors.blue.shade900,
                        ),
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
                    ),),
                Visibility(
                  child: TextFormField(
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
                  visible: !isTier1,
                ),
                Visibility(
                  child: TextFormField(
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
                  visible: !isTier1,
                ),
                SizedBox(
                  height: 16,
                ),
                if(widget.kyc_status=="Pending")...[
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.grey.shade300,
                      elevation: 1,
                    ),
                    onPressed: (){

                    },
                  child: Column(
      children: [
      ListTile(
      leading: Icon(
        FontAwesomeIcons.folder,
        color: Colors.blue.shade900,
      ),
      title: Text(
        "Under Review",
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blue.shade900,
        ),
      ),
      trailing: Icon(
        Icons.info,
        color: Colors.blue.shade900,
      ),
    ),
    ],
    ),
                  )
                ]else...[
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.grey.shade300,
                      elevation: 1,
                    ),
                    onPressed: () {
                      if (isTier1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UpgradePage()),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TierThreeUpgradePage()),
                        );
                      }
                    },
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.verified_user,
                            color: Colors.blue.shade900,
                          ),
                          title: Text(
                            !isTier1 ? 'Upgrade Account' : 'Verify Account',
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
                ],

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
                    // color: Colors.grey.shade300,
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
                Divider(
                  height: 2,
                  color: Colors.grey,
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

                    _changePIN(
                      context,
                      "Reset Password",
                      "Dear ${widget.name} Please kindly enter your old password and new password below to reset your account:",
                      "Old Password",
                      "New Password",
                      "Confirm New Password",
                      false,
                    );

/*
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Camtest(

                          )),
                    );
 */
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
                    _changePIN(
                      context,
                      "Reset Transaction PIN",
                      "Dear ${widget.name} Please kindly enter your old PIN and new PIN below:",
                      "Old PIN",
                      "New PIN",
                      "Confirm PIN",
                      true,
                    );
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
                        onChanged: (value) {
                          setState(() {
                            _isBiometricEnabled = value;
                          });
                          if (value) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(
                                    child: Text(
                                      "Verify Biometric",
                                      style: TextStyle(
                                        color: Colors.blue.shade900,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  content: SizedBox(
                                    height: 150,
                                    child: Column(
                                      children: [
                                        Text(
                                          Platform.isIOS
                                              ? "Please verify your your face ID to enable biometric authentication."
                                              : "Please verify your thumbprint to enable biometric authentication.",
                                          style: TextStyle(
                                            color: Colors.grey.shade700,
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Icon(
                                          Platform.isIOS
                                              ? Icons.face
                                              : Icons.fingerprint,
                                          color: Colors.grey.shade700,
                                          size: 80,
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                          color: Colors.blue.shade900,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // showDialog(
                            //   context: context,
                            //   builder: (BuildContext context) {
                            //     return AlertDialog(
                            //       title: Center(
                            //         child: Text(
                            //           "Biometric Disabled",
                            //           style: TextStyle(
                            //             color: Colors.blue.shade900,
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 16,
                            //           ),
                            //         ),
                            //       ),
                            //       content: Text(
                            //           "Biometric authentication has been disabled."),
                            //       actions: <Widget>[
                            //         TextButton(
                            //           child: Text("OK"),
                            //           onPressed: () {
                            //             Navigator.of(context).pop();
                            //           },
                            //         ),
                            //       ],
                            //     );
                            //   },
                            // );
                          }
                        },
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
        setState(() {
          isTier1 = true;
          isTier2 = false;
          isTier3 = false;
        });
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
        setState(() {
          isTier2 = true;
          isTier1 = false;
          isTier3 = true;
        });
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
        setState(() {
          isTier3 = true;
          isTier2 = true;
          isTier1 = false;
        });
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

  void _changePIN(BuildContext context, String title, String message,
      String label1, String label2, label3, bool isPin) {
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
                        title,
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
                        message,
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
                          labelText: label1,
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
                          labelText: label2,
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
                          labelText: label3,
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
