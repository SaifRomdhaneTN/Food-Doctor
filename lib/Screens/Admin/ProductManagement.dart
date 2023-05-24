// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prototype/Components/CircularButton.dart';
import 'package:prototype/Components/RecomElementWithButton.dart';
import 'package:prototype/Screens/Admin/AddProducts.dart';
import 'package:prototype/constants.dart';

class ProductManagement extends StatefulWidget {
  const ProductManagement({Key? key}) : super(key: key);

  @override
  State<ProductManagement> createState() => _ProductManagementState();
}

class _ProductManagementState extends State<ProductManagement> {
  final FirebaseFirestore firestore= FirebaseFirestore.instance;
  late List<Map<String,dynamic>> products = [];


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kCPWhite,
      appBar: AppBar(
        backgroundColor: kCPGreenDark,
        title: Text("Product Management",style: kTitleTextStyle2.copyWith(color: Colors.white,fontSize: 24),),
        centerTitle: true,
      ),
      body:  SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: CircularButton(
                  icon: Icons.add,
                  bgcolor: Colors.green,
                  iconColor: Colors.white,
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddProducts()));
                  }),
            ),
            StreamBuilder(
              stream: firestore.collection("Products").snapshots(),
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
                if(!snapshot.hasData){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<Widget> elements = [];
                List products = snapshot.data!.docs.map(( doc) {
                  return doc.data();
                }).toList();
                products.sort((a,b){
                  String aString = a['Name'];
                  String bString = b['Name'];
                  int i = aString.compareTo(bString);
                  return i;
                });
                for(int i =0;i<products.length;i++){
                  elements.add(RecomElementWithButton(currentProduct: products[i]));
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: elements
                );

              },
            ),
          ]
        ),
      ),
    );
  }
}
