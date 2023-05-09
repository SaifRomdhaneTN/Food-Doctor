// ignore_for_file: file_names
import 'package:flutter/material.dart';

class InfoFormButton extends StatelessWidget {
  const InfoFormButton({
    super.key, required this.onPressed, required this.child,
  });
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
        elevation: 2.0,
        onPressed: onPressed,
        shape: const CircleBorder(
            side: BorderSide(
                width: 3,
                color: Color(0xFF40513B)
            )
        ),
        fillColor: const Color(0xFF9DC08B),
        child: child);
  }
}