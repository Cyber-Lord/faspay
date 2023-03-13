import 'package:faspay/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerScreen extends StatefulWidget {
  @override
  _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen>
    with WidgetsBindingObserver {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool scanInProgress = false;
  bool isScanned = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && controller != null) {
      controller!.resumeCamera();
    } else if (state == AppLifecycleState.inactive) {
      controller!.pauseCamera();
    } else if (state == AppLifecycleState.paused) {
      controller!.pauseCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan QR Code'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          _buildQRView(context),
          if (scanInProgress) CircularProgressIndicator(),
        ],
      ),
    );
  }

  Widget _buildQRView(BuildContext context) {
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
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!isScanned) {
        isScanned = true;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Scan Result'),
              content: Text(scanData.code.toString()),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    isScanned = false;
                    controller.resumeCamera();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                    initState();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }
}
