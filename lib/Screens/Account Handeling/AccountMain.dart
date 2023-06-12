// ignore_for_file: file_names, no_logic_in_create_state, use_build_context_synchronously, empty_catches
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prototype/Components/AccountButton.dart';
import 'package:prototype/Components/BackgroundWidget.dart';
import 'package:prototype/Screens/Account%20Handeling/ChangePassword.dart';
import 'package:prototype/Screens/Account%20Handeling/MyUserInfoScreen.dart';
import 'package:prototype/Screens/Account%20Handeling/PreferencesScreen.dart';
import 'package:prototype/Screens/Account%20Handeling/SignedInWithGoogle.dart';
import 'package:prototype/Screens/Auth/ChangePhoto.dart';
import 'package:prototype/Screens/WelcomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  late ImageProvider image;
  _AccountMainState(this.document);

  Future<void> _showDeleteDialog() async {
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
                        String? userID = auth.currentUser!.uid;
                        String providerId = auth.currentUser!.providerData.first.providerId;
                        auth.currentUser!.delete();
                        if(providerId == 'google.com'){
                            GoogleSignIn googleSignIn = GoogleSignIn();
                            await googleSignIn.signOut();
                        }
                        else{
                          await auth.signOut();
                          try {
                            await FirebaseStorage.instance.ref().child(
                                'profilepic$userID.jpg').delete();
                          }
                          catch(e){

                          }
                        }
                        await firestore.collection("users").doc(email).delete();
                        SharedPreferences prefs =await SharedPreferences.getInstance();
                        prefs.remove("email");
                        Navigator.pushNamed(context, WelcomeScreen.id);
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
    if(auth.currentUser!.photoURL == null) {
      image=const AssetImage('assets/person.png');
    } else {
      image=NetworkImage(auth.currentUser!.photoURL!);
    }
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
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                    backgroundImage: image,
                    radius: 90,
                    backgroundColor: Colors.grey,)
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
              onPressed: ()  {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyUserInfoScreen(userInfo: userPersonalInfo)));
              },),
            AccountButton(
              text: 'Change Password',
              onPressed: (){
                String providerId = auth.currentUser!.providerData.first.providerId;
                if(providerId != 'google.com') {

                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChangePassword()));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignedInWithGoogle(element: "Password")));
                }
              },),
            AccountButton(
              text: 'Change Photo',
              onPressed: (){
                String providerId = auth.currentUser!.providerData.first.providerId;
                if(providerId != 'google.com') {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChangePhoto()));
                } else {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignedInWithGoogle(element: "Profile photo",)));
                }
              },),
            AccountButton(
              text: 'Delete Account',
              onPressed: _showDeleteDialog,),
          ],
        ),
      ),
    );
  }
}


