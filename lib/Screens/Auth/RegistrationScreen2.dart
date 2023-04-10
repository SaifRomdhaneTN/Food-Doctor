// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, no_logic_in_create_state, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prototype/Components/BackgroundWidget.dart';
import 'package:prototype/Components/Classes/User.dart';
import 'package:prototype/Components/InfoFormButton.dart';
import 'package:prototype/Components/RegScreenButton.dart';
import 'package:prototype/Screens/Auth/LoginPage.dart';
import 'package:prototype/constants.dart';


class RegistrationScreenP2 extends StatefulWidget {
   const RegistrationScreenP2({Key? key,  required this.tempuser}) : super(key: key);
  static String id = 'RegP2';
  final UserLocal tempuser;
  @override
  State<RegistrationScreenP2> createState() => _RegistrationScreenP2State(tempuser);
}

class _RegistrationScreenP2State extends State<RegistrationScreenP2> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final UserLocal user;

  late String email;
  late String pwd="";
  late String cpwd;
  bool showS = false;

  _RegistrationScreenP2State(this.user);

  Future<void> CreateUser(UserLocal u) async {

        try{
          u.filledform(false);
          final UserCredential newUser = await _auth.createUserWithEmailAndPassword(email: email, password: pwd);
          await FirebaseFirestore.instance.collection("users").doc(email).set(UserToJson(u,  newUser));
          setState(() {
            showS=false;
          });
          Navigator.pushNamed(context, LoginP.id);
        }
        catch(e){
          setState(() {
            showS = false;
          });
          String msg ="";
          if(e.toString().contains("email-already-in-use")){
            msg= "Email Already used by another account.";
          }
          CoolAlert.show(
            context: context,
              type: CoolAlertType.error,
              title:  "Error!",
              text:  msg
          );
        }
    }


  Map<String,dynamic> UserToJson(UserLocal u,UserCredential newuser)=>{
    'email':newuser.user!.email,
    'Additonal Information':u.toJson()
  };

  bool validatePassword(String value) {
    RegExp regex =
    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#&_*~]).{8,}$');
    if (value.isEmpty) {
      return false;
    } else {
      if (!regex.hasMatch(value)) {
        return false;
      } else {
        return true;
      }
    }
  }
  void ShowerrorMessage(msg){
    CoolAlert.show(
        context: context,
        type: CoolAlertType.error,
        text: msg);
  }

  @override
  Widget build(BuildContext context) {
    UserLocal u = user;
    return  ModalProgressHUD(
      inAsyncCall: showS,
      child: Scaffold(
        body: BackgroundWidget(
            bgImage: 'assets/background.gif',
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 80.0,
                    ),
                    const Hero(
                      tag: 'signup',
                      child: Text("Registre",
                          textAlign: TextAlign.center,
                          style: kTitleTextStyle
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Text("Email",style: kTextRegStyle,),
                    const SizedBox(height:10.0),
                    SizedBox(
                      width: 200.0,
                      child: TextFormField(
                        validator: (value){
                          if(value == null || !EmailValidator.validate(value)) return "email non validé";
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: kInputDecorationOfAuth,
                        onChanged: (value){
                          email = value;
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0,),
                    Text("mot de pas",style: kTextRegStyle,),
                    const SizedBox(height:10.0),
                    SizedBox(
                      width: 200.0,
                      child: Row(
                        children: [
                          Flexible(
                            child: TextFormField(
                              validator: (value){
                                if(value == null || !validatePassword(value)) return "non validé";
                                return null;
                              },
                              obscureText: true,
                              decoration: kInputDecorationOfAuth,
                              onChanged: (value){
                                  pwd=value;
                              },
                            ),
                          ),
                          InfoFormButton(
                            onPressed: (){
                              CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.info,
                                  title: "Specification de mot de pas",
                                  text: " le mot de passe doit contenir au moins :  \n *) 1 nombre \n *) 1 lettre (Majuscule et Minuscule ) \n *) et 1 caractère spécial (!@#&_*~)");
                            },
                            child: const Text("!",style: kInfoButtonTextStyleReg2),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20.0,),
                    Text("Confirmé mot de pas",style: kTextRegStyle,),
                    const SizedBox(height:10.0),
                    SizedBox(
                      width: 200.0,
                      child: TextFormField(
                        validator: (value){
                          if(value == null || value!= pwd) return "ce n'est pas égale à ci-dessus";
                          return null;
                        },
                        obscureText: true,
                        decoration: kInputDecorationOfAuth,
                        onChanged: (value){
                          cpwd=value;
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0,),
                    RegScreenButton(
                        onPressed: ()  {
                          setState(() {
                            showS=true;
                          });
                          if (_formKey.currentState!.validate()) {
                            CreateUser(u);
                          }
                          else {
                            setState(() {
                              showS=false;
                            });
                          }
                        },
                        msg: 'Finish',
                        txtColor: Colors.white,
                        bgColor: const Color(0xFF40513B))
                  ],
                ),
              ),
            )),
      ),
    );
  }
}


