import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_display/views/widgets/show_change_your_picture_dialog.dart';
import 'package:q_cut/modules/customer/features/home_features/profile_feature/views/widgets/show_change_user_info_bottom_sheet.dart';
import 'package:q_cut/modules/customer/features/settings/presentation/views/functions/show_log_out_dialog.dart';
import 'package:q_cut/modules/customer/features/settings/presentation/views/functions/show_my_cards_bottom_sheet.dart';

class MyProfileViewBody extends StatelessWidget {
  const MyProfileViewBody({super.key});

  final String profileDrawerImage =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzph4xv23B3sfc8O09BVewi1IeI-FWnHVvyxsnzqa6muN8-XWy08Vu0teNV7zXZrV1h8M&usqp=CAU";

  final String coverImageUrl =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQzph4xv23B3sfc8O09BVewi1IeI-FWnHVvyxsnzqa6muN8-XWy08Vu0teNV7zXZrV1h8M&usqp=CAU";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: double.infinity,
              height: 250.h,
              decoration: BoxDecoration(
                color: ColorsData.secondary,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  alignment: Alignment.topCenter,
                  image: CachedNetworkImageProvider(coverImageUrl),
                ),
              ),
            ),
            Positioned(
              bottom: 10.h,
              right: 20.w,
              child: CustomBigButton(
                width: 180.w,
                textData: "editYourProfile".tr,
                onPressed: () {
                  showChangeUserInfoBottomSheet(context, null);
                },
              ),
            ),
            Positioned(
              bottom: -50.h,
              left: 46.w,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: ColorsData.secondary,
                child: CircleAvatar(
                  radius: 45,
                  foregroundImage:
                      CachedNetworkImageProvider(profileDrawerImage),
                  backgroundColor: ColorsData.secondary,
                ),
              ),
            ),
            Positioned(
              left: 75.w,
              bottom: -56.h,
              child: MaterialButton(
                onPressed: () {
                  showChangeYourPictureDialog(context);
                },
                child: CircleAvatar(
                  backgroundColor: ColorsData.primary,
                  child: SvgPicture.asset(
                    height: 20.h,
                    width: 20.w,
                    AssetsData.addImageIcon,
                    colorFilter: const ColorFilter.mode(
                      ColorsData.font,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 50.h),
        Padding(
          padding: EdgeInsets.only(top: 5.h, left: 16.w, right: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Rashad", style: Styles.textStyleS16W700()),
              SizedBox(height: 5.h),
              Text("selectLanguage".tr, style: Styles.textStyleS20W400()),
              SizedBox(height: 5.h),
              Text("+971521484151",
                  style: Styles.textStyleS20W400(color: ColorsData.primary)),
              SizedBox(height: 10.h),
              buildDivider(),
              buildDrawerItem("cards".tr, AssetsData.cardsIcon, () {
                showMyCardsBottomSheet(context);
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
              }),
              buildDivider(),
              buildDrawerItem(
                  "changeYourLocation".tr, AssetsData.mapPinIcon, () {}),
              buildDivider(),
              buildDrawerItem("logout".tr, AssetsData.logOutIcon, () {
                showLogoutDialog(context);
              }),
              buildDivider(),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDrawerItem(String title, String imagePath, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
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
                Text(title, style: Styles.textStyleS14W400()),
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
