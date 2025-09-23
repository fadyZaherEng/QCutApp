import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';

class BookPaymentItemModel {
  final String? imageUrl;
  final String? shopName;
  final String? location;
  final String? service;
  final double? price;
  final int? quantity;
  final String? bookingDay;
  final String? bookingTime;
  final String? type;

  BookPaymentItemModel({
    this.imageUrl,
    this.shopName,
    this.location,
    this.service,
    this.price,
    this.quantity,
    this.bookingDay,
    this.bookingTime,
    this.type,
  });
}

class CustomBookPaymentMethodsItem extends StatelessWidget {
  final BookPaymentItemModel? model;

  const CustomBookPaymentMethodsItem({
    super.key,
    this.model,
  });

  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (!isRTL) _buildImageContainer(context, isRTL),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: !isRTL ? 4.w : 0,
              right: isRTL ? 4.w : 0,
              bottom: 4.h,
              top: 4.h,
            ),
            child: Container(
              width: double.infinity,
              // height: 194.h,
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
                          model?.shopName ?? "barberShop".tr,
                          style: Styles.textStyleS12W700(),
                        ),
                        const Spacer(),
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
                        Text(
                          model?.location ?? 'yourLocation'.tr,
                          style: Styles.textStyleS12W400(),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    _buildInfoRow("service".tr, model!.service!),
                    _buildInfoRow("servicePrice".tr, "\$ ${model?.price!}"),
                    _buildInfoRow(
                        "qty".tr, "${model?.quantity ?? 1} ${"consumer".tr}"),
                    _buildInfoRow("bookingDay".tr, model!.bookingDay!),
                    _buildInfoRow("bookingTime".tr, model!.bookingTime!),
                    _buildInfoRow("booking".tr, model?.type ?? "booking".tr),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (isRTL) _buildImageContainer(context, isRTL),
      ],
    );
  }

  Widget _buildImageContainer(BuildContext context, bool isRTL) {
    return Container(
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
          topLeft: Radius.circular(16.r),
          bottomLeft: Radius.circular(16.r),
        ),
        child: Image.asset(
          model?.imageUrl ?? AssetsData.myAppointmentImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Text(
            label,
            style: Styles.textStyleS10W400(),
          ),
          const Spacer(),
          Text(
            value,
            style: Styles.textStyleS10W400(),
          ),
        ],
      ),
    );
  }
}
