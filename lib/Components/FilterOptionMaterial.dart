import 'package:flutter/material.dart';
import 'package:prototype/constants.dart';

class FilterOptionMaterial extends StatelessWidget {
  const FilterOptionMaterial({
    super.key,
    required this.color, required this.txt,
  });

  final Color color;
  final String txt;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      elevation: 1,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45)
      ),
      child:  Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(txt,style: kFiltersOptionTextStyle),
      ),
    );
  }
}