// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:prototype/constants.dart';

class AccountButton extends StatelessWidget {
  const AccountButton({
    super.key, required this.text, required this.onPressed,
  });
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: SizedBox(
        width: 300,
        child: TextButton(
          onPressed: onPressed,
          style: kAccountManagmentButtons,
          child:  Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(text,style: const TextStyle(
                color: Color(0xFFEDF1D6),
                fontFamily: 'Eastman',
                fontWeight: FontWeight.bold,
                fontSize: 28
            ),
            ),
          ),
        ),
      ),
    );
  }
}