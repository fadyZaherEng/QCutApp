import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:q_cut/modules/customer/features/home_features/profile_feature/logic/profile_controller.dart';
import 'package:q_cut/modules/customer/features/home_features/profile_feature/views/widgets/change_user_info_bottom_sheet.dart';

void showChangeUserInfoBottomSheet(
    BuildContext context, ProfileController? profileController) {
  if (profileController == null) return;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) =>
        ChangeUserInfoBottomSheet(profileController: profileController),
  );
}

void showChangeUserLocationBottomSheet(
    BuildContext context, ProfileController? profileController) {
  if (profileController == null) return;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) =>
        ChangeUserLocationBottomSheet(profileController: profileController),
  );
}
