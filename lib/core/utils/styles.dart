import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';

abstract class Styles {
  static const String defaultFontFamily = "Alexandria";
  static const Color defaultColor = ColorsData.font;

  // Font size 8
  static TextStyle textStyleS8W400(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 8.sp,
        fontWeight: FontWeight.w400,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS8W500(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 6.sp,
        fontWeight: FontWeight.w400,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS8W600(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 6.sp,
        fontWeight: FontWeight.w600,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS8W700(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 6.sp,
        fontWeight: FontWeight.w700,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  // Font size 10
  static TextStyle textStyleS10W400(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 8.sp,
        fontWeight: FontWeight.w400,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS10W500(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 8.sp,
        fontWeight: FontWeight.w500,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS10W600(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 8.sp,
        fontWeight: FontWeight.w600,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS10W700(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 8.sp,
        fontWeight: FontWeight.w700,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  // Font size 12
  static TextStyle textStyleS12W400(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS12W500(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS12W600(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS12W700(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  // Font size 13
  static TextStyle textStyleS13W400(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w400,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS13W500(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS13W600(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS13W700(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  // Font size 14
  static TextStyle textStyleS14W400(
          {Color? color, double? letterSpacing, String? fontFamily,fontSize,fontWeight}) =>
      TextStyle(
        fontSize:fontSize?? 13.sp,
        fontWeight:fontWeight?? FontWeight.w500,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS14W500(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS14W600(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS14W700(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  // Font size 15
  static TextStyle textStyleS15W400(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS15W500(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS15W600(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS15W700(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  // Font size 16
  static TextStyle textStyleS16W400(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS16W500(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS16W600(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS16W700(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  // Font size 18
  static TextStyle textStyleS18W400(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS18W500(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w500,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS18W600(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w600,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS18W700(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  // Font size 20
  static TextStyle textStyleS20W400(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w400,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS20W500(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w500,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS20W600(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w600,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS20W700(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w700,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  // Font size 21
  static TextStyle textStyleS21W400(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w400,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS21W500(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS21W600(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS21W700(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  // Font size 22
  static TextStyle textStyleS22W400(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 19.sp,
        fontWeight: FontWeight.w400,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS22W500(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 19.sp,
        fontWeight: FontWeight.w500,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS22W600(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 19.sp,
        fontWeight: FontWeight.w600,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS22W700(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 19.sp,
        fontWeight: FontWeight.w700,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  // Font size 24
  static TextStyle textStyleS24W400(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w400,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS24W500(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS24W600(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS24W700(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  // Font size 26
  static TextStyle textStyleS26W400(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w400,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS26W500(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w500,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS26W600(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS26W700(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  // Font size 28
  static TextStyle textStyleS28W400(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 26.sp,
        fontWeight: FontWeight.w400,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS28W500(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 26.sp,
        fontWeight: FontWeight.w500,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS28W600(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 26.sp,
        fontWeight: FontWeight.w600,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );

  static TextStyle textStyleS28W700(
          {Color? color, double? letterSpacing, String? fontFamily}) =>
      TextStyle(
        fontSize: 26.sp,
        fontWeight: FontWeight.w700,
        color: color ?? defaultColor,
        letterSpacing: letterSpacing,
        fontFamily: fontFamily ?? defaultFontFamily,
      );
}
