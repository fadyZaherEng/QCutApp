import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';

class SimpleDaysPicker extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;
  final String? titleSimpleDaysPicker;

  const SimpleDaysPicker({
    super.key,
    required this.selectedDate,
    required this.onDaySelected,
    this.titleSimpleDaysPicker,
  });

  List<DateTime> getNext7Days() {
    final today = DateTime.now();
    return List.generate(7, (index) => today.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final days = getNext7Days();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          SizedBox(height: 16.h),
        ],
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: days.map((day) {
              bool isSelected = selectedDate.year == day.year &&
                  selectedDate.month == day.month &&
                  selectedDate.day == day.day;

              return GestureDetector(
                onTap: () => onDaySelected(day),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  width: 60.w,
                  height: 120.h,
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFC49A5B) : Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('E').format(day), // Sat, Sun, Mon...
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
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "${day.day}",
                          style: TextStyle(
                            color:
                            isSelected ? Colors.black : Colors.grey.shade800,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
