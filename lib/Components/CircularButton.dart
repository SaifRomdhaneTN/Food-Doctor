// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';

class CircularButton extends StatelessWidget {
  const CircularButton({
    super.key, required this.icon, required this.bgcolor, required this.iconColor, required this.onPressed,
  });

  final IconData icon;
  final Color bgcolor;
  final Color iconColor;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: kWelcomeScreenCircularButtonStyle.copyWith(backgroundColor: MaterialStateColor.resolveWith((states) =>bgcolor)),
        onPressed: onPressed,
        child:  FaIcon(
          icon,
          color: iconColor,
          size: 60,)
    );
  }
}
