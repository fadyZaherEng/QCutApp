String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'email cannot be empty';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Please enter a valid email address';
  }
  return null;
}
