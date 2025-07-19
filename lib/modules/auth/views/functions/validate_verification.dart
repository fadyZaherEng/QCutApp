// String? validateVerification(String? value) {
//   // Check if the value is empty
//   if (value == null || value.isEmpty) {
//     return 'Please enter the verification code';  // Custom error message
//   }

//   // Check if the value is exactly 4 digits long
//   if (value.length != 4) {
//     return 'Verification code must be 4 digits';
//   }

//   // Check if the value contains only numbers
//   if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
//     return 'Verification code must contain only numbers';
//   }

//   return null;  // If validation passes
// }
