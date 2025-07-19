// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/view_custom_button.dart';
import 'package:q_cut/modules/customer/features/home_features/home/models/barber_model.dart';

class CustomBarberShopWideCard extends StatelessWidget {
  final Barber barber;
  const CustomBarberShopWideCard({
    super.key,
    required this.barber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343.w,
      height: 274.h,
      decoration: BoxDecoration(
          color: ColorsData.cardColor,
          borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: barber.coverPic != null && barber.coverPic!.isNotEmpty
                  ? Image.network(
                      barber.coverPic!,
                      width: 343.w,
                      height: 161.h,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        AssetsData.barberSalonImage,
                        width: 343.w,
                        height: 161.h,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      AssetsData.barberSalonImage,
                      width: 343.w,
                      height: 161.h,
                      fit: BoxFit.cover,
                    )),
          Padding(
            padding:
                EdgeInsets.only(left: 12.w, right: 12.w, bottom: 8.h, top: 5.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(barber.barberShop ?? 'barberSalon'.tr,
                    style: Styles.textStyleS14W400()),
                SizedBox(height: 4.h),
                Text(barber.fullName.splitMapJoin(', '),
                    style: Styles.textStyleS10W400(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      AssetsData.mapPinIcon,
                      width: 12.w,
                      height: 12.h,
                      colorFilter: const ColorFilter.mode(
                          ColorsData.font, BlendMode.srcIn),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(barber.city,
                          style: Styles.textStyleS10W400(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                ViewCustomButton(
                  height: 28.h,
                  width: double.infinity,
                  onPressed: () {
                    Get.toNamed(AppRouter.selectedPath, arguments: barber);
                  },
                  text: "view".tr,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
