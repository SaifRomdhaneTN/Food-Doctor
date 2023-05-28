// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototype/Components/BackgroundWidget.dart';
import 'package:phone_number/phone_number.dart' as plugin;
import 'package:prototype/Components/RegScreenButton.dart';
import 'package:prototype/Screens/FormScreen.dart';

import '../../constants.dart';

class RegisterGoogle extends StatefulWidget {
  const RegisterGoogle({Key? key}) : super(key: key);

  @override
  State<RegisterGoogle> createState() => _RegisterGoogleState();
}

class _RegisterGoogleState extends State<RegisterGoogle> {
  final _formKey = GlobalKey<FormState>();


  DateTime selectedDate = DateTime.now();
  late int age=0;
  late String fullName='';
  late String phoneNumber='';
  late String countryCode = 'Us';
  String countryName ='Unites States';
  String phoneCode="1";
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
                const Text("Register",
                    textAlign: TextAlign.center,
                    style: kTitleTextStyle
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Text("Full Name",style: kTextRegStyle),
                const SizedBox(height: 10.0),
                SizedBox(
                    width: 200.0,
                    child: TextFormField(
                      decoration: kInputDecorationOfAuth.copyWith(
                          prefixIcon: const Icon(Icons.account_circle,color: kCPGreenMid,)
                      ),
                      onChanged: (value){
                        fullName=value;
                      },
                      validator: (value){
                        if(value== null) {
                          return "Empty Field";
                        } else if (value.contains(RegExp(r'[0-9]'))) {
                          return "The name must not contain numbers";
                        } else if(value.length <5) {
                          return"The name should be at least 5 letters long";
                        }
                        return null;
                      },)
                ),
                const SizedBox(height: 20.0),
                Text("Date Of Birth",style: kTextRegStyle),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: 200.0,
                  child: TextFormField(
                    decoration: kInputDecorationOfAuth.copyWith(
                        hintText: "${selectedDate.toLocal()}".split(' ')[0],
                        hintStyle: const TextStyle(color: Colors.black),
                        prefixIcon: const Icon(Icons.calendar_month,color: kCPGreenMid,)
                    ),
                    readOnly: true,
                    onTap: () => setState(() async {
                      await _selectDate(context);
                      age = calculateAge(selectedDate);
                    }),
                    validator: (value){
                      if(value == null) return  "Empty Field";
                      if(age <10) return "The user should be at least 10 years old";
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20.0,),
                Text("Country Of Residence",style: kTextRegStyle),
                const SizedBox(height: 10.0,),
                SizedBox(
                  width: 200.0,
                  child: TextFormField(
                    decoration: kInputDecorationOfAuth.copyWith(prefixIcon: const Icon(Icons.room,color: kCPGreenMid,),hintText: countryName),
                    readOnly: true,
                    onTap: (){showCountryPicker(
                      context: context,
                      showPhoneCode: true,
                      showSearch: true,
                      onSelect: (Country country) {
                        setState(() {
                          countryName=country.name;
                          phoneCode = country.phoneCode;
                          countryCode = country.countryCode;
                        });
                      },
                    );},
                    validator: (value){
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20.0,),
                Text("Phone Number",style: kTextRegStyle),
                const SizedBox(height: 10.0,),
                SizedBox(
                  width: 200.0,
                  child: TextFormField(
                    keyboardType: TextInputType.phone,
                    decoration: kInputDecorationOfAuth.copyWith(
                        prefixText: "+ $phoneCode ",
                        prefixStyle: const TextStyle(color: Colors.black,),
                        prefixIcon: const Icon(Icons.phone,color: kCPGreenMid,)),
                    onChanged: (value) async {
                      phoneNumber = await plugin.PhoneNumberUtil().format(value, phoneCode);
                      pnvaildation = await plugin.PhoneNumberUtil().validate(phoneNumber,regionCode: phoneCode);
                    },
                    validator: (value) {
                      if(value == null ) return "Empty Field";
                      if(value.length<5) return "It should be at least 5 numbers";
                      if(value.contains(RegExp(r'[a-z,A-z,[+,()/#.*]]')))return "It should contain only numbers";
                      if(pnvaildation) return "Phone Number Not Valid";
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10.0,),
                RegScreenButton(
                  onPressed: (){
                    if(_formKey.currentState!.validate()){
                      FirebaseFirestore firestore = FirebaseFirestore.instance;
                      FirebaseAuth auth =FirebaseAuth.instance;
                      firestore.collection("users").doc(auth.currentUser!.email).set({
                        'email':auth.currentUser!.email,
                        'Additonal Information':{
                          'Age':age,
                          'Country':countryName,
                          'CountryCode':countryCode,
                          'DateOfBirth':selectedDate,
                          'FilledForm':false,
                          'FullName':fullName,
                          'PhoneNumber':phoneNumber
                        },
                        'customScanOn':false,
                        'NumberOfScans':0,
                        'LoggedIn':false,
                        'customScanPref':{},
                        'imageUrl':auth.currentUser!.photoURL
                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const FormScreen()));
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
