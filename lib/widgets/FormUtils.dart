import 'package:flutter/material.dart';

/// Reusable text input field (TextFormField) builder.
/// This widget provides a consistent and customizable input field throughout the app.
Widget buildTextField({
  required TextEditingController controller, // Controller to manage input value
  required String label, // Field label displayed inside the text field
  bool readOnly = false, // If true, the field cannot be edited (e.g., for date pickers)
  Widget? suffixIcon, // Optional widget to show at the end of the field (e.g., calendar icon)
  String? Function(String?)? validator, // Validation logic
  VoidCallback? onTap, // Callback function triggered on tap (used with readOnly fields)
  Color fillColor = const Color(0xFFD1EFFF), // Background color of the field
  Color borderColor = Colors.grey, // Color of the border when not focused
  TextStyle? labelStyle, // Optional styling for the label text
  EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14), // Padding inside the field
}) {
  //TextFormField widget
  final field = TextFormField(
    controller: controller,
    readOnly: readOnly,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: labelStyle,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        // borderSide: const BorderSide(color: Colors.blue),
      ),
      contentPadding: contentPadding,
    ),
    validator: validator ?? (value) => value == null || value.isEmpty ? 'Required' : null,
  );

  // If the field is readOnly and should trigger an action (like a date picker), wrap it with GestureDetector
  if (onTap != null) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(child: field), // Prevents the user from typing while still allowing taps
    );
  } else {
    return field; // Regular editable field
  }
}

/// A specialized builder for date input fields that opens a date picker on tap.
Widget buildDateField({
  required BuildContext context, // Context is required for showing the date picker dialog
  required TextEditingController controller, // Controls the text displayed in the field
  required String label, // Field label
  required DateTime? selectedDate, // Currently selected date
  required Function(DateTime) onDatePicked, // Callback function to update the selected date
  Color fillColor = const Color(0xFFE0E0E0), // Field background color
}) {
  return buildTextField(
    controller: controller,
    label: label,
    readOnly: true, // Field is not editable directly
    suffixIcon: const Icon(Icons.calendar_today_outlined), // Calendar icon at the end
    onTap: () async {
      // Open the native date picker dialog
      final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(), // Default to today if no date is selected
        firstDate: DateTime(1900), // Earliest allowed date
        lastDate: DateTime(2100), // Latest allowed date
      );
      if (picked != null) {
        onDatePicked(picked); // Update the selected date
        controller.text = "${picked.month}/${picked.day}/${picked.year}"; // Format and display it
      }
    },
    validator: (_) => selectedDate == null ? 'Required' : null, // Require a date selection
    fillColor: fillColor,
  );
}

/// Reusable dropdown field builder that supports customization for value display and rendering.
Widget buildDropdownField<T>({
  required String label, // Dropdown label
  required T? value, // Currently selected value
  required List<T> items, // List of dropdown options
  required void Function(T?) onChanged, // Function to call when selection changes
  String? Function(T?)? validator, // Optional validation logic
  Widget Function(T)? itemBuilder, // Optional function to customize each item display
  String Function(T)? displayLabel, // Optional function to convert item to string label
  Color fillColor = const Color(0xFFE0E0E0), // Background color of the field
  Color dropdownColor = const Color(0xFFFFEBEE), // Background color of the dropdown menu
}) {
  return DropdownButtonFormField<T>(
    value: value,
    items: items.map((item) {
      return DropdownMenuItem<T>(
        value: item,
        // Display each item either using itemBuilder or the default text
        child: itemBuilder != null
            ? itemBuilder(item)
            : Text(displayLabel != null ? displayLabel(item) : item.toString()),
      );
    }).toList(),
    // Optional custom rendering for selected item in the field
    selectedItemBuilder: itemBuilder != null
        ? (context) => items.map((item) => itemBuilder(item)).toList()
        : null,
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label,
      filled: true,
      fillColor: fillColor,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16.0),
        borderSide: const BorderSide(color: Colors.red),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
    ),
    dropdownColor: dropdownColor,
    borderRadius: BorderRadius.circular(20),
    validator: validator ?? (value) => value == null ? 'Required' : null,
  );
}
