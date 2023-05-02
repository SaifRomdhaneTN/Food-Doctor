// ignore_for_file: use_build_context_synchronously



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prototype/Components/BackgroundWidget.dart';
import 'package:prototype/Components/RegScreenButton.dart';
import 'package:prototype/Screens/FormScreen.dart';
import 'package:prototype/Screens/MainScreen.dart';
import 'package:prototype/constants.dart';



class LoginP extends StatefulWidget {
  const LoginP({Key? key}) : super(key: key);

  static String id ="LoginP";

  @override
  State<LoginP> createState() => _LoginPState();
}

class _LoginPState extends State<LoginP> {
  final _auth = FirebaseAuth.instance;
  final _firestore =FirebaseFirestore.instance;
  late String email;
  late String pwd;
  bool showS = false;
  Future<void> getUserFilledFormProperty( ) async {
    try{
      UserCredential user = await _auth.signInWithEmailAndPassword(email: email.trim(), password: pwd);
      QuerySnapshot  usersAditionalInfo = await _firestore.
      collection('users').
      where('email',isEqualTo: user.user!.email).get();
      dynamic usersinfo =usersAditionalInfo.docs.first.get("Additonal Information");
      bool filledForm = usersinfo["FilledForm"];

      setState(() {
        showS=false;
      });
      if(filledForm == false){
        Navigator.pushNamed(context, FormScreen.id);
      }
      else{
        Navigator.pushNamed(context, MainScreen.id);
      }
    }
    catch(e){
      setState(() {
        showS=false;
      });
      String msg = "";
      if(e.toString().contains("user-not-found")) {
        msg="there is no user with this email";
      } else if (e.toString().contains("wrong-password")) {
        msg="Wrong Password";
      }
     else if (e.toString().contains("invalid-email")) {
    msg="Invalid Email";
    }
    CoolAlert.show(
    context: context,
    type: CoolAlertType.error,
    text: e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return   ModalProgressHUD(
      inAsyncCall: showS,
      child: Scaffold(
        body: BackgroundWidget(
            bgImage: 'assets/background.gif',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text("SE CONNECTER",
                  textAlign: TextAlign.center,
                  style: kTitleTextStyle.copyWith(fontSize: 40)
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Text("Email",style: kTextRegStyle,),
                const SizedBox(height:10.0),
                SizedBox(
                  width: 200.0,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: kInputDecorationOfAuth,
                    onChanged: (value){
                      email = value;
                    },
                  ),
                ),
                const SizedBox(height: 20.0,),
                Text("Mot de Passe",style: kTextRegStyle,),
                const SizedBox(height:10.0),
                SizedBox(
                  width: 200.0,
                  child: TextField(
                    obscureText: true,
                    decoration: kInputDecorationOfAuth,
                    onChanged: (value){
                      pwd = value;
                    },
                  ),
                ),
                const SizedBox(height: 20.0,),
                RegScreenButton(
                    onPressed: () async{
                      setState(() {
                        showS=true;
                      });
                      await getUserFilledFormProperty();
                    },
                    msg: 'connecter',
                    txtColor: Colors.white,
                    bgColor: const Color(0xFF40513B),),

              ],
            )),
      ),
    );
  }
}
