import 'dart:convert'; // Import for decoding JSON responses.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widgets/PageLayout.dart';
import '../widgets/FormUtils.dart';
import '../widgets/FloatingActionSubmitForm.dart';

class ProblemListScreen extends StatefulWidget {
  const ProblemListScreen({super.key});

  @override
  State<ProblemListScreen> createState() => _ProblemListScreenState();
}

class _ProblemListScreenState extends State<ProblemListScreen> {
  List<Map<String, dynamic>> problems = []; // Stores list of problem records
  List<StatusCount> chartData = []; // Stores aggregated status counts for the pie chart

  final _formKey = GlobalKey<FormState>(); // Key to manage form validation
  final observationController = TextEditingController();
  final commentsController = TextEditingController();
  final dateController = TextEditingController();
  DateTime? selectedDate; // Stores the date selected by the user
  String? selectedStatus; // Nullable String that holds selected status
  bool showForm = false; // Controls visibility of the form

  @override
  void initState() {
    super.initState();
    loadProblem(); // Load data from JSON when the screen loads
  }

  // Loads JSON data from assets and parses it into a list of maps
  Future<void> loadProblem() async {
    final String jsonString =
    await rootBundle.loadString('assets/user_problem_list.json'); // Reads the file as a string
    final List<dynamic> jsonList = json.decode(jsonString); // Decodes JSON string into a List<dynamic>
    final parsed = List<Map<String, dynamic>>.from(jsonList); // Convert dynamic list to list of maps and update the UI
    // Count problems by status
    final Map<String, int> statusCounts = {};
    for (var problem in parsed) {
      final status = problem['Status'] ?? 'Unknown'; // Use 'Unknown' if status is missing
      statusCounts[status] = (statusCounts[status] ?? 0) + 1;
    }
    // Update state with parsed data and status counts for chart
    setState(() {
      problems = parsed;
      chartData = statusCounts.entries
          .map((entry) => StatusCount(status: entry.key, count: entry.value))
          .toList();
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


  /// Form for adding a Problem entry
  Widget _buildFormSection() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Card(
        color: const Color(0xFFFFF0F0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add a Problem",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                // Observation input
                buildTextField(controller: observationController, label: "Observation", fillColor: const Color(0xD6FFDCEA),),
                const SizedBox(height: 14),
                // Custom dropdown to select status
                buildDropdownField<String>(
                  label: "Status",
                  value: selectedStatus,
                  items: const ["Active", "Resolved"],
                  onChanged: (value) {
                    setState(() => selectedStatus = value); // Update selected status
                  },
                  itemBuilder: (value) {
                    // Color the dropdown items differently based on status
                    final color = value == "Active"
                        ? const Color(0xFFB84A62)
                        : const Color(0xFF01BD60);
                    return Text(value, style: TextStyle(color: color));
                  },
                  displayLabel: (value) => value,
                  fillColor: const Color(0xD6FFDCEA),
                  dropdownColor: const Color(0xF4FFE8E8),
                ),
                const SizedBox(height: 14),
                // Comments input
                buildTextField(controller: commentsController, label: "Comments", fillColor: const Color(0xD6FFDCEA),),
                const SizedBox(height: 14),
                // Custom date picker field
                buildDateField(
                  context: context,
                  controller: dateController,
                  label: "Date",
                  selectedDate: selectedDate,
                  onDatePicked: (picked) {
                    setState(() {
                      selectedDate = picked; // Update selected date
                    });
                  },
                  fillColor: const Color(0xD6FFDCEA),
                ),
                const SizedBox(height: 20),
                // Submit button for the form
                Align(
                  alignment: Alignment.center, // Centers the button horizontally
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade300, // Color of the button
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text("Submit"),
                    // Handles form submission
                    onPressed: () {
                      // Proceed only if form is valid and a date is selected
                      if (_formKey.currentState!.validate() && selectedDate != null) {
                        final newProblem = {
                          "Observation": observationController.text, // Get text from observation input
                          "Status": selectedStatus!,
                          "Date": "${_monthName(selectedDate!.month)} ${selectedDate!.day}, ${selectedDate!.year}", // Format date
                          "Comments": commentsController.text, // Get text from comments input
                        };

                        setState(() {
                          problems.add(newProblem); // Add the new problem record to the list
                          showForm = false; // Hide the form after submission

                          final status = newProblem["Status"]!; // Get the status value from the newly submitted problem entry (e.g., "Active" or "Resolved"),the exclamation mark (!) asserts that the value is non-null

                          // Try to find an existing StatusCount object in chartData that matches the status
                          // If no match is found, create a new StatusCount object with count 0 (used for the next step)
                          final existing = chartData.firstWhere(
                                (e) => e.status == status, // Match by comparing each existing entry’s status
                            orElse: () => StatusCount(status: status, count: 0), // Fallback if not found
                          );

                          // Check if the returned object already exists in the chartData list
                          if (!chartData.contains(existing)) {
                            chartData.add(existing); // If it doesn't exist, add the new StatusCount object to chartData
                          } else {
                            existing.count++; // Existing status, increment count
                          }
                          // Clear form inputs
                          observationController.clear();
                          commentsController.clear();
                          dateController.clear();
                          selectedDate = null;
                          selectedStatus = null;
                          showForm = false;
                        });
                      }
                    }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageLayout(title: 'Problem List', isTitleBold: false, centerTitle: false, automaticallyImplyLeading: true,), // Using a custom PageLayout widget for the AppBar with the title 'Problem List'.
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adds spacing around the list
        child: ListView(
          children: [
            // Mapping plan of care data into a list of Cards
            ...problems.map((problem) {
              return Card(
                color: const Color(0xFFFFF0F0),
                child: ListTile(
                  title: Text(
                    problem["Observation"] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: problem.entries
                        .where((entry) => entry.key != "Observation") // Skip displaying the name again in the subtitle
                        .map((entry) {
                      final isStatus = entry.key == "Status"; // Used to color the date differently
                      final valueColor = isStatus
                          ? (entry.value == "Active"
                          ? Color(0xFFB84A62)
                          : Color(0xFF01BD60))
                          : Colors.black;
                      return Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: RichText(
                          text: TextSpan(
                            text: "${entry.key}: ",
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "${entry.value}",
                                style: TextStyle(color: valueColor), // Highlight status accordingly
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }).toList(), // Convert map data into a list of widgets
            const SizedBox(height: 24),

            // Show pie chart only if there's data
            if (chartData.isNotEmpty)
              SizedBox(
                height: 300, // Set the height of the chart area to 300 pixels
                child: SfCircularChart(
                  title: ChartTitle(text: 'Status Of Problems'), // Title displayed above the chart
                  // Configure legend (labels for chart slices)
                  legend: Legend(
                    isVisible: true,
                    overflowMode: LegendItemOverflowMode.wrap, // If items overflow, wrap them to the next line
                    position: LegendPosition.bottom, // Place the legend at the bottom of the chart
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true), // Enable tooltip on tap over chart segments
                  // Define the series of data to be rendered in the chart
                  series: <PieSeries<StatusCount, String>>[
                    PieSeries<StatusCount, String>(
                      dataSource: chartData, // Provide the data source for the chart (a list of StatusCount objects)
                      xValueMapper: (data, _) => data.status, // Define the property from the data to use as the label (status)
                      yValueMapper: (data, _) => data.count, // Define the property from the data to use as the value (how many problems)
                      //Map a specific color to each slice based on its status
                      pointColorMapper: (data, _) {
                        switch (data.status) {
                          case 'Active':
                            return Color(0xFFE16983);
                          case 'Resolved':
                            return Colors.greenAccent.shade400;
                          default:
                            return Colors.grey;
                        }
                      },
                      name: 'Status', // Name of the series (used in legend and tooltips)
                      dataLabelSettings: const DataLabelSettings(isVisible: false),
                      enableTooltip: true, // Enable tooltips for individual pie slices
                    )
                  ],
                ),
              ),
            if (showForm) _buildFormSection(), // If "showForm" is true, show the form
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

// Model class to represent problem status count
class StatusCount {
  final String status;
  int count;

  StatusCount({required this.status, required this.count});
}
