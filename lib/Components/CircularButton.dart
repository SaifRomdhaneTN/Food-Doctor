import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CircularButton extends StatelessWidget {
  const CircularButton({
    super.key, required this.icon, required this.bgcolor, required this.iconColor,
  });

  final IconData icon;
  final Color bgcolor;
  final Color iconColor;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith((states) =>bgcolor),
          elevation: MaterialStateProperty.resolveWith((states) => 10),
          shape: MaterialStateProperty.all<CircleBorder>(
              CircleBorder(

              )
          ),
        ),
        onPressed: (){

        },
        child:  FaIcon(
          icon,
          color: iconColor,
          size: 60,)
    );
  }
}
