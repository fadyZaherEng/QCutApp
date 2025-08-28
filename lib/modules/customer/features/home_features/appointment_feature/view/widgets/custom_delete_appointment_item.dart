import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/customer/features/home_features/appointment_feature/models/customer_appointment_model.dart';
import 'package:q_cut/modules/customer/features/home_features/home/models/barber_model.dart';

class CustomDeleteAppointmentItem extends StatelessWidget {
  final VoidCallback onDelete;
  final CustomerAppointment appointment;

  const CustomDeleteAppointmentItem({
    super.key,
    required this.onDelete,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final remaining = appointment.startDate.difference(now);

    final hours = remaining.inHours.toString().padLeft(2, '0');
    final minutes = (remaining.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //get language direction
                if (Get.locale?.languageCode == 'ar')
                  // Left side image container
                  Container(
                    width: 126.w,
                    height: 194.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.r),
                        bottomRight: Radius.circular(16.r),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.r),
                        bottomRight: Radius.circular(16.r),
                      ),
                      child: Image.asset(
                        AssetsData.myAppointmentImage,
                        fit: BoxFit.cover,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
                if (Get.locale?.languageCode == 'ar')
                  // Right side details container
                  Expanded(
                    child: Container(
                      height: 194.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          bottomLeft: Radius.circular(16.r),
                        ),
                        color: ColorsData.cardColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Barber name and payment method
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    appointment.barber.fullName,
                                    style: Styles.textStyleS12W700(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  appointment.paymentMethod,
                                  style: Styles.textStyleS14W400(
                                      color: ColorsData.primary),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            // Barbershop location
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AssetsData.mapPinIcon,
                                  width: 12.w,
                                  height: 12.h,
                                  colorFilter: const ColorFilter.mode(
                                    ColorsData.primary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    "${appointment.barber.fullName} ",
                                    style: Styles.textStyleS12W400(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            // Service details
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildInfoRow(
                                      'service'.tr, appointment.serviceName),
                                  _buildInfoRow('servicePrice'.tr,
                                      "\$${appointment.price.toStringAsFixed(0)}"),
                                  _buildInfoRow(
                                      'qty'.tr, appointment.totalConsumers),
                                  _buildInfoRow('bookingDay'.tr,
                                      appointment.formattedDate),
                                  _buildInfoRow('bookingTime'.tr,
                                      appointment.formattedTime),
                                  _buildInfoRow(
                                      'status'.tr, appointment.status),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (Get.locale?.languageCode != 'ar')
                  Expanded(
                    child: Container(
                      height: 194.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.r),
                          bottomLeft: Radius.circular(16.r),
                        ),
                        color: ColorsData.cardColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Barber name and payment method
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    appointment.barber.fullName,
                                    style: Styles.textStyleS12W700(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  appointment.paymentMethod,
                                  style: Styles.textStyleS14W400(
                                      color: ColorsData.primary),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            // Barbershop location
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AssetsData.mapPinIcon,
                                  width: 12.w,
                                  height: 12.h,
                                  colorFilter: const ColorFilter.mode(
                                    ColorsData.primary,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    "${appointment.barber.fullName} ",
                                    style: Styles.textStyleS12W400(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            // Service details
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildInfoRow(
                                      'service'.tr, appointment.serviceName),
                                  _buildInfoRow('servicePrice'.tr,
                                      "\$${appointment.price.toStringAsFixed(0)}"),
                                  _buildInfoRow(
                                      'qty'.tr, appointment.totalConsumers),
                                  _buildInfoRow('bookingDay'.tr,
                                      appointment.formattedDate),
                                  _buildInfoRow('bookingTime'.tr,
                                      appointment.formattedTime),
                                  _buildInfoRow(
                                      'status'.tr, appointment.status),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (Get.locale?.languageCode != 'ar')
                  Container(
                    width: 126.w,
                    height: 194.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.r),
                        bottomRight: Radius.circular(16.r),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16.r),
                        bottomRight: Radius.circular(16.r),
                      ),
                      child: Image.asset(
                        AssetsData.myAppointmentImage,
                        fit: BoxFit.cover,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.timer, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              remaining.isNegative
                  ? Text(
                      "Expired".tr,
                      style: const TextStyle(fontSize: 14, color: Colors.red),
                    )
                  : Text(
                      "${"Countdown".tr} : $hours:$minutes:$seconds",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
            ],
          ),
          SizedBox(height: 16.h),
          if (appointment.status.toLowerCase() == 'pending')
            CustomBigButton(
              textData: "Cancel".tr,
              onPressed: onDelete,
            ),
          if (appointment.status.toLowerCase() == 'completed')
            CustomBigButton(
              onPressed: () async {
                onDelete;
                Get.toNamed(AppRouter.barberServicesPath,
                    arguments: Barber(
                      id: appointment.barber.id,
                      fullName: appointment.barber.fullName,
                      phoneNumber: "",
                      userType: appointment.barber.userType,
                      city: "",
                      isFavorite: false,
                      status: appointment.status,
                      offDay: [],
                      workingDays: [],
                    ));
              },
              textData: "Book again".tr,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
