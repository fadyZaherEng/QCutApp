import 'package:flutter/material.dart';
import 'package:q_cut/modules/auth/views/widgets/reset_password_bottom_sheet.dart';

void showResetPasswordBottomSheet(BuildContext context) {
  // showModalBottomSheet ensures controllers are properly managed
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const ResetPasswordBottomSheet(),
  ).whenComplete(() {
    // Handle cleanup after bottom sheet is closed if needed
    // But since the ResetPasswordBottomSheet is stateful and manages its own controllers,
    // we don't need to do anything here
  });
}
