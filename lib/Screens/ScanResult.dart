import 'package:flutter/material.dart';
import 'package:prototype/Components/BackgroundWidget.dart';
import 'package:prototype/constants.dart';

class ScanResult extends StatelessWidget {
  const ScanResult({Key? key, required this.Result}) : super(key: key);
  final String Result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        bgImage: 'assets/background.gif',
        child: Center(child: Text(Result,style: kTitleTextStyle,)),),
    );
  }
}
