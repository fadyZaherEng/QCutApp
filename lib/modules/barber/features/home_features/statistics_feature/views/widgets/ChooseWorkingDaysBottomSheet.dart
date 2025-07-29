import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_checkbox.dart';

class ChooseWorkingDaysBottomSheet extends StatefulWidget {
  const ChooseWorkingDaysBottomSheet({super.key});

  @override
  State<ChooseWorkingDaysBottomSheet> createState() => _ChooseWorkingDaysBottomSheetState();
}

class _ChooseWorkingDaysBottomSheetState extends State<ChooseWorkingDaysBottomSheet> {
  final List<String> workingDays = [
    "Saturday".tr,
    "Sunday".tr,
    "Monday".tr,
    "Tuesday".tr,
    "Wednesday".tr,
    "Thursday".tr,
    "Friday".tr,
  ];

  final Set<String> selectedDays = {};

  @override
  Widget build(BuildContext context) {
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
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.close, size: 24),
            ),
          ),
          SizedBox(height: 16.h),

          Text(
            "Choose the working days",
            style: Styles.textStyleS16W700(color: ColorsData.primary),
          ),
          SizedBox(height: 16.h),

          Column(
            children: workingDays.map((day) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      day,
                      style: Styles.textStyleS16W700(color: ColorsData.secondary),
                    ),
                    CustomCheckbox(
                      isChecked: selectedDays.contains(day),
                      borderColor: ColorsData.primary,
                      onChanged: (isChecked) {
                        setState(() {
                          if (isChecked) {
                            selectedDays.add(day);
                          } else {
                            selectedDays.remove(day);
                          }
                        });
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
void showChooseWorkingDaysBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const ChooseWorkingDaysBottomSheet(),
  );
}
