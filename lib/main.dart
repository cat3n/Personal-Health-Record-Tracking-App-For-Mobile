import 'package:flutter/material.dart';
import 'screens/SplashScreen.dart';
import 'state/ImageState.dart';
import 'package:provider/provider.dart'; // Import the Provider package to manage state across the app



void main() {
  // Start the app by wrapping it with a ChangeNotifierProvider
  runApp(
    ChangeNotifierProvider(
      // Create an instance of ImageState and provide it to the widget tree
      create: (context) => ImageState(),
      // The child widget that will have access to the ImageState (the entire app)
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Hides the debug banner in the top-right corner.
      title: 'Personal Health Record', // Sets the app title.
      theme: ThemeData(
        // Set global background color for all screens
        scaffoldBackgroundColor: Colors.blue.shade100,
      ),
      home: const SplashScreen(), // Sets the initial screen of the app (SplashScreen).
    );
  }
}

