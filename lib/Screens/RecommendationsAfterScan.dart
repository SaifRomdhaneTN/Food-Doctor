// ignore_for_file: no_logic_in_create_state, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototype/Components/Classes/Product.dart';
import 'package:prototype/Components/RecomElement.dart';
import 'package:prototype/constants.dart';

class RecommendationsAfterScan extends StatefulWidget {
  const RecommendationsAfterScan({Key? key, required this.product, required this.userPref}) : super(key: key);
  final Product product;
  final Map<String,dynamic> userPref;

  @override
  State<RecommendationsAfterScan> createState() => _RecommendationsAfterScanState(product,userPref);
}

class _RecommendationsAfterScanState extends State<RecommendationsAfterScan> {
  final Map<String,dynamic> userPref;
  final Product product;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late List<Map<String,dynamic>> productsThatMatch=[];
  late List<Widget> recommendations = [];

  _RecommendationsAfterScanState(this.product, this.userPref);
  Future<void> getProducts() async {
    QuerySnapshot<Map<String,dynamic>> querySnapshotOFProducts = await firestore.collection("Products").get();
    List<Map<String,dynamic>> products = querySnapshotOFProducts.docs.map((doc) => doc.data()).toList();
    for(int i=0;i<products.length;i++){
      if(comparePref(products[i]['Details'],products[i]['Ingreidients'])){
        productsThatMatch.add(products[i]);
      }
    }

  }

  bool comparePref(Map<String, dynamic> productDetails,List<dynamic> ingr) {
    bool condition = true;
    List<dynamic> userAllergies = userPref['Allergies'];
    if (userPref['halal'] == true &&  productDetails['halal'] == false) {
      condition = false;
    }
    if (userPref['vegan'] == true && productDetails['vegan'] == false) condition = false;
    if (userPref['vegetarian'] == true && productDetails['vegetarian'] == false) condition = false;
    for(int i =0; i<userAllergies.length;i++){
      if(userAllergies[i] == 'Lactos Inflorescence' && productDetails['lactos'] == true) {
        condition = false;
      } else if(userAllergies[i] == 'Nut Allergy' && productDetails['nuts'] == true) {
        condition = false;
      } else if(userAllergies[i] == 'Gluten Allergy' && productDetails['gluten'] == true) {
        condition = false;
      } else if(userAllergies[i] == 'Fish Allergy' && productDetails['fish'] == true) {
        condition = false;
      }
    }
    if(userPref["HasCholesterol"] == true && productDetails["colesterol"] == true ) condition = false;
    if(userPref["HasDiabetes"] == true && productDetails["diabeties"] == true ) condition = false;
    List<dynamic> ingrCantEat = userPref['IngredientsCantEat'];
    for(int i = 0;i<ingrCantEat.length;i++){
      for(int j =0;j<ingr.length;j++){
        if(ingr[j].toLowerCase().trim().contains(ingrCantEat[i].toString().toLowerCase().trim())) condition = false;
      }
    }
    return condition;
  }

  void setRecommendations() async{
    List<Map<String,dynamic>> updatedList =[];
    List<String> productCategories = product.getCategories();
    await getProducts();
    for(int i=0;i<productsThatMatch.length;i++){
    List<dynamic> productMatchCategories =productsThatMatch[i]['Categories'];
    int counter =0;
    for(int j =0 ;j<productMatchCategories.length;j++){
      for(int k =0;k<productCategories.length;k++){
        if(productMatchCategories[j]==productCategories[k]) counter++;
      }
    }
    if(counter>=2 && productsThatMatch[i]['Barcode']!= product.getBarCode()) updatedList.add(productsThatMatch[i]);
    }
    updatedList.shuffle();
    for(int i=0;i<updatedList.length;i++){
      if(recommendations.length<4){
        setState(() {
          recommendations.add(RecomElement(currentProduct:updatedList[i],));
        });
      }
    }
    if(recommendations.isEmpty) {
      setState(() {
        recommendations.add(
            Column(
              children: [
                const Image(image: AssetImage('assets/sademoji.gif'),height: 200,width: 200,),
                Text("Sorry... There are no products in our database that matches your needs."
                    "\n weather that being similiar to the product scanned or if it is to your preferences.",style: kTitleTextStyle2.copyWith(fontSize: 22,color: kCPGreenDark),textAlign: TextAlign.center,),
              ],
            ));
      });}
  }

  @override
  void initState() {
    setRecommendations();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCPWhite,
      appBar: AppBar(
        title:  Text('Recommendations',style: kTitleTextStyle.copyWith(fontSize: 24),),
        centerTitle: true,
        backgroundColor: kCPGreenMid,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: recommendations,
      ),
    );
  }
}