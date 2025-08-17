import 'package:flutter/material.dart';
import 'dart:convert'; // Import for decoding JSON responses.
import 'package:flutter/services.dart';
import '../widgets/PageLayout.dart';

class DemographicsScreen extends StatefulWidget {
  const DemographicsScreen({super.key});

  @override
  State<DemographicsScreen> createState() => _DemographicsScreenState();
}

class _DemographicsScreenState extends State<DemographicsScreen> {
  List<Map<String, dynamic>> demographicsList = []; // Stores list of user's demographics

  @override
  void initState() {
    super.initState();
    loadDemographicsFromJson(); // Load data from JSON when the screen loads
  }

  // Loads JSON data from assets and parses it into a list of maps
  Future<void> loadDemographicsFromJson() async {
    final String jsonString =
    await rootBundle.loadString('assets/demographics.json'); // Reads the file as a string
    final List<dynamic> jsonData = json.decode(jsonString); // Decodes the string into a List<dynamic>
    setState(() {
      demographicsList = jsonData.cast<Map<String, dynamic>>(); // Convert dynamic list to list of maps and update the UI
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PageLayout(title: 'Demographics', isTitleBold: false, centerTitle: false, automaticallyImplyLeading: true,), // Using a custom PageLayout widget for the AppBar with the title 'Demographics'
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adds padding around the ListView
        // If data hasn't loaded yet, show a loading spinner
        child: demographicsList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            // Otherwise, display the data in a scrollable list
            : ListView.builder(
          itemCount: demographicsList.length, // Number of items to display
          itemBuilder: (context, index) {
            final item = demographicsList[index]; // Current demographic record
            return ListTile(
              title: Text(
                item['label'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item['value'].toString()), // Value safely converted to string
            );
          },
        ),
      ),
    );
  }
}
