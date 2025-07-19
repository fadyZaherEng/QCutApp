import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';

class CustomPinInput extends StatelessWidget {
  CustomPinInput(
      {super.key,
      required this.onSubmitted,
      this.controller,
      required String? Function(dynamic value) validator});
  final void Function(String)? onSubmitted;
  TextEditingController? controller;
  String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Pinput(
      controller: controller,
      onSubmitted: onSubmitted,
      validator: validator,
      length: 6,
      defaultPinTheme: PinTheme(
        margin: EdgeInsets.only(right: 8.w),
        width: 48.w,
        height: 48.h,
        textStyle: Styles.textStyleS24W600(),
        decoration: BoxDecoration(
          color: ColorsData.secondary,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(color: ColorsData.cardStrock, width: 1),
        ),
      ),
      showCursor: true,
      onCompleted: (pin) => print(pin),
    );
  }
}
