import 'package:flutter/material.dart';
import 'package:q_cut/modules/customer/features/settings/presentation/views/widgets/log_out_dialog.dart';

Future<bool?> showLogoutDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (context) => const LogoutDialog(),
  );
}
