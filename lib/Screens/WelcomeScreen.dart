
// ignore_for_file: file_names, use_build_context_synchronously, empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/BackgroundWidget.dart';

import '../Components/WelcomeButton.dart';

class WelcomeScreen extends StatefulWidget {
  
  static String id = 'WelcomeScreen';

  const WelcomeScreen({super.key});
  
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();}


class _WelcomeScreenState extends State<WelcomeScreen> {
  late bool showS = false;

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  void signInWithGoogle() async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    DocumentSnapshot documentSnapshotAccountsDel = await firestore.collection("admin").doc("DeletedAccounts").get();
    List<dynamic> accountsDeleted =documentSnapshotAccountsDel.get("emails") ;
    try {

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
      );
      await auth.signInWithCredential(credential);
    }
    catch(e){
      CoolAlert.show(context: context, type: CoolAlertType.error,text: e.toString());
    }
    DocumentSnapshot document = await firestore.collection("users").doc(auth.currentUser!.email).get();
    bool documentExists =document.exists;

    if(documentExists) {
      await firestore.collection("users").doc(auth.currentUser!.email).update({"LoggedIn":true});
      dynamic usersinfo =document.get("Additonal Information");
      SharedPreferences prefs =await SharedPreferences.getInstance();
      prefs.setString("email", auth.currentUser!.email!);
      if(usersinfo['FilledForm']==true) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const MainScreen()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const FormScreen()));
      }
    }
    else{
      if(!accountsDeleted.contains(auth.currentUser!.email)) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const RegisterGoogle()));
      } else {
        auth.currentUser!.delete();
        googleSignIn.signOut();
        await CoolAlert.show(
            context: context,
            type: CoolAlertType.warning,
            title: "Account Deleted",
            text: "It seems your account have been deleted by an admin. \n "
                "If you need further details please send an email to this address : saif.romtn@gmail.com");
      }
    }

  }
 
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: _onWillPop,
      child: ModalProgressHUD(
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
      ),
    );
  }
}







