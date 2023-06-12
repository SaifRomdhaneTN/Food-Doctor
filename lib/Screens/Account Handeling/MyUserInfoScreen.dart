// ignore_for_file: no_logic_in_create_state, file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototype/Components/BackgroundWidget.dart';
import 'package:prototype/Components/DisplayButtonPref.dart';
import 'package:prototype/Components/DisplayButtonPrefV2.dart';
import 'package:prototype/Screens/Account%20Handeling/ChangePersenalInfo.dart';
import 'package:prototype/constants.dart';

class MyUserInfoScreen extends StatefulWidget {
  const MyUserInfoScreen({Key? key, required this.userInfo}) : super(key: key);
  final Map<String,dynamic> userInfo;
  @override
  State<MyUserInfoScreen> createState() => _MyUserInfoScreenState(userInfo);
}

class _MyUserInfoScreenState extends State<MyUserInfoScreen> {
  final Map<String,dynamic> userInfo;
  late DateTime dateofbirth;

  _MyUserInfoScreenState(this.userInfo);

  @override
  void initState() {
    Timestamp dob= userInfo['DateOfBirth'];
    dateofbirth =dob.toDate();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        bgImage: 'assets/background.gif',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("My information",style: kTitleTextStyle.copyWith(fontSize: 40),),
            const SizedBox(
              height: 20,
              width: 100,
              child: Divider(
                thickness: 3,
              ),
            ),
            DisplayButtonPref(
                title: "My name",
                value: userInfo['FullName'],
                onPressed: (){}),
            const SizedBox(
              height: 20,
              width: 30,
              child: Divider(
                thickness: 3,
              ),
            ),
            DisplayButtonPref(
                title: "My Date Of Birth",
                value: '${dateofbirth.day}/${dateofbirth.month}/${dateofbirth.year}',
                onPressed: (){}),
            const SizedBox(
              height: 20,
              width: 30,
              child: Divider(
                thickness: 3,
              ),
            ),
            DisplayButtonPref(
                title: "My Country of Residence",
                value: userInfo['Country'],
                onPressed: (){}),
            const SizedBox(
              height: 20,
              width: 30,
              child: Divider(
                thickness: 3,
              ),
            ),
            DisplayButtonPref(
                title: "My Phone Number",
                value: userInfo['PhoneNumber'],
                onPressed: (){}),
            DisplayButtonPrefV2(
              title: "Change",
              color: const Color(0XFF9DC08B),
              onPressed: () async {
                DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.email).get();
                Map<String,dynamic> persenolInfo = documentSnapshot.get("Additonal Information");
                Navigator.push(context, MaterialPageRoute(builder: (context)=> ChangePersonalInfo(userInfo: persenolInfo,)));
              },
              textStyle: kPrefDisplayTextStyle.copyWith(color: Colors.white),)
          ],
        ),
      ),
    );
  }
}
