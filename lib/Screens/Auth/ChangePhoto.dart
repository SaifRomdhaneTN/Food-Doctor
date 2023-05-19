// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, file_names

import 'dart:io';

import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prototype/Components/BackgroundWidget.dart';
import 'package:prototype/Components/CircularButton.dart';
import 'package:prototype/Screens/MainScreen.dart';

class ChangePhoto extends StatefulWidget {
  const ChangePhoto({Key? key}) : super(key: key);

  @override
  State<ChangePhoto> createState() => _ChangePhotoState();
}

class _ChangePhotoState extends State<ChangePhoto> {
  late ImageProvider photo= const AssetImage("assets/person.png");
  late String newPhotoUrl;

  void pickUploadImage() async{
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75
    );
    Reference ref =FirebaseStorage.instance.ref().child("profilepic${FirebaseAuth.instance.currentUser!.uid}.jpg");
    await ref.putFile(File(image!.path));
    newPhotoUrl = await ref.getDownloadURL();
    setState(() {
      photo = NetworkImage(newPhotoUrl);
    });
  }
  void addNewPhoto() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.currentUser!.updatePhotoURL(newPhotoUrl);
    Navigator.popUntil(context, ModalRoute.withName(MainScreen.id));
  }
  @override
  void initState() {
    if(FirebaseAuth.instance.currentUser!.photoURL!=null){
      photo = NetworkImage(FirebaseAuth.instance.currentUser!.photoURL!);
    }
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
          CircleAvatar(
            backgroundImage: photo,
            radius: 100,
            backgroundColor: const Color(0xFF40513B),
          ),
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularButton(
                  icon: Icons.add,
                  bgcolor: Colors.grey,
                  iconColor: Colors.black54,
                  onPressed: (){
                    pickUploadImage();
                  }),
              const SizedBox(
                width: 20,
              ),
              CircularButton(
                  icon: Icons.check,
                  bgcolor: Colors.green,
                  iconColor: Colors.white,
                  onPressed: (){
                    if(newPhotoUrl == null){
                      CoolAlert.show(
                          context: context,
                          type: CoolAlertType.error,
                          title: "Photo Not Selected",
                          text: "Please Select a new photo first!");
                    }
                    else{
                      addNewPhoto();
                    }
                  })
            ],
          ),
          ],
      ),
    ),
    );
  }
}
