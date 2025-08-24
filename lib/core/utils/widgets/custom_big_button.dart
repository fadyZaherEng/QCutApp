import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';

class CustomBigButton extends StatefulWidget {
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
  State<CustomBigButton> createState() => _CustomBigButtonState();
}

class _CustomBigButtonState extends State<CustomBigButton> {
  bool isClicked = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 48.h,
      width: widget.width ?? 343.w,
      child: ElevatedButton(
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          if (isClicked) {
            isClicked = false;
            setState(() {});
            widget.onPressed?.call();
            Future.delayed(const Duration(seconds: 2), () {
              isClicked = true;
              if (mounted) {
                FocusManager.instance.primaryFocus?.unfocus();
                setState(() {});
              }
            });
          }
        },
        style: widget.color != null
            ? ElevatedButton.styleFrom(
                backgroundColor: widget.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              )
            : widget.isCustomStyle
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
          widget.textData,
          maxLines: 1,
          style: widget.isCustomStyle
              ? Styles.textStyleS10W500(
                  color: ColorsData.primary,
                ).copyWith(
                  fontSize: widget.font ?? 16.sp,
                )
              : Styles.textStyleS16W700().copyWith(
                  color: ColorsData.bodyFont,
                  fontSize: widget.font ?? 16.sp,
                ),
        ),
      ),
    );
  }
}
