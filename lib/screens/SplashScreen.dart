import 'package:flutter/material.dart';
import 'LoginScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  // Create a Stateful Widget for Splash Screen
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

// State class for SplashScreen
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //Delay for 3 seconds and then navigate to HomePage
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()), // Replaces the current screen with HomePage
      );
    });
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/heart_splashscreen.png', width: 150, height: 150),
      ),
    );
  }
}