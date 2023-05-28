import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototype/Components/Classes/Preferences.dart';
import 'package:prototype/Components/Classes/User.dart';
import 'package:prototype/Screens/Admin/AccountsManagement.dart';
import 'package:prototype/Screens/Auth/LoginPage.dart';
import 'package:prototype/Screens/Auth/registration_screen1.dart';
import 'package:prototype/Screens/Form/FormPage1.dart';
import 'package:prototype/Screens/Form/FormPage2.dart';
import 'package:prototype/Screens/FormScreen.dart';
import 'package:prototype/Screens/MainScreen.dart';
import 'package:prototype/Screens/WelcomeScreen.dart';
import 'package:prototype/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ...

import 'Screens/Auth/RegistrationScreen2.dart';

late List<CameraDescription> cameras;
String startingRoute = WelcomeScreen.id;
Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  cameras = await availableCameras();
  SharedPreferences prefs =await SharedPreferences.getInstance();
  var email=prefs.getString("email");
  startingRoute= email==null?WelcomeScreen.id:MainScreen.id;
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

   static Future<UserCredential?> register(String email, String password) async {

    UserCredential? userCredential;
     try {
       print("/////////////////////called//////////");
       await Firebase.initializeApp(
           name: 'Secondary',  options: DefaultFirebaseOptions.currentPlatform,);
       FirebaseApp app =Firebase.app('Secondary');
       userCredential = await FirebaseAuth.instanceFor(app: app)
           .createUserWithEmailAndPassword(email: email, password: password);
       await app.delete();
     }
     on FirebaseAuthException catch (e) {
       print("///////////////////////////");
       print(e.toString());
     }

     return userCredential;
   }
  @override
  Widget build(BuildContext context) {
    UserLocal placeholderuser = UserLocal("PlaceHolder",DateTime.now(),999,'nowhere','nophonenumber',"");
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(scaffoldBackgroundColor:const Color(0xFF609966) ,
        primarySwatch: Colors.green,
        radioTheme: RadioThemeData(
          fillColor: MaterialStateProperty.resolveWith((states) => const Color(0xFF609966))
        )
      ),
      initialRoute: startingRoute,
      routes: {
        WelcomeScreen.id : (context) =>  const WelcomeScreen(),
        RegistrationScreenP1.id:(context)=> const RegistrationScreenP1(),
        RegistrationScreenP2.id:(context)=> RegistrationScreenP2(tempuser: placeholderuser),
        LoginP.id:(context)=>const LoginP(),
        MainScreen.id:(context)=>const MainScreen(),
        FormScreen.id:(context)=> const FormScreen(),
        FormPage1.id:(context)=> const FormPage1(),
        FormPage2.id :(context) => FormPage2(p: Preferences("none","none",[])),
        AccountsManagement.id :(context)=>const AccountsManagement(adminsList: [],)
      },
    );
  }
}

