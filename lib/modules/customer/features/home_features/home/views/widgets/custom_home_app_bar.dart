import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/main.dart';

class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: SvgPicture.asset(
              AssetsData.menuIcon,
              width: 24,
              height: 24,
            )),
        SizedBox(
          width: 11.w,
        ),
        InkWell(
            onTap: () {
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
          onTap: () {},
          child: SvgPicture.asset(
            AssetsData.searchIcon,
            width: 24,
            height: 24,
          ),
        ),
        const Spacer(),
        CircleAvatar(
          radius: 24,
          backgroundImage: CachedNetworkImageProvider(
            profileImage,
            errorListener: (exception) =>
                print("Error loading image: $exception"),
          ),
          onBackgroundImageError: (exception, stackTrace) =>
              const Icon(Icons.person, color: Colors.white),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(67.h);
}
