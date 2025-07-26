import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
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
            onTap: () async {
              final instagramUrl =
                  controller.profileData.value?.instagramPage?.trim();

              // تأكد من أن الرابط موجود ويبدأ بـ http أو https
              if (instagramUrl != null &&
                  instagramUrl.isNotEmpty &&
                  Uri.tryParse(instagramUrl)?.hasAbsolutePath == true) {
                try {
                  final uri = Uri.parse(instagramUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    showErrorSnackBar(context, "Could not open Instagram link");
                  }
                } catch (e) {
                  showErrorSnackBar(context, "Invalid Instagram link");
                }
              } else {
                showErrorSnackBar(context, "Instagram link is not set");
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

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('⚠️ $message'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
