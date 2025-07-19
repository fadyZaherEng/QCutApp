import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseBreakDaysBottomSheet extends StatefulWidget {
  const ChooseBreakDaysBottomSheet({super.key});

  @override
  State<ChooseBreakDaysBottomSheet> createState() =>
      _ChooseBreakDaysBottomSheetState();
}

class _ChooseBreakDaysBottomSheetState
    extends State<ChooseBreakDaysBottomSheet> {
  int? _selectedDay;
  bool _isAmFrom = true;
  bool _isAmTo = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              const Spacer(),
            ],
          ),

          // Clock Icon and Title
          Icon(Icons.access_time_rounded, size: 36.h, color: Colors.black87),
          SizedBox(height: 8.h),
          Text(
            "Choose break days",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFC49A58),
            ),
          ),
          SizedBox(height: 24.h),

          // Custom Calendar
          Column(
            children: [
              Text(
                "June 2024",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16.h),
              _buildCalendarHeader(),
              _buildCalendarGrid(),
            ],
          ),
          SizedBox(height: 24.h),

          // Time Selectors
          _buildTimeSelector(
            "Time from",
            "8:00",
            _isAmFrom,
            (isAm) => setState(() => _isAmFrom = isAm),
          ),
          SizedBox(height: 16.h),
          _buildTimeSelector(
            "Time to",
            "8:00",
            _isAmTo,
            (isAm) => setState(() => _isAmTo = isAm),
          ),
          SizedBox(height: 24.h),

          // Confirm Button
          Container(
            width: double.infinity,
            height: 48.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC49A58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: () {},
              child: Text(
                "Confirm",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    final days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days
          .map((day) => SizedBox(
                width: 40,
                child: Text(
                  day,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 30,
      itemBuilder: (context, index) {
        final day = index + 1;
        final isSelected = _selectedDay == day;
        final isHighlighted = day == 10 || day == 26;

        return GestureDetector(
          onTap: () => setState(() => _selectedDay = day),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? const Color(0xFFC49A58)
                  : isHighlighted
                      ? const Color(0xFFFDF5E6)
                      : Colors.transparent,
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight:
                      isHighlighted ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? Colors.white
                      : isHighlighted
                          ? const Color(0xFFC49A58)
                          : Colors.black87,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimeSelector(
      String label, String time, bool isAm, Function(bool) onAmPmChanged) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Text(
            time,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        _buildAmPmSelector(isAm, onAmPmChanged),
      ],
    );
  }

  Widget _buildAmPmSelector(bool isAm, Function(bool) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildAmPmButton("AM", isAm, () => onChanged(true)),
          _buildAmPmButton("PM", !isAm, () => onChanged(false)),
        ],
      ),
    );
  }

  Widget _buildAmPmButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

void showChooseBreakDaysBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const ChooseBreakDaysBottomSheet(),
  );
}
