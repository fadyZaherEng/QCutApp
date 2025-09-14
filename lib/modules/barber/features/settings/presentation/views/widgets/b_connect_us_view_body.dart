import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../home_features/profile_features/profile_display/logic/b_profile_controller.dart';

class BConnectUsViewBody extends StatelessWidget {
  final BProfileController controller = Get.put(BProfileController());

  BConnectUsViewBody({super.key});

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
          SizedBox(height: 32.h),
          Text(
            "You can contact by".tr,
            style: Styles.textStyleS16W700(color: ColorsData.primary),
          ),
          SizedBox(height: 16.h),
          InkWell(
            onTap: () async {
              final instagramUrl =
                  "https://www.instagram.com/moataz.abnha?igsh=MW12b2JyYzJtMjY0bA%3D%3D&utm_source=qr";
              try {
                final uri = Uri.parse(instagramUrl);
                   await launchUrl(uri);
              } catch (e) {
                showErrorSnackBar(context, "Instagram link is not set".tr);
              }
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  height: 22.h,
                  width: 22.w,
                  AssetsData.instagramIcon,
                  colorFilter: const ColorFilter.mode(
                    ColorsData.primary,
                    BlendMode.srcIn,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  "INSTGRAM".tr,
                  style: Styles.textStyleS16W400(),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
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
                SizedBox(width: 8.w),
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

  void openLink(String url, BuildContext context) async {
    try {
      await launch(url);
    } catch (e) {
      showErrorSnackBar(context, "Invalid Instagram link");
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('⚠️ $message'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
