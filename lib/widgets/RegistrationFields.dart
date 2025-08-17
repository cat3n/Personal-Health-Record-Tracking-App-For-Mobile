import 'package:flutter/material.dart';


// Common error text style used throughout the register screen to display error messages
const TextStyle errorTextStyle = TextStyle(color: Colors.red, fontSize: 14, height: 1.3);

// Common decoration for all rounded input fields used in the app
InputDecoration fieldDecoration = InputDecoration(
  filled: true, // Ensures the input field has a background color
  fillColor: const Color(0xD6E1ECFF),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide.none, // No visible border side
  ),
  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), // Padding inside the input field
);

// Widget for common input fields with optional error text
Widget buildInputField({
  required String label, // Label for the input field
  required TextEditingController controller, // Controller to manage input text
  required String hintText, // Hint text that is shown in the field when it's empty
  TextInputType keyboardType = TextInputType.text, // Default type for the keyboard (can be changed if needed)
  bool obscureText = false, // Whether the text is obscured (for passwords)
  String? errorText, // Optional error text if validation fails (nullable)
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6), // Padding for the entire input field
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns to the left
      children: [
        Text(label, style: const TextStyle(fontSize: 18)), // Displays the label for the field
        const SizedBox(height: 5), // Adds space between the label and input field
        TextFormField(
          controller: controller, // Links the input field to the controller for text manipulation
          keyboardType: keyboardType, // Sets the keyboard type (text, email, etc.)
          obscureText: obscureText, // Determines if the text is hidden (for passwords)
          decoration: fieldDecoration.copyWith(
            hintText: hintText, // Sets the hint text inside the input field
            errorText: null, // No error text by default
          ),
        ),
        if (errorText != null) // If there's an error message,
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12), // Adds some padding around the error message
            child: Align(
              alignment: Alignment.centerLeft, // Aligns the error message to the left
              child: Text(errorText, style: errorTextStyle, textAlign: TextAlign.left), // Displays the error message
            ),
          ),
      ],
    ),
  );
}

// Widget for the gender selection input with a custom dropdown (and error text support)
Widget buildGenderField({
  required BuildContext context,
  required String? selectedGender, // Currently selected gender
  required ValueChanged<String?> onGenderChanged, // Callback function when a gender is selected
  String? errorText, // Optional error message to display if validation fails
}) {
  //final genderOptions = ['Male', 'Female', 'Do not want to declare']; // Gender options
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6), // Padding around the gender input field
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns the items in the column to the left
      children: [
        const Text('Gender', style: TextStyle(fontSize: 18)), // Label for the gender field
        const SizedBox(height: 5), // Adds space between the label and the input field
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xD6E1ECFF),
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonFormField<String>(
            value: selectedGender,
            onChanged: onGenderChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xD6E1ECFF),
              hintText: 'Select gender',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              errorText: errorText,
            ),
            borderRadius: BorderRadius.circular(20),
            dropdownColor: const Color(0xFDDDF7FA),
            items: ['Male', 'Female', 'Do not want to declare'].map((gender) {
              return DropdownMenuItem<String>(
                value: gender,
                child: Text(gender, style: const TextStyle(fontSize: 16)),
              );
            }).toList(),
          ),
        ),
        if (errorText != null) // If there's an error message,
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Align(
              alignment: Alignment.centerLeft, // Aligns the error message to the left
              child: Text(errorText, style: errorTextStyle, textAlign: TextAlign.left), // Displays the error message
            ),
          ),
      ],
    ),
  );
}

// Function for picking a birthdate using a date picker dialog
Future<DateTime?> pickBirthDate(BuildContext context) async { // This function is asynchronous because it opens a date picker and waits for the user's selection.
  // Opens a date picker dialog to select the birthdate
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime(2000), // Initial date shown (default to year 2000)
    firstDate: DateTime(1900), // Earliest selectable date (1900)
    lastDate: DateTime.now(), // Latest selectable date (current date)
  );
  return picked; // Returns the selected date
}

// Widget for the birthdate selection field with validation error support
Widget buildBirthdateField({
  required BuildContext context,
  required DateTime? selectedDate, // Currently selected birthdate
  required VoidCallback onTap, // Callback function to open the date picker
  String? errorText, // Optional error message if validation fails (nullable)
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6), // Padding for the input field
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns the items in the column to the left
      children: [
        const Text('Birthdate', style: TextStyle(fontSize: 18)), // Label for the birthdate field
        const SizedBox(height: 5), // Adds space between the label and the input field
        InkWell(
          onTap: onTap, // Opens the date picker when tapped
          child: InputDecorator(
            decoration: fieldDecoration.copyWith(
              hintText: 'DD/MM/YYYY', // Placeholder text for the birthdate input
              errorText: null, // No error text by default
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 35),
                child: Icon(
                  Icons.calendar_today_outlined,
                  color: Colors.black54,
                  size: 20,
                ),
              ),

            ),
            child: Text(
              selectedDate == null
                  ? 'DD/MM/YYYY' // Default placeholder text if no date is selected
                  : '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}', // Displays the selected date
              style: const TextStyle(fontSize: 16, color: Colors.black87), // Text style for the birthdate input
            ),
          ),
        ),
        if (errorText != null) // If there's an error message,
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Align(
              alignment: Alignment.centerLeft, // Aligns the error message to the left
              child: Text(errorText, style: errorTextStyle, textAlign: TextAlign.left), // Displays the error message
            ),
          ),
      ],
    ),
  );
}

// Styling for the Register button
Widget buildRegisterButton({
  required VoidCallback onPressed, // Callback function when the button is pressed
  required String label, // Text label for the button
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding for the button
    child: ElevatedButton(
      onPressed: onPressed, // Calls the onPressed function when the button is tapped
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50), // Button should take full width and have a height of 50
        textStyle: const TextStyle(fontSize: 22), // Font size for the button text
        backgroundColor: Colors.deepPurple.shade300, // Button background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded corners
        ),
        shadowColor: Colors.deepPurple.shade100, // Shadow color
      ),
      child: Text(
        label, // Button label
        style: const TextStyle(color: Color(0xB6FFFFFF)),
      ),
    ),
  );
}
