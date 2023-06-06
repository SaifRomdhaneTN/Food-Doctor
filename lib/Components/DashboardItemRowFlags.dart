// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:locale_emoji_flutter/locale_emoji_flutter.dart';
import 'package:prototype/constants.dart';

class DashboardItemRowFlags extends StatelessWidget {
  const DashboardItemRowFlags({
    super.key,
    required this.locale, required this.countryCode, required this.count,
  });

  final Locale locale;
  final String countryCode;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kCPWhite
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 10),
            child: Text(locale.flagEmoji!,style: const TextStyle(fontFamily: 'Eastman',fontSize: 60,),),
          ),
          Text("${count.toString()} users",style: const TextStyle(fontFamily: 'Eastman',fontSize: 16),),
          Text(countryCode,style: const TextStyle(fontFamily: 'Eastman',fontSize: 30,fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}