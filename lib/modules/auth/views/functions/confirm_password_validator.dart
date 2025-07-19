String? confirmPasswordValidator(String? value, String password) {
  if (value == null || value.isEmpty) {
    return 'Please confirm your password'; 
  } else if (value != password) {
    return 'Passwords do not match'; 
  }
  return null; 
}
