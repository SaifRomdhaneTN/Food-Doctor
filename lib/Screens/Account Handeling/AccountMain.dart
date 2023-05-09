// ignore_for_file: file_names, no_logic_in_create_state, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prototype/Components/AccountButton.dart';
import 'package:prototype/Components/BackgroundWidget.dart';
import 'package:prototype/Screens/Account%20Handeling/ChangePassword.dart';
import 'package:prototype/Screens/Account%20Handeling/MyUserInfoScreen.dart';
import 'package:prototype/Screens/Account%20Handeling/PreferencesScreen.dart';
import 'package:prototype/Screens/Account%20Handeling/SignedInWithGoogle.dart';

class AccountMain extends StatefulWidget {
   const AccountMain({Key? key, required this.document}) : super(key: key);
   final DocumentSnapshot document;
  @override
  State<AccountMain> createState() => _AccountMainState(document);
}

class _AccountMainState extends State<AccountMain> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final DocumentSnapshot document;
  late Map<String,dynamic> userPersonalInfo;
  _AccountMainState(this.document);

  Future<void> _showAllergiesDialog() async {
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog( // <-- SEE HERE
              title: const Text('Are you sure you want to delete your account?'),
              children: [
                Row(
                  children: [
                    SimpleDialogOption(
                      child: const Text('Yes'),
                      onPressed: () async {
                        String? email = auth.currentUser!.email;
                        String providerId = auth.currentUser!.providerData.first.providerId;
                        auth.currentUser!.delete();
                        if(providerId == 'google.com'){
                          GoogleSignIn googleSignIn = GoogleSignIn();
                          await googleSignIn.signOut();
                        }
                        else{
                          await auth.signOut();
                        }
                        firestore.collection("users").doc(email).delete();

                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                    ),
                    SimpleDialogOption(
                      child: const Text('No'),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ]
          );
        });
  }


  @override
  void initState()  {
    userPersonalInfo = document.get("Additonal Information");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: BackgroundWidget(
        bgImage: 'assets/backgroundwhite.gif',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:   [
            PhysicalModel(
              color: const Color(0xFF9D9D9D),
              borderRadius: BorderRadius.circular(90),
              elevation: 10,
              child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.person,color: Colors.black38,size: 150,),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(userPersonalInfo['FullName'],style: const TextStyle(
                  color: Color(0xFF609966),
                  fontFamily: 'Eastman',
                  fontSize: 32
              ),),
            ),
            const SizedBox(
              width: 50,
              child: Divider(
                thickness: 2,
                color: Colors.black54,
              ),
            ),
            AccountButton(
              text: 'My Preferences',
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>PreferencesScreen(document: document)));
              },),
            AccountButton(
              text: 'My User Information',
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyUserInfoScreen(userInfo: userPersonalInfo)));
              },),
            AccountButton(
              text: 'Change Password',
              onPressed: (){
                String providerId = auth.currentUser!.providerData.first.providerId;
                if(providerId != 'google.com') {
                  String hashedPass = document.get('passwordHash');
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ChangePassword(originalPassHash: hashedPass,)));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignedInWithGoogle()));
                }
              },),
            AccountButton(
              text: 'Delete Account',
              onPressed: _showAllergiesDialog,),
          ],
        ),
      ),
    );
  }
}


