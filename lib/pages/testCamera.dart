import 'dart:io';

import 'package:flutter/material.dart';

import 'package:face_camera/face_camera.dart';
class Camtest extends StatefulWidget {
  const Camtest({Key? key}) : super(key: key);

  @override
  State<Camtest> createState() => _CamtestState();
}

class _CamtestState extends State<Camtest> {
  File? _capturedImage;
  Future<void> load_cam() async {
    WidgetsFlutterBinding.ensureInitialized(); //Add this
    await FaceCamera.initialize();
  }
  @override
  void initState() {
    super.initState();
    load_cam();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('FaceCamera example app'),
        ),
        body: Material(
         borderRadius: BorderRadius.circular(15),
          child: Container(
            width: 200,
            height: 200,
            color: Colors.red,
            child: Builder(builder: (context) {
              if (_capturedImage != null) {
                return Center(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Image.file(
                        _capturedImage!,
                        width: double.maxFinite,
                        fit: BoxFit.fitWidth,
                      ),
                      ElevatedButton(
                          onPressed: () => setState(() => _capturedImage = null),
                          child: const Text(
                            'Capture Again',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700),
                          ))
                    ],
                  ),
                );
              }

              return SmartFaceCamera(
                  autoCapture: true,
                  showCaptureControl: false,
                  defaultCameraLens: CameraLens.front,
                  showFlashControl: false,
                  showCameraLensControl: false,
                  onCapture: (File? image) {
                    setState(() => _capturedImage = image);
                  },
                  onFaceDetected: (Face? face) {
                    //Do something
                    print("capp");
                  },
                  messageBuilder: (context, face) {
                    if (face == null) {
                      return _message('Place your face in the camera');
                    }
                    if (!face.wellPositioned) {
                      return _message('Center your face in the square');
                    }

                    return const SizedBox.shrink();
                  });
            }),
          ),
        ),
    );
  }

  Widget _message(String msg) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 55, vertical: 15),
  child: Text(msg,
  textAlign: TextAlign.center,
  style: const TextStyle(
  fontSize: 14, height: 1.5, fontWeight: FontWeight.w400)));
  }

