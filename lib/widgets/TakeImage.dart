import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';   // Package that allows picking images from the camera or gallery.
import 'dart:io';   // Dart's core library for working with files, directories, and other I/O operations.
import 'package:permission_handler/permission_handler.dart'; // Package to request and check app permissions (camera access, gallery access, etc.)
import 'package:path_provider/path_provider.dart'; // Package that provides access to commonly used locations on the filesystem (e.g., app's documents directory).
import 'package:provider/provider.dart';  // Import the Provider package to manage state across the app
import '../state/ImageState.dart';
import '../screens/UploadImage.dart';

// Helper function to show a popup with upload options (Camera or Gallery)
// Parameters:
// - context: The BuildContext needed to display the dialog.
// - onPickImage: A callback function that accepts an ImageSource (camera or gallery) and handles the logic after the user selects an option.
void showUploadOptionsPopup(BuildContext context, Future<void> Function(ImageSource) onPickImage) {
  showDialog(
    context: context, // The current UI context to attach the dialog to.
    builder: (_) => AlertDialog(  // Creates a custom popup dialog
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Upload Image'),
      content: Column(
        mainAxisSize: MainAxisSize.min, // Makes the column only as big as needed
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.camera_alt),
            label: const Text('Camera'),
            onPressed: () {
              Navigator.pop(context);  // Close the popup when pressed
              onPickImage(ImageSource.camera);  // Call the provided function with "camera" as the source
            },
          ),
          const SizedBox(height: 10), // Small space of 10 pixel between the two buttons
          ElevatedButton.icon(
            icon: const Icon(Icons.photo_library),
            label: const Text('Gallery'),
            onPressed: () {
              Navigator.pop(context);  // Close the popup when pressed
              onPickImage(ImageSource.gallery); // Call the provided function with "gallery" as the source
            },
          ),
        ],
      ),
    ),
  );
}

// Floating Action Button Widget that handles taking/uploading an image
class TakeImageFAB extends StatelessWidget {
  const TakeImageFAB({super.key});  // Constructor

  @override
  Widget build(BuildContext context) {
    // GestureDetector allows capturing tap events (like onTap)
    return GestureDetector(
      onTap: () async {    // Asynchronous because it waits for the user's selection.
        // Open upload options popup
        showUploadOptionsPopup(context, (source) async {    // Asynchronous because it waits for the user's selection.
          // Request appropriate permissions based on selected source
          final permission = source == ImageSource.camera
              ? await Permission.camera.request()
              : await Permission.photos.request();

          if (permission.isGranted) {
            // If permission is granted create an ImagePicker instance
            final picker = ImagePicker();
            final pickedFile = await picker.pickImage(source: source); // Pick an image using the selected source (camera or gallery)

            if (pickedFile != null) {
              // If the user actually picked an image:

              final directory = await getApplicationDocumentsDirectory();     // Get the app's documents directory
              final name = '${DateTime.now().millisecondsSinceEpoch}.jpg';   // Create a unique filename based on the current timestamp
              final localFile = File('${directory.path}/$name');            // Create a new file in the documents directory
              await File(pickedFile.path).copy(localFile.path);            // Copy the picked image file to the app's local storage

              Provider.of<ImageState>(context, listen: false).setImage(localFile);   // Update the app's state with the new image
            }
          } else {
            // If permission is denied:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No permissions given")),
            );
          }
        });
      },
      // Floating Action Button appearance
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient:  LinearGradient(
            colors: [Colors.purple.shade400, Colors.blue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Icon(Icons.add_a_photo, color: Color(0xFFE9EFFF), size: 35),
      ),
    );
  }
}
class ImagePreview extends StatelessWidget {
  const ImagePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageState>(
      builder: (context, imageState, child) {
        if (imageState.imageFile != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Selected Image Preview',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UploadImage(imageFile: imageState.imageFile!),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        imageState.imageFile!,
                        width: 130,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}

