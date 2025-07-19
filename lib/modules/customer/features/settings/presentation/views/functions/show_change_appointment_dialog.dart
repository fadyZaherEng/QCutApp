import 'package:flutter/material.dart';
import 'package:q_cut/modules/customer/features/settings/presentation/views/widgets/change_appointment_dialog.dart';

Future<bool?> showChangeAppointmentDialog({required BuildContext context}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => const ChangeAppointmentDialog(),
  );
}
