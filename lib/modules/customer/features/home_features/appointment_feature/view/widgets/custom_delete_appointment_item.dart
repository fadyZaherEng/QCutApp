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
import 'dart:async';

class CustomDeleteAppointmentItem extends StatefulWidget {
  final VoidCallback onDelete;
  final CustomerAppointment appointment;

  const CustomDeleteAppointmentItem({
    super.key,
    required this.onDelete,
    required this.appointment,
  });

  @override
  State<CustomDeleteAppointmentItem> createState() =>
      _CustomDeleteAppointmentItemState();
}

class _CustomDeleteAppointmentItemState
    extends State<CustomDeleteAppointmentItem> {
  Timer? _timer;
  Duration remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();

    // تحديث كل ثانية
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemaining();
    });
  }

  void _updateRemaining() {
    final now = DateTime.now();
    setState(() {
      remaining = widget.appointment.startDate.difference(now);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = remaining.inHours.toString().padLeft(2, '0');
    final minutes = (remaining.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (Get.locale?.languageCode == 'ar')
                  Container(
                    width: 126.w,
                    // height: 194.h,
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
                  Expanded(
                    child: Container(
                      // height: 194.h,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.appointment.barber.fullName,
                                    style: Styles.textStyleS12W700(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  widget.appointment.paymentMethod,
                                  style: Styles.textStyleS14W400(
                                    color: ColorsData.primary,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    "${widget.appointment.barber.city} ",
                                    maxLines: 3,
                                    style: Styles.textStyleS12W400(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildInfoRow('service'.tr,
                                      widget.appointment.serviceName),
                                  _buildInfoRow('servicePrice'.tr,
                                      "\$${widget.appointment.price.toStringAsFixed(0)}"),
                                  _buildInfoRow('qty'.tr,
                                      widget.appointment.totalConsumers),
                                  _buildInfoRow('bookingDay'.tr,
                                      widget.appointment.formattedDate),
                                  _buildInfoRow('bookingTime'.tr,
                                      widget.appointment.formattedTime),
                                  _buildInfoRow(
                                      'status'.tr, widget.appointment.status),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.appointment.barber.fullName,
                                    style: Styles.textStyleS12W700(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  widget.appointment.paymentMethod,
                                  style: Styles.textStyleS14W400(
                                      color: ColorsData.primary),
                                ),
                              ],
                            ),
                            SizedBox(height: 6.h),
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
                                    "${widget.appointment.barber.fullName} ",
                                    style: Styles.textStyleS12W400(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildInfoRow('service'.tr,
                                      widget.appointment.serviceName),
                                  _buildInfoRow('servicePrice'.tr,
                                      "\$${widget.appointment.price.toStringAsFixed(0)}"),
                                  _buildInfoRow('qty'.tr,
                                      widget.appointment.totalConsumers),
                                  _buildInfoRow('bookingDay'.tr,
                                      widget.appointment.formattedDate),
                                  _buildInfoRow('bookingTime'.tr,
                                      widget.appointment.formattedTime),
                                  _buildInfoRow(
                                      'status'.tr, widget.appointment.status),
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
                      style: const TextStyle(fontSize: 14),
                    ),
            ],
          ),
          SizedBox(height: 16.h),
          if (widget.appointment.status.toLowerCase() == 'pending')
            CustomBigButton(
              textData: "Cancel".tr,
              onPressed: widget.onDelete,
            ),
          if (widget.appointment.status.toLowerCase() == 'completed')
            CustomBigButton(
              onPressed: () async {
                Get.toNamed(
                  AppRouter.barberServicesPath,
                  arguments: Barber(
                    id: widget.appointment.barber.id,
                    fullName: widget.appointment.barber.fullName,
                    phoneNumber: "",
                    userType: widget.appointment.barber.userType,
                    city: "",
                    isFavorite: false,
                    status: widget.appointment.status,
                    offDay: [],
                    workingDays: [],
                    instagramPage: "",
                  ),
                );
              },
              textData: "Book again".tr,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: Styles.textStyleS12W400(),
          ),
          const Expanded(child: SizedBox()),
          Expanded(
            flex: 5,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              style: Styles.textStyleS13W500(),
            ),
          ),
        ],
      ),
    );
  }
}
