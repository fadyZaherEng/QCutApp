import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';

class CustomBHistoryItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String location;
  final String service;
  final String hairStyle;
  final String qty;
  final String bookingDay;
  final String bookingTime;
  final String type;
  final double price;
  final double finalPrice;

  const CustomBHistoryItem({
    super.key,
    required this.imageUrl,
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
}
