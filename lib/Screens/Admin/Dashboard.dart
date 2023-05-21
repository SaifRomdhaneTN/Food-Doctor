// ignore_for_file: file_names


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prototype/Components/DashboardItemRowFlags.dart';
import 'package:prototype/Components/DashboardItemRowIcon.dart';
import 'package:prototype/Components/DashboardItemRowImage.dart';
import 'package:prototype/Components/PieChartAge.dart';
import 'package:prototype/constants.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  late int totalOfAges =0;
  late Map<String,double> dataMap ={};
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late List<Widget> countries = [];
  late List<Widget> categories = [];
  late List<Widget> topProducts = [];
  late List<Map<String,dynamic>> users=[];
  late List<Map<String,dynamic>> products=[];
  late Widget userInfo = Container();

  Future<void> calculateAgePercentages() async {
    QuerySnapshot<Map<String,dynamic>> usersQS = await  firestore.collection("users").get();
    users = usersQS.docs.map((doc) => doc.data()).toList();
    totalOfAges =users.length;
    int agesGrp1Counter =0;
    int agesGrp2Counter =0;
    int agesGrp3Counter =0;
    int agesGrp4Counter =0;
    for(int i=0;i<users.length;i++){
        int userAge = users[i]['Additonal Information']['Age'];
        if(userAge >=10 && userAge<=21) agesGrp1Counter++;
        if(userAge >=22 && userAge<=35) agesGrp2Counter++;
        if(userAge >=36 && userAge<=60) agesGrp3Counter++;
        if(userAge >=61) agesGrp4Counter++;
    }
    setState(() {
      dataMap = {
        "Between 10 and 21" : agesGrp1Counter.toDouble(),
        "Between 22 and 35" : agesGrp2Counter.toDouble(),
        "Between 36 and 60" : agesGrp3Counter.toDouble(),
        "Older than 61" : agesGrp4Counter.toDouble(),
      };
    });
  }

  void getCountries() {
    Map<String,int> countriesWithCounter = {};
    for(int i=0;i<users.length;i++){
      String currentCountry=users[i]['Additonal Information']['CountryCode'];
      if(!countriesWithCounter.containsKey(currentCountry)){
        countriesWithCounter.addAll({
          currentCountry:1
        });
      }
      else{
        countriesWithCounter.update(currentCountry, (value) => value+1);
      }
    }
    countriesWithCounter = Map.fromEntries(countriesWithCounter.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value)));
    List<MapEntry<String,int>> countriesList = countriesWithCounter.entries.toList();
    for(int i=0; i<countriesList.length;i++){
      if(i<3){
        Locale locale = Locale('en', countriesList[i].key);
        setState(() {
          countries.add(
              DashboardItemRowFlags(locale: locale, countryCode: countriesList[i].key,)
          );
          countries.add(
              const SizedBox(
                width: 20,
              )
          );
        });
      }
    }
  }

  Future<void> getCategories() async {
    Map<String,int> detailsCounter ={
      "Low Salt" :0,
      "Low Fat":0,
      "Fish Free":0,
      "Gluten Free":0,
      "Halal":0,
      "Lactos Free":0,
      "Nuts Free":0,
      "Vegan":0,
      "Vegetarian":0
    };
    QuerySnapshot<Map<String,dynamic>> productsQS = await  firestore.collection("Products").get();
    products = productsQS.docs.map((doc) => doc.data()).toList();
    for(int i=0;i<products.length;i++){
      Map<String,dynamic> productDetails = products[i]['Details'];
      if(!productDetails['colesterol']) detailsCounter['Low Salt']=detailsCounter['Low Salt']!+1;
      if(!productDetails['diabeties']) detailsCounter['Low Fat']=detailsCounter['Low Fat']!+1;
      if(!productDetails['fish']) detailsCounter['Fish Free']=detailsCounter['Fish Free']!+1;
      if(productDetails['halal']) detailsCounter['Halal']=detailsCounter['Halal']!+1;
      if(!productDetails['lactos']) detailsCounter['Lactos Free']=detailsCounter['Lactos Free']!+1;
      if(!productDetails['nuts']) detailsCounter['Nuts Free']=detailsCounter['Nuts Free']!+1;
      if(productDetails['vegan']) detailsCounter['Vegan']=detailsCounter['Vegan']!+1;
      if(productDetails['vegetarian']) detailsCounter['Vegetarian']=detailsCounter['Vegetarian']!+1;
      if(!productDetails['gluten']) detailsCounter['Gluten Free']=detailsCounter['Gluten Free']!+1;
    }
    detailsCounter = Map.fromEntries(detailsCounter.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value)));
    List<MapEntry<String,int>> categoriesList = detailsCounter.entries.toList();
    for(int i=0;i<categoriesList.length;i++){
      IconData icon ;
      switch(categoriesList[i].key){
        case "Low Salt" : {icon = FontAwesomeIcons.s;}
          break;
        case "Low Fat" : {icon = FontAwesomeIcons.f;}
          break;
        case "Fish Free" : {icon = FontAwesomeIcons.fish;}
          break;
        case "Halal" : {icon = FontAwesomeIcons.solidMoon;}
          break;
        case "Lactos Free" : {icon = FontAwesomeIcons.cow;}
          break;
        case "Nuts Free" : {icon = FontAwesomeIcons.tree;}
          break;
        case "Vegan" : {icon = FontAwesomeIcons.leaf;}
          break;
        case "Vegetarian" : {icon = FontAwesomeIcons.apple;}
          break;
        case "Gluten Free" : {icon = FontAwesomeIcons.cookie;}
          break;
        default :{icon = Icons.error;}
          break;
      }
      setState(() {
        if(i<5){
          categories.add(DashboardItemRowIcon(
            icon: icon,
            name: categoriesList[i].key,
          ));
          categories.add(
              const SizedBox(
                width: 20,
              )
          );
        }
      });
    }
  }

  void setTopProducts(){
    Map<String,int> productsNumScanMap={};
    Map<String,int> productsImageUrlMap={};
    Map<String,int> productsNameMap={};
    for(int i=0;i<products.length;i++){
      productsNumScanMap.addAll({
        products[i]['Barcode']:products[i]['numberOfScans']
      });
      productsImageUrlMap.addAll({
        products[i]['ImageUrl']:products[i]['numberOfScans']
      });
      productsNameMap.addAll({
        products[i]['Name']:products[i]['numberOfScans']
      });
    }

    productsNumScanMap = Map.fromEntries(productsNumScanMap.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value)));
    List<MapEntry<String,int>> productsScanNumList = productsNumScanMap.entries.toList();
    productsImageUrlMap = Map.fromEntries(productsImageUrlMap.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value)));
    List<MapEntry<String,int>> productsImageUrlList = productsImageUrlMap.entries.toList();
    productsNameMap = Map.fromEntries(productsNameMap.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value)));
    List<MapEntry<String,int>> productsNameList = productsNameMap.entries.toList();
    for(int i=0;i<productsScanNumList.length;i++){
      if(i<5){
        setState(() {
          print("image URl : ${productsImageUrlList[i].key}");
          print("Barcode ! ${productsScanNumList[i].key}");
          topProducts.add( DashboardItemRowImage(
            imageUrl: productsImageUrlList[i].key,
            barcode: productsScanNumList[i].key,
            name: productsNameList[i].key,
          ));
          topProducts.add(const SizedBox(
            width: 20,
          ));
        });
      }
    }
  }

  Future<void> setTopUser() async {
    Map<String,int> usersNameMap = {};
    Map<String,int> usersEmailMap = {};
    for(int i=0;i<users.length;i++){
      usersNameMap.addAll({
        users[i]['Additonal Information']['FullName']:users[i]['NumberOfScans']
      });
      usersEmailMap.addAll({
        users[i]['email']:users[i]['NumberOfScans']
      });
    }

    usersNameMap = Map.fromEntries(usersNameMap.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value)));
    List<MapEntry<String,int>> usersNameList = usersNameMap.entries.toList();
    usersEmailMap = Map.fromEntries(usersEmailMap.entries.toList()..sort((e1, e2) => e2.value.compareTo(e1.value)));
    List<MapEntry<String,int>> usersEmailList = usersEmailMap.entries.toList();
    String userEmail = usersEmailList[0].key;
    ImageProvider image;
    try{
      DocumentSnapshot documentSnapshot = await firestore.collection("users").doc(userEmail).get();
      image = NetworkImage(documentSnapshot.get("imageUrl"));
    }
    catch(e){
      image = const AssetImage('assets/person.png');
    }
    setState(() {
      userInfo = Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: kCPWhite
        ),
        child: InkWell(
          onTap: () async {
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: 20.0,left:20.0,top: 10,bottom: 5),
                  child: CircleAvatar(
                    backgroundImage: image,
                    backgroundColor: kCPWhite,
                    radius: 100,
                  )
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(usersNameList[0].key,style: const TextStyle(fontFamily: 'Eastman',fontSize: 24,fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        ),
      );
    });
  }

  void setContent()async{
    await calculateAgePercentages();
    getCountries();
    await getCategories();
    setTopProducts();
    await setTopUser();

  }

  @override
  void initState() {
    setContent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kCPGreenDark,
        title: Text("Dashboard",style: kTitleTextStyle2.copyWith(fontSize: 22,color: Colors.white),),
        centerTitle: true,
      ),
      backgroundColor: kCPGreenLight,
      body:  SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "Ages by percentage :",
                textAlign: TextAlign.center,
                style: kTitleTextStyle.copyWith(color: Colors.white,fontSize: 22),
              ),
            ),
            PieChartAge(dataMap: dataMap),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "Top 3 users countries  :",
                textAlign: TextAlign.center,
                style: kTitleTextStyle.copyWith(color: Colors.white,fontSize: 22),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0,bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: countries,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "Top 5 Product Categories  :",
                textAlign: TextAlign.center,
                style: kTitleTextStyle.copyWith(color: Colors.white,fontSize: 22),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0,bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: categories,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "Top 5 Product Scanned  :",
                textAlign: TextAlign.center,
                style: kTitleTextStyle.copyWith(color: Colors.white,fontSize: 22),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0,bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: topProducts,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                "The Number 1 User of the app",
                textAlign: TextAlign.center,
                style: kTitleTextStyle.copyWith(color: Colors.white,fontSize: 22),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0,bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    userInfo
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




