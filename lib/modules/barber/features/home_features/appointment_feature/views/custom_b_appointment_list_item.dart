import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/modules/barber/features/home_features/appointment_feature/models/appointment_model.dart';
import 'package:q_cut/modules/barber/features/home_features/appointment_feature/views/change_time_bottom_sheet.dart';
import 'package:q_cut/modules/customer/features/home/presentation/views/widgets/show_delete_appointment_dialog.dart';

import '../logic/appointment_controller.dart';

class CustomBAppointmentListItem extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String id;
  final String location;
  final String service;
  final String hairStyle;
  final String qty;
  final String bookingDay;
  final String bookingTime;
  final String type;
  final double price;
  final double finalPrice;
  final Function()? onDeleteTap;
  final BAppointmentController controller;
  final List<ServiceItem> services;

  final BarberAppointment appointment;

  const CustomBAppointmentListItem({
    super.key,
    required this.imageUrl,
    required this.id,
    required this.name,
    required this.location,
    required this.service,
    required this.hairStyle,
    required this.qty,
    required this.bookingDay,
    required this.bookingTime,
    required this.type,
    required this.price,
    required this.finalPrice,
    this.onDeleteTap,
    required this.controller,
    required this.appointment,
    required this.services,
  });

  @override
  State<CustomBAppointmentListItem> createState() =>
      _CustomBAppointmentListItemState();
}

class _CustomBAppointmentListItemState
    extends State<CustomBAppointmentListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorsData.cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                foregroundImage: CachedNetworkImageProvider(widget.imageUrl),
                backgroundColor: ColorsData.secondary,
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: ColorsData.font,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      height: 16.h,
                      width: 16.w,
                      AssetsData.paymentIcon,
                      colorFilter: const ColorFilter.mode(
                        ColorsData.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "cashMethod".tr,
                      style:
                          Styles.textStyleS10W400(color: ColorsData.secondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // **Name**
          Text(
            widget.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),

          // **Location**
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                height: 16.h,
                width: 16.w,
                AssetsData.mapPinIcon,
                colorFilter: const ColorFilter.mode(
                  ColorsData.primary,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                  child: FutureBuilder<String>(
                future: widget.appointment.barber.location?.getAddress(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading address...");
                  }
                  if (snapshot.hasError) {
                    return Text("Error loading address");
                  }
                  return Text(
                    snapshot.data ?? "Address not available",
                    style: Styles.textStyleS12W400(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  );
                },
              )),
            ],
          ),
          SizedBox(height: 12.h),

          // **Details in Rows**
          _infoRow("service".tr, widget.service),
          _infoRow("Qty".tr, widget.qty),
          _infoRow("bookingDay".tr, widget.bookingDay),
          _infoRow("bookingTime".tr, widget.bookingTime),
          _infoRow("type".tr, widget.type),

          SizedBox(height: 12.h),

          // **Price Details**
          Divider(color: Colors.white.withOpacity(0.3)),
          SizedBox(height: 8.h),
          _infoRow("price".tr, "\$ ${widget.price.toStringAsFixed(2)}"),
          _infoRow(
              "finalPrice".tr, "\$ ${widget.finalPrice.toStringAsFixed(2)}",
              color: ColorsData.primary),
          SizedBox(height: 12.h),

          // **Buttons**
          // Row(
          //   children: [
          //     Expanded(
          //       child: _customButton(
          //         "change".tr,
          //         ColorsData.primary,
          //         () {
          //           showChangeTimeBottomSheet(context, bookingDay, id);
          //         },
          //       ),
          //     ),
          //     SizedBox(width: 12.w),
          //     Expanded(
          //       child: _customButton(
          //         "Didn’t come".tr,
          //         ColorsData.cardStrock,
          //         () {
          //           showDeleteAppointmentDialog(
          //             context: context,
          //             onYes: () {
          //               onDeleteTap?.call();
          //             },
          //             onNo: () {},
          //           );
          //         },
          //       ),
          //     ),
          //   ],
          // ),
          // داخل Row الأزرار
          Row(
            children: [
              if (DateTime.now().isBefore(widget.appointment.startDate
                  .subtract(const Duration(minutes: 30))))
                Expanded(
                  child: _customButton(
                    "delete".tr,
                    Colors.red,
                    () => showDeleteAppointmentDialog(
                      context: context,
                      onYes: () => widget.controller
                          .deleteAppointment(widget.appointment.id),
                      onNo: () {},
                    ),
                  ),
                ),
              if (DateTime.now().isAfter(
                  widget.appointment.startDate.add(const Duration(minutes: 5))))
                Expanded(
                  child: _customButton(
                    "Didn’t come".tr,
                    Colors.orange,
                    () => showDidNotComeDialog(
                      context: context,
                      onYes: () => showDeleteAppointmentDialog(
                        context: context,
                        onYes: () => widget.onDeleteTap?.call(),
                        onNo: () {},
                      ),
                    ),
                  ),
                ),
              SizedBox(width: 12.w),
              Expanded(
                child: _customButton(
                  "change".tr,
                  ColorsData.primary,
                  () => showChangeTimeBottomSheet(
                    context,
                    widget.bookingDay,
                    widget.id,
                    widget.services,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> showDidNotComeDialog({
    required BuildContext context,
    required VoidCallback onYes,
  }) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Confirmation".tr),
        content: Text("Are you sure the customer didn’t come?".tr,
            style: TextStyle(fontSize: 16, color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("No".tr),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              onYes();
            },
            child: Text("Yes".tr),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String value, {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Styles.textStyleS12W400(),
          ),
          Text(
            value,
            style: Styles.textStyleS12W400(color: color),
          ),
        ],
      ),
    );
  }

  Widget _customButton(String text, Color color, void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.r),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
