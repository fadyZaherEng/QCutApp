import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';

class ChooseBreakDaysBottomSheet extends StatefulWidget {
  const ChooseBreakDaysBottomSheet({super.key});

  @override
  State<ChooseBreakDaysBottomSheet> createState() =>
      _ChooseBreakDaysBottomSheetState();
}

class _ChooseBreakDaysBottomSheetState
    extends State<ChooseBreakDaysBottomSheet> {
  int? _selectedDay;
  List<DateTime> _breakDays = [];
  bool isClicked = true;

  @override
  void initState() {
    super.initState();
    _fetchBreaks();
  }

  Future<void> _fetchBreaks() async {
    try {
      final response =
          await NetworkAPICall().getData("${Variables.BARBER}get-break-time");

      print("Fetch breaks response: $response");

      if (response.statusCode == 200 && response.body != null) {
        // Decode JSON string
        final data =
            response.body is String ? jsonDecode(response.body) : response.body;

        print("Breaks response: $data");

        final List breaks = data["breakTime"] ?? [];

        setState(() {
          _breakDays = breaks.map<DateTime>((b) {
            int start = b["startDate"]; // already int in your API
            return DateTime.fromMillisecondsSinceEpoch(start * 1000);
          }).toList();
        });
      }
    } catch (e, st) {
      debugPrint("Error fetching breaks: $e\n$st");
    }
  }

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
            "Choose break days".tr,
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
                "Select the days you want to take a break".tr,
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
              onPressed: _addBreak,
              child: Text(
                "Confirm".tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 64.h),
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
                  day.toLowerCase().tr,
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
        final now = DateTime.now();
        final currentDate = DateTime(now.year, now.month, day);

        final isSelected = _selectedDay == day;
        final isHighlighted = _breakDays.any((d) =>
            d.year == currentDate.year &&
            d.month == currentDate.month &&
            d.day == currentDate.day);

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


  Future<void> _addBreak() async {
    if (isClicked) {
      isClicked = false;

      if (_selectedDay == null) {
        Get.snackbar(
          "Error",
          "Please select a day first",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      try {
        DateTime start = DateTime(
            DateTime.now().year, DateTime.now().month, _selectedDay!, 8, 0);
        DateTime end = DateTime(
            DateTime.now().year, DateTime.now().month, _selectedDay!, 9, 0);

        int startTimestamp = (start.millisecondsSinceEpoch / 1000).round();
        int endTimestamp = (end.millisecondsSinceEpoch / 1000).round();

        final body = {
          "breaks": [
            {"startDate": startTimestamp, "endDate": endTimestamp}
          ]
        };

        final response = await NetworkAPICall().putData(
          "${Variables.BARBER}take-break",
          body,
        );

        if (response.statusCode == 200) {
          Get.back();
          Get.snackbar(
            "Success".tr,
            "Break added successfully".tr,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          // Get.snackbar(
          //   "Error",
          //   "Failed to add break: ${response.body}",
          //   backgroundColor: Colors.red,
          //   colorText: Colors.white,
          // );
        }
      } catch (e) {
        // Get.snackbar(
        //   "Error",
        //   "Something went wrong: $e",
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        // );
      }
    }
    await Future.delayed(const Duration(seconds: 2));
    isClicked = true;
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
