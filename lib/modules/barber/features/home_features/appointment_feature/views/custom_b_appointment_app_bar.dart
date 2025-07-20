import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/modules/barber/features/home_features/appointment_feature/logic/appointment_controller.dart';

class CustomBAppointmentAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomBAppointmentAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BAppointmentController());

    return Row(
      children: [
        Row(
          children: [
            SvgPicture.asset(
              AssetsData.mapPinIcon,
              width: 24.w,
              height: 24.h,
              colorFilter: const ColorFilter.mode(
                ColorsData.primary,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 2.w),
            //TODO : add address
            Text(
              '208 , New Gaza, New Gaza',
              style: Styles.textStyleS12W400(),
            ),
            SizedBox(width: 2.w),
            SvgPicture.asset(
              AssetsData.downArrowIcon,
              width: 24.w,
              height: 24.h,
              colorFilter: const ColorFilter.mode(
                ColorsData.font,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
        const Spacer(),
        InkWell(
            onTap: () {
              Get.toNamed(AppRouter.notificationPath);
            },
            child: SvgPicture.asset(
              AssetsData.notificationsIcon,
              width: 24,
              height: 24,
            )),
        SizedBox(width: 11.w),
        InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: SvgPicture.asset(
              AssetsData.menuIcon,
              width: 24,
              height: 24,
            )),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(67.h);
}
