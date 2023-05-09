// ignore_for_file: file_names

import 'package:flutter/material.dart';

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: TextButton(
        onPressed: (){
          Navigator.pop(context);
        },
          child: const Text("Hey!",style: TextStyle(
            color: Colors.white
          ),),
      )
    );
  }
}
