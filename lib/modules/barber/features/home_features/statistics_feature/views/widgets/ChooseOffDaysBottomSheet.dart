import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_edit/logic/b_edit_profile_controller.dart';

class ChooseOffDaysBottomSheet extends StatefulWidget {
  final Function(List<String>) onDaysSelected;
  final List<String> selectedDays;

  const ChooseOffDaysBottomSheet({
    super.key,
    required this.onDaysSelected,
    this.selectedDays = const [],
  });

  @override
  State<ChooseOffDaysBottomSheet> createState() =>
      _ChooseOffDaysBottomSheetState();
}

class _ChooseOffDaysBottomSheetState extends State<ChooseOffDaysBottomSheet> {
  final List<String> allDays = [
    'Monday'.tr,
    'Tuesday'.tr,
    'Wednesday'.tr,
    'Thursday'.tr,
    'Friday'.tr,
    'Saturday'.tr,
    'Sunday'.tr,
  ];

  late List<String> selectedDays;
  List<String> availableDays = [];

  @override
  void initState() {
    super.initState();
    // Initialize with the days passed in
    selectedDays = List.from(widget.selectedDays);

    // Get working days to determine which days are available for selection
    final controller = Get.find<BEditProfileController>();
    final workingDays =
        controller.workingDays.map((workingDay) => workingDay.day).toList();

    // Filter days to only show available ones (days that aren't working days)
    availableDays = allDays.where((day) => !workingDays.contains(day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsData.secondary,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Choose Off Days".tr,
                style: Styles.textStyleS16W700(color: Colors.white),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          Text(
            "Select days when you are not working".tr,
            style: Styles.textStyleS14W400(color: Colors.grey),
          ),
          SizedBox(height: 16.h),

          // Days list - only show available days
          SingleChildScrollView(
            child: Column(
              children: availableDays.map((day) {
                final isSelected = selectedDays.contains(day);
                return ListTile(
                  title: Text(
                    day,
                    style: Styles.textStyleS14W500(
                      color: isSelected ? ColorsData.primary : Colors.white,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle,
                          color: ColorsData.primary)
                      : const Icon(Icons.circle_outlined, color: Colors.grey),
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedDays.remove(day);
                      } else {
                        selectedDays.add(day);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),

          if (availableDays.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Text(
                  "All days are already set as working days.".tr,
                  style: Styles.textStyleS14W400(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsData.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: () {
                widget.onDaysSelected(selectedDays);
                Get.back();
              },
              child: Text(
                "Confirm".tr,
                style: Styles.textStyleS16W600(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 64.h),
        ],
      ),
    );
  }
}
