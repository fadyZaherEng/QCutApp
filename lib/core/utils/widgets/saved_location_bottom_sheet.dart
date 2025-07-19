import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';

class SavedLocationBottomSheet extends StatelessWidget {
  const SavedLocationBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Icon(Icons.close, size: 24.sp),
              ),
            ),
            SizedBox(height: 12.h),

SvgPicture.asset(height: 24.h,width: 24.w,
  AssetsData.mapPinIcon,
  colorFilter: const ColorFilter.mode(
    ColorsData.primary, 
    BlendMode.srcIn, 
  ),
),            SizedBox(height: 12.h),

            Text(
              "Saved location",
              style: Styles.textStyleS14W700(color: ColorsData.secondary),
            ),
            SizedBox(height: 16.h),

            _buildLocationItem(
              title: "New Gaza",
              subtitle: "New Gaza, New Gaza",
              isSelected: true,
            ),
            SizedBox(height: 12.h),

            _buildLocationItem(
              title: "Add Another location",
              isSelected: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationItem({
    required String title,
    String? subtitle,
    required bool isSelected,
  }) {
    return Row(
      children: [

SvgPicture.asset(height: 24.h,width: 24.w,
  AssetsData.mapPinIcon,
  colorFilter: const ColorFilter.mode(
    ColorsData.primary, 
    BlendMode.srcIn, 
  ),
),           SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Styles.textStyleS14W700(color: ColorsData.secondary)),
            if (subtitle != null)
              Text(
                subtitle,
                style: Styles.textStyleS12W400(color: ColorsData.thirty),
              ),
          ],
        ),
        const Spacer(),
        if (isSelected)
          Icon(Icons.check_circle, color: ColorsData.primary, size: 20.sp),
      ],
    );
  }
}
