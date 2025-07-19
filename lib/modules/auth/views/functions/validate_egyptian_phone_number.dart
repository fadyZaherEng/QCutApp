
String? validateEgyptianPhoneNumber(String phoneNumber) {
  final RegExp regExp = _phoneNumberRegExp();
  
  if (regExp.hasMatch(phoneNumber)) {
    return null;
  } else if (phoneNumber.isEmpty) {
    return "Please enter your phone number";
  } else {
    return "Phone number is invalid";
  }
}

RegExp _phoneNumberRegExp() {
  return RegExp(r"^(?:\+20|0)(10|11|12|15)[0-9]{8}$");
}
