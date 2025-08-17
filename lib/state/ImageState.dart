import 'dart:io'; // Import the dart:io library to work with File objects, needed for managing local image files.
import 'package:flutter/foundation.dart'; // Import Flutter's foundation package to use ChangeNotifier for state management.

// ImageState is a class that manages the state of an image file in the app.
// It extends ChangeNotifier to allow widgets to listen for updates.
class ImageState with ChangeNotifier {
  File? _imageFile; // A private (due to the underscore "_") variable for the selected image file. It can be null (it is nullable) because no image might be selected.

  File? get imageFile => _imageFile; // Public getter to access the currently selected image file. Allows read-only access from outside the class.

  void setImage(File file) {
    _imageFile = file; // Sets (updates) the _imageFile with a new image file.
    notifyListeners(); // Notifies all registered listeners (widgets) that the state has changed, so they can rebuild and reflect the new image.
  }

  void clearImage() {
    _imageFile = null; // Clears the selected image by setting _imageFile to null.
    notifyListeners(); // Notifies listeners again so the UI updates accordingly (e.g., remove the displayed image).
  }
}
