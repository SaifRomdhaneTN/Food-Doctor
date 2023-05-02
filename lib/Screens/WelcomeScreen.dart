
// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:prototype/Components/CircularButton.dart';
import 'package:prototype/Screens/Auth/LoginPage.dart';
import 'package:prototype/Screens/Auth/registration_screen1.dart';

import '../Components/BackgroundWidget.dart';

import '../Components/WelcomeButton.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class WelcomeScreen extends StatefulWidget {
  
  static String id = 'WelcomeScreen';

  const WelcomeScreen({super.key});
  
  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();}


class _WelcomeScreenState extends State<WelcomeScreen> {
 
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: BackgroundWidget(
            bgImage: 'assets/FoodDoctor.gif',
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:   <Widget>[

                WelcomeButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RegistrationScreenP1.id);
                    },
                    msg: 'Registrer',
                    icon: Icons.app_registration,
                    bgcolor: const Color(0xFF40513B),
                    txtcolor: const Color(0xFFEDF1D6)),
                const SizedBox(height: 20.0,),
                WelcomeButton(
                    onPressed: () {
                      Navigator.pushNamed(context, LoginP.id);
                    },
                    msg: 'Se Connecter',
                    icon :Icons.login,
                    bgcolor:const Color(0xFF9DC08B),
                    txtcolor: const Color(0xFFEDF1D6)),
                const SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularButton(
                      icon: FontAwesomeIcons.google,
                      iconColor: Colors.blueAccent,
                      bgcolor: Colors.white,),
                    SizedBox(
                      width: 20.0,
                    ),
                    CircularButton(
                        icon: FontAwesomeIcons.facebook,
                        bgcolor: Colors.blueAccent,
                        iconColor: Colors.white)
                  ],
                ),
              ],
            )
        ),
      ),
    );
  }
}







