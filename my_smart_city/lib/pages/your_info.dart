// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class infoPage extends StatelessWidget {
  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FloatingActionButton(
      onPressed: logOut,
      child: Icon(Icons.logout),
    ));
  }
}
