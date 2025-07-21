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
import 'package:q_cut/main.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_display/views/widgets/show_change_your_picture_dialog.dart';
import 'package:q_cut/modules/customer/features/home_features/profile_feature/logic/profile_controller.dart';
import 'package:q_cut/modules/customer/features/home_features/profile_feature/views/widgets/show_change_user_info_bottom_sheet.dart';
import 'package:q_cut/modules/customer/features/settings/presentation/views/functions/show_log_out_dialog.dart';

class MyProfileView extends StatelessWidget {
  const MyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      body: Obx(() {
        if (profileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (profileController.isError.value) {
          return Center(child: Text(profileController.errorMessage.value));
        }

        final profileData = profileController.profileData.value;

        final String fullName = profileData?.fullName ?? "User";
        final String phoneNumber = profileData?.phoneNumber ?? "";
        final String city = profileData?.city ?? "";

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
                      image: CachedNetworkImageProvider(
                          profileData!.coverPic ?? ""),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10.h,
                  right: Get.locale?.languageCode == 'ar' ||
                          Get.locale?.languageCode == "he"
                      ? null
                      : 20.w,
                  left: Get.locale?.languageCode == 'ar' ||
                          Get.locale?.languageCode == "he"
                      ? 20.w
                      : null,
                  child: CustomBigButton(
                    width: 180.w,
                    textData: "editYourProfile".tr,
                    onPressed: () {
                      showChangeUserInfoBottomSheet(context, profileController);
                    },
                  ),
                ),
                Positioned(
                  bottom: -50.h,
                  left: Get.locale?.languageCode == 'ar' ||
                          Get.locale?.languageCode == "he"
                      ? null
                      : 30.w,
                  right: Get.locale?.languageCode == 'ar' ||
                          Get.locale?.languageCode == "he"
                      ? 30.w
                      : null,
                  child: InkWell(
                    onTap: () => showChangeYourPictureDialog(context),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: ColorsData.secondary,
                          child: CircleAvatar(
                            radius: 55,
                            foregroundImage:
                                CachedNetworkImageProvider(profileImage),
                            backgroundColor: ColorsData.secondary,
                          ),
                        ),
                        Positioned(
                          right: 9,
                          bottom: -3,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                debugPrint("Change your picture clicked");
                                showChangeYourPictureDialog(context);
                              },
                              borderRadius: BorderRadius.circular(45),
                              child: Container(
                                width: 36.17.w,
                                height: 36.17.h,
                                decoration: const BoxDecoration(
                                  color: ColorsData.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AssetsData.addImageIcon,
                                    fit: BoxFit.fill,
                                    width: 25.w,
                                    height: 25.h,
                                    colorFilter: const ColorFilter.mode(
                                      ColorsData.font,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 65.h),
            Container(
              padding: EdgeInsets.only(top: 5.h, left: 16.w, right: 16.w),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                    child: Column(
                      children: [
                        Text(
                          fullName,
                          style: Styles.textStyleS16W700(),
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AssetsData.mapPinIcon,
                              height: 16.h,
                              width: 16.w,
                              colorFilter: const ColorFilter.mode(
                                  ColorsData.primary, BlendMode.srcIn),
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              city,
                              style: Styles.textStyleS14W400(),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Text(  '\u200E$phoneNumber' // LTR override for RTL languages
                              ,
                          style: Styles.textStyleS20W400(
                              color: ColorsData.primary),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  buildDrawerItem("resetPassword".tr,
                      AssetsData.resetPasswordBottomSheetIcon, () {
                    Get.toNamed(AppRouter.resetPasswordPath);
                  }),
                  buildDivider(),
                  buildDrawerItem(
                      "changeLanguage".tr, AssetsData.changeLanguagesIcon, () {
                    Get.toNamed(AppRouter.changeLangugesPath);
                  }),
                  buildDivider(),
                  buildDrawerItem("changePhoneNumber".tr, AssetsData.callIcon,
                      () {
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
      }),
    );
  }
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
                colorFilter:
                    const ColorFilter.mode(ColorsData.primary, BlendMode.srcIn),
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
  return Divider(color: ColorsData.cardStrock.withOpacity(0.3));
}
