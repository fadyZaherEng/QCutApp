import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:q_cut/modules/customer/features/settings/presentation/views/widgets/change_your_name_bottom_sheet.dart';

void showChangeYourNameBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) => const ChangeYourNameBottomSheet(),
  );
}
