// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBadge extends StatelessWidget {
  const CustomBadge({
    super.key, required this.name, required this.icon,
  });
  final String name;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: CircleAvatar(
              backgroundColor: Colors.green,
              radius: 35,
              child: FaIcon(
                icon,
                size: 50,
                color: Colors.white,)
              ,),
          ),
          Text(name,style: const TextStyle(
              color: Color(0xFF40513B),
              fontSize: 16,
              fontFamily: "Eastman",
              fontWeight: FontWeight.bold
          ),)
        ],
      ),
    );
  }
}