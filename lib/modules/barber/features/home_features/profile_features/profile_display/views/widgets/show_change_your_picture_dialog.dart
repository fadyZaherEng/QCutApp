import 'package:flutter/material.dart';
import 'package:q_cut/modules/customer/features/home_features/profile_feature/views/widgets/change_your_picture_dialog.dart';

Future<String?> showChangeYourPictureDialog(BuildContext context) async {
  return showDialog<String>(
    context: context,
    builder: (context) => ChangeYourPictureDialog(),
  );
}
