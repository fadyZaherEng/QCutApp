import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/main.dart';
import 'package:q_cut/modules/customer/features/settings/presentation/views/functions/show_change_your_name_bottom_sheet.dart';
import 'package:q_cut/modules/customer/features/settings/presentation/views/functions/show_delete_account_dialog.dart';
import 'package:q_cut/modules/customer/features/settings/presentation/views/functions/show_log_out_dialog.dart';

class SettingViewBody extends StatefulWidget {
  const SettingViewBody({super.key});

  @override
  State<SettingViewBody> createState() => _SettingViewBodyState();
}

class _SettingViewBodyState extends State<SettingViewBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 5.h, left: 16.w, right: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
                height: 161.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorsData.cardStrock),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      foregroundImage: CachedNetworkImageProvider(profileImage),
                    ),
                    SizedBox(height: 1.h),
                    Text(fullName, style: Styles.textStyleS16W700()),
                    SizedBox(height: 3.h),
                    Text("\u200E$phoneNumber",
                        style:
                            Styles.textStyleS20W400(color: ColorsData.primary)),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              buildDrawerItem("changeYourName".tr, AssetsData.profileIcon,
                  () async {
                await showChangeYourNameBottomSheet(context);
                // After the bottom sheet is closed, update the UI
                if (mounted) {
                  setState(() {
                    // This will refresh the UI with the updated fullName
                  });
                }
              }),
              buildDivider(),
              buildDrawerItem(
                  "resetPassword".tr, AssetsData.resetPasswordBottomSheetIcon,
                  () {
                Get.toNamed(AppRouter.resetPasswordPath);
              }),
              buildDivider(),
              buildDrawerItem(
                  "changeLanguages".tr, AssetsData.changeLanguagesIcon, () {
                Get.toNamed(AppRouter.changeLangugesPath);
              }),
              buildDivider(),
              buildDrawerItem("changePhoneNumber".tr, AssetsData.callIcon, () {
                Get.toNamed(AppRouter.resetPhoneNumberPath);

                // context.push(AppRouter.resetPhoneNumberPath);
              }),
              buildDivider(),
              buildDrawerItem(
                  "changeYourLocation".tr, AssetsData.mapPinIcon, () {}),
              buildDivider(),
              buildDrawerItem("logout".tr, AssetsData.logOutIcon, () {
                showLogoutDialog(context);
              }),
              buildDivider(),
              buildDrawerItem("deleteAccount".tr, AssetsData.trashIcon, () {
                showDeleteAccountDialog(context);
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDrawerItem(String title, String imagePath, VoidCallback? onTap) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  imagePath,
                  height: 24.h,
                  width: 24.w,
                  colorFilter: const ColorFilter.mode(
                      ColorsData.primary, BlendMode.srcIn),
                ),
                SizedBox(width: 12.w),
                Text(title, style: Styles.textStyleS14W500()),
              ],
            ),
            SvgPicture.asset(
              AssetsData.downArrowIcon,
              height: 24.h,
              width: 24.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDivider() {
    return const Divider(color: ColorsData.cardStrock);
  }
}
