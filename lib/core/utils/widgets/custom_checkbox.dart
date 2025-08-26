import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';

class CustomCheckbox extends StatefulWidget {
  final bool isChecked;
  final Function(bool) onChanged;
  final Color? borderColor; // Make borderColor nullable

  const CustomCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
    this.borderColor,
  });

  @override
  CustomCheckboxState createState() => CustomCheckboxState();
}

class CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      onTap: () {
        widget.onChanged(!widget.isChecked);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 1,
            color: widget.borderColor ??
                ColorsData.primary, // Access borderColor using widget
          ),
        ),
        width: 24.w,
        height: 24.h,
        child: widget.isChecked
            ? Center(
                child: Text(
                  '✓',
                  style: Styles.textStyleS14W700(
                    color: ColorsData.primary,
                  ),
                ),
              )
            : Container(),
      ),
    );
  }
}
