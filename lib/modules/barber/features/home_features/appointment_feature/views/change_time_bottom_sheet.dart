import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/main.dart';
import 'package:q_cut/modules/barber/features/home_features/appointment_feature/logic/appointment_controller.dart';
import 'package:q_cut/modules/barber/features/home_features/appointment_feature/models/appointment_model.dart';

class ChangeTimeBottomSheet extends StatefulWidget {
  final String? day;
  final String appointmentId;
  final List<ServiceItem> services;

  const ChangeTimeBottomSheet({
    super.key,
    this.day,
    required this.appointmentId,
    required this.services,
  });

  @override
  State<ChangeTimeBottomSheet> createState() => _ChangeTimeBottomSheetState();
}

class _ChangeTimeBottomSheetState extends State<ChangeTimeBottomSheet> {
  int selectedDayIndex = 0;
  late List<Map<String, dynamic>> dynamicDays;
  bool isLoading = false;
  final NetworkAPICall _networkAPICall = NetworkAPICall();
  final controller = Get.put(BAppointmentController());
  List<String> timeSlots = [];
  String? selectedTimeSlot;

  @override
  void initState() {
    super.initState();
    dynamicDays = _generateDynamicDays();
    _getInitialTimeSlots();
  }

  Future<void> _getInitialTimeSlots() async {
    timeSlots = await controller.getTimeSlotAppointment(
      currentBarberId,
      DateTime.parse(DateFormat('yyyy-MM-dd')
              .format(dynamicDays[selectedDayIndex]["fullDate"]))
          .millisecondsSinceEpoch
          .toString(),
      widget.services,
    );
    if (mounted) {
      setState(() {});
    }
  }

  // List<Map<String, dynamic>> _generateDynamicDays() {
  //   DateTime startDate;
  //
  //   // Try to parse the provided date string or fall back to today
  //   if (widget.day != null) {
  //     try {
  //       startDate = DateTime.parse(widget.day!);
  //     } catch (e) {
  //       print('Error parsing date: ${widget.day}. Using current date instead.');
  //       startDate = DateTime.now();
  //     }
  //   } else {
  //     startDate = DateTime.now();
  //   }
  //
  //   final List<Map<String, dynamic>> days = [];
  //
  //   // Generate 3 days starting from the provided date
  //   for (int i = 0; i < 3; i++) {
  //     final day = startDate.add(Duration(days: i));
  //     days.add({
  //       "day": DateFormat('E').format(day), // Short day name (Mon, Tue, etc.)
  //       "date": day.day.toString(), // Day of month
  //       "fullDate": day, // Store the full date for reference
  //     });
  //   }
  //   return days;
  // }
  List<Map<String, dynamic>> _generateDynamicDays() {
    DateTime startDate;

    // Try to parse the provided date string or fall back to today
    if (widget.day != null) {
      try {
        startDate = DateTime.parse(widget.day!);
      } catch (e) {
        print('Error parsing date: ${widget.day}. Using current date instead.');
        startDate = DateTime.now();
      }
    } else {
      startDate = DateTime.now();
    }

    final List<Map<String, dynamic>> days = [];

    // ✅ Generate 7 days starting from the provided date
    for (int i = 0; i < 7; i++) {
      final day = startDate.add(Duration(days: i));
      days.add({
        "day": DateFormat('E').format(day), // Short day name (Mon, Tue, etc.)
        "date": day.day.toString(), // Day of month
        "fullDate": day, // Store the full date for reference
      });
    }
    return days;
  }

  bool isClicked = true;

  Future<void> _sendTimeChangeRequest() async {
    if (!isClicked) return; // Prevent multiple clicks

    setState(() => isClicked = false);

    if (selectedTimeSlot == null || selectedTimeSlot!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a time")),
      );
      if (mounted) {
        setState(() => isClicked = true);
      }
      return;
    }

    if (mounted) {
      setState(() => isLoading = true);
    }

    DateTime selectedDate = dynamicDays[selectedDayIndex]["fullDate"];

    final timeString = selectedTimeSlot!;
    final timeParts = timeString.split(RegExp(r'[: ]'));

    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    if (timeParts.length > 2 &&
        timeParts[2].toUpperCase() == 'PM' &&
        hour < 12) {
      hour += 12;
    }
    if (timeParts.length > 2 &&
        timeParts[2].toUpperCase() == 'AM' &&
        hour == 12) {
      hour = 0;
    }

