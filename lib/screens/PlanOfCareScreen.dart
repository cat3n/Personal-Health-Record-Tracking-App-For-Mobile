import 'dart:convert'; // Import for decoding JSON responses.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../widgets/PageLayout.dart';
import '../widgets/FormUtils.dart';
import '../widgets/FloatingActionSubmitForm.dart';

class PlanOfCareScreen extends StatefulWidget {
  const PlanOfCareScreen({super.key});

  @override
  State<PlanOfCareScreen> createState() => _PlanOfCareScreenState();
}

class _PlanOfCareScreenState extends State<PlanOfCareScreen> {
  List<Map<String, dynamic>> planOfCareData = []; // Stores list of plan of care records
  Map<String, int> activitiesPerDate = {}; // Holds the number of activities per date for the chart
  bool showForm = false; // Controls visibility of the form

  final _formKey = GlobalKey<FormState>(); // Key to manage form validation
  final activityNameController = TextEditingController();
  final instructionsController = TextEditingController();
  final dateController = TextEditingController();
  DateTime? selectedDate; // Stores the date selected by the user

  @override
  void initState() {
    super.initState();
    loadPlanData(); // Load data from JSON when the screen loads
  }

  // Loads JSON data from assets and parses it into a list of maps
  Future<void> loadPlanData() async {
    final String jsonString = await rootBundle.loadString('assets/plan_of_care.json'); // Reads the file as a string
    final List<dynamic> jsonList = json.decode(jsonString); // Decodes JSON string into a List<dynamic>
    final List<Map<String, dynamic>> plans = List<Map<String, dynamic>>.from(jsonList); // Convert dynamic list to list of maps and update the UI
    // Count how many activities occur per date
    final Map<String, int> countMap = {};
    for (final plan in plans) {
      final date = plan['Planned Date'] ?? '';
      countMap[date] = (countMap[date] ?? 0) + 1;
    }
    // Update the UI with parsed data
    setState(() {
      planOfCareData = plans;
      activitiesPerDate = countMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Prepare chart data from activities grouped by date
    final chartData = activitiesPerDate.entries.map((e) => _ChartData(e.key, e.value)).toList();

    return Scaffold(
      appBar: PageLayout(title: 'Plan of Care', isTitleBold: false, centerTitle: false, automaticallyImplyLeading: true,), // Using a custom PageLayout widget for the AppBar with the title 'Plan of Care'
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adds spacing around the list
        child: ListView(
          // Mapping plan of care data into a list of Cards
          children: [
            ...planOfCareData.map((plan) {
              return Card(
                color: Colors.green.shade50,
                child: ListTile(
                  title: Text(
                    plan["Planned Activity Name"] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: plan.entries.map((entry) {
                      if (entry.key == "Planned Activity Name") return const SizedBox.shrink(); // Skip displaying the name again in the subtitle
                      final isPlannedDate = entry.key == "Planned Date"; // Used to color the date differently
                      final valueColor = isPlannedDate ? Colors.green : Colors.black;
                      return Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: RichText(
                          text: TextSpan(
                            text: "${entry.key}: ",
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: "${entry.value}",
                                style: TextStyle(color: valueColor), // Highlight date in orange
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
            const SizedBox(height: 30),
            // Chart displaying number of activities per date
            SizedBox(
              height: 400, // Set the height of the chart area to 400 pixels
              child: SfCartesianChart(
                title: ChartTitle(text: 'Planned Activities by Date'),  // Title displayed at the top of the chart
                // Configuration of the X axis (horizontal), with rotation and force showing all labels
                primaryXAxis: CategoryAxis(labelRotation: -90,labelIntersectAction: AxisLabelIntersectAction.rotate90, maximumLabels: 100,),
                // Configuration of the Y axis (vertical) with label
                primaryYAxis: NumericAxis(title: AxisTitle(text: 'Number Of Activities')),
                // The actual data series for the bar chart
                series: <CartesianSeries<_ChartData, String>>[
                  BarSeries<_ChartData, String>(
                    dataSource: chartData, // Source of data for the bars
                    xValueMapper: (data, _) => data.date, // X-axis value (planned date)
                    yValueMapper: (data, _) => data.count, // Y-axis value (how many planned activities)
                    spacing: 0.4, // Space between bars
                    // When a bar is tapped, show a bottom sheet with activities for that date
                    onPointTap: (ChartPointDetails details) {
                      final tappedDateStr = details.dataPoints![details.pointIndex!].x; // Get the x-axis value (date string) from the tapped data point
                      // Filter the full list of plans to only include those matching the tapped date
                      final relatedPlans = planOfCareData
                          .where((plan) => plan['Planned Date'] == tappedDateStr)
                          .toList();
                      // Show a modal bottom sheet displaying the related activities for the selected date
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Top of the bottom sheet has a rounded border
                        ),
                        // The builder returns the widget to be shown in the bottom sheet
                        builder: (context) => Padding(
                          padding: const EdgeInsets.all(16.0), // Adds spacing inside the sheet
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // Ensures the sheet is only as tall as its content
                            crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start (left)
                            children: [
                              // Title text showing the selected date
                              Text(
                                'Activities on $tappedDateStr',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              // If there are no matching plans for the selected date, show a fallback message
                              if (relatedPlans.isEmpty)
                                const Text('No activities found.'),
                              // Otherwise, list each related activity by name
                              ...relatedPlans.map((plan) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0), // Spacing between activities
                                child: Text('- ${plan['Planned Activity Name']}'), // Show activity name with a dash
                              )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            /// Form for adding a new plan of care entry
            if (showForm) // If "showForm" is true, show the form
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 100),
                child: Card(
                  color:  Colors.green.shade50,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Text(
                            "Add Planned Activity",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 20),
                          // Planned Activity Name input
                          buildTextField(controller: activityNameController, label: "Planned Activity Name", fillColor: const Color(0xFFDFFFDB),),
                          const SizedBox(height: 14),
                          // Instructions input
                          buildTextField(controller: instructionsController, label: "Instructions", fillColor: const Color(0xFFDFFFDB),),
                          const SizedBox(height: 14),
                          // Custom date picker field
                          buildDateField(
                            context: context,
                            controller: dateController,
                            label: "Planned Date",
                            selectedDate: selectedDate,
                            onDatePicked: (picked) {
                              setState(() {
                                selectedDate = picked; // Update selected date
                              });
                            },
                            fillColor: const Color(0xFFDFFFDB),
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
                                  final newEntry = {
                                    "Planned Activity Name": activityNameController.text, // Get text from planned activity name input
                                    "Planned Date": "${_monthName(selectedDate!.month)} ${selectedDate!.day}, ${selectedDate!.year}", // Format date
                                    "Instructions": instructionsController.text, // Get text from instructions input
                                  };

                                  setState(() {
                                    planOfCareData.add(newEntry); // Add the new plan of care record to the list
                                    showForm = false; // Hide the form after submission
                                    final date = newEntry["Planned Date"] ?? "Unknown";
                                    activitiesPerDate[date] = (activitiesPerDate[date] ?? 0) + 1;
                                    // Clear form inputs
                                    activityNameController.clear();
                                    instructionsController.clear();
                                    dateController.clear();
                                    selectedDate = null;
                                    showForm = false;
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

  // Returns the name of a month from its integer representation (1–12)
  String _monthName(int month) {
    return [
      '',
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ][month];
  }
}

// Helper class to hold chart data (date and count)
class _ChartData {
  final String date;
  final int count;
  _ChartData(this.date, this.count);
}
