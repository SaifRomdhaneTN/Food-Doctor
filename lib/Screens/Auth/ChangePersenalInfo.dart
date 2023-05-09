// ignore_for_file: file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototype/Components/BackgroundWidget.dart';
import 'package:phone_number/phone_number.dart' as plugin;
import 'package:prototype/Components/RegScreenButton.dart';
import 'package:prototype/Screens/MainScreen.dart';

import '../../constants.dart';

class ChangePersonalInfo extends StatefulWidget {
  const ChangePersonalInfo({Key? key}) : super(key: key);

  @override
  State<ChangePersonalInfo> createState() => _ChangePersonalInfoState();
}

class _ChangePersonalInfoState extends State<ChangePersonalInfo> {
  final _formKey = GlobalKey<FormState>();


  DateTime selectedDate = DateTime.now();
  late int age=0;
  late String fullName='';
  late String phoneNumber='';
  String countryName ='Unites States';
  String phoneCode="+1";
  bool pnvaildation = false;


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  int calculateAge(DateTime bd){
    return DateTime.now().year-bd.year;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        bgImage: 'assets/background.gif',
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50.0,
                ),
                const Hero(
                  tag: 'signup',
                  child: Text("Registre",
                      textAlign: TextAlign.center,
                      style: kTitleTextStyle
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Text("Nom Complet",style: kTextRegStyle),
                const SizedBox(height: 10.0),
                SizedBox(
                    width: 200.0,
                    child: TextFormField(
                      decoration: kInputDecorationOfAuth,
                      onChanged: (value){
                        fullName=value;
                      },
                      validator: (value){
                        if(value== null) {
                          return "option vide";
                        } else if (value.contains(RegExp(r'[0-9]'))) {
                          return "Le nom ne contient pas de chiffres.";
                        } else if(value.length <5) {
                          return"un nom doit avoir min 5 caractères";
                        }
                        return null;
                      },)
                ),
                const SizedBox(height: 20.0),
                Text("Date de naissance",style: kTextRegStyle),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: 200.0,
                  child: TextFormField(
                    decoration: kInputDecorationOfAuth.copyWith(
                        hintText: "${selectedDate.toLocal()}".split(' ')[0],
                        hintStyle: const TextStyle(color: Colors.black)
                    ),
                    readOnly: true,
                    onTap: () => setState(() async {
                      await _selectDate(context);
                      age = calculateAge(selectedDate);
                    }),
                    validator: (value){
                      if(value == null) return  "option vide";
                      if(age <10) return "doive être au moins 10 ans";
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20.0,),
                Text("pays de résidence",style: kTextRegStyle),
                const SizedBox(height: 10.0,),
                SizedBox(
                  width: 200.0,
                  child: TextFormField(
                    decoration: kInputDecorationOfAuth.copyWith(hintText: countryName),
                    readOnly: true,
                    onTap: (){showCountryPicker(
                      context: context,
                      showPhoneCode: true,
                      showSearch: true,
                      onSelect: (Country country) {
                        setState(() {
                          countryName=country.name;
                          phoneCode = country.phoneCode;
                        });
                      },
                    );},
                    validator: (value){
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20.0,),
                Text("Numéro de Téléphone",style: kTextRegStyle),
                const SizedBox(height: 10.0,),
                SizedBox(
                  width: 200.0,
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: kInputDecorationOfAuth.copyWith(prefixText: "+ $phoneCode ",prefixStyle: const TextStyle(color: Colors.black)),
                    onChanged: (value) async {
                      phoneNumber = await plugin.PhoneNumberUtil().format(value, phoneCode);
                      pnvaildation = await plugin.PhoneNumberUtil().validate(phoneNumber,regionCode: phoneCode);
                    },
                    validator: (value) {
                      if(value == null || value.length<5) return "doive être 5 chiffres au minimum";
                      if(pnvaildation) return "numéro non validé";
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10.0,),
                RegScreenButton(
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      FirebaseFirestore firestore = FirebaseFirestore.instance;
                      FirebaseAuth auth =FirebaseAuth.instance;
                      DocumentSnapshot document =await firestore.collection("users").doc(auth.currentUser!.email).get();
                      Map<String,dynamic> preferences = document.get('Preferences');
                      firestore.collection("users").doc(auth.currentUser!.email).set({
                        'email':auth.currentUser!.email,
                        'Additonal Information':{
                          'Age':age,
                          'Country':countryName,
                          'DateOfBirth':selectedDate,
                          'FilledForm':true,
                          'FullName':fullName,
                          'PhoneNumber':phoneNumber
                        },
                        'Preferences':preferences
                      });
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>const MainScreen()));
                    }
                  },
                  msg: 'Finish',
                  bgColor: const Color(0xFF40513B),
                  txtColor: Colors.white,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
