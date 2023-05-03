// ignore_for_file: file_names

import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:prototype/Components/Classes/Processing.dart';
import 'package:prototype/Screens/History.dart';
import 'package:prototype/Screens/ScanResult.dart';
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  ModalProgressHUD(
      inAsyncCall:showS ,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 80,
                child: Container(
                  decoration: kcustomContainer,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: (){},
                        style: kButtonStyleAppBar,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                          child: Text("filtres",style: kButtonTextStyleAppbar),
                        ),
                      ),
                      SizedBox(
                        width: 150.0,
                        child: TextField(
                          decoration: kSearchFieldDec,
                          onSubmitted: (value){
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const History()));
                        },
                        style: kButtonStyleAppBar,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                          child: Text("historique",style: kButtonTextStyleAppbar),
                        ),
                      ),
                      InkWell(
                        child: const Icon(
                          Icons.more_vert,
                          color:kCPWhite,
                          size: 30,),
                        onTap: (){

                        },
                      )
                    ],
                  ),
                ),
              ),
              if (!controller.value.isInitialized) const Text("Camera Error")
              else Expanded(
                  child: SizedBox(
                      width:double.infinity,
                      child: CameraPreview(controller)
                  )
              ),
              SizedBox(
                height: 80,
                width: double.infinity,
                child: Container(
                  decoration: kcustomContainer,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: (){},
                          style: kButtonStyleAppBar,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                            child: Text("Mes Promos",style: kButtonTextStyleAppbar,),
                          ),
                      ),
                      TextButton(
                          onPressed: (){
                            // if(controller.value.isInitialized) onTakePictureButtonPressed();
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
                      TextButton(
                        onPressed: (){},
                        style: kButtonStyleAppBar,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                          child: Text("Mes Recommandation",style: kButtonTextStyleAppbar,),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        )
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
      print("//////////////////////////////////////////////////Ingreidients///////////////////////////");
      String result = await processing.checkIfCanEat();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ScanResult(Result: result)));
    }
    catch(e){
      print(e);
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
    print(barcode);
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
      print(response.statusCode);
      throw Exception("Failed to get Product data");
    }
  }
}
