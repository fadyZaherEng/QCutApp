import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/models/barber_profile_model.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_edit/logic/b_edit_profile_controller.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_display/models/barber_profile_model.dart';

class OnboardingWorkingDaysBottomSheet extends StatefulWidget {
  final BarberProfileModel profileData;
  const OnboardingWorkingDaysBottomSheet({super.key, required this.profileData});

  @override
  State<OnboardingWorkingDaysBottomSheet> createState() =>
      _OnboardingWorkingDaysBottomSheetState();
}

class _OnboardingWorkingDaysBottomSheetState
    extends State<OnboardingWorkingDaysBottomSheet> {
  late final BEditProfileController controller;

  @override
  void initState() {
    super.initState();
    // Register or find the edit profile controller
    if (Get.isRegistered<BEditProfileController>()) {
      controller = Get.find<BEditProfileController>();
    } else {
      controller = Get.put(BEditProfileController());
    }
    
    // Manually initialize with data to avoid Get.arguments issues
    controller.initWithData(widget.profileData);
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
          Text(
            "Set Your Working Hours".tr,
            style: Styles.textStyleS16W700(color: ColorsData.primary),
          ),
          SizedBox(height: 8.h),
          Text(
            "You must set at least one working day to continue.".tr,
            style: Styles.textStyleS14W400(color: Colors.grey),
          ),
          SizedBox(height: 16.h),
          
          Flexible(
            child: SingleChildScrollView(
              child: _buildWorkingDaysSelector(),
            ),
          ),
          
          SizedBox(height: 24.h),
          Obx(() => SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsData.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              onPressed: controller.isLoading.value ? null : () async {
                if (controller.workingDays.isEmpty) {
                  Get.snackbar(
                    "Working Days Required".tr,
                    "Please add at least one working day".tr,
                    backgroundColor: Colors.orange,
                    colorText: Colors.white,
                  );
                  return;
                }
                
                await controller.updateProfile();
              },
              child: controller.isLoading.value 
                ? const SpinKitThreeBounce(color: Colors.white, size: 20)
                : Text("Confirm & Continue".tr,
                    style: Styles.textStyleS16W600(color: Colors.white)),
            ),
          )),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildWorkingDaysSelector() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Working Days Schedule".tr,
                    style: Styles.textStyleS14W500(color: Colors.white)),
                TextButton.icon(
                  onPressed: () => controller.addWorkingDay(),
                  icon: const Icon(Icons.add, color: ColorsData.primary),
                  label: Text("Add Day".tr,
                      style:
                          Styles.textStyleS12W500(color: ColorsData.primary)),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            if (controller.workingDays.isEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: ColorsData.cardColor,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: ColorsData.cardStrock),
                ),
                child: Center(
                  child: Text(
                    "No working days set. Add your working days.".tr,
                    style: Styles.textStyleS14W400(color: Colors.grey),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.workingDays.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.h),
                itemBuilder: (context, index) {
                  final workingDay = controller.workingDays[index];
                  return _buildWorkingDayItem(index, workingDay);
                },
              ),
          ],
        ));
  }

  Widget _buildWorkingDayItem(int index, WorkingDay workingDay) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: ColorsData.cardColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: ColorsData.cardStrock),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  border:
                      Border.all(color: ColorsData.primary.withOpacity(0.5)),
                ),
                child: Obx(() {
                  final usedDays = controller.workingDays
                      .where((wd) => wd != workingDay)
                      .map((wd) => wd.day)
                      .toList();

                  final offDays = controller.offDays;

                  final availableDays = controller.availableDays
                      .where((day) =>
                          !usedDays.contains(day) && !offDays.contains(day) ||
                          day == workingDay.day)
                      .toList();

                  return DropdownButton<String>(
                    value: workingDay.day,
                    dropdownColor: ColorsData.secondary,
                    style: Styles.textStyleS14W500(color: Colors.white),
                    underline: Container(),
                    icon: const Icon(Icons.arrow_drop_down,
                        color: ColorsData.primary),
                    items: availableDays
                        .map((day) => DropdownMenuItem<String>(
                              value: day,
                              child: Text(day.tr),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.updateWorkingDay(
                            index,
                            WorkingDay(
                                day: value,
                                startHour: workingDay.startHour,
                                endHour: workingDay.endHour));
                      }
                    },
                  );
                }),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                onPressed: () => controller.removeWorkingDay(index),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("From".tr,
                        style: Styles.textStyleS12W400(color: Colors.grey)),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: () async {
                        final timeOfDay = await showTimePicker(
                          context: context,
                          initialTime:
                              TimeOfDay(hour: workingDay.startHour, minute: 0),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: ColorsData.primary,
                                  onSurface: Colors.white,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (timeOfDay != null) {
                          controller.updateWorkingDay(
                              index,
                              WorkingDay(
                                  day: workingDay.day,
                                  startHour: timeOfDay.hour,
                                  endHour: workingDay.endHour));
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: ColorsData.secondary,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: ColorsData.cardStrock),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.access_time,
                                color: ColorsData.primary, size: 16),
                            SizedBox(width: 8.w),
                            Text("${workingDay.startHour}:00",
                                style: Styles.textStyleS14W400(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("To".tr,
                        style: Styles.textStyleS12W400(color: Colors.grey)),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: () async {
                        final timeOfDay = await showTimePicker(
                          context: context,
                          initialTime:
                              TimeOfDay(hour: workingDay.endHour, minute: 0),
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: ColorsData.primary,
                                  onSurface: Colors.white,
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (timeOfDay != null) {
                          controller.updateWorkingDay(
                              index,
                              WorkingDay(
                                  day: workingDay.day,
                                  startHour: workingDay.startHour,
                                  endHour: timeOfDay.hour));
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 12.h, horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: ColorsData.secondary,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: ColorsData.cardStrock),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.access_time,
                                color: ColorsData.primary, size: 16),
                            SizedBox(width: 8.w),
                            Text("${workingDay.endHour}:00",
                                style: Styles.textStyleS14W400(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
