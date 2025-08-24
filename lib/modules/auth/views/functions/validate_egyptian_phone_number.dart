import 'package:get/get_utils/get_utils.dart';

String? validateEgyptianPhoneNumber(String phoneNumber) {
  final RegExp regExp = _phoneNumberRegExp();

  // if (regExp.hasMatch(phoneNumber)) {
  //   return null;
  // } else
  if (phoneNumber.isEmpty||phoneNumber.length>9) {
    return "inValidPhoneNumber".tr;
  } else {
    return null;
  }
}

RegExp _phoneNumberRegExp() {
  return RegExp(r"^(?:\+20|0)(10|11|12|15)[0-9]{8}$");
}
