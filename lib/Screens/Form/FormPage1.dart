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

class FormPage1 extends StatefulWidget {
  const FormPage1({Key? key}) : super(key: key);
  static String id = "form_page_1";
  @override
  State<FormPage1> createState() => _FormPage1State();
}

class _FormPage1State extends State<FormPage1> {

  MeatPref? _meatPref = MeatPref.neither;
  OrganicPref? _organicPref = OrganicPref.donotpreferorganic;
  late String? religion;
  late String? allergy;
  List<String> religions = ['Islam','christianisme','judaïsme','athéisme'];
  List<String> alergies = ['intolérance au lactose','allergie aux noix','Intolérance coeliaque (farine)','fruits de mer et poissons','champignons','Aucun'];
  List<String> selectedAlergies = [];
  final _formKey = GlobalKey<FormState>();

  bool validateAlergies(List<String> sa){
    if(sa.length>1 && sa.contains('Aucun')) return false;
    return true;
  }
  String fromMeatPreftoString(MeatPref meatPref){
    if(meatPref == MeatPref.neither) {
      return"all";
    } else if(meatPref == MeatPref.vegan) {
      return"vegan";
    } else {
      return "vegetarian";
    }
  }

  String fromOrganicPrefToString(OrganicPref organicPref){
    if(organicPref == OrganicPref.prefersorganic){
      return"yes";
    }
    else {
      return"no";
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
                    child: Text('quelle est votre religion?',
                      textAlign: TextAlign.center,),
                  ),
                ),
                SizedBox(
                  width: 200.0,
                  child: DropdownButtonFormField(
                    validator: (value){
                      if(value == null) return"Pick an option";
                      return null;
                    },
                      items: religions.map((e) => DropdownMenuItem(value: e,child: Text(e),)).toList(),
                      onChanged: (value){
                        religion=value;
                      },
                      hint: const Text("choisir un",style: TextStyle(color: Colors.grey),),
                    decoration: kInputDecorationOfAuth
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: DefaultTextStyle(
                    style: kFormTextStyle,
                    child: Text('Êtes-vous végétalien ou végétarien ?',
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
                              title: const Text("aucun"),
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
                              title: const Text("végan"),
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
                          title: const Text("végétarien"),
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
                    child: Text('Préférez-vous les aliments biologiques?',
                      textAlign: TextAlign.center,),
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              title: const Text("Oui"),
                              leading: Radio<OrganicPref>(
                                autofocus: true,
                                value: OrganicPref.prefersorganic,
                                groupValue: _organicPref,
                                onChanged: (value){
                                  setState(() {
                                    _organicPref=value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: const Text("Non"),
                              leading: Radio<OrganicPref>(
                                value: OrganicPref.donotpreferorganic,
                                groupValue: _organicPref,
                                onChanged: (value){
                                  setState(() {
                                    _organicPref=value;
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
                    child: Text('Vous avez des allergies ?',
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
                  whenEmpty: "sélectionner un",)
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
                            title: "Erreur liée aux allergies!",
                            text: "Veuillez choisir une allergie ou n’en choisir aucune si vous n’en avez pas.");
                      }
                      else if(validateAlergies(selectedAlergies)==false){
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.warning,
                            title: "Erreur liée aux allergies!",
                            text: "Veuillez ne pas choisir une allergie avec l’option 'Aucun' ");
                      }
                      else if (_formKey.currentState!.validate() ) {
                        Preferences p = Preferences(religion!,fromMeatPreftoString(_meatPref!),fromOrganicPrefToString(_organicPref!),selectedAlergies);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>FormPage2(p: p)));
                      }
                    },
                    msg: "Suivant",
                    txtColor: const Color(0xFF609966),
                    bgColor: Colors.white)
              ],
            ),
          )),
    );
  }
}
