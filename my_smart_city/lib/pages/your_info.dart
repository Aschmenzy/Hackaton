// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_smart_city/util/user_intox.dart';

class infoPage extends StatelessWidget {
  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            // History text in the top right corner
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 35.0, right: 15),
                child: Text(
                  'History',
                  style: GoogleFonts.inter(
                      fontSize: 32, fontWeight: FontWeight.w800),
                ),
              ),
            ),

            // Empty StreamBuilder
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("UserIntoxicated")
                    .doc(user!.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData ||
                      snapshot.data!.data() == null) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cancel_presentation_outlined,
                          color: Theme.of(context).colorScheme.primary,
                          size: 70,
                        ),
                        Text(
                          'No Data',
                          style: GoogleFonts.inter(
                            fontSize: 25,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    );
                  } else {
                    var userData =
                        snapshot.data!.data() as Map<String, dynamic>;

                    // Access the 'testResults' array from userData
                    List<dynamic> testResults =
                        userData['testResults'] as List<dynamic>;

                    // Now you can loop through testResults to access each individual test
                    return ListView.builder(
                      itemCount: testResults.length,
                      itemBuilder: (context, index) {
                        var test = testResults[index] as Map<String, dynamic>;

                        // Access the data fields you need from test
                        String userName = test['name'] ?? "Karlo";
                        Timestamp testDate = test['timestamp'] ?? "";
                        String intoxicationLevel =
                            test['intoxicationLevel'] ?? "";

                        // Check intoxication level and set color
                        Color containerColor;
                        if (intoxicationLevel == 'Not Intoxicated') {
                          containerColor = Colors.green;
                        } else {
                          containerColor = Colors.red;
                        }

                        // Create your UI widget here using the data
                        return UserIntoxicatonContainer(
                          userEmail: "",
                          user: userName,
                          DateOfBooking: testDate,
                          userIntoxication: intoxicationLevel,
                          color:
                              containerColor, // Pass the color to your widget
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
