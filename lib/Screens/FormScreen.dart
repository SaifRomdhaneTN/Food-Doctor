// ignore_for_file: file_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prototype/Components/BackgroundWidget.dart';
import 'package:prototype/Components/RegScreenButton.dart';
import 'package:prototype/Screens/Form/FormPage1.dart';
import 'package:prototype/constants.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);
  static String id ="FormScreen";
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFFEDF1D6),
      body: BackgroundWidget(
        bgImage: 'assets/backgroundwhite.gif',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:   [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "In order to start using our application estimed user.\n"
                    "You will have to Fill in a quick form that will allow us to retrieve your food preferences. \n "
                    "Of course you can fill it in at a later date",
                textAlign: TextAlign.center,
                style: kFormHomeTextStyle
              ),
            ),
            const SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RegScreenButton(
                    onPressed: (){
                    Navigator.pushNamed(context, FormPage1.id);
                    },
                    msg: 'continue',
                    txtColor: Colors.white,
                    bgColor: const Color(0xFF609966)),
                const SizedBox(width: 10.0,),
                RegScreenButton(
                    onPressed: () async {
                      if(_auth.currentUser!.providerData.first.providerId=='google.com'){
                        GoogleSignIn googleSignIn = GoogleSignIn();
                       await googleSignIn.signOut();
                      }
                    else{_auth.signOut();}

                    Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    msg: 'Exit',
                    txtColor: const Color(0xFF609966),
                    bgColor: Colors.white),
              ],
            )
          ],
        )
      ),
    );
  }
}
