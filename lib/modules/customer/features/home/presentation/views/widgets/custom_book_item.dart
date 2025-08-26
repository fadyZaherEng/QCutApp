import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/modules/customer/history_feature/model/customer_history_appointment.dart';
import 'package:intl/intl.dart';

class CustomBookItem extends StatelessWidget {
  final CustomerHistoryAppointment? appointment;

  const CustomBookItem({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 126.w,
          height: 200.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              bottomLeft: Radius.circular(16.r),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              bottomLeft: Radius.circular(16.r),
            ),
            child: Image.asset(
              AssetsData.myAppointmentImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: 4.w, bottom: 4.h, top: 4.h),
            child: Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16.r),
                  bottomRight: Radius.circular(16.r),
                ),
                color: ColorsData.cardColor,
              ),
              child: Padding(
                padding: EdgeInsets.all(8.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          appointment?.barber.barberShop ?? "barberShop".tr,
                          style: Styles.textStyleS12W700(),
                        ),
                        const Spacer(),
                        Text(
                          appointment?.paymentMethod.toUpperCase() ?? "cash".tr,
                          style: Styles.textStyleS14W400(
                              color: ColorsData.primary),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    _buildInfoRow(
                        "service".tr,
                        appointment?.services
                                .map((s) => s.service.name)
                                .join(", ") ??
                            "Hair style"),
                    _buildInfoRow("price".tr,
                        "₪ ${appointment?.price.toString() ?? "0"}"),
                    _buildInfoRow("qty".tr,
                        "${appointment?.services.fold(0, (sum, service) => sum + service.numberOfUsers)} ${'consumer'.tr}(s)"),
                    _buildInfoRow(
                        "bookingDay".tr,
                        appointment != null
                            ? DateFormat('EEE dd/MM/yyyy')
                                .format(appointment!.startDate)
                            : "Not set"),
                    _buildInfoRow(
                        "bookingTime".tr,
                        appointment != null
                            ? "${DateFormat('hh:mm a').format(appointment!.startDate)} - ${DateFormat('hh:mm a').format(appointment!.endDate)}"
                            : "Not set".tr),
                    _buildInfoRow(
                        "status".tr, appointment?.status ?? "Pending".tr),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Text(
            label,
            style: Styles.textStyleS14W400(),
          ),
          const Spacer(),
          Text(
            value,
            style: Styles.textStyleS14W400(),
          ),
        ],
      ),
    );
  }
}
