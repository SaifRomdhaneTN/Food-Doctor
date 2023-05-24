// ignore_for_file: no_logic_in_create_state, non_constant_identifier_names, file_names, use_build_context_synchronously


import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prototype/Components/CircularButton.dart';
import 'package:prototype/Components/Classes/Processing.dart';
import 'package:prototype/Components/Classes/Product.dart';
import 'package:prototype/Components/CustomBadge.dart';
import 'package:prototype/constants.dart';

class CheckProductDetails extends StatefulWidget {
  const CheckProductDetails({Key? key, required this.Result}) : super(key: key);
  final Product Result;

  @override
  State<CheckProductDetails> createState() => _CheckProductDetailsState(Result);
}

class _CheckProductDetailsState extends State<CheckProductDetails> {
  final Product Result;
  late List<Widget> badges=[];
  late List<Widget> ingr=[];
  late String recomText ="These are Similar items \n that matches your Requirements";

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

  _CheckProductDetailsState(this.Result);
  @override
  void initState() {
    fillbadges();
    showIngreidients();
    super.initState();
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: CircularButton(
                            icon: FontAwesomeIcons.check,
                            bgcolor: Colors.green,
                            iconColor: Colors.white,
                            onPressed: () async {
                            bool added  = await Processing.saveToDataBaseAdmin(Result);
                            if(added) {
                              await CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.success,
                                  title: "Added!",
                                  text: "Added successfully to the database !");
                              Navigator.pop(context);
                            }
                            else{
                              await CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.error,
                                  title: "Error!",
                                  text: "An Error occurred that made it impossible to add to the database !");
                            }

                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: CircularButton(
                            icon: Icons.close,
                            bgcolor: Colors.red,
                            iconColor: Colors.white,
                            onPressed: (){
                              Navigator.pop(context);
                            }),
                      )
                    ],
                  )

                ],
              ),
            ),
          ),
        )
    );
  }
}


