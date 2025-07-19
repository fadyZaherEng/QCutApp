import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';

class ViewCustomButton extends StatelessWidget {
  const ViewCustomButton({
    super.key,
    this.onPressed,
    this.height,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.textStyle,
    this.text = 'View',
    this.boxShadow,
  });

  final void Function()? onPressed;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final String text;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 25.h,
      width: width ?? 185.w,
      decoration: BoxDecoration(
        color: backgroundColor ?? ColorsData.primary,
        borderRadius: borderRadius ?? BorderRadius.circular(10.r),
        boxShadow: boxShadow,
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius ?? BorderRadius.circular(8.r),
        child: Center(
          child: Text(
            text,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: textStyle ??
                Styles.textStyleS14W400(color: textColor ?? ColorsData.font),
          ),
        ),
      ),
    );
  }
}
