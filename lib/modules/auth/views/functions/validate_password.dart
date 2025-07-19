// String? validatePassword(String? password) {
//   if (password == null || password.isEmpty) {
//     return 'Password cannot be empty';
//   }

//   // Password validation rules
//   RegExp lowerCase = RegExp(r'[a-z]');
//   RegExp upperCase = RegExp(r'[A-Z]');
//   RegExp digits = RegExp(r'[0-9]');
//   RegExp specialChars = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

//   if (password.length < 8) {
//     return 'Password should be at least 8 characters';
//   }
//   if (!lowerCase.hasMatch(password)) {
//     return 'must contain at least one lowercase letter';
//   }
//   if (!upperCase.hasMatch(password)) {
//     return 'must contain at least one uppercase letter';
//   }
//   if (!digits.hasMatch(password)) {
//     return 'must contain at least one digit';
//   }
//   if (!specialChars.hasMatch(password)) {
//     return 'must contain at least one special character';
//   }

//   return null; // Return null when the password is strong
// }
