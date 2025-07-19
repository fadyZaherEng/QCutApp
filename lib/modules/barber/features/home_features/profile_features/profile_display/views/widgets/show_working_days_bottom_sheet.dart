import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_display/models/barber_profile_model.dart';
import 'package:q_cut/modules/customer/features/home/presentation/views/widgets/working_days_bottom_sheet.dart';

void showWorkingDaysBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) => const WorkingDaysBottomSheet(),
  );
}

void showBWorkingDaysBottomSheet(
    BuildContext context, List<WorkingDay> workingDays) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) => Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: Icon(Icons.close, size: 24.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            "working days".tr,
            style: Styles.textStyleS14W700(color: ColorsData.primary),
          ),
          SizedBox(height: 16.h),
          ...workingDays.map((day) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    day.day,
                    style: Styles.textStyleS14W700(color: ColorsData.secondary),
                  ),
                  Text(
                    "${day.startHour} ${day.startHour > 12 ? "PM" : "AM"} - ${day.endHour - 12} ${day.endHour > 12 ? "PM" : "AM"}",
                    style: Styles.textStyleS14W400(color: ColorsData.thirty),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    ),
  );
}
