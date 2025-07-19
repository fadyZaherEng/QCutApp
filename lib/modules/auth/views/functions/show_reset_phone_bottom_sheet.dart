import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q_cut/modules/auth/logic/controller/reset_phone_controller.dart';
import 'package:q_cut/modules/auth/views/widgets/reset_phone_bottom_sheet.dart';

void showResetPhoneBottomSheet(BuildContext context) {
  // Use GetX's dependency injection to manage the controller's lifecycle
  final controller = Get.put(ResetPhoneController());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ResetPhoneBottomSheet(controller: controller),
  ).whenComplete(() {
    // When the bottom sheet is dismissed, remove the controller from memory
    // but don't do this immediately to avoid issues with animations
    Future.delayed(const Duration(milliseconds: 300), () {
      if (Get.isRegistered<ResetPhoneController>()) {
        Get.delete<ResetPhoneController>();
      }
    });
  });
}

void showBResetPhoneBottomSheet(BuildContext context) {
  final controller = Get.put(ResetPhoneController());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) => BResetPhoneBottomSheet(
      controller: controller,
    ),
  );
}
