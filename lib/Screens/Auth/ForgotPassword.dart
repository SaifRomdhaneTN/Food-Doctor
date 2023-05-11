// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prototype/Components/BackgroundWidget.dart';
import 'package:prototype/Components/RegScreenButton.dart';
import 'package:prototype/constants.dart';

class ForgotPassword extends StatefulWidget {
   const ForgotPassword({Key? key}) : super(key: key);
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late String email;
  late bool showS=false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showS,
      child: Scaffold(
        body: BackgroundWidget(
          bgImage: 'assets/backgroundwhite.gif',
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Forgot Password?",style: kTitleTextStyle2),
                const SizedBox(
                  height: 10,
                ),
                 Text(
                  "Type in your email. "
                      "\n and if it exists then we will send you a mail so you can change your password",
                  style: kFormHomeTextStyle.copyWith(color: Colors.black),
                  textAlign: TextAlign.center,),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 200.0,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: kInputDecorationOfAuth,
                    onChanged: (value){
                       email = value;
                    },
                    validator: (value){
                      if(value == null || value.length<2) return "Empty field";
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                RegScreenButton(
                  onPressed: () async {
                    if(_formKey.currentState!.validate()) {

                      bool result =await CheckEmail();
                      if(result){
                        CoolAlert.show(
                            context: context,
                            type:CoolAlertType.success,
                            title: "Account Found",
                            text: "an email has been to your mail. please do check your junk mails as well");
                      }
                      else {
                        CoolAlert.show(
                          context: context,
                          type:CoolAlertType.error,
                          title: "Account Error",
                          text: "There is no account by this email!");
                      }
                    }
                  },
                  msg: 'Connect',
                  txtColor: Colors.white,
                  bgColor: const Color(0xFF40513B),),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> CheckEmail() async {
    DocumentSnapshot document =await firestore.collection("users").doc(email).get();
    if(document.exists){
      auth.sendPasswordResetEmail(email: email);
      return true;
    }
    else {
      return false;
    }
  }
}
