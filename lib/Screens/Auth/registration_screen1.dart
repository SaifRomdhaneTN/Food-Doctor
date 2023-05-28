// ignore_for_file: non_constant_identifier_names



import 'package:flutter/material.dart';
import 'package:prototype/Components/BackgroundWidget.dart';
import 'package:prototype/Components/Classes/User.dart';
import 'package:prototype/Components/RegScreenButton.dart';
import 'package:prototype/Screens/Auth/RegistrationScreen2.dart';
import 'package:prototype/constants.dart';
import 'package:country_picker/country_picker.dart';
import 'package:phone_number/phone_number.dart' as plugin;



class RegistrationScreenP1 extends StatefulWidget {
  const RegistrationScreenP1({Key? key}) : super(key: key);

  static String id  = 'RegP1';

  @override
  State<RegistrationScreenP1> createState() => _RegistrationScreenP1State();
}

class _RegistrationScreenP1State extends State<RegistrationScreenP1> {

  final _formKey = GlobalKey<FormState>();


  DateTime selectedDate = DateTime.now();
  late int Age=0;
  late String FullName='';
  late String PhoneNumber='';
  late String CountryCode = 'US';
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

  int CalculateAge(DateTime BD){
    return DateTime.now().year-BD.year;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        bgImage: 'assets/background.gif',
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50.0,
                  ),
                  const Text("Registre",
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
                        FullName=value;
                    },
                    validator: (value){
                      if(value== null) {
                        return "Empty field";
                      } else if (value.contains(RegExp(r'[0-9]'))) {
                        return "The name must not contain numbers.";
                      } else if(value.length <5) {
                        return"Must be at least 5 characters long";
                      }
                      return null;
                    },

                    )
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
                      Age = CalculateAge(selectedDate);
                    }),
                    validator: (value){
                      if(value == null) return  "Empty field";
                      if(Age <10) return "Must at least be 10 years old";
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
                          hintText: countryName,
                          prefixIcon: const Icon(Icons.room,color: kCPGreenMid,)
                      ),
                      readOnly: true,
                      onTap: (){showCountryPicker(
                        context: context,
                        showPhoneCode: true,
                        showSearch: true,
                        onSelect: (Country country) {
                          setState(() {
                            countryName=country.name;
                            phoneCode = country.phoneCode;
                            CountryCode =country.countryCode;
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
                          prefixIcon: const Icon(Icons.phone,color: kCPGreenMid,)
                      ),
                      onChanged: (value) async {
                        PhoneNumber = await plugin.PhoneNumberUtil().format(value, phoneCode);
                        pnvaildation = await plugin.PhoneNumberUtil().validate(PhoneNumber,regionCode: phoneCode);
                      },
                      validator: (value) {
                        if(value == null) return "Empty Field";
                        if(value.length<5) return "Must be at least 5 numbers";
                        if(pnvaildation) return "Number not valid";
                        if(value.contains(RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[(/*),.+#;]).{8,}$')))return "It should contain only numbers";
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10.0,),
                  RegScreenButton(
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        UserLocal user = UserLocal(FullName, selectedDate, Age , countryName,CountryCode ,PhoneNumber);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrationScreenP2(tempuser: user)));
                      }
                    },
                    msg: 'Next',
                    bgColor: const Color(0xFF40513B),
                    txtColor: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}