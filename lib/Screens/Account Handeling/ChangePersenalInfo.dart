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
  const ChangePersonalInfo({Key? key, required this.userInfo}) : super(key: key);

  final Map<String,dynamic> userInfo;
  @override
  State<ChangePersonalInfo> createState() => _ChangePersonalInfoState();
}

class _ChangePersonalInfoState extends State<ChangePersonalInfo> {
  final _formKey = GlobalKey<FormState>();


  DateTime selectedDate = DateTime.now();
  late int age=0;
  late String fullName='';
  late String phoneNumber='';
  late String displayDate = "";
  String countryName ='Tunisia';
  late String countryCode="TN";
  String phoneCode="216";
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

  void setValues(){
    setState(() {
      fullName = widget.userInfo['FullName'];
      Timestamp timestamp = widget.userInfo['DateOfBirth'];
      selectedDate = timestamp.toDate();
      displayDate = "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}";
      age = widget.userInfo['Age'];
      phoneNumber = widget.userInfo['PhoneNumber'];
      countryName = widget.userInfo['Country'];
      countryCode = widget.userInfo['CountryCode'];
    });
  }

  @override
  void initState() {
    setValues();
    super.initState();
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
                Text("Full name",style: kTextRegStyle),
                const SizedBox(height: 10.0),
                SizedBox(
                    width: 200.0,
                    child: TextFormField(
                      decoration: kInputDecorationOfAuth.copyWith(
                          prefixIcon: const Icon(Icons.account_circle,color: kCPGreenMid,)
                      ),
                      initialValue: fullName,
                      onChanged: (value){
                        fullName=value;
                      },
                      validator: (value){
                        if(value== null) {
                          return "Empty Field";
                        } else if (value.contains(RegExp(r'[0-9]'))) {
                          return "Must Not Contain numbers";
                        } else if(value.length <5) {
                          return"Must be at least 5 characters long";
                        }
                        return null;
                      },)
                ),
                const SizedBox(height: 20.0),
                Text("Date of birth",style: kTextRegStyle),
                const SizedBox(height: 10.0),
                SizedBox(
                  width: 200.0,
                  child: TextFormField(
                    decoration: kInputDecorationOfAuth.copyWith(
                        prefixIcon: const Icon(Icons.calendar_month,color: kCPGreenMid,),
                        hintText: displayDate,
                        hintStyle: const TextStyle(color: Colors.black)
                    ),
                    readOnly: true,
                    onTap: () => setState(() async {
                      await _selectDate(context);
                      age = calculateAge(selectedDate);
                      setState(() {
                        displayDate = "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}";
                      });
                    }),
                    validator: (value){
                      if(value == null) return  "Empty Field";
                      if(age <10) return "Must be at least 10 years old";
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20.0,),
                Text("Country of residence",style: kTextRegStyle),
                const SizedBox(height: 10.0,),
                SizedBox(
                  width: 200.0,
                  child: TextFormField(
                    decoration: kInputDecorationOfAuth.copyWith(
                        prefixIcon: const Icon(Icons.room,color: kCPGreenMid,),
                        hintText: countryName),
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
                    initialValue: phoneNumber,
                    keyboardType: TextInputType.phone,
                    decoration: kInputDecorationOfAuth.copyWith(
                        prefixText: "+ $phoneCode ",
                        prefixStyle: const TextStyle(color: Colors.black),
                        prefixIcon: const Icon(Icons.phone,color: kCPGreenMid,)
                    ),
                    onChanged: (value) async {
                      phoneNumber = await plugin.PhoneNumberUtil().format(value, phoneCode);
                      pnvaildation = await plugin.PhoneNumberUtil().validate(phoneNumber,regionCode: phoneCode);
                    },
                    validator: (value) {
                      if(value == null) return "Empty Field";
                      if(value.length<5) return "Must be at least 5 numbers long";
                      if(pnvaildation) return "Number not valid";
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
                      firestore.collection("users").doc(auth.currentUser!.email).update({
                        'email':auth.currentUser!.email,
                        'Additonal Information':{
                          'Age':age,
                          'Country':countryName,
                          'CountryCode':countryCode,
                          'DateOfBirth':selectedDate,
                          'FilledForm':true,
                          'FullName':fullName,
                          'PhoneNumber':phoneNumber
                        },
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
