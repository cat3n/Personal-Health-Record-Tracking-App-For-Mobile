import 'dart:convert'; // Import for decoding JSON responses.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widgets/PageLayout.dart';
import '../widgets/FormUtils.dart';
import '../widgets/FloatingActionSubmitForm.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  List<Map<String, dynamic>> medicationData = []; // Stores list of medication records
  List<RateData> chartData = []; // Stores chart data based on medication rate quantity

  bool showForm = false; // Controls visibility of the form

  final _formKey = GlobalKey<FormState>(); // Key to manage form validation
  final dateController = TextEditingController();
  final typeController = TextEditingController();
  final nameController = TextEditingController();
  final instructionsController = TextEditingController();
  final doseController = TextEditingController();
  final rateController = TextEditingController();
  final prescriberController = TextEditingController();
  DateTime? selectedDate; // Stores the date selected by the user

  double _paddedMax = 5; // Maximum Y-axis value for chart, with padding
  double _interval = 1; // Interval steps for chart Y-axis

  @override
  void initState() {
    super.initState();
    loadMedication(); // Load data from JSON when the screen loads
  }

  // Loads JSON data from assets and parses it into a list of maps
  Future<void> loadMedication() async {
    final String jsonString = await rootBundle.loadString('assets/medication.json'); // Reads the file as a string
    final List<dynamic> jsonList = json.decode(jsonString); // Decodes JSON string into a List<dynamic>
    // Parse rate-related data for visualization in the chart
    List<RateData> parsedChartData = jsonList.map((item) {
      final name = item['Name'] ?? 'Unknown';
      final instructions = item['Instructions'] ?? 'No instructions';
      return RateData(
        name,
        _parseRate(item['Rate Quantity'] ?? '0'),
        instructions,
      );
    }).toList();
    // Dynamically determine the max value for the chart Y-axis
    double maxRate = parsedChartData.isNotEmpty
        ? parsedChartData.map((e) => e.rate).reduce((a, b) => a > b ? a : b)
        : 0.0;
    _paddedMax = (maxRate <= 5) ? 5 : (maxRate * 1.2).ceilToDouble(); // Add 20% buffer
    _interval = (_paddedMax / 5).ceilToDouble(); // Set interval based on max
    // Update UI state with the loaded data
    setState(() {
      medicationData = List<Map<String, dynamic>>.from(jsonList); // Convert dynamic list to list of maps and update the UI
      chartData = parsedChartData;
    });
  }

  // Helper method to extract numeric value from a string (e.g., "2mg" -> 2.0)
  double _parseRate(String rateStr) {
    final match = RegExp(r'(\d+(\.\d+)?)').firstMatch(rateStr);
    if (match != null) {
      return double.tryParse(match.group(0)!) ?? 0.0;
    }
    return 0.0;
  }

  // Returns the name of a month from its integer representation (1–12)
  String _monthName(int month) {
    return [
      '',
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ][month];
  }

  /// Form for adding a new medication entry
  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Card(
        color: const Color(0xFFE0F7FA),
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
                  "Add Medication",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),
                // Medication Name input
                buildTextField(controller: nameController, label: "Name"),
                const SizedBox(height: 14),
                // Type input
                buildTextField(controller: typeController, label: "Type"),
                const SizedBox(height: 14),
                // Instructions input
                buildTextField(controller: instructionsController, label: "Instructions"),
                const SizedBox(height: 14),
                // Dose Quantity input
                buildTextField(controller: doseController, label: "Dose Quantity"),
                const SizedBox(height: 14),
                // Rate Quantity input
                buildTextField(controller: rateController, label: "Rate Quantity"),
                const SizedBox(height: 14),
                // Prescriber input
                buildTextField(controller: prescriberController, label: "Prescriber"),
                const SizedBox(height: 14),
                // Custom date picker field
                buildDateField(
                  context: context,
                  controller: dateController,
                  label: "Date",
                  selectedDate: selectedDate,
                  fillColor: const Color(0xFFD1EFFF),
                  onDatePicked: (picked) {
                    setState(() {
                      selectedDate = picked; // Update selected date
                      dateController.text = "${picked.month}/${picked.day}/${picked.year}"; // Format picked date
                    });
                  },
                ),
                const SizedBox(height: 20),
                // Submit button for the form
                FilledButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text("Submit"),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade300, // Color of the button
                  ),
                  // Handles form submission
                  onPressed: () {
                    // Proceed only if form is valid and a date is selected
                    if (_formKey.currentState!.validate() && selectedDate != null) {
                      final newMedication = {
                        "Date": "${_monthName(selectedDate!.month)} ${selectedDate!.day}, ${selectedDate!.year}", // Format date
                        "Type": typeController.text, // Get text from type input
                        "Name": nameController.text, // Get text from name input
                        "Instructions": instructionsController.text, // Get text from instructions input
                        "Dose Quantity": doseController.text, // Get text from dose quantity input
                        "Rate Quantity": rateController.text, // Get text from rate quantity input
                        "Prescriber": prescriberController.text, // Get text from prescriber input
                      };
                      // Update app state with new data
                      setState(() {
                        medicationData.add(newMedication); // Add the new medication record to the list
                        showForm = false; // Hide the form after submission
                        chartData.add(
                          RateData(
                            nameController.text,
                            _parseRate(rateController.text),
                            instructionsController.text,
                          ),
                        );
                        // Clear form inputs
                        nameController.clear();
                        typeController.clear();
                        instructionsController.clear();
                        doseController.clear();
                        rateController.clear();
                        prescriberController.clear();
                        dateController.clear();
                        selectedDate = null;
                        showForm = false;
                      });
                    }
                  }
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
      appBar: PageLayout(title: 'Medication', isTitleBold: false, centerTitle: false, automaticallyImplyLeading: true,), // Using a custom PageLayout widget for the AppBar with the title 'Medication'
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adds spacing around the list
        child: ListView(
          // Mapping medication data into a list of Cards
          children: [
            ...medicationData.map((med) {
              return Card(
                color: const Color(0xFFE0F7FA),
                child: ListTile(
                  title: Text(
                    med["Name"] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: med.entries.map((entry) {
                      if (entry.key == "Name") return const SizedBox.shrink(); // Skip displaying the name again in the subtitle
                      final isInstructions = entry.key == "Instructions"; // Used to color the instructions differently
                      final valueColor = isInstructions ? const Color(0xFF007B8A) : Colors.black;

                      return Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: RichText(
                          text: TextSpan(
                            text: "${entry.key}: ",
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "${entry.value}",
                                style: TextStyle(color: valueColor), // Highlight instructions
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(), // Convert map data into a list of widgets
                  ),
                ),
              );
            }),
            const SizedBox(height: 30),
            // Bar chart showing medication rate quantity
            SizedBox(
              height: 400, // Set the height of the chart area to 400 pixels
              child: SfCartesianChart(
                title: ChartTitle(text: 'Daily Medication'), // Title displayed at the top of the chart
                // Tooltip configuration for displaying additional data on tap
                tooltipBehavior: TooltipBehavior(
                  enable: true,// Enable tooltips when user taps over a bar
                  builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
                    // Access the corresponding RateData object based on the data point index
                    final RateData rateData = chartData[pointIndex];
                    return Container(
                      padding: const EdgeInsets.all(10), // Padding inside the tooltip
                      decoration: BoxDecoration(
                        color: Colors.black87, // Tooltip background color
                        borderRadius: BorderRadius.circular(8), // Rounded corners for tooltip
                      ),
                      // Tooltip content: medication name and instructions
                      child: Text(
                        '${rateData.fullName}\nInstructions: ${rateData.instructions}',
                        style: const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    );
                  },
                ),
                // Configuration of the X axis (horizontal)
                primaryXAxis: CategoryAxis(
                  labelRotation: -90, // Rotate labels vertically to prevent overlap
                  labelIntersectAction: AxisLabelIntersectAction.rotate90, // Force rotation if labels intersect
                  maximumLabels: 100, // force showing all labels
                ),
                // Configuration of the Y axis (vertical)
                primaryYAxis: NumericAxis(
                  minimum: 0, // Start the Y-axis from 0
                  maximum: _paddedMax, // Maximum value determined dynamically based on chart data
                  interval: _interval, // Space between Y-axis ticks
                  title: AxisTitle(text: 'Dosage per day'), // Y-axis label
                ),
                // The actual data series for the bar chart
                series: <CartesianSeries<RateData, String>>[
                  BarSeries<RateData, String>(
                    dataSource: chartData, // Source of data for the bars
                    xValueMapper: (RateData data, _) => data.name, // X-axis value (medication short name)
                    yValueMapper: (RateData data, _) => data.rate, // Y-axis value (rate quantity)
                    dataLabelMapper: (RateData data, _) => data.fullName, // Full name shown in data labels
                    spacing: 0.4, // Space between bars
                    dataLabelSettings:  DataLabelSettings(
                      isVisible: true, // Show labels on bars
                      overflowMode: OverflowMode.trim, // Trim labels if they don't fit
                    ),
                    enableTooltip: true, // Enable tooltip for this series
                  ),
                ],
              ),
            ),

            if (showForm) _buildForm(), // If "showForm" is true, show the form
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
// Model for storing medication rate data for the chart
class RateData {
  final String name; // Shortened name for display
  final String fullName; // Full medication name in the toolip
  final double rate; // Dosage rate (numeric)
  final String instructions; // Medication instructions
  // If name is longer than 10 chars, shorten with ellipsis
  RateData(this.fullName, this.rate, this.instructions)
      : name = fullName.length > 10 ? '${fullName.substring(0, 10)}…' : fullName;
}
