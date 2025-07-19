import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';

class CustomBAppointmentAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomBAppointmentAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print("Building CustomBAppointmentAppBar");
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
            SizedBox(
              width: 2.w,
            ),
            Text(
              '208 , New Gaza, New Gaza',
              style: Styles.textStyleS12W400(),
            ),
            SizedBox(
              width: 2.w,
            ),
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
              print("Notification icon tapped, navigating to notifications");
              Get.toNamed(AppRouter.notificationPath);
            },
            child: SvgPicture.asset(
              AssetsData.notificationsIcon,
              width: 24,
              height: 24,
            )),
        SizedBox(
          width: 11.w,
        ),
        InkWell(
            onTap: () {
              print("Menu icon tapped, opening drawer");
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
