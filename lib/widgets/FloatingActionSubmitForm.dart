import 'package:flutter/material.dart';

// A custom floating action button that toggles between "add" and "close" icons,
// and changes its color depending on whether the form is open or closed.
class FloatingActionSubmitForm extends StatelessWidget {
  final bool isOpen; // Determines the state of the form (open/closed)
  final VoidCallback onPressed; // Callback function to handle button press

  const FloatingActionSubmitForm({
    super.key,
    required this.isOpen,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56, // Set the width of the button
      height: 56, // Set the height of the button
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Make the button circular
        gradient: LinearGradient( // Apply a gradient background color
          colors: isOpen
          // Use pink/red gradient if the form is open
              ? [Colors.pink.shade900, Colors.red]
          // Use blue/purple gradient if the form is closed
              : [Colors.blue.shade400, Colors.purple.shade400],
          begin: Alignment.topLeft, // Gradient starts at the top-left corner
          end: Alignment.bottomRight, // Gradient ends at the bottom-right corner
        ),
        boxShadow: const [
          // Add shadow to give a 3D effect
          BoxShadow(
            color: Colors.black26, // Shadow color
            blurRadius: 6,         // How blurry the shadow appears
            offset: Offset(2, 2),  // Shadow offset in x and y
          ),
        ],
      ),
      child: RawMaterialButton(
        onPressed: onPressed, // Executes the provided callback when tapped
        shape: const CircleBorder(), // Makes the button's shape circular
        elevation: 0, // No extra elevation (handled by the container’s shadow)
        child: Icon(
          isOpen ? Icons.close : Icons.add, // Display 'X' if open, '+' if closed
          color: const Color(0xFFE9EFFF), // Icon color (light blue/white)
          size: 25, // Icon size
        ),
      ),
    );
  }
}
