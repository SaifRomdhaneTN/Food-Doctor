
// ignore_for_file: file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prototype/Components/CircularButton.dart';
import 'package:prototype/Screens/Auth/LoginPage.dart';
import 'package:prototype/Screens/Auth/RegisterGoogle.dart';
import 'package:prototype/Screens/Auth/registration_screen1.dart';
import 'package:prototype/Screens/FormScreen.dart';
import 'package:prototype/Screens/MainScreen.dart';

import '../Components/BackgroundWidget.dart';

import '../Components/WelcomeButton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';
class WelcomeScreen extends StatefulWidget {
  
  static String id = 'WelcomeScreen';

  const WelcomeScreen({super.key});
  
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();}


class _WelcomeScreenState extends State<WelcomeScreen> {

  void signInWithGoogle() async{
    FirebaseAuth auth = FirebaseAuth.instance;
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
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                  TextButton(
                      style: kWelcomeScreenCircularButtonStyle,
                      onPressed: () async {
                        signInWithGoogle();
                      },
                      child: const Image(image: AssetImage('assets/google.png'),height: 60,width: 60,)
                  ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    CircularButton(
                        icon: FontAwesomeIcons.facebook,
                        bgcolor: Colors.blueAccent,
                        iconColor: Colors.white,
                        onPressed: () async {
                          GoogleSignIn googleSignIn = GoogleSignIn();
                          await googleSignIn.signOut();
                        },)
                  ],
                ),
              ],
            )
        ),
      ),
    );
  }
}







