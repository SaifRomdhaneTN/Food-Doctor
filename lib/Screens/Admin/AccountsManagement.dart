import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototype/Components/AccountManageElement.dart';
import 'package:prototype/Components/CircularButton.dart';
import 'package:prototype/Components/RegScreenButton.dart';
import 'package:prototype/Screens/Admin/DeletedAccountsPage.dart';
import 'package:prototype/constants.dart';

class AccountsManagement extends StatefulWidget {
  const AccountsManagement({Key? key}) : super(key: key);

  @override
  State<AccountsManagement> createState() => _AccountsManagementState();
}

class _AccountsManagementState extends State<AccountsManagement> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCPWhite,
      appBar: AppBar(
        title:  Text("Accounts Management",style: kTitleTextStyle2.copyWith(color: Colors.white,fontSize: 24),),
        centerTitle: true,
        backgroundColor: kCPGreenDark,
    ),
      body:   SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: RegScreenButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>const DeletedAccountsPage()));
                      },
                      msg: 'Deleted Accounts',
                      txtColor: kCPWhite,
                      bgColor: kCPGreenMid,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: CircularButton(
                        icon: Icons.add,
                        bgcolor: Colors.green,
                        iconColor: Colors.white,
                        onPressed: (){

                        }),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 100,
              child: Divider(
                thickness: 2,
                color: kCPGreenDark,
              ),
            ),
            StreamBuilder(
              stream: firestore.collection("users").snapshots(),
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
                if(!snapshot.hasData){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<Widget> elements = [];
                List users = snapshot.data!.docs.map(( doc) {
                  return doc.data();
                }).toList();
                users.sort((a,b){
                  String aString = a['email'];
                  String bString = b['email'];
                  int i = aString.compareTo(bString);
                  return i;
                });
                for(int i =0;i<users.length;i++){
                  ImageProvider image = const AssetImage('assets/person.png'); ;
                  if(users[i]['imageUrl']!=null) {
                    image = NetworkImage(users[i]['imageUrl']);
                  }
                  Color onlineColor = Colors.red;
                  if(users[i]['LoggedIn']==true) onlineColor = Colors.green;
                  if(users[i]['email'] != FirebaseAuth.instance.currentUser!.email) {
                    elements.add(AccountManageElement(
                    image: image,
                    email: users[i]['email'],
                    onlineColor: onlineColor,));
                  }
                }
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: elements
                );

              },
            ),
          ],
        ),
      ),
    );
  }
}


