String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field cannot be empty';
  } else if (value.length < 3) {
    return 'Name must be more than 2 characters';
  } else {
    return null;
  }
}
