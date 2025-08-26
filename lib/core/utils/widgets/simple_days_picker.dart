import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';

class SimpleDaysPicker extends StatelessWidget {
  final int selectedDay;
  final ValueChanged<int> onDaySelected;
  final String? titleSimpleDaysPicker;

  SimpleDaysPicker({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
    this.titleSimpleDaysPicker,
  });

  final List<Map<String, dynamic>> days = [
    {"day": "Sat", "date": 12},
    {"day": "Sun", "date": 13},
    {"day": "Mon", "date": 14},
    {"day": "Tue", "date": 15},
    {"day": "Wed", "date": 16},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (titleSimpleDaysPicker != null) ...[
              Text(
                titleSimpleDaysPicker!,
                style: TextStyle(
                  color: ColorsData.font,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8.w),
            ],
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: days.map((day) {
            bool isSelected = selectedDay == day["date"];
            return GestureDetector(
              onTap: () => onDaySelected(day["date"]),
              child: Container(
                width: 60.w,
                height: 120.h,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFC49A5B) : Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day["day"],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "${day["date"]}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
