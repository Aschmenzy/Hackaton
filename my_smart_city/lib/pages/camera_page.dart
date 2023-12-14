// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, unnecessary_nullable_for_final_variable_declarations

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class CameraPage extends StatefulWidget {
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;

  int direction = 0;

  @override
  void initState() {
    startCamera();
    super.initState();
  }

  void startCamera() async {
    cameras = await availableCameras();

    cameraController = CameraController(
        cameras[direction], ResolutionPreset.high,
        enableAudio: false);

    await cameraController.initialize().then((value) {
      if (!mounted) {
        return;
      }
      //refreshes the screen
      setState(() {});
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController.value.isInitialized) {
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
                  final String? imagePath = file.path;
                  final File imageFile = File(imagePath!);

                  // Get the directory to save the image
                  final Directory? picturesDirectory =
                      await getApplicationDocumentsDirectory();
                  final String picturesPath = picturesDirectory!.path;

                  // Copy the file to the new path
                  final File newImage = await imageFile.copy(
                      '$picturesPath/${DateTime.now().toIso8601String()}.png');

                  // Save the image to the gallery
                  final result =
                      await ImageGallerySaver.saveFile(newImage.path);
                  print(result);
                }
              },
              child: button(Icons.camera_alt_outlined, Alignment.bottomCenter),
            ),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }
}

Widget button(IconData icon, Alignment alignment) {
  return Align(
    alignment: alignment,
    child: Container(
      margin: EdgeInsets.only(
        left: 10,
        bottom: 30,
      ),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 10)
          ]),
      child: Center(
        child: Icon(
          icon,
          color: Colors.black,
        ),
      ),
    ),
  );
}
