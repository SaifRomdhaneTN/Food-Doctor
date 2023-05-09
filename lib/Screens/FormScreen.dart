// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                "Pour commencer à utiliser l’application, vous devez remplir un formulaire rapide.\n"
                    "en utilisant ceci nous comprendrons vos préférences quand il vient à la nourriture",
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
                    msg: 'continuer',
                    txtColor: Colors.white,
                    bgColor: const Color(0xFF609966)),
                const SizedBox(width: 10.0,),
                RegScreenButton(
                    onPressed: (){
                    _auth.signOut();
                    Navigator.pop(context);
                    },
                    msg: 'sortie',
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
