import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/modules/barber/features/home_features/appointment_feature/views/change_time_bottom_sheet.dart';
import 'package:q_cut/modules/customer/features/home/presentation/views/widgets/show_delete_appointment_dialog.dart';

class CustomBAppointmentListItem extends StatelessWidget {
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
  });

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
                foregroundImage: CachedNetworkImageProvider(imageUrl),
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
                      "Cash method",
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
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),

          // **Location**
          Row(
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
                child: Text(
                  location,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // **Details in Rows**
          _infoRow("Service", service),
          _infoRow("Qty", qty),
          _infoRow("Booking day", bookingDay),
          _infoRow("Booking time", bookingTime),
          _infoRow("Type", type),

          SizedBox(height: 12.h),

          // **Price Details**
          Divider(color: Colors.white.withOpacity(0.3)),
          SizedBox(height: 8.h),
          _infoRow("Price", "\$ ${price.toStringAsFixed(2)}"),
          _infoRow("Final price", "\$ ${finalPrice.toStringAsFixed(2)}",
              color: ColorsData.primary),
          SizedBox(height: 12.h),

          // **Buttons**
          Row(
            children: [
              Expanded(
                child: _customButton(
                  "Change",
                  ColorsData.primary,
                  () {
                    showChangeTimeBottomSheet(context, bookingDay, id);
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _customButton(
                  "Didn’t come",
                  ColorsData.cardStrock,
                  () {
                    showDeleteAppointmentDialog(
                      context: context,
                      onYes: () {
                        onDeleteTap?.call();
                      },
                      onNo: () {},
                    );
                  },
                ),
              ),
            ],
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
            style: Styles.textStyleS10W400(),
          ),
          Text(
            value,
            style: Styles.textStyleS10W400(color: color),
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
