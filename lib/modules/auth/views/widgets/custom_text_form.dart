import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';

// ignore: must_be_immutable
class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  void Function(String)? onFieldSubmitted;
  void Function(String)? onChanged;
  final TextStyle? style;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  void Function(String?)? onSaved;
  final Color? fillColor;
  // Add new parameters
  final bool readOnly;
  final VoidCallback? onTap;

  CustomTextFormField({
    super.key,
    this.hintText,
    this.onSaved,
    this.controller,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onFieldSubmitted,
    this.style,
    this.suffixIconColor,
    this.prefixIconColor,
    this.fillColor,
    this.prefixIcon,
    this.onChanged,
    this.readOnly = false, // Default to false
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: onSaved,
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType ?? TextInputType.emailAddress,
      validator: validator,
      style: style ?? Styles.textStyleS14W500(),
      readOnly: readOnly, // Add readOnly property
      onTap: onTap, // Add onTap callback
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Styles.textStyleS14W400(color: ColorsData.cardStrock),
        fillColor: fillColor ?? ColorsData.secondary,
        filled: true, // Ensure filled is true for proper background color
        contentPadding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 14.h,
          bottom: 14.h,
        ),
        suffixIconColor: ColorsData.primary,
        prefixIconColor: ColorsData.secondary,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: ColorsData.cardStrock),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: ColorsData.cardStrock),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: ColorsData.cardStrock),
        ),
      ),
    );
  }

}
