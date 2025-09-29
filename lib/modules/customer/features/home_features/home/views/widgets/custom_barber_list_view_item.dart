import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/view_custom_button.dart';
import 'package:q_cut/modules/customer/features/home_features/home/models/barber_model.dart';

class CustomBarberListViewItem extends StatelessWidget {
  final Barber? barber;

  const CustomBarberListViewItem({
    super.key,
    this.barber,
  });

  @override
  Widget build(BuildContext context) {
    // Use static data if barber is null
    final String barberName = barber?.fullName ?? 'barberName'.tr;
    final String barberShop = barber?.barberShop ?? 'barberSalon'.tr;
    final String city = barber?.city ?? 'city'.tr;

    return Container(
      width: 211.w,
      height: 300.h,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          color: ColorsData.cardColor,
          borderRadius: BorderRadius.circular(16.r)),
      child: Column(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: barber?.coverPic != null
                  ? CachedNetworkImage(
                      imageUrl: barber!.coverPic!,
                      width: 211.w,
                      height: 170.h,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                          child:
                              SpinKitDoubleBounce(color: ColorsData.primary)),
                      errorWidget: (context, url, error) => Image.asset(
                        AssetsData.barberSalonImage,
                        width: 211.w,
                        height: 170.h,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.asset(
                      AssetsData.barberSalonImage,
                      width: 211.w,
                      height: 170.h,
                      fit: BoxFit.cover,
                    )),
          Padding(
            padding:
                EdgeInsets.only(left: 12.w, right: 12.w, bottom: 8.h, top: 5.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(barberShop, style: Styles.textStyleS14W400()),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    SvgPicture.asset(
                      AssetsData.personIcon,
                      width: 18.w,
                      height: 18.h,
                      colorFilter: const ColorFilter.mode(
                        ColorsData.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        barberName,
                        style: Styles.textStyleS13W400(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    SvgPicture.asset(
                      AssetsData.mapPinIcon,
                      width: 18.w,
                      height: 18.h,
                      colorFilter: const ColorFilter.mode(
                          ColorsData.primary, BlendMode.srcIn),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        city,
                        style: Styles.textStyleS13W400(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                ViewCustomButton(
                  text: "View".toLowerCase().tr,
                  onPressed: () {
                    Get.toNamed(AppRouter.selectedPath, arguments: barber);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
