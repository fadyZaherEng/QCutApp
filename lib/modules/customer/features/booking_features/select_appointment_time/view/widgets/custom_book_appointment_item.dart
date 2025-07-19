import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/modules/customer/features/booking_features/display_barber_services_feature/models/barber_service.dart';

class CustomBookAppointmentItem extends StatelessWidget {
  final List<BarberServices>? services;
  final List<int>? quantities;
  const CustomBookAppointmentItem({super.key, this.services, this.quantities});

  @override
  Widget build(BuildContext context) {
    final int totalPrice = services?.asMap().entries.fold(
            0,
            (sum, entry) =>
                sum! + (entry.value.price * (quantities?[entry.key] ?? 1))) ??
        20;
    final int serviceCount = services?.length ?? 1;
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      height: serviceCount == 1 ? 120.h : serviceCount * 70.h,
      decoration: BoxDecoration(
        color: ColorsData.cardColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          if (!isRTL) ...[
            _buildImageSection(context),
            SizedBox(width: 12.w),
            Expanded(
                child: _buildServiceDetails(context, serviceCount, totalPrice)),
            SizedBox(width: 12.w),
          ] else ...[
            SizedBox(width: 12.w),
            Expanded(
                child: _buildServiceDetails(context, serviceCount, totalPrice)),
            SizedBox(width: 12.w),
            _buildImageSection(context),
          ],
        ],
      ),
    );
  }

  Widget _buildImageSection(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: isRTL ? Radius.zero : Radius.circular(16.r),
        bottomLeft: isRTL ? Radius.zero : Radius.circular(16.r),
        topRight: isRTL ? Radius.circular(16.r) : Radius.zero,
        bottomRight: isRTL ? Radius.circular(16.r) : Radius.zero,
      ),
      child: Image.asset(
        AssetsData.myAppointmentImage,
        width: 120.w,
        height: double.infinity,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _buildServiceDetails(
      BuildContext context, int serviceCount, int totalPrice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "barberShop".tr,
          style: Styles.textStyleS14W700(color: Colors.white),
        ),
        _buildInfoRow("quantity".tr,
            "$serviceCount ${serviceCount > 1 ? 'servicesCount'.tr : 'service'.tr}"),
        if (services != null && services!.isNotEmpty) ...[
          ...services!.asMap().entries.map((entry) => _buildInfoRow(
              "${entry.value.name} x${quantities?[entry.key] ?? 1}",
              "\$ ${entry.value.price * (quantities?[entry.key] ?? 1)}")),
          Column(
            children: [
              Divider(
                color: Colors.grey.withOpacity(0.5),
                thickness: 0.5,
                height: 10.h,
              ),
              _buildInfoRow(
                "total".tr,
                "\$ $totalPrice",
                isTotal: true,
              ),
            ],
          ),
        ] else
          _buildInfoRow("hairCutService".tr, "\$ 20"),
        SizedBox(height: 4.h),
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
              'yourLocation'.tr,
              style: Styles.textStyleS12W400(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          Text(
            label,
            style: isTotal
                ? Styles.textStyleS12W700(color: ColorsData.primary)
                : Styles.textStyleS10W400(),
          ),
          const Spacer(),
          Text(
            value,
            style: isTotal
                ? Styles.textStyleS12W700(color: ColorsData.primary)
                : Styles.textStyleS10W400(),
          ),
        ],
      ),
    );
  }
}
