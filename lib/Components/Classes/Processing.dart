// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:translator/translator.dart';

import '../EnumbersMap.dart';

class Processing {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Map<String, dynamic> _data;
  late Map<dynamic, dynamic> _EdamamDataRaw;
  late List<String> ingredients = [];
  final translator = GoogleTranslator();

  Processing(this._data);

  List numbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

  Future<bool> extractIngreidients() async {
    if (_data['product']['ingredients'] != null) {
      List<dynamic> ingr = _data['product']['ingredients'];
      for (int i = 0; i < ingr.length; i++) {
        if (!ingr[i].containsKey('ingredients')) {
          String intial_id = ingr[i]['id'];
          String afterDel;
          if (intial_id.substring(0, 3) == "fr:") {
            intial_id = ingr[i]['text'];
            if (intial_id.toLowerCase().contains("lait")) {
              afterDel = "Milk";
            } else {
              var translation = await translator.translate(intial_id, to: 'en');
              afterDel = translation.text;
            }
          }
          else {
            afterDel = intial_id.substring(3);
          }
          String finalresult = afterDel;
          if (afterDel[0] == 'e' && numbers.contains(afterDel[1])) {
            finalresult = afterDel[0];
            for (int i = 1; i < afterDel.length; i++) {
              if (afterDel[i] != 'i') finalresult += afterDel[i];
            }
            if (foodAdditives.containsKey(finalresult)) {
              String key = finalresult;
              finalresult = foodAdditives[key]!;
            }
          }
          ingredients.add(finalresult);
        }
        else {
          List<dynamic> miniIngr = ingr[i]['ingredients'];
          for (int j = 0; j < miniIngr.length; j++) {
            String intial_id = miniIngr[j]['id'];
            String afterDel;
            if (intial_id.substring(0, 3) == "fr:") {
              intial_id = miniIngr[j]['text'];
              if (intial_id.toLowerCase().contains("lait")) {
                afterDel = "Milk";
              } else {
                var translation = await translator.translate(
                    intial_id, to: 'en');
                afterDel = translation.text;
              }
            }
            else {
              afterDel = intial_id.substring(3);
            }
            String finalresult = afterDel;
            if (afterDel[0] == 'e' && numbers.contains(afterDel[1])) {
              finalresult = afterDel[0];
              for (int i = 1; i < afterDel.length; i++) {
                if (afterDel[i] != 'i') finalresult += afterDel[i];
              }
              if (foodAdditives.containsKey(finalresult)) {
                String key = finalresult;
                finalresult = foodAdditives[key]!;
              }
            }
            ingredients.add(finalresult);
          }
        }
      }
      return true;
    }
    else {
      return false;
    }
  }

  Future<List<String>> addOz() async {
    List<String> updated = [];
    String oz = "1 oz ";
    for (int i = 0; i < ingredients.length; i++) {
      updated.add(oz + ingredients[i]);
    }
    return updated;
  }

  Future<bool> foodapi() async {
    String appId = "1ea9ed9c";
    String appKey = "ff4874b740717d07e7bb53c7058550fa";
    List<String> updated = await addOz();
    String apiUrl = "https://api.edamam.com/api/nutrition-data?app_id=$appId&app_key=$appKey&ingr=$updated";
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        _EdamamDataRaw = jsonDecode(response.body);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void showIngridients() async {
    bool condition = await extractIngreidients();
    if (condition) {
      print("/////////////////");
      print(ingredients);
    }
    else {
      print("///////////////////Errrorrrrr");
    }
  }

  Future<Map<String, dynamic>> UserPrefrencesToMap() async {
    DocumentSnapshot snapshot = await _firestore.collection("users").doc(
        _auth.currentUser!.email).get();
    Map<String, dynamic> data = snapshot.get('Preferences');
    bool halal = false;
    bool vegan = false;
    bool vegetarian = false;
    bool organic = false;
    if (data['HalalKosherPref'] != 'neither') halal = true;
    if (data['MeatPreferences'] == 'vegan') vegan = true;
    if (data['MeatPreferences'] == 'vegetarian') vegetarian = true;
    if (data['OrganicPreferences'] == 'yes') organic = true;
    return {
      "halal": halal,
      "vegan": vegan,
      "vegetarian": vegetarian,
      "organic": organic,
      "Allergies": data['Allergies'],
      "IngrCantEat": data['IngredientsCantEat']
    };
  }

  Map<String, dynamic> ProductIntoMap() {
    bool halal = false;
    bool vegan = false;
    bool vegetarian = false;
    bool organic = false;
    bool lactos = true;
    bool nuts = true;
    bool gluten = true;
    bool fish = true;
    List<dynamic> EdamamData = _EdamamDataRaw['healthLabels'];
    if (EdamamData.contains("ALCOHOL_FREE") &&
        EdamamData.contains('PORK_FREE')) halal = true;
    if (EdamamData.contains("VEGAN")) vegan = true;
    if (EdamamData.contains("VEGETARIAN")) vegetarian = true;
    if (EdamamData.contains("DAIRY_FREE")) lactos = false;
    if (EdamamData.contains("GLUTEN_FREE")) gluten = false;
    if (EdamamData.contains("CRUSTACEAN_FREE") &&
        EdamamData.contains("SHELLFISH_FREE") &&
        EdamamData.contains("FISH_FREE")) fish = false;
    if (EdamamData.contains("PEANUT_FREE") &&
        EdamamData.contains("TREE_NUT_FREE")) nuts = false;

    return {
      "halal": halal,
      "vegan": vegan,
      "vegetarian": vegetarian,
      "organic": organic,
      "lactos": lactos,
      "nuts": nuts,
      "gluten": gluten,
      "fish": fish
    };
  }

  Future<String> checkIfCanEat() async {
    bool IngreidientsFound = await extractIngreidients();
    if (IngreidientsFound == true) {
      bool EdamamWorked = await foodapi();
      if (EdamamWorked == true) {
        Map<String, dynamic> userPrefrences = await UserPrefrencesToMap();
        Map<String, dynamic> productDetails = ProductIntoMap();
        bool condition = ComparePref(userPrefrences, productDetails);
        if (condition) {
          return 'You can eat this product :) ';
        } else {
          return 'i would not Recommend it "_" ';
        }
      }
      else {
        return "Edamam Error";
      }
    }
    else
      return 'Product not found';
  }

  bool ComparePref(Map<String, dynamic> userPrefrences,
      Map<String, dynamic> productDetails) {
    bool condition = true;
    List<dynamic> userAllergies = userPrefrences['Allergies'];
    if (userPrefrences['halal'] == true &&  productDetails['halal'] == false) {
      condition = false;
    }
    if (userPrefrences['vegan'] == true && productDetails['vegan'] == false)
      condition = false;
    if (userPrefrences['vegetarian'] == true &&
        productDetails['vegetarian'] == false) condition = false;
    for(int i =0; i<userAllergies.length;i++){
      if(userAllergies[i] == 'intolérance au lactose' && productDetails['lactos'] == true) condition = false;
      else if(userAllergies[i] == ' allergie aux noix' && productDetails['nuts'] == true)condition = false;
      else if(userAllergies[i] == ' Intolérance coeliaque (farine)' && productDetails['gluten'] == true)condition = false;
      else if(userAllergies[i] == ' fruits de mer et poissons' && productDetails['fish'] == true)condition = false;
    }
    return condition;
  }
}
