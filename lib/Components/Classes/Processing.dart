// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'package:translator/translator.dart';

class Processing {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, dynamic> _data;
  final translator = GoogleTranslator();
  late Map<String,dynamic> ingredients={};
  Processing(this._data);

  String getProductTitle() {
    return "${_data['product']["brands"]} ${_data['product']["product_name"]}";
  }

  void setIngAndVegStats(){
    List<dynamic> ing = _data['product']['ingredients'];
    print(ing);

    for(Map ingredient in ing){
      print(ingredient);
      if(ingredient.containsKey("ingredients")){
        List<dynamic> minIng=ingredient['ingredients'];
        for(Map mining in minIng){
          if(mining.containsKey("vegan")&&mining.containsKey("vegetarian")){
            ingredients[mining['text']]={
              'name':mining['text'],
              'vegan':mining['vegan'],
              'vegetarian': mining['vegetarian'],
            };
          }
          else{
            ingredients[mining['text']]={
              'name':mining['text'],
              'vegan':"unknown",
              'vegetarian': "unknown"
            };
          }
        }
      }
      else{
        if(ingredient.containsKey("vegan")&&ingredient.containsKey("vegetarian")){
          ingredients[ingredient['text']]={
            'name':ingredient['text'],
            'vegan':ingredient['vegan'],
            'vegetarian': ingredient['vegetarian'],
          };
        }
        else{
          ingredients[ingredient['text']]={
            'name':ingredient['text'],
            'vegan':"unknown",
            'vegetarian': "unknown"
          };
        }
      }
    }
  }
  Future<void> saveToDataBase() async {
    setIngAndVegStats();
    try{
      print("adding to database////////////////////////////////////");
      await _firestore.collection("products").doc(getProductTitle()).set(dataToJson());
    }
    catch(e){
      print(e.toString());
      print("////////////////////////////////////////////////");
    }
  }
  Map<String,dynamic> dataToJson(){
    print(ingredients);
    return {
      "code":_data["code"],
      "ScannedBy":_auth.currentUser!.email,
      "DateScanned":DateTime.now(),
      "ProductTitle":getProductTitle(),
      "Ingredients":ingredients
    };
  }
}

