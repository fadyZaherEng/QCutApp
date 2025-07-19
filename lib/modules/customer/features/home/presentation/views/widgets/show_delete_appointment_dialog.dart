import 'package:flutter/material.dart';
import 'package:q_cut/modules/customer/features/home/presentation/views/widgets/delete_appointment_dialog.dart';

void showDeleteAppointmentDialog({required BuildContext context,required VoidCallback onYes,required VoidCallback onNo}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => DeleteAppointmentDialog(onYes: onYes, onNo: onNo),
  );
}
