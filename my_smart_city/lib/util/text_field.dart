import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Colors.black,
            width: 2.0,
          ),
        ),
        labelText: hintText,
        labelStyle: GoogleFonts.inter(
          color: Colors.black,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
