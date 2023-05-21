// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototype/Components/FilterOptionMaterial.dart';
import 'package:prototype/Components/HistoryElement.dart';
import 'package:prototype/constants.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late List<Widget> products=[];
  late List<Map<String,dynamic>> productsDataGlobal =[];
  late List<Widget> productsInitial=[];
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Color sortDateColor=Colors.white54;
  late Color sortAlphabetColor=Colors.white54;
  late Color orderAscColor = Colors.white54;
  late Color orderDscColor = Colors.white54;

  late bool sortDateSelected=false;
  late bool sortAlphabetSelected=false;
  late bool orderAsc = false;
  late bool orderDsc = false;
  late bool halal = false;
  late bool vegan = false;
  late bool vegitarian = false;
  late bool fishFree = false;
  late bool nutFree = false;
  late bool lactosFree = false;
  late bool glutenFree = false;
  late bool lowFat = false;
  late bool lowSalt = false;

  bool checkWithParameters(productsData) {
    bool condition = true;
    dynamic details= productsData['Details'];
    if(halal == true && details['halal'] == false) condition = false;
    if(vegan == true && details['vegan'] == false) condition = false;
    if(vegitarian == true && details['vegetarian'] == false) condition = false;
    if(lactosFree == true && details['lactos'] == true) condition = false;
    if(glutenFree == true && details['gluten'] == true) condition = false;
    if(nutFree == true && details['nuts'] == true) condition = false;
    if(fishFree == true && details['fish'] == true) condition = false;
    if(lowFat == true && details['diabeties'] == true) condition = false;
    if(lowSalt == true && details['colesterol'] == true) condition = false;
    return condition;
  }

  List<Map<String,dynamic>> sortDateList(List<Map<String,dynamic>> productsMapToOrder){
    if(orderAsc == true) {
      productsMapToOrder.sort((a,b){
        DateTime aDate = a['date'];
        DateTime bDate = b['date'];
        int r = aDate.compareTo(bDate);
        return r;
      });
    }
    if(orderDsc == true) {
      productsMapToOrder.sort((a,b){
        DateTime aDate = a['date'];
        DateTime bDate = b['date'];
        int r = bDate.compareTo(aDate);
        return r;
      });
    }
    return productsMapToOrder;
  }
  List<Map<String,dynamic>> sortAlphaList(List<Map<String,dynamic>> productsMapToOrder){
    if(orderAsc == true) {
      productsMapToOrder.sort((a,b){
        String aString = a['product']['Name'];
        String bString= b['product']['Name'];
        int r = aString.compareTo(bString);
        return r;
      });
    }
    if(orderDsc == true) {
      productsMapToOrder.sort((a,b){
        String aString = a['product']['Name'];
        String bString= b['product']['Name'];
        int r = bString.compareTo(aString);
        return r;
      });
    }
    return productsMapToOrder;
  }


  void updateProducts(){
    List<Widget> productsNew = [];
    List<Map<String,dynamic>> productsMapToOrder = [];
    for(int i=0;i<productsDataGlobal.length;i++){
        bool condition = checkWithParameters(productsDataGlobal[i]['currentproduct']);
          if(condition){
            productsMapToOrder.add({
              'product':productsDataGlobal[i]['currentproduct'],
              'date':productsDataGlobal[i]['datescanned']
            });

          }
    }
    if(sortDateSelected == true) productsMapToOrder = sortDateList(productsMapToOrder);
    if(sortAlphabetSelected == true)productsMapToOrder = sortAlphaList(productsMapToOrder);
    for(int i =0;i<productsMapToOrder.length;i++){
      productsNew.add(
          HistoryElement(
              currentProduct: productsMapToOrder[i]['product'],
              dateScanned: productsMapToOrder[i]['date']));
      productsNew.add(const SizedBox(
        height: 20,
        width: 50,
        child: Divider(
          color: kCPGreenDark,
          thickness: 1,
        ),
      ));
    }
    setState(() {
      products = productsNew;
    });
  }

  void resetProduct(){
    setState((){
      products = productsInitial;
      sortDateColor=Colors.white54;
      sortAlphabetColor=Colors.white54;
      orderAscColor = Colors.white54;
      orderDscColor = Colors.white54;
      orderAsc = false;
      orderDsc = false;
      sortDateSelected=false;
      sortAlphabetSelected=false;
      halal = false;
      vegan = false;
      vegitarian = false;
      fishFree = false;
      nutFree = false;
      lactosFree = false;
      glutenFree = false;
      lowFat = false;
      lowSalt = false;
    });
  }

  Future<void> _showFilterDialog() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleDialog(
              title: const Text('Sort and filter the History',textAlign: TextAlign.center,),
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Sort By : ",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'EastMan',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if(sortDateColor == Colors.white54){
                                  sortDateColor = const Color(0xFF609966);
                                  sortAlphabetColor = Colors.white54;
                                  sortDateSelected = true;
                                  sortAlphabetSelected = false;
                                }
                                else{
                                  sortDateColor = Colors.white54;
                                  sortDateSelected = false;
                                }
                              });
                            },
                            child: FilterOptionMaterial(
                              color: sortDateColor,
                              txt: 'By Date',
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if(sortAlphabetColor == Colors.white54){
                                  sortAlphabetColor = const Color(0xFF609966);
                                  sortDateColor = Colors.white54;
                                  sortAlphabetSelected = true;
                                  sortDateSelected = false;
                                }
                                else{
                                  sortAlphabetColor = Colors.white54;
                                  sortAlphabetSelected = false;
                                }
                              });
                            },
                            child: FilterOptionMaterial(
                              color: sortAlphabetColor,
                              txt: 'By Alphabet',
                            ),
                          ),
                        ],
                      ),//Sorting line
                      const SizedBox(
                        height: 20,
                      ),//Space

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Order : ",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'EastMan',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if(orderAscColor == Colors.white54){
                                  orderAscColor = const Color(0xFF609966);
                                  orderDscColor = Colors.white54;
                                  orderAsc = true;
                                  orderDsc = false;
                                }
                                else{
                                  orderAscColor = Colors.white54;
                                  orderAsc = false;
                                }
                              });
                            },
                            child: FilterOptionMaterial(
                              color: orderAscColor,
                              txt: 'Ascending',
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if(orderDscColor == Colors.white54){
                                  orderDscColor = const Color(0xFF609966);
                                  orderAscColor = Colors.white54;
                                  orderDsc = true;
                                  orderAsc = false;
                                }
                                else{
                                  orderDscColor = Colors.white54;
                                  orderDsc = false;
                                }
                              });
                            },
                            child: FilterOptionMaterial(
                              color: orderDscColor,
                              txt: 'Descending',
                            ),
                          ),
                        ],
                      ),//Order Line
                      const SizedBox(
                        width: 50,
                        height: 20,
                        child: Divider(
                          thickness: 3,
                          color: Colors.black54,
                        ),
                      ),//Divider

                      const Text(
                        "Filters :",
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'EastMan',
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),//Filters Title
                      const SizedBox(height: 20,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          const Text("Halal",style: TextStyle(fontFamily: 'Eastman', fontSize: 24,),),
                          Switch(value: halal, onChanged: (value){
                            setState((){
                              halal = value;
                            });
                          })
                        ],
                      ),//Halal
                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          const Text("Vegan",style: TextStyle(fontFamily: 'Eastman', fontSize: 24,),),
                          Switch(value: vegan , onChanged: (value){
                            setState((){
                              vegan = value;
                            });
                          })
                        ],
                      ),//Vegan
                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          const Text("Vegetarian",style: TextStyle(fontFamily: 'Eastman', fontSize: 24,),),
                          Switch(value: vegitarian , onChanged: (value){
                            setState((){
                              vegitarian = value;
                            });
                          })
                        ],
                      ),//Vegetarian
                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          const Text("Lactos Free",style: TextStyle(fontFamily: 'Eastman', fontSize: 24,),),
                          Switch(value: lactosFree , onChanged: (value){
                            setState((){
                              lactosFree = value;
                            });
                          })
                        ],
                      ),//Lactos Free
                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          const Text("Gluten Free",style: TextStyle(fontFamily: 'Eastman', fontSize: 24,),),
                          Switch(value: glutenFree , onChanged: (value){
                            setState((){
                              glutenFree = value;
                            });
                          })
                        ],
                      ),//Gluten Free
                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          const Text("Nuts Free",style: TextStyle(fontFamily: 'Eastman', fontSize: 24,),),
                          Switch(value: nutFree , onChanged: (value){
                            setState((){
                              nutFree = value;
                            });
                          })
                        ],
                      ),//Nuts Free
                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          const Text("Fish Free",style: TextStyle(fontFamily: 'Eastman', fontSize: 24,),),
                          Switch(value: fishFree , onChanged: (value){
                            setState((){
                              fishFree = value;
                            });
                          })
                        ],
                      ),//Fish Free
                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          const Text("Low Fat",style: TextStyle(fontFamily: 'Eastman', fontSize: 24,),),
                          Switch(value: lowFat , onChanged: (value){
                            setState((){
                              lowFat = value;
                            });
                          })
                        ],
                      ),//Low Fat
                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:  [
                          const Text("Low Salt",style: TextStyle(fontFamily: 'Eastman', fontSize: 24,),),
                          Switch(value: lowSalt , onChanged: (value){
                            setState((){
                              lowSalt = value;
                            });
                          })
                        ],
                      ),//Low Salt
                      const SizedBox(
                        height: 10,
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SimpleDialogOption(
                            child: const Text('Apply',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Eastman'),),
                            onPressed: ()  {
                              updateProducts();
                              Navigator.pop(context);
                            },
                          ),
                          SimpleDialogOption(
                            child: const Text('Cancel',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Eastman'),),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          SimpleDialogOption(
                            child: const Text('Reset',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontFamily: 'Eastman'),),
                            onPressed: () {
                              resetProduct();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),//Buttons
                    ],
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  void getProductsOfTheUser() async {
    DocumentSnapshot<Map<String,dynamic>> documentSnapshotOFUserHistory = await firestore.collection("UserScans").doc(auth.currentUser!.email).get();
    Map<dynamic,dynamic> userHistory = documentSnapshotOFUserHistory.data()!;
    List usersBarcodes = userHistory.keys.toList();
    QuerySnapshot<Map<String,dynamic>> querySnapshotOFProducts = await firestore.collection("Products").get();
    List<Map<String,dynamic>> productsData = querySnapshotOFProducts.docs.map((doc) => doc.data()).toList();
    for(int i =0;i<usersBarcodes.length;i++){
      for(int j=0;j<productsData.length;j++){
        if(productsData[j]['Barcode']==usersBarcodes[i]){
          Map<String,dynamic> currentProduct = productsData[j];
          Timestamp dateScannedTimestamp = userHistory[usersBarcodes[i]];
          DateTime dateScanned = dateScannedTimestamp.toDate();
          setState(() {
            productsDataGlobal.add({
              'currentproduct':currentProduct,
              'datescanned':dateScanned
            });
            products.add(
                HistoryElement(
                    currentProduct: currentProduct,
                    dateScanned: dateScanned));
            products.add(const SizedBox(
              height: 20,
              width: 50,
              child: Divider(
                color: kCPGreenDark,
                thickness: 1,
              ),
            ));
          });
        }
      }
    }
    productsInitial = products;
  }

  @override
  void initState() {
    getProductsOfTheUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: kCPWhite,
      appBar: AppBar(
        actions: [
          InkWell(
            onTap: (){
              _showFilterDialog();
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 15.0),
              child:Icon(
                Icons.filter_alt,
                color: kCPWhite,
                size: 50,
              ),
            ),
          )
        ],
        elevation: 3,
        title: const Text("Scanning History"),
        backgroundColor: kCPGreenMid,
        titleTextStyle: kTitleTextStyle.copyWith(fontSize: 24),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: products,
        ),
      )
    );
  }
}