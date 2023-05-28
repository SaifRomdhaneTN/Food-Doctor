// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:prototype/constants.dart';

class PieChartAge extends StatelessWidget {
  const PieChartAge({
    super.key,
    required this.dataMap,
  });

  final Map<String, double> dataMap;

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: dataMap,
      animationDuration: const Duration(milliseconds: 800),
      chartType:ChartType.disc,
      chartRadius: 150,
      colorList: const [
        Colors.white,
        kCPWhite,
        kCPGreenMid,
        kCPGreenDark
      ],
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Eastman',
            color: Colors.white
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: true,
        showChartValuesOutside: false,
        decimalPlaces: 1,
      ),
    );
  }
}