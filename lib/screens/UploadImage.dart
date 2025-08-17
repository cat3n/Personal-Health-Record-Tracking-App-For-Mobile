import 'dart:io';  // Dart's core library for working with files, directories, and other I/O operations.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  // Import the Provider package to manage state across the app
import '../state/ImageState.dart';
import '../widgets/ScreensMenu.dart';
import '../widgets/PageLayout.dart';

class UploadImage extends StatefulWidget {
  final File imageFile;  // The image file that will be previewed and categorized.

  const UploadImage({super.key, required this.imageFile});  // Constructor for UploadImage widget, requires an imageFile.

  @override
  State<UploadImage> createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  String? selectedCategory;  // Holds the currently selected category from the dropdown (nullable)

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PageLayout(title: 'Preview Image', isTitleBold: false, centerTitle: false, automaticallyImplyLeading: true), // Using a custom PageLayout widget for the AppBar with the title 'Preview Image'.
      body: PopScope(
        canPop: true, // Specifies that the screen can be popped (navigated back).
        onPopInvokedWithResult: (didPop, result) { // This callback is invoked when the pop action occurs.
          if (didPop) {  // Check if the screen is actually being popped (i.e., back button was pressed).
            Provider.of<ImageState>(context, listen: false).clearImage(); // Clear image when back button pressed
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),  // Adds padding around the Card.
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),  // Rounded corners
            elevation: 8,   // Adds shadow to the Card.
            color: Color(0xFFE9EFFF), // Background color of the card
            child: Padding(
              padding: const EdgeInsets.all(16.0),  // Adds padding inside the Card.
              child: Column(
                children: [
                  Expanded(
                    // Expands to fill available vertical space.
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),  // Image with rounded corners.
                      child: Image.file(
                        widget.imageFile,          // Displays the uploaded image.
                        width: double.infinity,   // Makes the image stretch across the width.
                        fit: BoxFit.contain,     // Scales the image to fit inside the container without cropping.
                      ),
                    ),
                  ),
                  //const SizedBox(height: 20),
                  ScreensMenu.buildCategoryDropdown(
                    selectedCategory: selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                  const SizedBox(height: 28),  // Adds spacing of 28 pixels between dropdown and button.
                  SizedBox(
                    width: double.infinity,  // Makes the button stretch across the width.
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (selectedCategory == null) {
                          // If no category selected, show a snackbar warning.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please select a category')),
                          );
                          return;
                        }
                        Provider.of<ImageState>(context, listen: false).clearImage(); // Clears the image from the app's state after saving.
                        Navigator.pop(context); // Navigates back to the previous screen.
                      },
                      // 'Save' button appearance
                      icon: const Icon(Icons.save),
                      label: const Text('Save', style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: Colors.deepPurple.shade300,
                        foregroundColor: Color(0xB6FFFFFF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30), // Adds bottom spacing after the button.
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
