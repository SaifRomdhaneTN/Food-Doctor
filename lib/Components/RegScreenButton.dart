// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:prototype/constants.dart';

class RegScreenButton extends StatelessWidget {


  final VoidCallback onPressed;
  final String msg;
  final Color txtColor;
  final Color bgColor;

  const RegScreenButton({super.key, required this.onPressed, required this.msg, required this.txtColor, required this.bgColor});


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) => bgColor,
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0)
              )
          ),
          elevation: MaterialStateProperty.resolveWith((states) => 5),
          shadowColor: MaterialStateProperty.resolveWith((states) => const Color.fromRGBO(0, 0, 0, 1))
        ),
        child:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 10.0),
          child: Text(
            msg,
            style: kRegButtonTxtStyle.copyWith(color: txtColor),
            textAlign: TextAlign.left,),
        ));
  }
}