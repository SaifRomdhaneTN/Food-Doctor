// ignore_for_file: use_build_context_synchronously, file_names



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prototype/Components/BackgroundWidget.dart';
import 'package:prototype/Components/RegScreenButton.dart';
import 'package:prototype/Screens/Auth/ForgotPassword.dart';
import 'package:prototype/Screens/FormScreen.dart';
import 'package:prototype/Screens/MainScreen.dart';
import 'package:prototype/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';



class LoginP extends StatefulWidget {
  const LoginP({Key? key}) : super(key: key);

  static String id ="LoginP";

  @override
  State<LoginP> createState() => _LoginPState();
}

class _LoginPState extends State<LoginP> {
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  final _auth = FirebaseAuth.instance;
  final _firestore =FirebaseFirestore.instance;
  late String email;
  late String pwd;
  bool showS = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> getUserFilledFormProperty( ) async {
    DocumentSnapshot documentSnapshotAccountsDel = await _firestore.collection("admin").doc("DeletedAccounts").get();
    List<dynamic> accountsDeleted =documentSnapshotAccountsDel.get("emails") ;
    try {
      await _auth.signInWithEmailAndPassword(email: email.trim(), password: pwd);
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
      else {
        msg = e.toString();
      }
      CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: msg);
    }
      try{
        DocumentSnapshot documentSnapshot = await _firestore.collection("users").doc(_auth.currentUser!.email).get();
        Map<String,dynamic> usersinfo =documentSnapshot.get("Additonal Information");
        bool filledForm = usersinfo["FilledForm"];

        setState(() {
          showS=false;
        });
        if(_auth.currentUser!.emailVerified){
          await _firestore.collection("users").doc(_auth.currentUser!.email).update({'LoggedIn':true,});
          SharedPreferences prefs =await SharedPreferences.getInstance();
          prefs.setString("email", _auth.currentUser!.email!);
          if(filledForm == false){
            Navigator.pushNamed(context, FormScreen.id);
          }
          else{
            Navigator.pushNamed(context, MainScreen.id);
          }}
        else {
          _auth.signOut();
          CoolAlert.show(context: context, type: CoolAlertType.warning,title: 'Email not verified',text: "Please verify your email. check your junk mail if you didn't find it in the main section");}
      }
      catch(e){
      if(accountsDeleted.contains(_auth.currentUser!.email)){
        _auth.currentUser!.delete();
        await CoolAlert.show(
            context: context,
            type: CoolAlertType.warning,
            title: "Account Deleted",
            text: "It seems your account have been deleted by an admin. \n "
                "If you need further details please send an email to this address : saif.romtn@gmail.com");
      }
      else{
        await CoolAlert.show(
            context: context,
            type: CoolAlertType.warning,
            text: e.toString());
      }
        setState(() {
          showS=false;
        });

      }
  }


  @override
  Widget build(BuildContext context) {
    return   ModalProgressHUD(
      inAsyncCall: showS,
      child: Scaffold(
        body: BackgroundWidget(
            bgImage: 'assets/background.gif',
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text("LOG IN",
                    textAlign: TextAlign.center,
                    style: kTitleTextStyle.copyWith(fontSize: 70)
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Text("Email",style: kTextRegStyle,),
                  const SizedBox(height:10.0),
                  SizedBox(
                    width: 200.0,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: kInputDecorationOfAuth.copyWith(
                        prefixIcon: const Icon(Icons.email,color: kCPGreenMid,)
                      ),
                      onChanged: (value){
                        email = value;
                      },
                      validator: (value){
                        if(value == null || value.length<2) return "Empty field";
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  Text("Password",style: kTextRegStyle,),
                  const SizedBox(height:10.0),
                  SizedBox(
                    width: 200.0,
                    child: TextFormField(
                      obscureText: obscurePassword,
                      decoration: kInputDecorationOfAuth.copyWith(
                          suffixIcon: InkWell(
                              child: Icon(iconPassword,color: kCPGreenMid,),
                            onTap: (){
                                setState(() {
                                  if(iconPassword == CupertinoIcons.eye_fill ){
                                    iconPassword = CupertinoIcons.eye_slash;
                                    obscurePassword = false;
                                  }
                                  else{
                                    iconPassword = CupertinoIcons.eye_fill;
                                    obscurePassword = true;
                                  }
                                });
                            },
                          )
                      ),
                      onChanged: (value){
                        pwd = value;
                      },
                      validator: (value){
                        if(value == null || value.length<2) return "Empty field";
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0,),
                  Padding(
                    padding: const EdgeInsets.only(right: 60.0),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const ForgotPassword()));
                      },
                      child: const Text("Forgot password ?",style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFEDF1D6),
                      ),),
                    ),
                  ),
                  const SizedBox(height: 40.0,),
                  RegScreenButton(
                      onPressed: () async{
                        if(_formKey.currentState!.validate()) {
                          setState(() {
                            showS=true;
                          });
                          await getUserFilledFormProperty();
                        }
                      },
                      msg: 'Connect',
                      txtColor: Colors.white,
                      bgColor: const Color(0xFF40513B),),
                ],
              ),
            )
        ),
      ),
    );
  }
}
