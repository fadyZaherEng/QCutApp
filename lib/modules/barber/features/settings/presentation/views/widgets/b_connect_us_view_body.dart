import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/models/barber_profile_model.dart';
import 'package:url_launcher/url_launcher.dart';

class BConnectUsViewBody extends StatelessWidget {
  const BConnectUsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 32.h, left: 15.w, right: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SvgPicture.asset(
              AssetsData.connectUsImage,
              width: 254.w,
              height: 190.h,
            ),
          ),
          SizedBox(
            height: 32.h,
          ),
          Text(
            "You can contact by".tr,
            style: Styles.textStyleS16W700(color: ColorsData.primary),
          ),
          SizedBox(
            height: 16.h,
          ),
          InkWell(
            onTap: () {
              final BarberProfileModel initialData =
                  Get.arguments as BarberProfileModel;
              try {
                launch(initialData.instagramPage).then((value) {});
              } catch (e) {
                print(e);
                Get.snackbar("Error".tr, "Instagram link is not set".tr);
              }
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  height: 24.h,
                  width: 24.w,
                  AssetsData.changeLanguagesIcon,
                ),
                SizedBox(
                  width: 8.w,
                ),
                Text(
                  "Instagram".tr,
                  style: Styles.textStyleS16W400(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 24.h,
          ),
          InkWell(
            onTap: () {
              Get.toNamed(AppRouter.chatWithUsPath);
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  height: 24.h,
                  width: 24.w,
                  AssetsData.messageIcon,
                  colorFilter: const ColorFilter.mode(
                    ColorsData.primary,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                Text(
                  "Chat with us".tr,
                  style: Styles.textStyleS16W400(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
