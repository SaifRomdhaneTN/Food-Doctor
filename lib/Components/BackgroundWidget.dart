// ignore_for_file: file_names

import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({
    super.key, required this.bgImage, required this.child,
  });

  final String bgImage;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        decoration:  BoxDecoration(
            image: DecorationImage(
                image: AssetImage(bgImage),
                fit: BoxFit.cover
            )
        ),
        child: child
    );
  }
}