
// Function to check if an email is valid.
bool isValidEmail(String email) {
  return email.contains('@') && email.contains('.');  // Checks if email contains both "@" and "." characters.
}
// Validates the email field.
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';  // Returns error message if the email is empty.
  }
  if (!isValidEmail(value)) {
    return 'Please enter a valid email';  // Returns error message if the email is not valid.
  }
  return null;  // Returns null if the email is valid.
}

// Validates the name field.
String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your name';  // Returns error message if the name is empty.
  }
  return null;  // Returns null if the name is valid.
}

// Validates the surname field.
String? validateSurname(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your surname';  // Returns error message if the surname is empty.
  }
  return null;  // Returns null if the surname is valid.
}

// Validates the weight field.
String? validateWeight(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your weight';  // Returns error message if the weight is empty.
  }
  final weight = double.tryParse(value);  // Tries to parse the weight as a double.
  if (weight == null) return 'Please enter a valid number';  // Returns error if weight is not a valid number.
  return null;  // Returns null if the weight is valid.
}

// Validates the username field.
String? validateUsername(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a username';  // Returns error message if the username is empty.
  }
  return null;  // Returns null if the username is valid.
}

// Validates the password field.
String? validatePassword(String? value) {
  if (value == null || value.length < 8) {
    return 'Password must be at least 8 characters long';  // Returns error message if password length is less than 8 characters.
  }
  return null;  // Returns null if the password is valid.
}

// Validates the gender field.
String? validateGender(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please select your gender';  // Returns error message if the gender is not selected.
  }
  return null;  // Returns null if the gender is valid.
}

// Validates the birthdate field.
String? validateBirthDate(DateTime? value) {
  if (value == null) {
    return 'Please select your birthdate';  // Returns error message if the birthdate is not selected.
  }
  if (value.isAfter(DateTime.now())) {
    return 'Birthdate cannot be in the future';  // Additional check to ensure the birthdate is not in the future.
  }
  return null;  // Returns null if the birthdate is valid.
}

// Validates the login (username and password) fields.
String? validateLogin(String username, String password) {
  if (username.isEmpty || password.isEmpty) {
    return 'Username and password cannot be empty';  // Returns error if username or password is empty.
  }
  // You could add more login rules here if needed.
  return null;  // Returns null if login is valid.
}

// Returns the message for an invalid login.
String get invalidLoginMessage => 'Invalid username or password';  // Message displayed when the username or password is incorrect.
