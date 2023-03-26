import 'dart:developer';
import 'dart:io';

import 'package:faspay/pages/homepage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  Barcode? result;
  bool isScanned = false;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    controller?.resumeCamera();
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan QR"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 5, child: _buildQrView(context)),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.blue.shade900,
        borderRadius: 16,
        borderLength: 32,
        borderWidth: 8,
        cutOutSize: MediaQuery.of(context).size.width * 0.75,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Scan Result'),
              content: Text(scanData.code.toString()),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () async {
                    await controller.pauseCamera();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                phoneNumber: "",
                                token: "",
                              )),
                    );
                  },
                ),
              ],
            );
          });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
