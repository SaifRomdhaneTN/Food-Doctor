// ignore_for_file: file_names

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';
import 'package:prototype/Components/BackgroundWidget.dart';
import 'package:prototype/Components/Classes/Preferences.dart';
import 'package:prototype/Components/RegScreenButton.dart';
import 'package:prototype/Screens/Form/FormPage2.dart';
import 'package:prototype/constants.dart';
enum MeatPref {neither,vegan,vegetarian}
enum OrganicPref{prefersorganic,donotpreferorganic}
enum HalalAndKosherPref{kosher,halal,neither}

class FormPage1 extends StatefulWidget {
  const FormPage1({Key? key}) : super(key: key);
  static String id = "form_page_1";
  @override
  State<FormPage1> createState() => _FormPage1State();
}

class _FormPage1State extends State<FormPage1> {

  MeatPref? _meatPref = MeatPref.neither;
  HalalAndKosherPref? _halalAndKosherPref = HalalAndKosherPref.neither;
  late String? religion;
  late String? allergy;
  List<String> alergies = ['Lactos Inflorescence','Nut Allergy','Gluten Allergy','Fish Allergy','None'];
  List<String> selectedAlergies = [];
  final _formKey = GlobalKey<FormState>();

  bool validateAlergies(List<String> sa){
    if(sa.length>1 && sa.contains('None')) return false;
    return true;
  }
  String fromMeatPreftoString(MeatPref meatPref){
    if(meatPref == MeatPref.neither) {
      return"none";
    } else if(meatPref == MeatPref.vegan) {
      return"vegan";
    } else {
      return "vegetarian";
    }
  }
  String fromHalalAndKoshertoString(HalalAndKosherPref? halalAndKosherPref){
    if(halalAndKosherPref == HalalAndKosherPref.neither) {
      return"neither";
    } else if(halalAndKosherPref == HalalAndKosherPref.halal) {
      return"halal";
    } else {
      return "kosher";
    }
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
              children:    [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: DefaultTextStyle(
                    style: kFormTextStyle,
                    child: Text('Do you Prefer Halal or Kosher Food?',
                      textAlign: TextAlign.center,),
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: const Text("Neither"),
                              leading: Radio<HalalAndKosherPref>(
                                autofocus: true,
                                value: HalalAndKosherPref.neither,
                                groupValue: _halalAndKosherPref,
                                onChanged: (value){
                                  setState(() {
                                    _halalAndKosherPref=value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text("Halal"),
                              leading: Radio<HalalAndKosherPref>(
                                value: HalalAndKosherPref.halal,
                                groupValue: _halalAndKosherPref,
                                onChanged: (value){
                                  setState(() {
                                    _halalAndKosherPref=value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 200.0,
                        child: ListTile(
                          title: const Text("Kosher"),
                          leading: Radio<HalalAndKosherPref>(
                            value: HalalAndKosherPref.kosher,
                            groupValue: _halalAndKosherPref,
                            onChanged: (value){
                              setState(() {
                                _halalAndKosherPref=value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: DefaultTextStyle(
                    style: kFormTextStyle,
                    child: Text('Are you a Vegan Or Vegetarian ?',
                      textAlign: TextAlign.center,),
                  ),
                ),
                SizedBox(
                  height: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: const Text("Neither"),
                              leading: Radio<MeatPref>(
                                autofocus: true,
                                value: MeatPref.neither,
                                groupValue: _meatPref,
                                onChanged: (value){
                                  setState(() {
                                    _meatPref=value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text("Vegan"),
                              leading: Radio<MeatPref>(
                                value: MeatPref.vegan,
                                groupValue: _meatPref,
                                onChanged: (value){
                                  setState(() {
                                    _meatPref=value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 200.0,
                        child: ListTile(
                          title: const Text("Vegetarian"),
                          leading: Radio<MeatPref>(
                            value: MeatPref.vegetarian,
                            groupValue: _meatPref,
                            onChanged: (value){
                              setState(() {
                                _meatPref=value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: DefaultTextStyle(
                    style: kFormTextStyle,
                    child: Text('Do you have any allergies ?',
                      textAlign: TextAlign.center,),
                  ),
                ),
                SizedBox(
                  width: 250.0,
                  child: DropDownMultiSelect(
                      options: alergies,
                      selectedValues: selectedAlergies,
                      onChanged: (value){
                        setState(() {
                          selectedAlergies=value;
                        });
                      },
                  decoration: kInputDecorationOfAuth,
                  whenEmpty: "Select One",)
                ),
                const SizedBox(
                  height: 20.0,
                ),
                RegScreenButton(
                    onPressed: (){
                      if(selectedAlergies.isEmpty){
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.warning,
                            title: "Error while selecting allergies!",
                            text: "Please select 'none' if you don't have any of the presented allergies.");
                      }
                      else if(validateAlergies(selectedAlergies)==false){
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.warning,
                            title: "Error while selecting allergies!",
                            text: "Please Don't Select another Option with the 'None' option.");
                      }
                      else if (_formKey.currentState!.validate() ) {
                        Preferences p = Preferences(fromHalalAndKoshertoString(_halalAndKosherPref),fromMeatPreftoString(_meatPref!),selectedAlergies);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>FormPage2(p: p)));
                      }
                    },
                    msg: "Next",
                    txtColor: const Color(0xFF609966),
                    bgColor: Colors.white)
              ],
            ),
          )),
    );
  }
}
