// ignore_for_file: file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:locale_emoji_flutter/locale_emoji_flutter.dart';
import 'package:prototype/Components/RegScreenButton.dart';
import 'package:prototype/Screens/MainScreen.dart';
import 'package:prototype/constants.dart';
class AccountDetailsDashboard extends StatefulWidget {
  const AccountDetailsDashboard({Key? key, required this.usersData, required this.email, required this.image}) : super(key: key);
  final Map<String,dynamic> usersData;
  final String email;
  final ImageProvider image;

  @override
  State<AccountDetailsDashboard> createState() => _AccountDetailsDashboardState();
}

class _AccountDetailsDashboardState extends State<AccountDetailsDashboard> {
  late String dateOfBirth ="";
  late Locale  locale ;
  late String badgeURL='assets/user.png';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late String buttonMsg = "Add";

  Future<bool> showActionDialog() async {
    bool condition = false;
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog( // <-- SEE HERE
              title: Text(
                'Are you sure you want to $buttonMsg Admin Status ??',
                style: const TextStyle(fontFamily: 'Eastman',fontSize: 24,fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              children: [
                Text(
                  widget.email,
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




  String monthToString(int month){
    String monthString;
    switch (month){
      case 1 : {
        monthString = "January";
      }
      break;
      case 2 : {
        monthString = "February";
      }
      break;
      case 3 : {
        monthString = "March";
      }
      break;
      case 4 : {
        monthString = "April";
      }
      break;
      case 5 : {
        monthString = "May";
      }
      break;
      case 6 : {
        monthString = "June";
      }
      break;
      case 7 : {
        monthString = "July";
      }
      break;
      case 8 : {
        monthString = "August";
      }
      break;
      case 9 : {
        monthString = "September";
      }
      break;
      case 10 : {
        monthString = "October";
      }
      break;
      case 11 : {
        monthString = "November ";
      }
      break;
      case 12 : {
        monthString = "December";
      }
      break;
      default: {
        monthString = "Error";
      }
      break;
    }
    return monthString;
  }

  Future<bool> checkIfAdmin() async {
    bool condition = false;
    DocumentSnapshot documentSnapshot = await firestore.collection("admin").doc("Information").get();
    List<dynamic> adminsEmailsDn = documentSnapshot.get("email");
    if(adminsEmailsDn.contains(widget.email)) condition = true;
    return condition;
  }


  void initializeFields() async{
    Timestamp dateOfBirthTS = widget.usersData['DateOfBirth'];
    DateTime dateOfBirthDT = dateOfBirthTS.toDate();
    dateOfBirth = "${monthToString(dateOfBirthDT.month)} ${dateOfBirthDT.day} ${dateOfBirthDT.year}";
    locale = Locale('en', widget.usersData['CountryCode'].toString());
    bool isAdmin = await checkIfAdmin();
    if(isAdmin) {
      setState(() {
        badgeURL = 'assets/admin.png';
        buttonMsg = "Remove";
      });
    }
  }

  @override
  void initState() {
    initializeFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCPGreenLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Image+badge
              Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0,top: 30),
                    child: Center(
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(180),
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: widget.image,
                          radius: 100,
                        ),
                      ),
                    ),
                  ),
                  Image(image: AssetImage(badgeURL),width: 125,height: 125,)
                ],
              ),

              //Divider
              const SizedBox(
                width: 50,
                child: Divider(
                  color: kCPGreenDark,
                  thickness: 3,
                ),
              ),

              //Full Name
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(widget.usersData['FullName'],style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontFamily: 'Eastman',
                    fontWeight: FontWeight.bold
                ),textAlign: TextAlign.center,),
              ),

              //Container
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: kCPWhite
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //email
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Icon(Icons.email,size: 24,color: kCPGreenLight,),
                            ),
                            const Text("Email :  ",style: TextStyle(color: kCPGreenDark,fontSize: 24,fontWeight: FontWeight.bold),),
                            Expanded(child: Text(widget.email,style: const TextStyle(color: kCPGreenDark,fontSize: 18,)))
                          ],
                        ),
                      ),

                      const Divider(
                        thickness: 1,
                        color: Color.fromRGBO(0, 0, 0, 0.4),
                      ),

                      //DateOfBirth
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Icon(Icons.cake,size: 24,color: kCPGreenLight,),
                            ),
                            const Text("Date Of Birth :  ",style: TextStyle(color: kCPGreenDark,fontSize: 24,fontWeight: FontWeight.bold),),
                            Expanded(child: Text(dateOfBirth,style: const TextStyle(color: kCPGreenDark,fontSize: 22,)))
                          ],
                        ),
                      ),

                      const Divider(
                        thickness: 1,
                        color: Color.fromRGBO(0, 0, 0, 0.4),
                      ),

                      //Country
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Icon(Icons.room,size: 24,color: kCPGreenLight,),
                            ),
                            const Text("Country :  ",style: TextStyle(color: kCPGreenDark,fontSize: 22,fontWeight: FontWeight.bold),),
                            Expanded(child: Text('${widget.usersData['Country']} ${locale.flagEmoji}',style: const TextStyle(color: kCPGreenDark,fontSize: 24,)))
                          ],
                        ),
                      ),

                      const Divider(
                        thickness: 1,
                        color: Color.fromRGBO(0, 0, 0, 0.4),
                      ),

                      //Phone Number
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Icon(Icons.phone,size: 24,color: kCPGreenLight,),
                            ),
                            const Text("Phone Number :  ",style: TextStyle(color: kCPGreenDark,fontSize: 22,fontWeight: FontWeight.bold),),
                            Expanded(child: Text(widget.usersData['PhoneNumber'],style: const TextStyle(color: kCPGreenDark,fontSize: 24,)))
                          ],
                        ),
                      ),


                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
