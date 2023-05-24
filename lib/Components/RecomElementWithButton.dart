
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prototype/Components/Classes/Product.dart';
import 'package:prototype/Screens/ProductDetails.dart';
import 'package:prototype/constants.dart';

class RecomElementWithButton extends StatefulWidget {
  const RecomElementWithButton({
    super.key, required this.currentProduct,
  });

  final Map<String,dynamic>currentProduct;

  @override
  State<RecomElementWithButton> createState() => _RecomElementWithButtonState();
}

class _RecomElementWithButtonState extends State<RecomElementWithButton> {
  List<String> listDynamicToString(List<dynamic> list){
    List<String> listS =[];
    for(int i =0;i<list.length;i++){
      listS.add(list[i].toString());
    }
    return listS;
  }
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> deleteProduct(String barcode)async{
    QuerySnapshot<Map<String,dynamic>> querySnapshot = await firestore.collection("UserScans").get();
    List<Map<String,dynamic>> usersScans = querySnapshot.docs.map((doc) => doc.data()).toList();

    for(int i = 0; i<usersScans.length;i++){
      Map<String,dynamic> oldData = usersScans[i];
      oldData.remove(barcode);
      String email = usersScans[i]['email'];
      await firestore.collection("UserScans").doc(email).delete();
      await firestore.collection("UserScans").doc(email).set(oldData);
    }

    await firestore.collection("Products").doc(barcode).delete();

  }

  Future<bool> showDeleteDialog(String barcode) async {
    bool condition = false;
    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog( // <-- SEE HERE
              title: const Text(
                'Are you sure you want to delete This product?',
                style: TextStyle(fontFamily: 'Eastman',fontSize: 24,fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              children: [
                Text(
                  widget.currentProduct['Name'],
                  style: const TextStyle(fontFamily: 'Eastman',
                      fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SimpleDialogOption(
                      child: const Text('Yes'),
                      onPressed: () async {
                        condition =true;
                        Navigator.pop(context);
                      },
                    ),
                    SimpleDialogOption(
                      child: const Text('No'),
                      onPressed: (){

                        Navigator.pop(context);
                      },
                    ),
                  ],
                )
              ]
          );
        });
    return condition;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        onTap: (){
          List<dynamic> ingreidientsD =widget.currentProduct['Ingreidients'];
          List<String> ingreidients =listDynamicToString(ingreidientsD);
          List<dynamic> categoriesD =widget.currentProduct['Categories'];
          List<String> categories =listDynamicToString(categoriesD);

          Product p = Product(
              widget.currentProduct['Name'],
              widget.currentProduct['Maker'],
              widget.currentProduct['ImageUrl'],
              widget.currentProduct['Details'],
              '',
              widget.currentProduct['Barcode'],
              ingreidients,
              categories,
              DateTime.now());
          Navigator.push(context, MaterialPageRoute(builder:(context)=> ProductDetails(Result: p,)));
        },
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                  decoration:  BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1.5,
                        blurRadius: 1,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:   [
                        CircleAvatar(
                          backgroundImage: NetworkImage(widget.currentProduct['ImageUrl']),
                          radius: 70,
                        ),
                        const SizedBox(
                          width: 40.0,
                          height: 40.0,
                          child: VerticalDivider(
                            thickness: 3,
                            color: kCPGreenDark,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  [
                              Text(widget.currentProduct['Name'],
                                style: const TextStyle(
                                    fontFamily: 'Eastman',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: kCPGreenMid
                                ),
                                textAlign: TextAlign.left,
                              ),
                              Text('By : ${widget.currentProduct['Maker']}',
                                style: const TextStyle(
                                    fontFamily: 'Eastman',
                                    fontSize: 16,
                                    color: kCPGreenMid
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
              ),
            ),
            TextButton(
                style: kWelcomeScreenCircularButtonStyle.copyWith(backgroundColor: MaterialStateColor.resolveWith((states) =>Colors.red)),
                onPressed: () async {
                  bool delete = await showDeleteDialog(widget.currentProduct['Barcode']);
                  if(delete) await deleteProduct(widget.currentProduct['Barcode']);
                },
                child:  const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 20,
                )
            ),
          ]
        ),
      ),
    );
  }
}