import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:intl/intl.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';

class CustomDaysPicker extends StatelessWidget {
  final int selectedDay;
  final ValueChanged<int> onDaySelected;
  final String? titleSimpleDaysPicker;

  const CustomDaysPicker({
    super.key,
    required this.selectedDay,
    required this.onDaySelected,
    this.titleSimpleDaysPicker,
  });

  List<Map<String, dynamic>> _generateDynamicDays(BuildContext context) {
    final now = DateTime.now();
    final List<Map<String, dynamic>> days = [];

    for (int i = 0; i < 7; i++) {
      // ✅ Show 7 days instead of 5
      final day = now.add(Duration(days: i));
      days.add({
        "day": DateFormat('E', Get.locale?.languageCode)
            .format(day), // Localized day name
        "date": day.day,
        "fullDate": day,
      });
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    final days = _generateDynamicDays(context);

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
                  fontSize: Get.locale?.languageCode == 'ar' ? 13.sp : 14.sp,
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                  letterSpacing: 0,
                ),
              ),
              SizedBox(width: 8.w),
            ],
          ],
        ),
        SizedBox(height: 16.h),

        // ✅ Wrap Row with horizontal scroll
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: days.map((day) {
              bool isSelected = selectedDay == day["date"];
              return Padding(
                padding: EdgeInsets.only(right: 12.w), // spacing between items
                child: GestureDetector(
                  onTap: () => onDaySelected(day["date"]),
                  child: Container(
                    width: 70.w,
                    height: 100.h,
                    padding:
                        EdgeInsets.symmetric(horizontal: 0.w, vertical: 11.h),
                    decoration: BoxDecoration(
                      color:
                          isSelected ? const Color(0xFFC49A5B) : Colors.white,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day["day"],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize:
                                Get.locale?.languageCode == 'ar' ? 9.sp : 12.sp,
                            fontFamily: 'Alexandria',
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
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
