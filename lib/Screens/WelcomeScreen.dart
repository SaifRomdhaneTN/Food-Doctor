
// ignore_for_file: file_names, use_build_context_synchronously, empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prototype/Screens/Auth/LoginPage.dart';
import 'package:prototype/Screens/Auth/RegisterGoogle.dart';
import 'package:prototype/Screens/Auth/registration_screen1.dart';
import 'package:prototype/Screens/FormScreen.dart';
import 'package:prototype/Screens/MainScreen.dart';

import '../Components/BackgroundWidget.dart';

import '../Components/WelcomeButton.dart';

class WelcomeScreen extends StatefulWidget {
  
  static String id = 'WelcomeScreen';

  const WelcomeScreen({super.key});
  
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();}


class _WelcomeScreenState extends State<WelcomeScreen> {
  late bool showS = false;

  void signInWithGoogle() async{
    try{FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );
    final UserCredential userCredential =  await auth.signInWithCredential(credential);
    DocumentSnapshot document = await firestore.collection("users").doc(userCredential.user!.email).get();
    bool documentExists =document.exists;
    if(documentExists) {
      dynamic usersinfo =document.get("Additonal Information");
      if(usersinfo['FilledForm']==true) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const MainScreen()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const FormScreen()));
      }
    }
    else{
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const RegisterGoogle()));
    }}
        catch(e){
        }
  }
 
  @override
  Widget build(BuildContext context) {
    return  ModalProgressHUD(
      inAsyncCall: showS,
      child: Scaffold(
        body: SafeArea(
          child: BackgroundWidget(
              bgImage: 'assets/FoodDoctor.gif',
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:   <Widget>[

                  WelcomeButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RegistrationScreenP1.id);
                      },
                      msg: 'Register',
                      icon: Icons.app_registration,
                      bgcolor: const Color(0xFF40513B),
                      txtcolor: const Color(0xFFEDF1D6)),
                  const SizedBox(height: 20.0,),
                  WelcomeButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginP.id);
                      },
                      msg: 'SignIn',
                      icon :Icons.login,
                      bgcolor:const Color(0xFF9DC08B),
                      txtcolor: const Color(0xFFEDF1D6)),
                  const SizedBox(height: 20.0,),
                  WelcomeButton(
                      msg: 'Google Sign In',
                      icon: FontAwesomeIcons.google,
                    bgcolor: Colors.white,
                    txtcolor: Colors.blueAccent,
                      onPressed: () async {
                        signInWithGoogle();
                      }
                  ),
                    const SizedBox(
                      width: 20.0,
                    ),
                ],
              )
          ),
        ),
      ),
    );
  }
}







