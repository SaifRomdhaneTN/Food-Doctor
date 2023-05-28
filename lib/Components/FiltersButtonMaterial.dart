// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:prototype/constants.dart';

class FiltersButtonMaterial extends StatelessWidget {
  const FiltersButtonMaterial({
    super.key, required this.btnColor, required this.icon, required this.value, required this.txtColor,
  });

   final Color btnColor;
   final Color txtColor;
   final IconData icon;
   final String value;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(15),
      color:btnColor,
      elevation: 5,
      shadowColor: const Color.fromRGBO(0, 0, 0, 0.7),
      child:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(icon,color: Colors.white,),
            ),
            Text(
                value,
                style: kFiltersButtonTextStyle.copyWith(color: txtColor)
            ),
          ],
        ),
      ),
    );
  }
}