import 'dart:convert'; // Import for decoding JSON responses.
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the HTTP package for making network requests.


class RandomQuote extends StatefulWidget {
  const RandomQuote({Key? key}) : super(key: key);

  @override
  _RandomQuoteState createState() => _RandomQuoteState();
}

class _RandomQuoteState extends State<RandomQuote> {
  String _quote = "Loading..."; // Initial state of the quote displayed while fetching.

  // Method to fetch a random quote from the external API.
  Future<void> _fetchQuote() async {
    final response = await http.get(Uri.parse('https://api.adviceslip.com/advice')); // Perform HTTP GET request.

    if (response.statusCode == 200) {
      // If the response is successful (HTTP 200 OK)
      final data = jsonDecode(response.body); // Decode the JSON response body.
      setState(() {
        _quote = data['slip']['advice']; // Update the _quote state with the fetched advice text.
      });
    } else {
      // If the API call fails or returns an error.
      setState(() {
        _quote = "Failed to load advice."; // Update the _quote state with an error message.
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchQuote(); // Fetch the quote when the widget is first created (on initialization).
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0), // Add outer padding around the entire container.
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0), // Inner padding inside the container.
        decoration: BoxDecoration(
          // Create a colorful gradient background for the container.
          gradient: LinearGradient(
            colors: [Colors.blue.shade300, Colors.deepPurple.shade500], // Colors for the gradient.
            begin: Alignment.topLeft, // Gradient starts at the top left.
            end: Alignment.bottomRight, // Gradient ends at the bottom right.
          ),
          borderRadius: BorderRadius.circular(30.0), // Make the container edges rounded.
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Align all column elements to the center horizontally.
          children: [
            // Section for the title "Quote of the Day".
            Align(
              alignment: Alignment.center, // Center-align the title.
              child: const Text(
                'Quote of the Day', // Static title text.
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xD3FFFFFF),
                ),
              ),
            ),
            const SizedBox(height: 10), // Add spacing between the title and the quote.

            // Section for displaying the quote text or error message.
            Align(
              alignment: Alignment.center, // Center-align the quote text.
              child: Text(
                '"$_quote"', // Display the quote surrounded by quotation marks.
                style: const TextStyle(
                  fontSize: 22,
                  fontStyle: FontStyle.italic,
                  color: Color(0xB6FFFFFF),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center, // Center-align the text inside the Text widget.
              ),
            ),
          ],
        ),
      ),
    );
  }
}
