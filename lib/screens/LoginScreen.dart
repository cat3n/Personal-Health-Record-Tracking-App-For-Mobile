import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'RegisterScreen.dart';
import '../widgets/PageLayout.dart';
import '../validators/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers to manage the input for username and password fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Adding listeners to clear error messages whenever user types in either field
    usernameController.addListener(_clearErrorMessage);
    passwordController.addListener(_clearErrorMessage);
  }

  // Clears the error message if the user modifies the input after an error
  void _clearErrorMessage() {
    if (errorMessage != null) {
      setState(() {
        errorMessage = null;
      });
    }
  }

  bool _isPasswordVisible = false; // Controls whether password text is visible or obscured
  String? errorMessage; // Holds any error message to be displayed (nullable)

  // Handles the login logic
  void _login() {
    final username = usernameController.text.trim();
    final password = passwordController.text;
    // Validate the input fields
    final validationError = validateLogin(username, password);
    if (validationError != null) {
      // If there is a validation error, show the error message
      setState(() {
        errorMessage = validationError;
      });
      return;
    }

    // Hardcoded authentication check (for now)
    if (username == 'jsmith' && password == 'phrpassword') {
      // If credentials match, navigate to the HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Otherwise, display an error message
      setState(() {
        errorMessage = invalidLoginMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageLayout(
        title: 'Login', // Using a custom PageLayout widget for the AppBar with the title 'Login'
      ),
      body: Column(
        children: [
          // Adds vertical spacing depending on screen size (responsive design)
          SizedBox(height: MediaQuery.of(context).size.height * 0.12),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Display a logo/image at the top
                  Image.asset(
                    'assets/heart_splashscreen.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: 16),

                  // Motivational / branding tagline with a gradient shader
                  Row(
                    mainAxisSize: MainAxisSize.min, // Shrinks the Row to fit its children
                    children: [
                      Text(
                        "Your health, safely in your hands",
                        style: TextStyle(
                          fontSize: 17,
                          foreground: Paint()
                            ..shader = LinearGradient(
                              colors: [Colors.pinkAccent.shade200, Colors.deepPurple.shade400],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Icon with gradient shader effect
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [Colors.deepPurple.shade400, Colors.pinkAccent.shade200],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(Rect.fromLTWH(0.0, 0.0, bounds.width, bounds.height)),
                        child: const Icon(
                          Icons.handshake_outlined,
                          color: Colors.white, // The base color needs to be white for the shader to apply correctly
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Username Input Field
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: const TextStyle(fontSize: 18),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.deepPurple, width: 2.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Password Input Field
                  TextField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible, // Hide or show the password based on _isPasswordVisible flag
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(fontSize: 18),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: Colors.deepPurple, width: 2.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      filled: true,
                      fillColor: Colors.transparent,
                      // Toggle password visibility
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off, // Check if the password is currently visible. If it is, show the 'eye open' icon (Icons.visibility), otherwise, show the 'eye closed' icon (Icons.visibility_off)
                          color: Colors.deepPurple,
                        ),
                        onPressed: () {
                          setState(() {
                            // Toggle the value of _isPasswordVisible. If it was true (visible), make it false (hidden). If it was false (hidden), make it true (visible)
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Display error message if login fails
                  if (errorMessage != null)
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                    ),

                  const SizedBox(height: 10),

                  // Login Button
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50), // Button takes full width
                      backgroundColor: Colors.deepPurple.shade300,
                      textStyle: const TextStyle(fontSize: 22),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Color(0xB6FFFFFF)),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Prompt for users who don't have an account to navigate to RegisterScreen
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to Register Screen when clicked
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterScreen()),
                          );
                        },
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
