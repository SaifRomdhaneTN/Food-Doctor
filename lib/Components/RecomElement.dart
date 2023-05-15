import 'package:flutter/material.dart';
import 'package:prototype/Components/Classes/Product.dart';
import 'package:prototype/Screens/ProductDetails.dart';
import 'package:prototype/constants.dart';

class RecomElement extends StatelessWidget {
  const RecomElement({
    super.key, required this.currentProduct,
  });

  List<String> listDynamicToString(List<dynamic> list){
    List<String> listS =[];
    for(int i =0;i<list.length;i++){
      listS.add(list[i].toString());
    }
    return listS;
  }

  final Map<String,dynamic>currentProduct;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        List<dynamic> ingreidientsD =currentProduct['Ingreidients'];
        List<String> ingreidients =listDynamicToString(ingreidientsD);
        List<dynamic> categoriesD =currentProduct['Categories'];
        List<String> categories =listDynamicToString(categoriesD);

        Product p = Product(
            currentProduct['Name'],
            currentProduct['Maker'],
            currentProduct['ImageUrl'],
            currentProduct['Details'],
            '',
            currentProduct['Barcode'],
            ingreidients,
            categories,
            DateTime.now());
        Navigator.push(context, MaterialPageRoute(builder:(context)=> ProductDetails(Result: p,)));
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
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
                    backgroundImage: NetworkImage(currentProduct['ImageUrl']),
                    radius: 70,
                  ),
                  const SizedBox(
                    width: 40.0,
                    height: 40.0,
                    child: VerticalDivider(
                      thickness: 3,
                      color: kCPGteenDark,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:  [
                        Text(currentProduct['Name'],
                          style: const TextStyle(
                              fontFamily: 'Eastman',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: kCPGreenMid
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text('By : ${currentProduct['Maker']}',
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
    );
  }
}