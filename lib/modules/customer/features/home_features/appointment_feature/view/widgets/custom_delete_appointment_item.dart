import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/customer/features/home_features/appointment_feature/models/customer_appointment_model.dart';

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
    return Padding(
      padding: EdgeInsets.only(top: 24.h, left: 17.w, right: 17.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildInfoRow(
                                    'service'.tr, appointment.serviceName),
                                _buildInfoRow('servicePrice'.tr,
                                    "\$${appointment.price.toStringAsFixed(0)}"),
                                _buildInfoRow(
                                    'qty'.tr, appointment.totalConsumers),
                                _buildInfoRow(
                                    'bookingDay'.tr, appointment.formattedDate),
                                _buildInfoRow('bookingTime'.tr,
                                    appointment.formattedTime),
                                _buildInfoRow('status'.tr, appointment.status),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          if (appointment.status.toLowerCase() == 'pending')
            CustomBigButton(
              textData: "delete".tr,
              onPressed: onDelete,
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
          style: Styles.textStyleS14W400(),
        ),
        Expanded(
          child: Text(
            value,
            style: Styles.textStyleS14W400(),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
