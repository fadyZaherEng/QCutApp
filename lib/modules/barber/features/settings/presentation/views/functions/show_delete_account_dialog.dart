import 'package:flutter/material.dart';
import 'package:q_cut/modules/customer/features/settings/presentation/views/widgets/delete_account_dialog.dart';

Future<bool?> showDeleteAccountDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (context) => const DeleteAccountDialog(),
  );
}
