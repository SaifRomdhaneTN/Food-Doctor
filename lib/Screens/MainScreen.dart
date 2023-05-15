// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prototype/Components/Classes/Processing.dart';
import 'package:prototype/Components/Classes/Product.dart';
import 'package:prototype/Screens/Account%20Handeling/AccountMain.dart';
import 'package:prototype/Screens/History.dart';
import 'package:prototype/Screens/Scaning/ProductNotFoundPage.dart';
import 'package:prototype/Screens/Scaning/ScanResult.dart';
import 'package:prototype/constants.dart';
import 'package:prototype/main.dart' as main;
import 'package:http/http.dart' as http;


class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static String id ="MainScreen";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  late CameraController controller;
  bool showS=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = CameraController(main.cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });
  }
  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: _onWillPop,
      child: ModalProgressHUD(
        inAsyncCall:showS ,
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                if (!controller.value.isInitialized) const Text("Camera Permission Not Accepted!",textAlign: TextAlign.center,style: TextStyle(fontSize: 40),)
                else SizedBox(
                    width:double.infinity,
                    height: double.infinity,
                    child: CameraPreview(controller)
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: (){},
                        style: kButtonStyleAppBar,
                        child:  Padding(
                          padding: EdgeInsets.all(3.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.filter_list,color: kCPGreenMid,),
                              Text("Filtres",style: kButtonTextStyleAppbar),
                            ],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: (){
                        },
                        style: kButtonStyleAppBar.copyWith(shape:  MaterialStateProperty.all<CircleBorder>(
                            const CircleBorder(
                                side: BorderSide(width: 0,color: Color.fromRGBO(0, 0, 0, 0))
                            )
                        ),),
                        child:  const Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Icon(Icons.search,color: kCPGreenMid,size: 30,)
                        ),
                      ),
                      PopupMenuButton(
                        // icon: const Icon(Icons.list_outlined,color:Colors.white ,size: 40,weight: 5,),
                        itemBuilder: (BuildContext bc){
                        return const[
                          PopupMenuItem(value:"My account", child: Text("My Account"),),
                          PopupMenuItem(value: "ScanHistory",child: Text("Scan History"),),
                          PopupMenuItem(value: "Sign Out",child: Text("Sign out"),),
                        ];
                      },
                        onSelected: (value) async {
                          if(value == "Sign Out"){
                            FirebaseAuth auth =FirebaseAuth.instance;
                            String providerId = auth.currentUser!.providerData.first.providerId;
                            if(providerId == 'google.com'){
                              GoogleSignIn googleSignIn = GoogleSignIn();
                              await googleSignIn.signOut();
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            }
                            else{
                              await auth.signOut();
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            }
                          }
                          if(value == "My account"){
                            FirebaseFirestore firestore = FirebaseFirestore.instance;
                            FirebaseAuth auth = FirebaseAuth.instance;
                            DocumentSnapshot document = await firestore.collection("users").doc(auth.currentUser!.email).get();
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AccountMain(document: document,)));
                          }
                          if(value == "ScanHistory"){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>const History()));
                          }
                        },
                        child: Material(
                            shape:const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(45))
                              ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const[
                                  Text("More",style: kButtonTextStyleAppbar),
                                  SizedBox(width: 5),
                                  Icon(Icons.playlist_add_outlined,color: kCPGreenMid,),
                                ],
                              ),
                            )),)
                    ],
                  ),
                ),
                SizedBox(
                  height: double.infinity,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: TextButton(
                          onPressed: (){
                            scanBarcode();
                            setState(() {

                            });
                          },
                          style: kButtonStyleAppBar.copyWith(shape:  MaterialStateProperty.all<CircleBorder>(
                              const CircleBorder(
                                  side: BorderSide(width: 0,color: Color.fromRGBO(0, 0, 0, 0))
                              )
                          ),),
                          child:  Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text("Scan",style: kButtonTextStyleAppbar.copyWith(fontSize: 20),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ),
          )
        ),
      ),
    );



  }



  Future<void> scanBarcode() async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color of the toolbar.
      'Cancel', // Text displayed on the cancel button.
      true, // Whether to show the flash icon.
      ScanMode.BARCODE, // The type of scan to perform (barcode or QR code).
    );
    Map<String, dynamic> data;
    setState(() {
      showS=true;
    });
    try{
      data = await getDataFromBarcode(barcodeScanRes);
      Processing processing = Processing(data);
      Product productResult = await processing.checkIfCanEat(barcodeScanRes);
      processing.saveToDataBase(productResult);
      setState(() {
        showS=false;
      });
      if(productResult.getdetails()["Error"]!= null) {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProductnotfoundPage()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ScanResult(Result: productResult)));
      }
    }
    catch(e){
      if(!e.toString().contains('404')){
        if(!e.toString().contains('NoSuchMethodError')){
          CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              title: "Error",
              text: "An Error occurred! please do Scan again. ${e.toString()}");
        }
      }
      else {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProductnotfoundPage()));
      }
    }

    setState(() {
      showS=false;
    });

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });

  }
  Future<Map<String, dynamic>> getDataFromBarcode(String barcode) async {
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
      throw Exception("${response.statusCode}");
    }
  }
}
