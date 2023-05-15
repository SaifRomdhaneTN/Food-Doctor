import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prototype/Components/Classes/Product.dart';
import 'package:prototype/Screens/ProductDetails.dart';

class HistoryElement extends StatelessWidget {
  const HistoryElement({
    super.key,
    required this.currentProduct,
    required this.dateScanned,
  });

  final Map<String, dynamic> currentProduct;
  final DateTime dateScanned;

  List<String> listDynamicToString(List<dynamic> list){
     List<String> listS =[];
     for(int i =0;i<list.length;i++){
       listS.add(list[i].toString());
     }
     return listS;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        List<dynamic> ingreidientsD =currentProduct['Ingreidients'];
        List<String> ingreidients =listDynamicToString(ingreidientsD);
        List<dynamic> categoriesD =currentProduct['Categories'];
        List<String> categories =listDynamicToString(categoriesD);
        Timestamp ts = currentProduct['LastScan'];
        DateTime lastScan = ts.toDate();
        Product p = Product(
            currentProduct['Name'],
            currentProduct['Maker'],
            currentProduct['ImageUrl'],
            currentProduct['Details'],
            '',
            currentProduct['Barcode'],
            ingreidients,
            categories,
            lastScan);
        Navigator.push(context, MaterialPageRoute(builder:(context)=> ProductDetails(Result: p,)));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(currentProduct['ImageUrl']),
            radius: 45,
          ),
          const SizedBox(width: 10,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentProduct['Name'],style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                Text("Maker : ${currentProduct['Maker']}",style: const TextStyle(fontSize: 14),),
                Text("Time Scanned : ${dateScanned.year}/${dateScanned.month}/${dateScanned.day}  ${dateScanned.hour}:${dateScanned.minute}:${dateScanned.second}",style: const TextStyle(fontSize: 14),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}