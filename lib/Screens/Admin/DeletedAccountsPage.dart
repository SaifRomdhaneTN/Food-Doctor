// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prototype/constants.dart';

class DeletedAccountsPage extends StatefulWidget {
  const DeletedAccountsPage({Key? key}) : super(key: key);

  @override
  State<DeletedAccountsPage> createState() => _DeletedAccountsPageState();
}

class _DeletedAccountsPageState extends State<DeletedAccountsPage> {

  Future<bool> showDeleteDialog(String email) async {
    bool condition = false;
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog( // <-- SEE HERE
              title: const Text(
                'Are you sure you want to delete This Account from the list?',
                style: TextStyle(fontFamily: 'Eastman',fontSize: 24,fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              children: [
                Text(
                  email,
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

  Future<void> deleteFromList(String email) async{
    try{
      DocumentSnapshot documentSnapshot = await firestore.collection("admin").doc("DeletedAccounts").get();
      List<dynamic> emailsDel = documentSnapshot.get("emails");
      if(emailsDel.contains(email)) {
        emailsDel.remove(email);
      }
      await firestore.collection("admin").doc("DeletedAccounts").update({
        "emails":emailsDel
      });
    }
    catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCPWhite,
      appBar: AppBar(
        backgroundColor: kCPGreenDark,
        title: Text('Deleted Accounts',style: kTitleTextStyle2.copyWith(color: Colors.white,fontSize: 24),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
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
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0,-5),
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  blurRadius: 3,
                  spreadRadius: 3
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StreamBuilder(
                    stream: firestore.collection("admin").doc("DeletedAccounts").snapshots(),
                    builder: (BuildContext context,AsyncSnapshot<DocumentSnapshot<Map<String,dynamic>>> snapshot){
                      if(!snapshot.hasData){
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      List<Widget> elements = [];
                      List<dynamic> emailsDeletedDynamic = snapshot.data!.data()!['emails'];
                      List<String> emailsDeleted = [];
                      for(int i=0;i<emailsDeletedDynamic.length;i++){
                        emailsDeleted.add(emailsDeletedDynamic[i].toString());
                      }
                      emailsDeleted.sort((a,b){
                        return a.compareTo(b);
                      });
                      if(emailsDeleted.isEmpty) {
                        elements.add(const Text("No User was Deleted",style: TextStyle(color:Colors.black,fontFamily: 'Eastman',fontSize: 28,fontWeight: FontWeight.bold),textAlign: TextAlign.center,));
                      }
                      else{
                        for(int i=0;i<emailsDeleted.length;i++){
                          elements.add(Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                  child: Text(emailsDeleted[i],style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Eastman',
                                    color: Colors.black,
                                    fontSize: 18
                                  ),),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                child: TextButton(
                                    style: kWelcomeScreenCircularButtonStyle.copyWith(backgroundColor: MaterialStateColor.resolveWith((states) =>Colors.red)),
                                    onPressed: () async {
                                      bool condition = await showDeleteDialog(emailsDeleted[i]);
                                      if(condition) await deleteFromList(emailsDeleted[i]);
                                    },
                                    child:  const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                ),
                              ),
                            ],
                          ));
                          elements.add(const SizedBox(
                            child: Divider(
                              thickness: 2,
                              color: Colors.black54,
                            ),
                          ));
                        }
                      }
                      return Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: elements
                      );

                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
