import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_smart_city/LoginPages/login_or_register.dart';
import 'package:my_smart_city/bottomNavBar/bottomNavBar.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        //user is logged in
        if (snapshot.hasData) {
          return const NavBar();
        } else {
          return const LoginOrRegister();
        }
      },
    ));
  }
}
