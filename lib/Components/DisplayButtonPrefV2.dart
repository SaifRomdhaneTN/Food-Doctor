// ignore_for_file: file_names

import 'package:flutter/material.dart';

class DisplayButtonPrefV2 extends StatelessWidget {
  const DisplayButtonPrefV2({
    super.key, required this.title, required this.color, required this.onPressed, required this.textStyle,
  });
  final String title;
  final VoidCallback onPressed;
  final Color color;
  final TextStyle textStyle;
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
        backgroundColor: MaterialStateProperty.resolveWith((states) => color),
      ),
      child: Column(
        children:  [
          Padding(
            padding: const EdgeInsets.only(top: 5.0,bottom: 15,right: 10,left: 10),
            child: Text(
                title,
                textAlign: TextAlign.center,
                style: textStyle
            ),
          ),
        ],
      ),
    );
  }
}