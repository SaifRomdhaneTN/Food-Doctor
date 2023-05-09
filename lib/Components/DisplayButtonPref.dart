// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:prototype/constants.dart';

class DisplayButtonPref extends StatelessWidget {
  const DisplayButtonPref({
    super.key, required this.title, required this.value, required this.onPressed,
  });
  final String title;
  final String value;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.resolveWith((states) => 5),
        shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            )
        ),
        backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.white),
      ),
      child: Column(
        children:  [
          Padding(
            padding: const EdgeInsets.only(top: 5.0,bottom: 15,right: 10,left: 10),
            child: Text(
                title,
                textAlign: TextAlign.center,
                style: kPrefDisplayTextStyle
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10,right: 10,left: 10),
            child: Text(
                value,
                textAlign: TextAlign.center,
                style: kPrefDisplayTextStyle.copyWith(fontWeight: FontWeight.normal)
            ),
          ),
        ],
      ),
    );
  }
}