// ignore_for_file: file_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:prototype/Components/RegScreenButton.dart';
import 'package:prototype/Screens/Form/FormPage1.dart';
import 'package:prototype/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);
  static String id ="FormScreen";
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }
  void setFilledFormOption() async {
    SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
    sharedPreferences.setString("filledForm", "no");
  }

  @override
  void initState() {
    setFilledFormOption();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: kCPWhite,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:   [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Text(
                "In order to start using The App.\n"
                    "You will have to Fill in a quick form that will allow us to know the food you like to eat. \n ",
                textAlign: TextAlign.center,
                style: kFormHomeTextStyle
              ),
            ),
            const SizedBox(height: 20.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RegScreenButton(
                    onPressed: (){
                    Navigator.pushNamed(context, FormPage1.id);
                    },
                    msg: 'continue',
                    txtColor: Colors.white,
                    bgColor: const Color(0xFF609966)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
