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
        title: Text('Tier 3 Upgrade Page'),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text('Step 1: Face Verification'),
          SizedBox(height: 20),
          _faceImage == null
              ? Text('Please take a clear photo of your face.')
              : Image.file(_faceImage!),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              getImage("face");
            },
            child: Text('Take Face Photo'),
          ),
          SizedBox(height: 20),
          Text('Step 2: Passport Verification'),
          SizedBox(height: 20),
          _passportImage == null
              ? Text('Please take a clear photo of your passport.')
              : Image.file(_passportImage!),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              getImage("passport");
            },
            child: Text('Take Passport Photo'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Verify face and passport images
              // Upgrade to Tier 3 if verification is successful
              // Otherwise, display error message
            },
            child: Text('Submit Verification'),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<File>('_faceImage', _faceImage));
  }
}
