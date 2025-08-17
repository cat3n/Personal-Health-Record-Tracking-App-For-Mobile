import 'package:flutter/material.dart';
import '../widgets/ScreensMenu.dart';
import '../widgets/PageLayout.dart';
import '../widgets/RandomQuote.dart';
import '../widgets/TakeImage.dart';
import './HeartRateCalculatorScreen.dart';


// HomePage is a StatelessWidget representing the main screen after login.
class HomePage extends StatelessWidget {
  // Create a GlobalKey to access the ScaffoldState (to open the drawer programmatically).
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Attach the key to Scaffold to control it (e.g., open the drawer)

      appBar: PageLayout(
        title: 'Good Day, Ellen Ross', // Using a custom PageLayout widget for the AppBar with user's name as title
        leading: IconButton(
          icon: const Icon(
            Icons.menu_open,
            size: 30,
          ), // Drawer icon
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // Open the Drawer when the icon is tapped
          },
        ),
      ),
      drawer: const ScreensMenu(), // Custom side menu (Drawer widget)

      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add 16 pixels of space around the entire body
        child: Column(
          children: <Widget>[
            const RandomQuote(), // Display a random quote at the top
            const SizedBox(height: 10), // Add 10 pixels of vertical spacing

            Column(
              mainAxisAlignment: MainAxisAlignment.center, // Center items vertically
              crossAxisAlignment: CrossAxisAlignment.center, // Center items horizontally
              children: <Widget>[
                // Text(
                //   'Welcome, Ellen Ross',  // Welcome message
                //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                // ),
                // SizedBox(height: 10), // Add 10 pixels of spacing between elements

                // Text in gradient color with a custom shader.
                Text(
                  'Your Personal Health Record',
                  style: TextStyle(
                    fontSize: 22,
                    // Shader that applies a gradient to the text.
                    foreground: (() {
                      // Create a Paint object to apply a custom shader to the text.
                      Paint paint = Paint();
                      // Define a LinearGradient for the shader. This will create a gradient effect that goes from one color to another.
                      paint.shader = LinearGradient(
                        colors: [Colors.purple.shade200, Colors.deepPurple.shade400,],
                        begin: Alignment.topLeft,   // Define where the gradient should begin (top-left).
                        end: Alignment.bottomRight, // Define where the gradient should end (bottom-right).
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 300.0, 70.0)); // Create the shader by defining the area to apply the gradient.
                      return paint; // <- return the Paint object
                    })(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  // When the widget is tapped, navigate to the HeartRateCalculatorScreen
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HeartRateCalculatorScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(30), // Rounded corners for the ripple effect of InkWell
                  splashColor: Colors.pinkAccent.withOpacity(0.3), // Ripple splash color with transparency when tapped
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), // Adds padding inside the button
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30), // Rounded corners
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF4056), Color(0xFF7E57C2)], // gradient
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pinkAccent.withOpacity(0.4), // Light pink shadow
                          blurRadius: 16, // How soft the shadow appears
                          offset: const Offset(0, 6), // Vertical displacement of the shadow
                        ),
                      ],
                    ),
                    // The content inside the button: icon and text aligned horizontally
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Only takes as much horizontal space as needed
                      children: const [
                        Icon(Icons.favorite, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          'Heart Rate Calculator',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 20),

            // Expanded widget to make the grid of menu items responsive.
            Expanded(
              // Display menu items as a responsive List
              child: ScreensMenu.buildListMenu(context),
            ),
            const ImagePreview(),
          ],
        ),
      ),
      floatingActionButton: const TakeImageFAB(), // Floating action button to upload an image
    );
  }
}
