import 'dart:convert'; // Import for decoding JSON responses.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widgets/PageLayout.dart';
import '../widgets/FormUtils.dart';
import '../widgets/FloatingActionSubmitForm.dart';


class ProceduresScreen extends StatefulWidget {
  const ProceduresScreen({super.key});

  @override
  State<ProceduresScreen> createState() => _ProceduresScreenState();
}

class _ProceduresScreenState extends State<ProceduresScreen> {
  List<Map<String, dynamic>> proceduresData = []; // Stores list of procedures records
  Map<String, int> proceduresByType = {}; // Holds the number of procedures by type for the chart

  final _formKey = GlobalKey<FormState>(); // Key to manage form validation
  final procedureController = TextEditingController();
  final providerController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();
  DateTime? selectedDate; // Stores the date selected by the user
  bool showForm = false; // Controls visibility of the form



  @override
  void initState() {
    super.initState();
    loadProcedures(); // Load data from JSON when the screen loads
  }

  // Loads JSON data from assets and parses it into a list of maps
  Future<void> loadProcedures() async {
    final String jsonString = await rootBundle.loadString('assets/procedures.json'); // Reads the file as a string
    final List<dynamic> jsonList = json.decode(jsonString); // Decodes JSON string into a List<dynamic>
    final List<Map<String, dynamic>> parsedData = List<Map<String, dynamic>>.from(jsonList); // Convert dynamic list to list of maps and update the UI

    final Map<String, int> typeCount = {}; // Temporary map to count each procedure type
    for (var procedure in parsedData) {
      final type = procedure['Procedure'] ?? 'Unknown'; // Default to 'Unknown' if field is missing
      typeCount[type] = (typeCount[type] ?? 0) + 1; // Increment count
    }
    // Update UI state with the loaded data
    setState(() {
      proceduresData = parsedData;
      proceduresByType = typeCount;
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

  @override
  Widget build(BuildContext context) {
    // Sort procedure types by count (descending) to display the most frequent first
    final sortedTypes = proceduresByType.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: PageLayout(title: 'Procedures', isTitleBold: false, centerTitle: false, automaticallyImplyLeading: true,), // Using a custom PageLayout widget for the AppBar with the title 'Procedures'.
      body: Container(
        color: const Color(0xFFBEE2F5),
        padding: const EdgeInsets.all(16.0), // Adds padding around the list
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final procedure = proceduresData[index]; // Get current item
                  return Card(
                    color: const Color(0xFFEDF1F8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        procedure["Procedure"] ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: procedure.entries.map((entry) {
                          if (entry.key == "Procedure") return const SizedBox.shrink(); // Skip displaying the name again in the subtitle
                          final isDate = entry.key == "Date"; // Used to color the date differently
                          final valueColor = isDate ? const Color(0xFF60759B) : Colors.black;
                          return Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: RichText(
                              text: TextSpan(
                                text: "${entry.key}: ",
                                style: const TextStyle(color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: "${entry.value}",
                                    style: TextStyle(color: valueColor), // Highlight date
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
                childCount: proceduresData.length, // Number of cards to generate
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // Show pie chart only if there is chart data
            if (proceduresByType.isNotEmpty)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 300,
                  child: SfCircularChart(
                    title: ChartTitle(text: 'Number Of Procedures'),
                    legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
                    tooltipBehavior: TooltipBehavior(enable: true), // Enable tooltip on tap over chart segments
                    // Define the series of data to be rendered in the chart
                    series: <PieSeries<MapEntry<String, int>, String>>[
                      PieSeries<MapEntry<String, int>, String>(
                        dataSource: sortedTypes, // Provide the data source for the chart
                        xValueMapper: (entry, _) => entry.key, // Procedure label for each pie slice
                        yValueMapper: (entry, _) => entry.value, // Size of each slice (how many procedures)
                        dataLabelSettings: const DataLabelSettings(isVisible: false),
                        enableTooltip: true, // Enable tooltips for individual pie slices
                      )
                    ],
                  ),
                ),
              ),

            /// Form for adding a new procedure entry
            if (showForm) // If "showForm" is true, show the form
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 24),
                  child: Card(
                    color: const Color(0xFFEDF1F8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text(
                              "Add Scheduled Procedure",
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 20),
                            // Procedure Name input
                            buildTextField(controller: procedureController, label: "Procedure Name", fillColor: const Color(0xFFD1E0FD),),
                            const SizedBox(height: 14),
                            // Provider input
                            buildTextField(controller: providerController, label: "Provider", fillColor: const Color(0xFFD1E0FD),),
                            const SizedBox(height: 14),
                            // Location input
                            buildTextField(controller: locationController, label: "Location", fillColor: const Color(0xFFD1E0FD),),
                            const SizedBox(height: 14),
                            // Custom date picker field
                            buildDateField(
                              context: context,
                              controller: dateController,
                              label: "Date",
                              selectedDate: selectedDate,
                              onDatePicked: (picked) {
                                setState(() => selectedDate = picked); // Update selected date
                              },
                              fillColor: const Color(0xFFD1E0FD),
                            ),
                            const SizedBox(height: 20),
                            // Submit button for the form
                            Align(
                              alignment: Alignment.center, // Centers the button horizontally
                              child: FilledButton.icon(
                                icon: const Icon(Icons.check),
                                label: const Text("Submit"),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.deepPurple.shade300, // Color of the button
                                ),
                                // Handles form submission
                                onPressed: () {
                                  // Proceed only if form is valid and a date is selected
                                  if (_formKey.currentState!.validate() && selectedDate != null) {
                                    final newProcedure = {
                                      "Procedure": procedureController.text, // Get text from procedure input
                                      "Date": "${_monthName(selectedDate!.month)} ${selectedDate!.day}, ${selectedDate!.year}", // Format date
                                      "Provider": providerController.text, // Get text from provider input
                                      "Location": locationController.text, // Get text from location input
                                    };
                                    // Update app state with new data
                                    setState(() {
                                      proceduresData.add(newProcedure); // Add the new procedure record to the list
                                      final type = newProcedure['Procedure'] ?? 'Unknown';
                                      proceduresByType[type] = (proceduresByType[type] ?? 0) + 1;
                                      // Clear form inputs
                                      procedureController.clear();
                                      providerController.clear();
                                      locationController.clear();
                                      selectedDate = null;
                                      showForm = false; // Hide the form after submission
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      )

                    ),
                  ),
                ),
              ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 100), // Extra spacing for scroll area
            ),
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
