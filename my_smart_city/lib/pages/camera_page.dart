// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, sized_box_for_whitespace, avoid_print, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class CameraPage extends StatefulWidget {
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final box = Hive.box('myBox');

  late List<CameraDescription> cameras;
  late CameraController cameraController;
  int direction = 0;
  bool isready = false;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    startCamera();
  }

  void startCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(
      cameras[direction],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await cameraController.initialize().then((_) {
      isready = true;
      if (!mounted) return;
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

  Future<String> determineIntoxicationLevel() async {
    await Future.delayed(Duration(seconds: Random().nextInt(7) + 4));
    return _random.nextInt(20) < 1 ? 'Not Intoxicated' : 'Intoxicated';
  }

  Future<void> saveTestResult(String intoxicationLevel) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Reference to the user's document in the Firestore collection
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection('UserIntoxicated')
          .doc(user.uid);

      // Get the current test results array
      DocumentSnapshot userDoc = await userDocRef.get();

      // Initialize the testResults array if it doesn't exist
      List<Map<String, dynamic>> testResults =
          (userDoc.exists && userDoc['testResults'] != null)
              ? List<Map<String, dynamic>>.from(userDoc['testResults'])
              : [];

      // Create a map for the new test result
      Map<String, dynamic> newTestResult = {
        'name': "Karlo",
        'email': user.email,
        'userUid': user.uid,
        'intoxicationLevel': intoxicationLevel,
        'timestamp': DateTime.now(),
      };

      // Add the new test result to the testResults array
      testResults.add(newTestResult);

      // Update the user's document with the modified testResults array
      await userDocRef.set({
        'testResults': testResults,
      });
    }
  }

  void showResultDialog(String result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              result == 'Not Intoxicated' ? Colors.green : Colors.red,
          title: Text('Result'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This person is $result'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void onCameraButtonPressed() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Processing...'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Detecting intoxication level...'),
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );

    String result = await determineIntoxicationLevel();
    Navigator.of(context).pop(); // Close the processing dialog
    await saveTestResult(result);
    showResultDialog(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                isready
                    ? Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: CameraPreview(cameraController),
                      )
                    : CircularProgressIndicator(),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            direction = direction == 0 ? 1 : 0;
                            startCamera();
                          });
                        },
                        child: button(Icons.flip_camera_ios_outlined),
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: onCameraButtonPressed,
                        child: button(Icons.camera_alt_outlined),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Text(
                'Point the camera at your face and click the camera button to check intoxication level.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget button(IconData icon) {
    return Container(
      margin: EdgeInsets.all(10),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 10)
        ],
      ),
      child: Center(child: Icon(icon, color: Colors.black)),
    );
  }
}
