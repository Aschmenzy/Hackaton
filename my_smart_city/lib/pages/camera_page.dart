import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:tflite/tflite.dart';

class CameraPage extends StatefulWidget {
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  int direction = 0;
  String _intoxicationLevel = '';
  bool isready = false;

  @override
  void initState() {
    super.initState();
    startCamera();
    loadModel();
  }

  void startCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(
        cameras[direction], ResolutionPreset.high,
        enableAudio: false);

    await cameraController.initialize().then((value) {
      isready = true;
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((e) {
      print(e);
    });
  }

  Future<void> loadModel() async {
    String? res = await Tflite.loadModel(
      model: "assets/intoxication-detection.tflite",
      labels: "assets/labels.txt", // If you have labels
    );
    print(res);
  }

  @override
  void dispose() {
    cameraController.dispose();
    Tflite.close();
    super.dispose();
  }

  Future<void> detectIntoxication(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      // other parameters as per model requirements
    );

    // Process the recognitions to get intoxication level
    setState(() {
      _intoxicationLevel =
          recognitions?[0]["label"]; // Adjust according to your model's output
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isready){
      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(child: CameraPreview(cameraController)),
            GestureDetector(
              onTap: () {
                setState(() {
                  direction = direction == 0 ? 1 : 0;
                  startCamera();
                });
              },
              child:
                  button(Icons.flip_camera_ios_outlined, Alignment.bottomLeft),
            ),
            GestureDetector(
              onTap: () async {
                final XFile? file = await cameraController.takePicture();
                if (file != null) {
                  final File imageFile = File(file.path);
                  await detectIntoxication(imageFile);
                }
              },
              child: button(Icons.camera_alt_outlined, Alignment.bottomCenter),
            ),
            Positioned(
              child: Text(
                _intoxicationLevel.isNotEmpty
                    ? "Intoxication Level: $_intoxicationLevel"
                    : "Take a picture to detect intoxication",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              bottom: 100,
              left: 10,
            ),
          ],
        ),
      );
    }
    else{
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

Widget button(IconData icon, Alignment alignment) {
  return Align(
    alignment: alignment,
    child: Container(
      margin: EdgeInsets.only(left: 10, bottom: 30),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 10)
        ],
      ),
      child: Center(
        child: Icon(icon, color: Colors.black),
      ),
    ),
  );
}
