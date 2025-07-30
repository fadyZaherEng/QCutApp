import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';

class ViewCustomButton extends StatefulWidget {
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
  State<ViewCustomButton> createState() => _ViewCustomButtonState();
}

class _ViewCustomButtonState extends State<ViewCustomButton> {
  bool isPressed = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 35.h,
      width: widget.width ?? 185.w,
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? ColorsData.primary,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(10.r),
        boxShadow: widget.boxShadow,
      ),
      child: InkWell(
        onTap: () async {
          if (isPressed) {
            isPressed = false;
            setState(() {});
            widget.onPressed!();
            await Future.delayed(const Duration(seconds: 2), () {
              isPressed = true;
              setState(() {});
            });
          }
        },
        borderRadius: widget.borderRadius ?? BorderRadius.circular(8.r),
        child: Center(
          child: Text(
            widget.text,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: widget.textStyle ??
                Styles.textStyleS14W400(
                    color: widget.textColor ?? ColorsData.font),
          ),
        ),
      ),
    );
  }
}
