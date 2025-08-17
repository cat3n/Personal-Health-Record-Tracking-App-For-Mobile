import 'dart:convert'; // Import for decoding JSON responses.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/PageLayout.dart';
import '../widgets/FormUtils.dart';
import '../widgets/FloatingActionSubmitForm.dart';

class AllergiesScreen extends StatefulWidget {
  const AllergiesScreen({super.key});

  @override
  State<AllergiesScreen> createState() => _AllergiesScreenState();
}

class _AllergiesScreenState extends State<AllergiesScreen> {
  List<Map<String, dynamic>> allergiesData = []; // Stores list of allergy records
  bool showForm = false; // Controls visibility of the form
  String? _selectedSeverity; // Nullable String that holds selected severity level

  final _formKey = GlobalKey<FormState>(); // Key to manage form validation
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reactionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAllergies(); // Load data from JSON when the screen loads
  }

  // Loads JSON data from assets and parses it into a list of maps
  Future<void> loadAllergies() async {
    final String jsonString = await rootBundle.loadString('assets/allergies.json'); // Reads the file as a string
    final List<dynamic> jsonList = json.decode(jsonString); // Decodes JSON string into a List<dynamic>
    setState(() {
      allergiesData = List<Map<String, dynamic>>.from(jsonList); // Convert dynamic list to list of maps and update the UI
    });
  }

  // Handles form submission
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newEntry = {
        "Allergy Name": _nameController.text, // Get text from name input
        "Reaction": _reactionController.text, // Get text from reaction input
        "Severity": _selectedSeverity ?? "", // Use selected severity or empty string
      };

      setState(() {
        allergiesData.add(newEntry); // Add the new allergy record to the list
        showForm = false; // Hide the form after submission

        // Clear form inputs
        _nameController.clear();
        _reactionController.clear();
        _selectedSeverity = null;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    // Defines severity options with labels, icons, and colors
    final List<Map<String, dynamic>> severityOptions = [
      {'label': 'Mild', 'value': 'mild', 'color': Colors.green, 'icon': Icons.sentiment_satisfied},
      {'label': 'Mild to Moderate', 'value': 'mild to moderate', 'color': Colors.lightGreen, 'icon': Icons.sentiment_neutral},
      {'label': 'Moderate', 'value': 'moderate', 'color': Colors.orange, 'icon': Icons.sentiment_dissatisfied},
      {'label': 'Moderate to Severe', 'value': 'moderate to severe', 'color': Colors.deepOrange, 'icon': Icons.warning},
      {'label': 'Severe', 'value': 'severe', 'color': Colors.red, 'icon': Icons.report},
    ];
    return Scaffold(
      appBar: PageLayout(title: 'Allergies', isTitleBold: false, centerTitle: false, automaticallyImplyLeading: true,), // Using a custom PageLayout widget for the AppBar with the title 'Allergies'
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adds padding around the ListView
        child: ListView(
          // Iterating through the allergy data and converting it into Card widgets
          children: [
            /// Display each allergy as a styled Card widget
            ...allergiesData.map((allergy) {
              return Card(
                color: Colors.red.shade50, // Light red shade for allergy-related information
                  child: ListTile(
                    title: Text(
                      allergy["Allergy Name"] ?? "",
                      style: const TextStyle(fontWeight: FontWeight.bold), // Bold text for allergy name
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: allergy.entries.map((entry) {
                        if (entry.key == "Allergy Name") return const SizedBox.shrink();  // Skip displaying the name again in the subtitle

                        Color textColor = Colors.black;
                        String valueText = "${entry.value}";
                        // Color code based on severity
                        if (entry.key.toLowerCase() == "severity") {
                          final severityValue = (entry.value as String).toLowerCase();

                          if (severityValue.contains("severe")) {
                            textColor = Colors.red;
                          } else if (severityValue.contains("moderate")) {
                            textColor = Colors.orange;
                          } else if (severityValue.contains("mild")) {
                            textColor = Colors.green;
                          }

                          // Capitalize each word in severity
                          valueText = severityValue
                              .split(' ')
                              .map((word) => word[0].toUpperCase() + word.substring(1))
                              .join(' ');
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: RichText(
                            text: TextSpan(
                              text: "${entry.key}: ",
                              style: const TextStyle(color: Colors.black),
                              children: [
                                TextSpan(
                                  text: valueText,
                                  style: TextStyle(color: textColor),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),  // Convert the iterable list into a list of Cards
                    ),
                  )
              );
            }),

            /// Form for adding a new allergy entry
            if (showForm)...[ // If "showForm" is true, show the form
              const SizedBox(height: 30), // Add vertical spacing before form
              Card(
                elevation: 2,
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          'Add New Allergy',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 20),
                        // Allergy Name input
                        buildTextField(controller: _nameController, label: 'Allergy Name', fillColor: const Color(0xFFFFD2D2),),
                        const SizedBox(height: 14),
                        // Reaction input
                        buildTextField(controller: _reactionController, label: 'Reaction', fillColor: const Color(0xFFFFD2D2),),
                        const SizedBox(height: 14),
                        // Severity dropdown input
                        buildDropdownField<String>(
                          label: 'Severity', // Label displayed above the dropdown field
                          value: _selectedSeverity, // Currently selected value (nullable String)
                          // List of dropdown options created from the severityOptions list
                          items: severityOptions.map((item) => item['value'] as String).toList(),
                          // Called when the user selects a different value from the dropdown
                          onChanged: (value) {
                            setState(() => _selectedSeverity = value); // Update the selected value and refresh the UI
                          },
                          // Validator to ensure that the field is not left empty
                          validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                          // Builds each dropdown menu item using an icon and label
                          itemBuilder: (value) {
                            // Find the full map for the currently processed value
                            final item = severityOptions.firstWhere((e) => e['value'] == value);
                            return Row(
                              children: [
                                // Display the associated icon with the associated color
                                Icon(item['icon'] as IconData, color: item['color'] as Color),
                                const SizedBox(width: 10),
                                Text(item['label'] as String), // Display the label text
                              ],
                            );
                          },
                          // Show the selected item when the dropdown is collapsed
                          displayLabel: (value) {
                            final item = severityOptions.firstWhere((e) => e['value'] == value);
                            return item['label'] as String;
                          },
                          fillColor: const Color(0xFFFFD2D2), // Background fill color for the dropdown field
                          dropdownColor: Colors.red.shade50, // Background color of the dropdown menu
                        ),
                        const SizedBox(height: 12),
                        // Submit button for the form
                        Align(
                          alignment: Alignment.center, // Centers the button horizontally
                          child: ElevatedButton.icon(
                            onPressed: _submitForm, // Trigger form submission logic
                            icon: const Icon(Icons.check, color: Colors.white), // Leading icon in the button
                            label: const Text('Submit', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple.shade300, // Color of the button
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0), // Rounded corners for the button
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 80), // Extra spacing for scroll area
          ],
        ),
      ),
      // Floating action button to toggle form visibility
      floatingActionButton: FloatingActionSubmitForm(
        isOpen: showForm,
        onPressed: () {
          setState(() {
            showForm = !showForm; // Toggle form visibility
          });
        },
      ),
    );
  }
}
