// ignore_for_file: file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prototype/Screens/Admin/AccountDetails.dart';
import 'package:prototype/constants.dart';

class AccountManageElement extends StatefulWidget {
   const AccountManageElement({
    super.key,  required this.usersData, required this.onlineColor, required this.imageURL,
  });


  final Map<String,dynamic> usersData;
  final Color onlineColor;
  final String imageURL;
  @override
  State<AccountManageElement> createState() => _AccountManageElementState();
}

class _AccountManageElementState extends State<AccountManageElement> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  late ImageProvider image = const AssetImage("assets/person.png");
  Future<bool> showDeleteDialog() async {
    bool condition = false;
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog( // <-- SEE HERE
              title: const Text(
                'Are you sure you want to delete This Account?',
                style: TextStyle(fontFamily: 'Eastman',fontSize: 24,fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              children: [
                Text(
                  widget.usersData['email'],
                  style: const TextStyle(fontFamily: 'Eastman',
                      fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SimpleDialogOption(
                      child: const Text('Yes'),
                      onPressed: () async {
                        condition =true;
                        Navigator.pop(context);
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
    return condition;
  }

  

  Future<void> deleteAccount()async{
    DocumentSnapshot documentSnapshot = await firestore.collection("users").doc(widget.usersData['email']).get();
    bool isLoggedIn = documentSnapshot.get("LoggedIn");
    if(isLoggedIn) {
      await CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: "Account Logged In",
          text: "This account appears to be online at the moment. Come back when the user logout ");
    }
    else{
      DocumentSnapshot documentSnapshotAdminAccountsDel = await firestore.collection("admin").doc("DeletedAccounts").get();
      List<dynamic> accountsDeleted = documentSnapshotAdminAccountsDel.get("emails");
      if(!accountsDeleted.contains(widget.usersData['email'])) accountsDeleted.add(widget.usersData['email']);
      try{
        await firestore.collection("users").doc(widget.usersData['email']).delete();
        await firestore.collection("UserScans").doc(widget.usersData['email']).delete();
        await firestore.collection("admin").doc("DeletedAccounts").set({
          "emails":accountsDeleted
        });
      }
      catch(e){
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
  }



  @override
  void initState() {

    if(widget.usersData.containsKey("imageUrl")) image = NetworkImage(widget.usersData['imageUrl']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration:  BoxDecoration(
            color: Colors.white,
            border: const Border(
              top: BorderSide(
                  color: kCPGreenDark,
                  width: 1.0,
                  strokeAlign: BorderSide.strokeAlignCenter
              ),
              bottom: BorderSide(
                  color: kCPGreenDark,
                  width: 1.0,
                  strokeAlign: BorderSide.strokeAlignCenter
              ),
              left: BorderSide(
                  color: kCPGreenDark,
                  width: 1.0,
                  strokeAlign: BorderSide.strokeAlignCenter
              ),
              right: BorderSide(
                  color: kCPGreenDark,
                  width: 1.0,
                  strokeAlign: BorderSide.strokeAlignCenter
              ),
            ),
            borderRadius: BorderRadius.circular(45),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  offset: Offset(0, 5),
                  blurRadius: 3,
                  spreadRadius: 1
              )
            ]
        ),
        child:   Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0,left: 10.0),
                  child: Material(
                    color: widget.onlineColor,
                    elevation: 3,
                    shape: const CircleBorder(
                      side: BorderSide(
                        strokeAlign: BorderSide.strokeAlignCenter
                      )
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(""),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountDetails(usersData: widget.usersData)));
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Center(
                            child: CircleAvatar(
                              foregroundImage: image,
                              backgroundColor: Colors.grey,
                              radius: 70,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(widget.usersData['email'],style: const TextStyle(fontFamily: 'Eastman',color:Colors.black54,fontSize: 24,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 50.0),
              child: Image(image: AssetImage(widget.imageURL),height: 65,width: 65,),
            ),
            TextButton(
                style: kWelcomeScreenCircularButtonStyle.copyWith(backgroundColor: MaterialStateColor.resolveWith((states) =>Colors.red)),
                onPressed: () async {
                  bool delete = await showDeleteDialog();
                  if(delete) await deleteAccount();
                },
                child:  const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 20,
                )
            ),
          ],
        )
      ),
    );
  }
}