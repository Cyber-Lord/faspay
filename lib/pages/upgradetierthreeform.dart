import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TierThreeUpgradePage extends StatefulWidget {
  @override
  _TierThreeUpgradePageState createState() => _TierThreeUpgradePageState();
}

class _TierThreeUpgradePageState extends State<TierThreeUpgradePage> {
  File? _faceImage;
  File? _passportImage;
  final picker = ImagePicker();
  bool hasError = false;

  Future getImage(String type) async {
    // ignore: deprecated_member_use
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (type == "face") {
        _faceImage = File(pickedFile!.path);
      } else if (type == "passport") {
        _passportImage = File(pickedFile!.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Document Verification',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text(
                    'Hello! by advancing your verification status, you can access exclusive features and benefits to enhance your financial experience with us. With this verification, you will be eligible to request our POS terminal and become an agent or merchant in your area.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  'Step 1: Face Verification',
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                _faceImage == null
                    ? Text(
                        'Please take a clear photo of your face.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      )
                    : Image.file(_faceImage!),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue.shade900, // foreground
                  ),
                  onPressed: () {
                    getImage("face");
                  },
                  child: Text('Take Face Photo'),
                ),
                SizedBox(height: 20),
                Text(
                  'Step 2: ID Verification',
                  style: TextStyle(
                    color: Colors.blue.shade900,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                _passportImage == null
                    ? Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Please take a clear photo of your National ID, Voter Card or International Passport.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      )
                    : Image.file(_passportImage!),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue.shade900, // foreground
                  ),
                  onPressed: () {
                    getImage("passport");
                  },
                  child: Text('Take Passport Photo'),
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue.shade900, // foreground
                  ),
                  onPressed: () {
                    _showDialog(
                        !hasError
                            ? "Successfully Submitted."
                            : "Document verification failed. Please try again.",
                        !hasError ? "Success" : "Error");

                    // Verify face and passport images
                    // Upgrade to Tier 3 if verification is successful
                    // Otherwise, display error message
                  },
                  child: Text('Submit Verification'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(String message, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
          ),
          content: !hasError
              ? Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 80,
                )
              : Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 80,
                ),
          // content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(
                'OK',
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<File>('_faceImage', _faceImage));
  }
}
