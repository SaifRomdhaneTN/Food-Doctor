// ignore_for_file: file_names, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prototype/Components/Classes/Product.dart';
import 'package:prototype/Screens/ProductDetails.dart';
import 'package:prototype/constants.dart';

class DashboardItemRowImage extends StatelessWidget {
  const DashboardItemRowImage({
    super.key,
    required this.imageUrl, required this.barcode, required this.name, required this.count,
  });

  final String imageUrl;
  final String barcode;
  final String name;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kCPWhite
      ),
      child: InkWell(
        onTap: () async {
          DocumentSnapshot<Map<String,dynamic>> documentSnapshot = await FirebaseFirestore.instance.collection("Products").doc(barcode).get();
          Product p = Product.DocumentToProductForDisplay(documentSnapshot);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetails(Result: p)));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.only(right: 20.0,left:20.0,top: 10,bottom: 5),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 50,
                )
            ),
            Text("scanned ${count.toString()} times",style: const TextStyle(fontFamily: 'Eastman',fontSize: 12,),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(name,style: const TextStyle(fontFamily: 'Eastman',fontSize: 12,fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }
}