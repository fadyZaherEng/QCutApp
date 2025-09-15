import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/modules/customer/features/booking_features/select_appointment_time/controller/select_appointment_time_controller.dart';
import 'package:q_cut/modules/customer/features/booking_features/select_appointment_time/model/time_slot_model.dart';

class CustomAvailableTime extends GetView<SelectAppointmentTimeController> {
  const CustomAvailableTime({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectAppointmentTimeController>(
      id: 'timeSlots',
      builder: (controller) {
        if (controller.isLoadingTimeSlots.value) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpinKitDoubleBounce(color: ColorsData.primary),
                SizedBox(height: 10.h),
                Text(
                  'Loading time slots...',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }

        final timeSlots =
            controller.getTimeSlotsByDay(controller.selectedDay.value);

        if (timeSlots.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time, size: 40.sp, color: Colors.grey),
                SizedBox(height: 8.h),
                Text(
                  'noAvailableTimeSlotsForThisDay'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Group slots by time of day for better organization
        final groupedSlots = _groupSlotsByHour(timeSlots);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var hourGroup in groupedSlots.entries) ...[
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 2.5,
                ),
                itemCount: hourGroup.value.length,
                itemBuilder: (context, index) {
                  final timeSlot = hourGroup.value[index];
                  return Obx(() {
                    final isSelected =
                        controller.selectedTimeSlot.value?.id == timeSlot.id;

                    return GestureDetector(
                      onTap: () => controller.selectTimeSlot(timeSlot),
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 4.w),
                        decoration: BoxDecoration(
                          color: isSelected ? ColorsData.primary : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? ColorsData.primary
                                : ColorsData.font.withOpacity(0.3),
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: ColorsData.primary.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ]
                              : null,
                        ),
                        child: Text(
                          _formatTimeSlot(timeSlot),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight:
                                isSelected ? FontWeight.w700 : FontWeight.w400,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  });
                },
              ),
              SizedBox(height: 16.h), // Add space between time of day groups
            ],
          ],
        );
      },
    );
  }

  // Format time slot to display start and end time
  String _formatTimeSlot(TimeSlot slot) {
    final startTime = DateFormat('h:mm').format(slot.startTime);
    final endTime = DateFormat('h:mm').format(slot.endTime);
    return '$startTime - $endTime';
  }

  // Group slots by morning, afternoon, evening
  Map<int, List<TimeSlot>> _groupSlotsByHour(List<TimeSlot> slots) {
    final Map<int, List<TimeSlot>> grouped = {};

    for (var slot in slots) {
      // Group by hour range (0-11: morning, 12-16: afternoon, 17-23: evening)
      int hour = slot.startTime.hour;
      int group;

      if (hour < 12) {
        group = 0; // Morning
      } else if (hour < 17) {
        group = 1; // Afternoon
      } else {
        group = 2; // Evening
      }

      if (!grouped.containsKey(group)) {
        grouped[group] = [];
      }
      grouped[group]!.add(slot);
    }

    // Sort the groups by their keys
    final sortedKeys = grouped.keys.toList()..sort();
    return {for (var k in sortedKeys) k: grouped[k]!};
  }
}
