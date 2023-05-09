// ignore_for_file: file_names, no_logic_in_create_state

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prototype/Components/BackgroundWidget.dart';
import 'package:prototype/Components/InfoFormButton.dart';
import 'package:prototype/Components/RegScreenButton.dart';
import 'package:prototype/constants.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key, required this.originalPassHash}) : super(key: key);
  final String originalPassHash;
  @override
  State<ChangePassword> createState() => _ChangePasswordState(originalPassHash);
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late bool equalToBasePassword= false;
  late bool showS = false;
  final String originalPassHash;
  late String newPass;

  _ChangePasswordState(this.originalPassHash);



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
  bool validatePassWithFirebase(String value)  {
    String hashedEnteredPassword = sha256.convert(utf8.encode(value)).toString();
    if(hashedEnteredPassword==originalPassHash) {
      print("Matches");
      return true;
    } else {
      print("Noooooooo");
      return false;
    }
  }

  void updatePassword() async {
    try{
      await _auth.currentUser!.updatePassword(newPass);
      await _firestore.collection("users").doc(_auth.currentUser!.email).update(
          {
            'passwordHash':sha256.convert(utf8.encode(newPass)).toString()
          }).then((value) => print("worked"));
    }
    catch(e){
      print("Error while updating password!");
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showS,
      child: Scaffold(
        body: BackgroundWidget(
          bgImage: 'assets/background.gif',
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: SizedBox(
                height: 600,
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 70.0),
                      child: Text("Change Password",style: kTitleTextStyle.copyWith(fontSize: 36),),
                    ),
                    const SizedBox(
                      height: 50,
                      width: 100,
                      child: Divider(
                        thickness: 3,
                      ),
                    ),
                    Text("Original Password",style: kTextRegStyle,),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        validator: (value)  {
                          if(value == null) return "empty Field";
                          if(!validatePassWithFirebase(value)) return"this password does not match the original one";
                          return null;
                        },
                        obscureText: true,
                        decoration: kInputDecorationOfAuth,
                        onChanged: (value)  {
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0,),
                    Text("New Password",style: kTextRegStyle,),
                    const SizedBox(height:10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            validator: (value){
                              if(value == null ) return "Empty field";
                              if(!validatePassword(value)) return "Not Valid. Check '!' sign to the right.";
                              return null;
                            },
                            obscureText: true,
                            decoration: kInputDecorationOfAuth,
                            onChanged: (value){
                              newPass=value;
                            },
                          ),
                        ),
                        InfoFormButton(
                          onPressed: (){
                            CoolAlert.show(
                                context: context,
                                type: CoolAlertType.info,
                                title: "Specification of Password:",
                                text: " The password must Contain at least:  \n - 1 Number \n - 1 Letter (Upper and Lower Case) \n - And 1  special character among these: \n !@#&_*~");
                          },
                          child: const Text("!",style: kInfoButtonTextStyleReg2),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0,),
                    Text("Confirm New Password",style: kTextRegStyle,),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        validator: (value)  {
                          if(value == null) return "empty Field";
                          if(value!=newPass) return"does not match the above Password!";
                          return null;
                        },
                        obscureText: true,
                        decoration: kInputDecorationOfAuth,
                        onChanged: (value)  {
                        },
                      ),
                    ),
                    const SizedBox(height: 20.0,),
                    RegScreenButton(
                        onPressed: ()  {
                          setState(() {
                            showS=true;
                          if (_formKey.currentState!.validate()) {
                            updatePassword();
                              showS=false;
                              Navigator.pop(context);
                          }
                          else {
                              showS=false;
                          }
                          });
                        },
                        msg: 'Finish',
                        txtColor: Colors.white,
                        bgColor: const Color(0xFF40513B))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


}


