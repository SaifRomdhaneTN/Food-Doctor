// ignore_for_file: file_names, no_logic_in_create_state, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prototype/Components/BackgroundWidget.dart';
import 'package:prototype/Components/DisplayButtonPref.dart';
import 'package:prototype/Components/DisplayButtonPrefV2.dart';
import 'package:prototype/Screens/Form/FormPage1.dart';
import 'package:prototype/constants.dart';


class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key, required this.document}) : super(key: key);
  final DocumentSnapshot document;
  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState(document);
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final DocumentSnapshot document;
  late Map<String,dynamic> preferences;
  _PreferencesScreenState(this.document);
  late List<Widget> allergies=[];
  late List<Widget> IngrCantEat=[];
  void getAllergiesList(){
    List<dynamic> allergisSring = preferences['Allergies'];
    for(int i=0;i<allergisSring.length;i++){
      allergies.add(
        SimpleDialogOption(
          onPressed: () {

          },
          child:  Text(allergisSring[i]),
        ),
      );
    }
  }
  void getIngrCantEatList(){
    List<dynamic> IngrCantEatString = preferences['IngredientsCantEat'];
    for(int i=0;i<IngrCantEatString.length;i++){
      IngrCantEat.add(
        SimpleDialogOption(
          onPressed: () {

          },
          child:  Text(IngrCantEatString[i]),
        ),
      );
    }
  }

  Future<void> _showAllergiesDialog() async {
    getAllergiesList();
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog( // <-- SEE HERE
            title: const Text('Allergies'),
            children: allergies
          );
        });
  }
  Future<void> _showIngrCantEatDialog() async {
    getIngrCantEatList();
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog( // <-- SEE HERE
              title: const Text('IngreidientsCantEat'),
              children: IngrCantEat
          );
        });
  }
  @override
  void initState()  {
    preferences = document.get("Preferences");
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        bgImage: 'assets/background.gif',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("My Preferences",style: kTitleTextStyle.copyWith(fontSize: 40),),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DisplayButtonPref(
                  title: "Halal Food :",
                  value: preferences['HalalKosherPref'] == "Neither" ? 'No' : 'Yes',
                  onPressed: (){},),
                DisplayButtonPref(
                  title: "Meat Preferences",
                  value: preferences['MeatPreferences'],
                  onPressed: (){},),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DisplayButtonPref(
                  title: "Infected with \n Diabetes :",
                  value: preferences['HasDiabetes'].toString(),
                  onPressed: (){},),
                DisplayButtonPref(
                  title: "Infected with \n cholesterol : ",
                  value: preferences['HasCholesterol'].toString(),
                  onPressed: (){},),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DisplayButtonPrefV2(
                    title: "Allergies",
                    color:const Color(0xFFEDF1D6),
                    onPressed: (){
                      _showAllergiesDialog();
                    },
                textStyle: kPrefDisplayTextStyle,),
                DisplayButtonPrefV2(
                    title: "Can't Eat Ingreidients",
                    color:const Color(0xFFEDF1D6),
                    onPressed: (){
                      _showIngrCantEatDialog();
                    },
                textStyle: kPrefDisplayTextStyle,),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            DisplayButtonPrefV2(
            title: "Change",
            color: const Color(0XFF9DC08B),
            onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const FormPage1(  )));
            },
            textStyle: kPrefDisplayTextStyle.copyWith(color: Colors.white),)
          ],
        ),
      ),
    );
  }
}


