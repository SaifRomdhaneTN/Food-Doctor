// ignore_for_file: use_build_context_synchronously, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prototype/Components/Classes/Processing.dart';
import 'package:prototype/Components/Classes/Product.dart';
import 'package:prototype/Components/RegScreenButton.dart';
import 'package:prototype/Screens/Admin/CheckProductDetails.dart';
import 'package:prototype/constants.dart';
import 'package:http/http.dart' as http;

class AddProducts extends StatefulWidget {
  const AddProducts({Key? key}) : super(key: key);

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {

  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late String barcode ="";
  late bool showS=false;

  Future<bool> checkIfInFirebase() async {
    DocumentSnapshot documentSnapshot = await firestore.collection("Products").doc(barcode).get();
    if(documentSnapshot.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<Map<String, dynamic>> getOpenFoodFactsData() async {
    String url = 'https://world.openfoodfacts.org/api/v2/product/$barcode';
    final headers = {"Content-Type": "application/json"};
    final response = await http.post(
        Uri.parse(url),
        headers: headers
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      throw Exception("${response.statusCode} ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showS,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kCPGreenDark,
          title: Text("Add Product",style: kTitleTextStyle2.copyWith(color: Colors.white,fontSize: 24),),
          centerTitle: true,
        ),
        backgroundColor: kCPWhite,
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text("Please enter the product's barcode : ",style: kTitleTextStyle.copyWith(color: kCPGreenMid,fontSize: 28), textAlign: TextAlign.center,),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  width: 200,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: kInputDecorationOfAuth,
                    onChanged: (value){
                      barcode = value;
                    },
                    validator: (value){
                      if(value == null) {
                        return 'Empty Field';
                      }
                      return null;
                    },
                  ),
                ),
              ),

              RegScreenButton(
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      setState(() {
                        showS=true;
                      });
                      bool inFireBase = await checkIfInFirebase();
                      if(inFireBase){
                        await CoolAlert.show(
                            context: context,
                            type: CoolAlertType.warning,
                            title:"Exists",
                            text: "This Product already exists in the Database.");
                      }
                      else{
                        try{
                          Map<String,dynamic> data =await  getOpenFoodFactsData();
                          Processing processing = Processing(data);
                          Product product = await processing.checkIfCanEat(barcode);
                          if(product.getdetails()["Error"] != null){
                            await CoolAlert.show(
                                context: context,
                                type: CoolAlertType.warning,
                                title: "Missing Data",
                                text: "it appears this product is missing some key data in the api. "
                                    "This may include tha product's image, categories, ingreidients or name and maker's name");
                          }
                          else{
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> CheckProductDetails(Result: product,)));
                          }
                        }
                        catch(e){
                          await CoolAlert.show(
                              context: context,
                              type: CoolAlertType.warning,
                              title: "Not Recognizable by API",
                              text: "This Product is not available on OpenFoodFacts");
                        }
                      }
                      setState(() {
                        showS=false;
                      });
                    }
                  },
                  msg: "Submit",
                  txtColor: kCPWhite,
                  bgColor: kCPGreenDark)
            ],
          ),
        ),
      ),
    );
  }
}
