import 'package:flutter/material.dart';
import '../widgets/HeartRateCalculator.dart';
import '../widgets/PageLayout.dart';

class HeartRateCalculatorScreen extends StatelessWidget {
  const HeartRateCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageLayout(title: 'Heart Rate Calculator', isTitleBold: false, centerTitle: false, automaticallyImplyLeading: true,), // Using a custom PageLayout widget for the AppBar with the title 'Heart Rate Calculator'
      body: const Padding(
        padding: EdgeInsets.all(16.0), // Adds padding around the ListView
        child: HeartRateCalculator(), // Calls the Heart Rate Calculator
      ),
    );
  }
}
