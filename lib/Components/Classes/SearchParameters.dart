// ignore_for_file: file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';


class SearchParameters{
 final bool scaningWithProductName;
 final bool scaningWithIngredientsNames;
 final bool scaningWithFilters;
 final String productNameParameter;
 final Map<String,dynamic> filtersParameters;
 final String ingrdsTextEntered;
 late List<Map<String,dynamic>> listOfProducts;
 late List<String> ingrEnteredList=[];
 final FirebaseFirestore firestore  = FirebaseFirestore.instance;

  SearchParameters(this.scaningWithProductName, this.scaningWithFilters, this.scaningWithIngredientsNames, this.productNameParameter, this.filtersParameters, this.ingrdsTextEntered);

  Future<List<Map<String,dynamic>>> SearchProduct() async {
    List<Map<String,dynamic>> productThatMatch=[];
    QuerySnapshot<Map<String,dynamic>> querySnapshotOFProducts = await firestore.collection("Products").get();
    listOfProducts= querySnapshotOFProducts.docs.map((doc) => doc.data()).toList();
    for(int i =0;i<listOfProducts.length;i++){
      bool condition = true;
      if(scaningWithProductName){
        if(await checkWithProductName(listOfProducts[i]) == false) {
          condition = false;
        }
      }
      if(scaningWithIngredientsNames){
        if(checkWithIngredients(listOfProducts[i]) == false) {
          condition = false;
        }
      }
      if(scaningWithFilters){
        if(checkWithFilters(listOfProducts[i]) == false) {
          condition = false;
        }
      }
      if(condition) {
        productThatMatch.add(listOfProducts[i]);
      }
    }
    return productThatMatch;
  }

  Future<bool> checkWithProductName(Map<String, dynamic> product) async {
    bool condition = false;
    String productNameWithDash = product['Name'];
    String productName = productNameWithDash.replaceAll('-', " ");
    if(productName.toLowerCase().trim().contains(productNameParameter.toLowerCase().trim())) condition = true;
    return condition;
  }

  bool checkWithIngredients(Map<String, dynamic> product) {
    bool condition = false;
    List<dynamic> productIngrDynamic = product['Ingreidients'];
    List<String> productIngr = [];
    for(int i=0;i<productIngrDynamic.length;i++){
      productIngr.add(productIngrDynamic[i].toString());
    }
    ingrEnteredList = getIngr();
    int ingrThatMatchCounter =0;
    for(int i =0;i<ingrEnteredList.length;i++){
      for(int j =0;j<productIngr.length;j++){
        if(productIngr[j].replaceAll("-", " ").trim().toLowerCase().contains(ingrEnteredList[i].trim().toLowerCase())) {
          ingrThatMatchCounter++;
          break;
        }
      }
    }
    if(ingrThatMatchCounter >= ingrEnteredList.length) {
      condition = true;
    }
    return condition;
  }

  bool checkWithFilters(Map<String, dynamic> product) {
    bool condition = true;
    Map<String,dynamic> productDetails = product['Details'];
    if(filtersParameters['halal']== true &&  productDetails['halal'] == false) condition =false;
    if(filtersParameters['vegan']== true &&  productDetails['vegan'] == false) condition =false;
    if(filtersParameters['vegetarian']== true &&  productDetails['vegetarian'] == false) condition =false;
    if(filtersParameters['lactosFree']== true &&  productDetails['lactos'] == true) condition =false;
    if(filtersParameters['glutenFree']== true &&  productDetails['gluten'] == true) condition =false;
    if(filtersParameters['fishFree']== true &&  productDetails['fish'] == true) condition =false;
    if(filtersParameters['nutFree']== true &&  productDetails['nuts'] == true) condition =false;
    if(filtersParameters['lowFat']== true &&  productDetails['diabeties'] == true) condition =false;
    if(filtersParameters['lowSalt']== true &&  productDetails['colesterol'] == true) condition =false;
    return condition;
  }

  List<String> getIngr() {
    if(ingrdsTextEntered.isNotEmpty) {
      return ingrdsTextEntered.trim().split(',');
    } else {
      return [];
    }
  }

}