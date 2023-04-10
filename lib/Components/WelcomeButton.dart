import 'package:flutter/material.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({
    super.key, required this.msg, required this.icon, required this.bgcolor, required this.txtcolor, required this.onPressed,
  });
  final String msg;
  final IconData icon;
  final Color bgcolor;
  final Color txtcolor;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280.0,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith((states) => bgcolor,),
          elevation: MaterialStateProperty.resolveWith((states) => 10),
          iconSize: MaterialStateProperty.resolveWith((states) => 30),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(35)
              )
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children:  [
              Icon(icon,color: txtcolor,),
              SizedBox(width: 20.0,),
              Text(msg,style: TextStyle(
                  fontSize: 25.0,
                  fontFamily: 'Eastman',
                  fontWeight: FontWeight.bold,
                  color: txtcolor
              ),),
            ],
          ),
        ),
      ),
    );
  }
}