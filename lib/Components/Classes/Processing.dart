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
  late List<String> ingredients;
  Processing(this._data);

  void extractIngreidients(){
    if(_data['product']['ingredients']!=null){
      List<Map<dynamic,dynamic>> ingr = _data['product']['ingredients'];
      for(int i=0;i<ingr.length;i++){
        if()
      }
    }
  }

}

