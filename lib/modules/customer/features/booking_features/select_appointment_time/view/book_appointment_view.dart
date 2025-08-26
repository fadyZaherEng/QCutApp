import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_app_bar.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/customer/features/bookingAndPayment/models/booking_payment_details_model.dart';
import 'package:q_cut/modules/customer/features/booking_features/select_appointment_time/controller/select_appointment_time_controller.dart';
import 'package:q_cut/modules/customer/features/booking_features/select_appointment_time/view/widgets/custom_available_time.dart';
import 'package:q_cut/modules/customer/features/booking_features/select_appointment_time/view/widgets/custom_b_simple_days_picker.dart';
import 'package:q_cut/modules/customer/features/booking_features/select_appointment_time/view/widgets/custom_book_appointment_item.dart';
import 'package:intl/intl.dart';

import '../../display_barber_services_feature/models/free_time_request_model.dart';

class BookAppointmentView extends GetView<SelectAppointmentTimeController> {
  const BookAppointmentView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SelectAppointmentTimeController());
    final selectedServices = Get.arguments as FreeTimeRequestModel?;

    if (selectedServices != null) {
      if (selectedServices.barber.isNotEmpty) {
        controller.barberId.value = selectedServices.barber;
        print("${"setBarberID".tr}: ${controller.barberId.value}");
      } else {
        print("warningBarberIDEmpty".tr);
      }

      // Prepare and store the services data
      if (selectedServices.services.isNotEmpty) {
        final servicesList = selectedServices.services
            .map((service) => {
                  "service": service.service,
                  "numberOfUsers": service.numberOfUsers
                })
            .toList();

        controller.setSelectedServices(servicesList);
        print("${"setServices".tr}: ${controller.selectedServices}");
      } else {
        print("warningNoServices".tr);
      }

      // Fetch available days immediately without any delay
      controller.getAvailableDays(selectedServices);

      // Manually add test timestamps if needed for debugging
      if (controller.availableDaysTimestamps.isEmpty) {
        print("addingTestTimestamps".tr);
        final now = DateTime.now().millisecondsSinceEpoch;
        final oneDayMs = 86400000; // 24 hours in milliseconds

        // Add the next 7 days as test data
        for (int i = 0; i < 7; i++) {
          final dayTimestamp = now + (i * oneDayMs);
          print(
              "${"addingTestDay".tr}: ${DateTime.fromMillisecondsSinceEpoch(dayTimestamp)}");
          controller.availableDaysTimestamps.add(dayTimestamp);
        }
      }
    }

    return Scaffold(
      appBar: CustomAppBar(title: "bookAppointment".tr),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Obx(() {
          // Show loading indicator if data is being loaded
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SpinKitDoubleBounce(color: ColorsData.primary),
                  SizedBox(height: 20.h),
                  Text("loadingAvailableAppointments".tr,
                      style: TextStyle(fontSize: 16.sp, color: Colors.grey))
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomBookAppointmentItem(
                  services: selectedServices!.barberServices,
                  quantities: selectedServices.services
                      .asMap()
                      .entries
                      .map((entry) => entry.value.numberOfUsers)
                      .toList(),
                ),
                SizedBox(height: 17.h),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "availableAppointments".tr,
                    style: Styles.textStyleS16W700(),
                  ),
                ),
                SizedBox(height: 24.h),
                Obx(() {
                  print(
                      "${"daysPickerRebuilding".tr} ${controller.availableDaysTimestamps.length} ${"days".tr}");
                  return CustomBSimpleDaysPicker(
                    selectedDay: controller.selectedDay.value,
                    onDaySelected: (day) {
                      print("${"daySelectedInUI".tr}: $day");
                      controller.changeSelectedDay(
                          day, selectedServices.onHolding);
                    },
                    titleSimpleDaysPicker: "selectDay".tr,
                  );
                }),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    SvgPicture.asset(AssetsData.clockIcon),
                    SizedBox(width: 5.w),
                    Text("availableTime".tr, style: Styles.textStyleS16W400()),
                  ],
                ),
                SizedBox(height: 24.h),
                // Use GetBuilder with specific ID for time slots to prevent full UI rebuilds
                GetBuilder<SelectAppointmentTimeController>(
                  id: 'timeSlots',
                  builder: (controller) => CustomAvailableTime(),
                ),
                SizedBox(height: 24.h),
                Text(
                  "ifAppointmentsDontFit".tr,
                  style: Styles.textStyleS16W400(),
                ),
                Row(
                  children: [
                    Text(
                      "youCanSelectFrom".tr,
                      style: Styles.textStyleS16W400(),
                    ),
                    GestureDetector(
                      onTap: () async {
                        Get.toNamed(AppRouter.onHoldAppointmentPath,
                            arguments:
                                selectedServices.copyWith(onHolding: true));
                      },
                      child: Text(
                        textAlign: TextAlign.left,
                        "onHoldAppointments".tr,
                        style:
                            Styles.textStyleS16W400(color: ColorsData.primary),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                CustomBigButton(
                  textData: "confirm".tr,
                  onPressed: () {
                    final startTime = DateFormat('h:mm a')
                        .format(controller.selectedTimeSlot.value!.startTime);

                    // Print booking model data
                    print({
                      "barber": controller.barberId.value,
                      "service": selectedServices.services
                          .asMap()
                          .entries
                          .map((entry) => {
                                "service": entry.value.service,
                                "numberOfUsers": entry.value.numberOfUsers
                              })
                          .toList(),
                      "startDate": controller.selectedTimeSlot.value!.startTime
                          .millisecondsSinceEpoch,
                      "paymentMethod": "cash"
                    });

                    BookingPaymentDetailsModel bookingPaymentDetailsModel =
                        BookingPaymentDetailsModel(
                            serviceTitle: selectedServices.services
                                .asMap()
                                .entries
                                .map((entry) =>
                                    "${selectedServices.barberServices![entry.key].name} x${entry.value.numberOfUsers}")
                                .join(", "),
                            servicePrice: selectedServices.barberServices!
                                .asMap()
                                .entries
                                .map((entry) =>
                                    entry.value.price *
                                    selectedServices
                                        .services[entry.key].numberOfUsers)
                                .reduce((a, b) => a + b)
                                .toDouble(),
                            totalAmount: selectedServices.services
                                .asMap()
                                .entries
                                .map((entry) =>
                                    selectedServices
                                        .barberServices![entry.key].price *
                                    selectedServices
                                        .services[entry.key].numberOfUsers)
                                .reduce((a, b) => a + b)
                                .toDouble(),
                            barberName: controller.barberName.value,
                            barberImage: controller.barberImage.value,
                            salonName:
                                selectedServices.barberServices!.first.name,
                            appointmentDate: controller
                                .selectedTimeSlot.value!.dayName
                                .toString(),
                            appointmentTime:
                                startTime, // Force unwrap as we expect it to be non-null when confirming
                            serviceDuration: "20");
                    Get.toNamed(AppRouter.bookAppointmentWithPaymentMethodsPath,
                        arguments: {
                          "pay": {
                            "barber": controller.barberId.value,
                            "service": selectedServices.services
                                .asMap()
                                .entries
                                .map((entry) => {
                                      "service": entry.value.service,
                                      "numberOfUsers": selectedServices
                                          .services[entry.key].numberOfUsers
                                    })
                                .toList(),
                            "startDate": controller.selectedTimeSlot.value!
                                .startTime.millisecondsSinceEpoch,
                            "paymentMethod": "cash"
                          },
                          "bookingPaymentDetailsModel":
                              bookingPaymentDetailsModel
                        });
                  },
                ),
                SizedBox(height: 24.h),
              ],
            ),
          );
        }),
      ),
    );
  }
}
