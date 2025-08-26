import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:q_cut/modules/customer/features/home_features/profile_feature/views/widgets/change_user_info_bottom_sheet.dart';

void showChangeUserInfoBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) => ChangeUserInfoBottomSheet(),
  );
}
