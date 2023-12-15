// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UserIntoxicatonContainer extends StatelessWidget {
  final String userEmail;
  final String user;
  final Timestamp DateOfBooking;
  final String userIntoxication;
  final Color color;

  UserIntoxicatonContainer(
      {super.key,
      required this.userEmail,
      required this.user,
      required this.DateOfBooking,
      required this.userIntoxication, required this.color});

  late DateTime dateTime = DateOfBooking.toDate();

  // Format the timestamp to display only the month and day
  late String formattedDate = DateFormat.yMMMd().format(dateTime);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(
        left: 25,
        right: 25,
        top: 25,
      ),
      child: Wrap(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              top: 12,
              bottom: 12,
              right: 12,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //service type text
                    Text(
                      userIntoxication,
                      style:
                          GoogleFonts.inter(fontSize: 18, color: Colors.black),
                    ),
                    //time of booking text
                    Text(
                      userEmail,
                      style:
                          GoogleFonts.inter(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //username text
                    Text(
                      user,
                      style:
                          GoogleFonts.inter(fontSize: 18, color: Colors.black),
                    ),
                    //date text
                    Text(
                      formattedDate.toString(),
                      style:
                          GoogleFonts.inter(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
