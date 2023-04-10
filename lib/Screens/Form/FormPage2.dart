// ignore_for_file: non_constant_identifier_names, no_logic_in_create_state

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototype/Components/BackgroundWidget.dart';
import 'package:prototype/Components/Classes/Preferences.dart';
import 'package:prototype/Components/RegScreenButton.dart';
import 'package:prototype/Screens/MainScreen.dart';
import 'package:prototype/constants.dart';
enum DiabeticPref {diabetic,notdiebatic}
enum CholesterolPref {hascholesterol,donothavecholesterol}
class FormPage2 extends StatefulWidget {
  const FormPage2({Key? key, required this.p}) : super(key: key);

  final Preferences p;
  static String id ="FormPage2";

  @override
  State<FormPage2> createState() => _FormPage2State(p);
}

class _FormPage2State extends State<FormPage2> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Preferences p;
  DiabeticPref? _diabeticPref =DiabeticPref.notdiebatic;
  CholesterolPref? _cholesterolPref =CholesterolPref.donothavecholesterol;
  late String extra_allergies="none";

  final _formKey = GlobalKey<FormState>();

  bool fromDiabeticPrefToString(DiabeticPref diabeticPref){
    if(diabeticPref==DiabeticPref.diabetic) {
      return true;
    } else {
      return false;
    }
  }
  bool fromCholesterolPrefToString(CholesterolPref cholesterolPref){
    if(cholesterolPref==CholesterolPref.hascholesterol) {
      return true;
    } else {
      return false;
    }
  }

  Map<String, dynamic> updateUser(Preferences p,Map<String,dynamic> addInfo)  {
   return {
     "Additonal Information" : addInfo,
     "Preferences" : p.toJson()
   };
  }
  List<String> fromStringtoList(String string){
   return string.split(',');
  }
  void getDocument(Preferences p) async {
    final documentRef = _firestore.collection("users").doc(_auth.currentUser!.email);
    DocumentSnapshot<Map<String, dynamic>>  d=await _firestore.collection("users").doc(_auth.currentUser!.email).get();
    Map<String, dynamic>? data = d.data();
    data!["Additonal Information"]["FilledForm"] = true;
    Map<String,dynamic> addInfo = data["Additonal Information"];
     documentRef.update(updateUser(p,addInfo)).then((value) {
       CoolAlert.show(
           context: context,
           type: CoolAlertType.success,
           title: "Formulaire rempli!",
           text: "Le formulaire est complet. Vous pouvez commencer à utiliser l’application");
       Navigator.pushNamed(context, MainScreen.id);
     },
      onError: (e)=> CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: "quelque chose a mal tourné",
      text: e));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
          bgImage: 'assets/backgroundwhite.gif',
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:  [
                 const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: DefaultTextStyle(
                    style: kFormTextStyle,
                    child: Text("les ingrédients que vous ne pouvez pas manger (facultatif)",
                      textAlign: TextAlign.center,),
                  ),
                ),
                 SizedBox(
                   width: 300.0,
                   child: TextFormField(
                     decoration: kInputDecorationOfAuth.copyWith(hintText: "Séparer les ingrédients par un ','."),
                     validator: (value){
                       if(value == null) {
                         extra_allergies="none";
                         return null;
                       }
                       return null;
                     },
                     onChanged: (value){
                       extra_allergies = value;
                     },
                   ),
                 ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: DefaultTextStyle(
                    style: kFormTextStyle,
                    child: Text('Souffrez-vous de diabète ?',
                      textAlign: TextAlign.center,),
                  ),
                ),
                SizedBox(
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: const Text("Oui"),
                              leading: Radio<DiabeticPref>(
                                value: DiabeticPref.diabetic,
                                groupValue: _diabeticPref,
                                onChanged: (value){
                                  setState(() {
                                    _diabeticPref=value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              autofocus: true,
                              title: const Text("Non"),
                              leading: Radio<DiabeticPref>(
                                value: DiabeticPref.notdiebatic,
                                groupValue: _diabeticPref,
                                onChanged: (value){
                                  setState(() {
                                    _diabeticPref=value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: DefaultTextStyle(
                    style: kFormTextStyle,
                    child: Text('Souffrez-vous de cholestérol ?',
                      textAlign: TextAlign.center,),
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: const Text("Oui"),
                              leading: Radio<CholesterolPref>(
                                value: CholesterolPref.hascholesterol,
                                groupValue: _cholesterolPref,
                                onChanged: (value){
                                  setState(() {
                                    _cholesterolPref=value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              autofocus: true,
                              title: const Text("Non"),
                              leading: Radio<CholesterolPref>(
                                value: CholesterolPref.donothavecholesterol,
                                groupValue: _cholesterolPref,
                                onChanged: (value){
                                  setState(() {
                                    _cholesterolPref=value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                RegScreenButton(
                    onPressed: (){
                        p.ingredientsCantEat = fromStringtoList(extra_allergies);
                        p.hasDiabetes =fromDiabeticPrefToString(_diabeticPref!);
                        p.hasCholesterol = fromCholesterolPrefToString(_cholesterolPref!);
                        getDocument(p);
                    },
                    msg: "Terminer",
                    txtColor: const Color(0xFF609966),
                    bgColor: Colors.white)
              ],
            ),
          )),
    );
  }

  _FormPage2State(this.p);


}
