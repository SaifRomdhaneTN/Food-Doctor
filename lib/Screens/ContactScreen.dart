// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prototype/Components/WelcomeButton.dart';
import 'package:prototype/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {

  final Uri facebookUrl = Uri.parse('https://www.facebook.com/profile.php?id=100005916961279');
  final Uri instagramUrl = Uri.parse('https://www.instagram.com/ser.saif.rom/');
  final Uri linkedinUrl = Uri.parse("https://www.linkedin.com/in/saif-eddine-romdhane-879a8b21a/");
  final Uri gmailUrl = Uri.parse("mail.google.com");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCPWhite,
      appBar: AppBar(
        backgroundColor: kCPGreenMid,
        title: Text("Contact Us",style: kTitleTextStyle.copyWith(fontSize: 22,color: kCPWhite),),
        centerTitle: true,
      ),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Please feel free to contact us \n on our Social Media or par Email",style: kTitleTextStyle2.copyWith(color: kCPGreenMid, fontSize: 24),textAlign: TextAlign.center,),
          ),
          const SizedBox(
            height: 20,
          ),
          WelcomeButton(
              msg: "Facebook",
              icon: Icons.facebook,
              bgcolor: Colors.blue,
              txtcolor: Colors.white,
              onPressed: () async {
                  launchUrl(facebookUrl);
              }),
          const SizedBox(height: 20,),
          WelcomeButton(
              msg: "LinkedIn",
              icon: FontAwesomeIcons.linkedin,
              bgcolor: Colors.lightBlue,
              txtcolor: Colors.white,
              onPressed: (){
                launchUrl(linkedinUrl);
              }),
          const SizedBox(height: 20,),
          WelcomeButton(
              msg: "Instagram",
              icon: FontAwesomeIcons.instagram,
              bgcolor: Colors.deepOrange,
              txtcolor: Colors.white,
              onPressed: (){
                launchUrl(instagramUrl);
              }),
          const SizedBox(height: 20,),
          SizedBox(
            width: 280.0,
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateColor.resolveWith((states) => Colors.grey,),
                  elevation: MaterialStateProperty.resolveWith((states) => 10),
                  iconSize: MaterialStateProperty.resolveWith((states) => 30),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35)
                    )
                  ),
            ),
            onPressed: (){
            },
            child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
            children:  [
              Icon(Icons.email,color: Colors.white,),
              SizedBox(width: 20.0,),
              Text("saif.romtn@gmail.com",style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'Eastman',
                fontWeight: FontWeight.bold,
                color: Colors.white
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
