// ignore_for_file: no_logic_in_create_state, non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:prototype/Components/Classes/Product.dart';
import 'package:prototype/Components/CustomBadge.dart';
import 'package:prototype/constants.dart';

class ScanResult extends StatefulWidget {
  const ScanResult({Key? key, required this.Result}) : super(key: key);
  final Product Result;

  @override
  State<ScanResult> createState() => _ScanResultState(Result);
}

class _ScanResultState extends State<ScanResult> {
  late String resultgif;
  final Product Result;
  late List<Widget> badges=[];
  late List<Widget> ingr=[];

  void fillbadges(){
    Map<String,dynamic> PDetails = Result.getdetails();
    if(PDetails['halal']==true) badges.add(const CustomBadge(name: "Halal", icon: FontAwesomeIcons.solidMoon));
    if(PDetails['vegan']==true) badges.add(const CustomBadge(name: "Vegan", icon: FontAwesomeIcons.leaf));
    if(PDetails['vegetarian']==true) badges.add(const CustomBadge(name: "Vegetarian", icon: FontAwesomeIcons.apple));
    if(PDetails['organic']==true) badges.add(const CustomBadge(name: "Bio", icon: FontAwesomeIcons.wheatAwnCircleExclamation));
    if(PDetails['lactos']==false) badges.add(const CustomBadge(name: "Lactos-Free", icon: FontAwesomeIcons.cow));
    if(PDetails['nuts']==false) badges.add(const CustomBadge(name: "Nuts-Free", icon: FontAwesomeIcons.tree));
    if(PDetails['gluten']==false) badges.add(const CustomBadge(name: "Gluten-Free", icon: FontAwesomeIcons.wheatAwn));
    if(PDetails['fish']==false) badges.add(const CustomBadge(name: "Fish-Free", icon: FontAwesomeIcons.fish));
    if(PDetails['colesterol']==false) badges.add(const CustomBadge(name: "Low-Salt", icon: FontAwesomeIcons.s));
    if(PDetails['diabeties']==false) badges.add(const CustomBadge(name: "Low-Fat", icon: FontAwesomeIcons.f));
  }
  void showIngreidients(){
    List<String> ingridients = Result.getIngreidients();
    for(int i = 0;i<ingridients.length;i++){
      ingr.add(Text(' ${ingridients[i]},',style: kResultPIngrTextStyle));
    }
  }

  _ScanResultState(this.Result);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(Result.getCanEat()=="you can eat it :)") {
      resultgif = 'assets/check.gif';
    } else {
      resultgif = 'assets/cross.gif';
    }
    fillbadges();
    showIngreidients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDF1D6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(Result.getimageURL()),
                  backgroundColor: Colors.white,
                  radius: 70,
                ),
              ),
              Padding(padding: const EdgeInsets.symmetric(vertical: 5),child: Text(" ${Result.getname()} Par ${Result.getmaker()}",textAlign: TextAlign.center,style: kResultPNameTextStyle)),
              const SizedBox(
                width: 50,
                child: Divider(
                  color: Colors.black,
                  thickness: 1.5,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text("List of Ingreidients :",style: TextStyle(fontFamily: 'Eastman',fontSize: 24,fontWeight: FontWeight.bold),),
              ),
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: ingr,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        width:200,
                        child: Text(Result.getCanEat(),style: kResultPIngrTextStyle.copyWith(fontWeight: FontWeight.bold))
                    ),
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Image(image: AssetImage(resultgif))
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 50,
                child: Divider(
                  color: Colors.black,
                  thickness: 1.5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                child: Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: badges,
                ),
              ),
              const SizedBox(
                width: 50,
                child: Divider(
                  color: Colors.black,
                  thickness: 1.5,
                ),
              ),

            ],
    ),
          ),
        ),
      )
    );
  }
}


