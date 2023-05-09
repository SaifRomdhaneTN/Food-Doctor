// ignore_for_file: file_names

import 'package:flutter/material.dart';

class SignedInWithGoogle extends StatelessWidget {
  const SignedInWithGoogle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF1D6),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Image(image: AssetImage('assets/google.png'),width: 200,height: 200,),
          SizedBox(height:20,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text("It appears you have signed in using google. \n therefore you can not change you're password.",style: TextStyle(
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