    final combinedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      hour,
      minute,
    );

    final startDateMillis = combinedDateTime.millisecondsSinceEpoch;

    final requestData = {
      'appointment': widget.appointmentId,
      'startDate': startDateMillis,
    };
    print('Request Data: $requestData');

    final response = await _networkAPICall.addData(
      requestData,
      '${Variables.baseUrl}request-change-appointment-time',
    );
    print('Response: $response');
    print("url is :${Variables.baseUrl}request-change-appointment-time");

    if (!mounted) return;
    Map<String, dynamic> responseBody;
    try {
      final bodyString = response.body.toString();
      print('Raw Body: $bodyString');

      if (bodyString.trim().startsWith('{') ||
          bodyString.trim().startsWith('[')) {
        responseBody = jsonDecode(bodyString);
      } else {
        responseBody = {"message": bodyString};
      }

      print('Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        ShowToast.showSuccessSnackBar(
          message: "Request sent successfully".tr,
        );
        Get.back();
      } else {
        ShowToast.showError(
          message: responseBody['message'] ?? 'An error occurred',
        );
        Get.back();
      }
    } catch (e) {
      print('Error decoding response: $e');
      ShowToast.showError(message: 'Unexpected response format');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }

    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() => isClicked = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// زر الإغلاق
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            Column(
              children: [
                SvgPicture.asset(
                  height: 36.h,
                  width: 36.w,
                  AssetsData.clockIcon,
                  colorFilter: const ColorFilter.mode(
                    ColorsData.dark,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "changeTime".tr,
                  style: Styles.textStyleS16W600(color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            Row(
              children: [
                SvgPicture.asset(
                  height: 20.h,
                  width: 20.w,
                  AssetsData.calendarIcon,
                  colorFilter: const ColorFilter.mode(
                    ColorsData.primary,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  "days".tr,
                  style: Styles.textStyleS14W500(color: Colors.black),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(dynamicDays.length, (index) {
                  bool isSelected = selectedDayIndex == index;
                  return GestureDetector(
                    onTap: () async {
                      setState(() {
                        selectedDayIndex = index;
                        timeSlots = [];
                        selectedTimeSlot = null;
                        isLoading = true;
                      });

                      final newSlots = await controller.getTimeSlotAppointment(
                        currentBarberId,
                        DateTime.parse(DateFormat('yyyy-MM-dd').format(
                                dynamicDays[selectedDayIndex]["fullDate"]))
                            .millisecondsSinceEpoch
                            .toString(),
                        widget.services,
                      );

                      if (mounted) {
                        setState(() {
                          timeSlots = newSlots;
                          isLoading = false;
                        });
                      }
                    },
                    child: Container(
                      width: 60.w,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      margin: EdgeInsets.symmetric(horizontal: 6.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFC49A58)
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(
                            dynamicDays[index]["day"],
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                          Text(
                            dynamicDays[index]["date"],
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 20.h),
            //TODO ADD TIME SLOT WIDGET
            SizedBox(height: 20.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العنوان مع الأيقونة
                Row(
                  children: [
                    SvgPicture.asset(
                      AssetsData.clockIcon,
                      height: 20.h,
                      width: 20.w,
                      colorFilter: const ColorFilter.mode(
                        ColorsData.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "timeSlots".tr,
                      style: Styles.textStyleS14W500(color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                if (isLoading)
                  Center(
                    child: SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: SpinKitDoubleBounce(
                        color: ColorsData.primary,
                      ),
                    ),
                  )
                else
                // لو مفيش مواعيد
                if (timeSlots.isEmpty)
                  Center(
                    child: Text(
                      "noAvailableTimeSlots".tr,
                      style: Styles.textStyleS14W400(color: Colors.grey),
                    ),
                  )
                else
                  Wrap(
                    spacing: 4.w,
                    runSpacing: 4.h,
                    children: List.generate(timeSlots.length, (index) {
                      final slot = timeSlots[index];
                      final isSelected = selectedTimeSlot == slot;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTimeSlot = slot;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width:
                              (MediaQuery.of(context).size.width - (12.w * 4)) /
                                  3,
                          padding: EdgeInsets.symmetric(
                            vertical: 8.h,
                            horizontal: 6.w,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected ? ColorsData.primary : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? ColorsData.primary
                                  : Colors.grey[300]!,
                              width: 1.5,
                            ),
                            boxShadow: [
                              if (isSelected)
                                BoxShadow(
                                  color: ColorsData.primary.withOpacity(0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              slot,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  )
              ],
            ),
            SizedBox(height: 20.h),

            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC49A58),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: isLoading
                    ? null
                    : () async {
                        await _sendTimeChangeRequest();
                      },
                child: isLoading
                    ? SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "request from customer".tr,
                        style: Styles.textStyleS16W600(color: Colors.white),
                      ),
              ),
            ),
            SizedBox(height: 48.h),
          ],
        ),
      ),
    );
  }
}

void showChangeTimeBottomSheet(
  BuildContext context,
  String day,
  String appointmentId,
  List<ServiceItem> services,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) => ChangeTimeBottomSheet(
      day: day,
      appointmentId: appointmentId,
      services: services,
    ),
  );
}
