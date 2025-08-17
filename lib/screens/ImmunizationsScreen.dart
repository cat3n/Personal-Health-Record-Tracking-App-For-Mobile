import 'dart:convert'; // Import for decoding JSON responses.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/PageLayout.dart';
import '../widgets/FormUtils.dart';
import '../widgets/FloatingActionSubmitForm.dart';

class ImmunizationsScreen extends StatefulWidget {
  const ImmunizationsScreen({super.key});

  @override
  State<ImmunizationsScreen> createState() => _ImmunizationsScreenState();
}

class _ImmunizationsScreenState extends State<ImmunizationsScreen> {
  List<Map<String, dynamic>> immunizationsData = []; // Stores list of immunizations records
  bool showForm = false; // Controls visibility of the form

  final _formKey = GlobalKey<FormState>(); // Key to manage form validation
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  DateTime? selectedDate; // Stores the date selected by the user

  @override
  void initState() {
    super.initState();
    loadImmunizations(); // Load data from JSON when the screen loads
  }

  // Loads JSON data from assets and parses it into a list of maps
  Future<void> loadImmunizations() async {
    final String jsonString = await rootBundle.loadString('assets/immunizations.json'); // Reads the file as a string
    final List<dynamic> jsonList = json.decode(jsonString); // Decodes JSON string into a List<dynamic>
    setState(() {
      immunizationsData = List<Map<String, dynamic>>.from(jsonList); // Convert dynamic list to list of maps and update the UI
    });
  }

  // Returns the name of a month from its integer representation (1–12)
  String _monthName(int month) {
    return [
      '',
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ][month];
  }

  // Handles form submission
  void _submitForm() {
    // Proceed only if form is valid and a date is selected
    if (_formKey.currentState!.validate() && selectedDate != null) {
      final newEntry = {
        "Date": "${_monthName(selectedDate!.month)} ${selectedDate!.year}", // Format date
        "Immunization Name": _nameController.text, // Get text from name input
        "Type": _typeController.text, // Get text from type input
        "Dose Quantity": _doseController.text, // Get text from dose quantity input
        "Instructions": _instructionsController.text, // Get text from instructions input
      };

      setState(() {
        immunizationsData.add(newEntry); // Add the new immunization record to the list
        showForm = false; // Hide the form after submission
        // Clear form inputs
        _nameController.clear();
        _typeController.clear();
        _doseController.clear();
        _instructionsController.clear();
        selectedDate = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageLayout(title: 'Immunizations', isTitleBold: false, centerTitle: false, automaticallyImplyLeading: true,), // Using a custom PageLayout widget for the AppBar with the title 'Immunizations'
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adds spacing around the list
        child: ListView(
          // Mapping immunization data into a list of Cards
          children: [
            ...immunizationsData.map((immunization) {
              return Card(
                color: Colors.orange.shade50,
                child: ListTile(
                  title: Text(
                    immunization["Immunization Name"] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: immunization.entries.map((entry) {
                      if (entry.key == "Immunization Name") return const SizedBox.shrink(); // Skip displaying the name again in the subtitle
                      final isDate = entry.key == "Date"; // Used to color the date differently
                      return Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: RichText(
                          text: TextSpan(
                            text: "${entry.key}: ",
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "${entry.value}",
                                style: TextStyle(color: isDate ? Colors.orange : Colors.black), // Highlight date in orange
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(), // Convert iterable to a list of Cards
                  ),
                ),
              );
            }),

            /// Form for adding a new immunization entry
            if (showForm)...[ // If "showForm" is true, show the form
              const SizedBox(height: 30), // Add vertical spacing before form
              Card(
                elevation: 2,
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text('Add an Immunization', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 20),
                        // Immunization Name input
                        buildTextField(controller: _nameController, label: 'Immunization Name',fillColor: const Color(0xFFFFE9BA)),
                        const SizedBox(height: 14),
                        // Type input
                        buildTextField(controller: _typeController, label: 'Type',fillColor: const Color(0xFFFFE9BA)),
                        const SizedBox(height: 14),
                        // Dose Quantity input
                        buildTextField(controller: _doseController, label: 'Dose Quantity', fillColor: const Color(0xFFFFE9BA)),
                        const SizedBox(height: 14),
                        // Instructions input
                        buildTextField(controller: _instructionsController, label: 'Instructions', fillColor: const Color(0xFFFFE9BA)),
                        const SizedBox(height: 14),
                        // Custom date picker field
                        buildDateField(
                          context: context,
                          controller: TextEditingController(
                            text: selectedDate == null
                                ? ''
                                : "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}",
                          ),
                          label: 'Date',
                          selectedDate: selectedDate,
                          onDatePicked: (picked) {
                            setState(() {
                              selectedDate = picked; // Update selected date
                            });
                          },
                            fillColor: const Color(0xFFFFE9BA)
                        ),
                        const SizedBox(height: 20),
                        // Submit button for the form
                        Align(
                          alignment: Alignment.center, // Centers the button horizontally
                          child: ElevatedButton.icon(
                            onPressed: _submitForm, // Trigger form submission logic
                            icon: const Icon(Icons.check, color: Colors.white),
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
                  )
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
