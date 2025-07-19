import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';

class WorkingDaysBottomSheet extends StatelessWidget {
  const WorkingDaysBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> workingDays = [
      {"day": "saturday".tr, "time": "7:00 am to 9:00 pm"},
      {"day": "sunday".tr, "time": "7:00 am to 9:00 pm"},
      {"day": "monday".tr, "time": "7:00 am to 9:00 pm"},
      {"day": "tuesday".tr, "time": "7:00 am to 9:00 pm"},
      {"day": "wednesday".tr, "time": "7:00 am to 9:00 pm"},
      {"day": "thursday".tr, "time": "7:00 am to 9:00 pm"},
      {"day": "friday".tr, "time": "notWorking".tr},
    ];

    return Container(
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
            onTap: () => context.pop(),
            child: Icon(Icons.close, size: 24.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            "workingDays".tr,
            style: Styles.textStyleS14W700(color: ColorsData.primary),
          ),
          SizedBox(height: 16.h),
          ...workingDays.map((dayInfo) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dayInfo["day"]!,
                    style: Styles.textStyleS14W700(color: ColorsData.secondary),
                  ),
                  Text(
                    dayInfo["time"]!,
                    style: Styles.textStyleS14W400(color: ColorsData.thirty),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class BWorkingDaysBottomSheet extends StatelessWidget {
  const BWorkingDaysBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> workingDays = [
      {"day": "saturday".tr, "time": "7:00 am to 9:00 pm"},
      {"day": "sunday".tr, "time": "7:00 am to 9:00 pm"},
      {"day": "monday".tr, "time": "7:00 am to 9:00 pm"},
      {"day": "tuesday".tr, "time": "7:00 am to 9:00 pm"},
      {"day": "wednesday".tr, "time": "7:00 am to 9:00 pm"},
      {"day": "thursday".tr, "time": "7:00 am to 9:00 pm"},
      {"day": "friday".tr, "time": "notWorking".tr},
    ];

    return Container(
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
            onTap: () => context.pop(),
            child: Icon(Icons.close, size: 24.sp),
          ),
          SizedBox(height: 16.h),
          Text(
            "workingDays".tr,
            style: Styles.textStyleS14W700(color: ColorsData.primary),
          ),
          SizedBox(height: 16.h),
          ...workingDays.map((dayInfo) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dayInfo["day"]!,
                    style: Styles.textStyleS14W700(color: ColorsData.secondary),
                  ),
                  Text(
                    dayInfo["time"]!,
                    style: Styles.textStyleS14W400(color: ColorsData.thirty),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
