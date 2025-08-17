import 'package:flutter/material.dart';
import '../widgets/RegistrationFields.dart';
import '../validators/validators.dart';
import 'LoginScreen.dart';
import '../widgets/PageLayout.dart';

// A stateful widget for the user registration screen.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Map to hold all TextEditingControllers for each input field.
  final Map<String, TextEditingController> controllers = {
    'name': TextEditingController(),
    'surname': TextEditingController(),
    'email': TextEditingController(),
    'weight': TextEditingController(),
    'username': TextEditingController(),
    'password': TextEditingController(),
  };

  DateTime? _birthdate; // Stores the selected birthdate (nullable).
  String? _gender; // Stores the selected gender (nullable).
  final Map<String, String?> errors = {}; // Holds validation errors for each field (nullable).

  // Function to validate all form fields when the "Register" button is pressed.
  void validateForm() {
    setState(() {
      // Validate each field using corresponding validation functions and store errors (null means valid).
      errors['name'] = validateName(controllers['name']!.text);
      errors['surname'] = validateSurname(controllers['surname']!.text);
      errors['email'] = validateEmail(controllers['email']!.text);
      errors['weight'] = validateWeight(controllers['weight']!.text);
      errors['username'] = validateUsername(controllers['username']!.text);
      errors['password'] = validatePassword(controllers['password']!.text);
      errors['birthdate'] = validateBirthDate(_birthdate);
      errors['gender'] = validateGender(_gender);
    });

    // If no field has an error, navigate to the login screen.
    if (!errors.values.any((e) => e != null)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // List of all fields to display on the registration form.
    List<Map<String, dynamic>> fields = [
      {'type': 'text', 'label': 'Name', 'controller': controllers['name'], 'hintText': 'Enter your name', 'errorText': errors['name']},
      {'type': 'text', 'label': 'Surname', 'controller': controllers['surname'], 'hintText': 'Enter your surname', 'errorText': errors['surname']},
      {'type': 'birthdate'}, // Special type for date picker.
      {'type': 'gender'}, // Special type for gender selection.
      {'type': 'text', 'label': 'Weight', 'controller': controllers['weight'], 'hintText': 'Enter your weight (kg)', 'errorText': errors['weight']},
      {'type': 'text', 'label': 'Email', 'controller': controllers['email'], 'hintText': 'Enter your email', 'errorText': errors['email']},
      {'type': 'text', 'label': 'Username', 'controller': controllers['username'], 'hintText': 'Enter your username', 'errorText': errors['username']},
      {'type': 'text', 'label': 'Password', 'controller': controllers['password'], 'hintText': 'Enter your password', 'errorText': errors['password'], 'obscureText': true}, // Hide password input text.
    ];

    return Scaffold(
      appBar: PageLayout(title: 'Sign Up', automaticallyImplyLeading: true), // Using a custom PageLayout widget for the AppBar with the title 'Sign Up'.
      body: Padding(
        padding: const EdgeInsets.all(20.0), // Outer padding around the body.
        child: SingleChildScrollView( // Allows form scrolling when keyboard appears.
          child: Column(
            children: [
              // Loop through the fields list and dynamically generate input fields.
              for (var field in fields) ...[
                if (field['type'] == 'text')
                  buildInputField(
                    label: field['label'],
                    controller: field['controller'],
                    hintText: field['hintText'],
                    errorText: field['errorText'],
                    obscureText: field['obscureText'] ?? false, // Default to false if null.
                  )
                else if (field['type'] == 'gender') ...[
                  // Special UI for gender selection
                  buildGenderField(
                    context: context,
                    selectedGender: _gender,
                    onGenderChanged: (selected) {
                      setState(() {
                        _gender = selected;   // Save the selected gender.
                      });
                    },
                  ),
                  // Display error message if gender not selected
                  if (errors['gender'] != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          errors['gender']!,  //error message
                          style: TextStyle(color: Colors.red, fontSize: 14),
                        ),
                      ),
                    ),
                ]
                else if (field['type'] == 'birthdate') ...[
                    // Special UI for birthdate selection
                    buildBirthdateField(
                      context: context,
                      selectedDate: _birthdate,
                      onTap: () async {
                        // Open a date picker and set the selected date.
                        final pickedDate = await pickBirthDate(context);
                        setState(() {
                          _birthdate = pickedDate; // Save selected date
                        });
                      },
                    ),
                    // Display error message if birthdate not selected
                    if (errors['birthdate'] != null)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            errors['birthdate']!, // error message
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        ),
                      ),
                  ]
              ],
              const SizedBox(height: 20), // Add  20 pixels of spacing before the register button.
              // Register button to submit the form.
              buildRegisterButton(onPressed: validateForm, label: 'Register'), // When pressed, validate the form.
            ],
          ),
        ),
      ),
    );
  }
}
