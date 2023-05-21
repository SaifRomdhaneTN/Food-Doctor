// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:prototype/constants.dart';

class DashboardItemRowIcon extends StatelessWidget {
  const DashboardItemRowIcon({
    super.key,
    required this.icon, required this.name,
  });

  final IconData icon;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kCPWhite
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0,left:20.0,top: 10,bottom: 5),
            child: Icon(icon,size: 60,color: kCPGreenMid,)
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(name,style: const TextStyle(fontFamily: 'Eastman',fontSize: 26,fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    );
  }
}