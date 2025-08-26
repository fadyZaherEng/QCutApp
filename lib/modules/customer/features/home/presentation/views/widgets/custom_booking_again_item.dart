import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/customer/features/home/presentation/views/widgets/custom_book_item.dart';
import 'package:q_cut/modules/customer/history_feature/model/customer_history_appointment.dart';

class CustomBookingAgainItem extends StatelessWidget {
  final VoidCallback onBookingAgain;
  final CustomerHistoryAppointment appointment;

  const CustomBookingAgainItem({
    super.key,
    required this.onBookingAgain,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h, left: 17.w, right: 17.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomBookItem(
            appointment: appointment,
          ),
          SizedBox(height: 24.h),
          CustomBigButton(
            textData: "bookingAgain".tr,
            onPressed: onBookingAgain,
          ),
        ],
      ),
    );
  }
}
