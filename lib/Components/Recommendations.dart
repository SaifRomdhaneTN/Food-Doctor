import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototype/Components/RecomElement.dart';
import 'package:prototype/constants.dart';

class Recommendations extends StatefulWidget {
  const Recommendations({Key? key}) : super(key: key);

  @override
  State<Recommendations> createState() => _RecommendationsState();
}

class _RecommendationsState extends State<Recommendations> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late List<Map<String,dynamic>> productsThatMatch=[];
  late Map<String,dynamic> userPref={};
  late List<Widget> recommendations = [];
  Future<void> getProducts() async {
    QuerySnapshot<Map<String,dynamic>> querySnapshotOFProducts = await firestore.collection("Products").get();
    List<Map<String,dynamic>> products = querySnapshotOFProducts.docs.map((doc) => doc.data()).toList();
    DocumentSnapshot documentSnapshot = await firestore.collection("users").doc(auth.currentUser!.email).get();
    userPref= documentSnapshot.get('Preferences');
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
    print(condition);
    return condition;
  }

  void setRecommendations() async{
    await getProducts();
    for(int i=0;i<productsThatMatch.length;i++){
      if(recommendations.length<4){
      setState(() {
        recommendations.add(RecomElement(currentProduct:productsThatMatch[i],));
      });
      }
    }
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


