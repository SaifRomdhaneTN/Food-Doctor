// ignore_for_file: no_logic_in_create_state, file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prototype/Components/Classes/SearchParameters.dart';
import 'package:prototype/Components/CustomBadge.dart';
import 'package:prototype/Components/RecomElement.dart';
import 'package:prototype/constants.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({Key? key, required this.products, required this.searchParameters}) : super(key: key);
  final List<Map<String,dynamic>> products ;
  final SearchParameters searchParameters ;
  @override
  State<SearchResult> createState() => _SearchResultState(products,searchParameters);
}

class _SearchResultState extends State<SearchResult> {
  final List<Map<String,dynamic>> products ;
  late List<Widget> badges=[];
  late List<Widget> productWidgets =[];
  final SearchParameters searchParameters ;
  late String msg="Search result of your query.";
  late String ingrmsg="";
  _SearchResultState(this.products, this.searchParameters);

  void setIngrMsg(){
    for(int i=0;i<searchParameters.ingrEnteredList.length;i++){
      if(i!=searchParameters.ingrEnteredList.length-1){
        ingrmsg += " ${searchParameters.ingrEnteredList[i]},";
      }
      else if (i!=searchParameters.ingrEnteredList.length-1 && searchParameters.ingrEnteredList.length>1) {
        ingrmsg += "and ${searchParameters.ingrEnteredList[i]}.";
      }
      else {
        ingrmsg += "${searchParameters.ingrEnteredList[i]}.";
      }
    }

  }

  void fillBadges(){
    bool halal=false;
    bool vegan=false;
    bool vegetarian=false;
    bool lactosFree = false;
    bool glutenFree = false;
    bool nutFree = false;
    bool fishFree = false;
    bool lowSalt = false;
    bool lowFat = false;
    for(int i=0;i<products.length;i++){
      Map<String,dynamic> productDetails = products[i]['Details'];
      if(productDetails['halal']) halal = true;
      if(productDetails['vegan'])vegan = true;
      if(productDetails['vegetarian'])vegetarian = true;
      if(productDetails['lactos']==false)lactosFree = true;
      if(productDetails['gluten']==false)glutenFree = true;
      if(productDetails['nuts']==false)nutFree = true;
      if(productDetails['fish']==false)fishFree = true;
      if(productDetails['colesterol']==false)lowSalt = true;
      if(productDetails['diabeties']==false)lowFat = true;
    }
    if(halal) badges.add(const CustomBadge(name: "Halal", icon: FontAwesomeIcons.solidMoon));
    if(vegan) badges.add(const CustomBadge(name: "Vegan", icon: FontAwesomeIcons.leaf));
    if(vegetarian) badges.add(const CustomBadge(name: "Vegetarian", icon: FontAwesomeIcons.apple));
    if(lactosFree) badges.add(const CustomBadge(name: "Lactos-Free", icon: FontAwesomeIcons.cow));
    if(nutFree) badges.add(const CustomBadge(name: "Nuts-Free", icon: FontAwesomeIcons.tree));
    if(glutenFree) badges.add(const CustomBadge(name: "Gluten-Free", icon: FontAwesomeIcons.wheatAwn));
    if(fishFree) badges.add(const CustomBadge(name: "Fish-Free", icon: FontAwesomeIcons.fish));
    if(lowSalt) badges.add(const CustomBadge(name: "Low-Salt", icon: FontAwesomeIcons.s));
    if(lowFat) badges.add(const CustomBadge(name: "Low-Fat", icon: FontAwesomeIcons.f));
  }

  void fillProductWidget(){
    for(int i=0;i<products.length;i++){
      setState(() {
        productWidgets.add(RecomElement(currentProduct: products[i]));
      });
    }
  }

  @override
  void initState() {
    setIngrMsg();
    fillBadges();
    fillProductWidget();
    if(searchParameters.scaningWithProductName) {
      msg += "\n the products have ${searchParameters.productNameParameter} written in their name";
    }
    if(searchParameters.scaningWithIngredientsNames) {
      msg+= "\n These items contain $ingrmsg";
    }
    if(badges.isNotEmpty) msg+="\n Here are the characteristics of the products Found :";
    super.initState();
  }

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kCPGreenDark,
          title: Text("Search Results",style:kTitleTextStyle2.copyWith(fontSize: 22,color: kCPGreenLight)),
          leading: InkWell(
            onTap: (){
              int count = 0;
              Navigator.of(context).popUntil((_) => count++ >= 2);
            },
              child: const Icon(
                Icons.arrow_back_ios,
                color: kCPGreenLight,
                size: 50,),
          ),
          centerTitle: true,
        ),
        backgroundColor: kCPWhite,
        body:  SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(msg,style: kResultPIngrTextStyle.copyWith(fontWeight:  FontWeight.bold,fontSize: 16),textAlign: TextAlign.center,),
              const SizedBox(
                height: 10,
              ),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: badges,
              ),
              const SizedBox(
                height: 30,
                width: 50,
                child: Divider(
                  thickness: 3,
                  color: Color.fromRGBO(0, 0, 0, 0.8),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: productWidgets,
              )
            ],
          ),
        ),
      ),
    );
  }
}
