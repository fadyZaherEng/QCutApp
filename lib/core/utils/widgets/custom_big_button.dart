import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';

class CustomBigButton extends StatelessWidget {
  const CustomBigButton({
    super.key,
    required this.textData,
    required this.onPressed,
    this.height,
    this.font,
    this.width,
    this.isCustomStyle = false,
    this.color,
  });

  final void Function()? onPressed;
  final String textData;
  final double? height;
  final double? font;
  final double? width;
  final bool isCustomStyle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 48.h,
      width: width ?? 343.w,
      child: ElevatedButton(
        onPressed: onPressed,
        style: color != null
            ? ElevatedButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              )
            : isCustomStyle
                ? ElevatedButton.styleFrom(
                    backgroundColor: ColorsData.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side:
                          const BorderSide(color: ColorsData.primary, width: 2),
                    ),
                    elevation: 0,
                  )
                : ElevatedButton.styleFrom(),
        child: Text(
          textData,
          maxLines: 1,
          style: isCustomStyle
              ? Styles.textStyleS10W500(
                  color: ColorsData.primary,
                ).copyWith(
                  fontSize: font ?? 15.sp,
                )
              : Styles.textStyleS16W700().copyWith(
                  color: ColorsData.bodyFont,
                  fontSize: font ?? 15.sp,
                ),
        ),
      ),
    );
  }
}
