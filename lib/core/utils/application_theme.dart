import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
    fontFamily: "Alexandria",
    scaffoldBackgroundColor: ColorsData.secondary,
    primaryColor: ColorsData.primary,
    cardColor: ColorsData.cardColor,
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontSize: 18.sp,
        color: ColorsData.bodyFont,
      ),
      bodyMedium: TextStyle(
        fontSize: 16.sp,
        color: ColorsData.font,
      ),
      bodySmall: TextStyle(
        fontSize: 14.sp,
        color: ColorsData.bodyFont,
      ),
    ),
    appBarTheme: AppBarTheme(
      toolbarHeight: 67.h,
      centerTitle: true,
      backgroundColor: ColorsData.secondary,
      elevation: 0,
      iconTheme: const IconThemeData(color: ColorsData.font),
      titleTextStyle: Styles.textStyleS16W600(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsData.primary,
        foregroundColor: ColorsData.font,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
        textStyle: Styles.textStyleS16W700(),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorsData.cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: ColorsData.cardStrock),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: ColorsData.cardStrock),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: ColorsData.cardStrock, width: 2),
      ),
      hintStyle: TextStyle(
          color: ColorsData.thirty,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400),
    ),
  );
}
