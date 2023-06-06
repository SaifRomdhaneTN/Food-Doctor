// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ProductnotfoundPage extends StatelessWidget {
  const ProductnotfoundPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFEDF1D6),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/crossedout.png'),width: 200,height: 200,),
          SizedBox(height:20,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text("Sorry but the product you are scanning is unrecognizable in our database. \n we apologize for this inconvenience :(",style: TextStyle(
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
