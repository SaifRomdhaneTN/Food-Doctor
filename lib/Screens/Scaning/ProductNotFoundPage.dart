// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ProductnotfoundPage extends StatelessWidget {
  const ProductnotfoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF1D6),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Image(image: AssetImage('assets/sademoji.gif'),width: 200,height: 200,),
          SizedBox(height:20,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text("So sorry but the product you are scanning is unrecognizable. \n we apologize for this inconvenience :(",style: TextStyle(
              fontFamily: 'Eastman',
              fontSize: 24,
              wordSpacing: 1.5,
              height: 1.25
            ),
            textAlign: TextAlign.center,),
          )
        ],
      ) ,
    );
  }
}
