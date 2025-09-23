import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/main.dart';

class CustomBDrawer extends StatefulWidget {
  const CustomBDrawer({super.key});

  @override
  _CustomBDrawerState createState() => _CustomBDrawerState();
}

class _CustomBDrawerState extends State<CustomBDrawer> {
  bool isNotificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorsData.secondary,
      width: 311.w,
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none, // Add this to allow child to overflow
                children: [
                  // Cover image container (background layer)
                  if (coverImage.isNotEmpty)
                    Container(
                      width: double.infinity,
                      height: 127.h,
                      decoration: BoxDecoration(
                        color: ColorsData.secondary,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          alignment: Alignment.topCenter,
                          image: CachedNetworkImageProvider(coverImage),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x1A000000),
                            offset: Offset(0, -1),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                    ),

                  // Profile image (foreground layer)
                  if (profileImage.isNotEmpty)
                    Positioned(
                      top: 80.h,
                      left: 19.w,
                      child: InkWell(
                        onTap: () {
                          Get.toNamed(AppRouter.bprofilePath);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 43.r,
                            backgroundColor: ColorsData.secondary,
                            child: CircleAvatar(
                              radius: 35.r,
                              foregroundImage:
                                  CachedNetworkImageProvider(profileImage),
                              backgroundColor: ColorsData.secondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 45.h,
                  horizontal: 19.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 277.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: Styles.textStyleS16W700(),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "\u200E$phoneNumber",
                            style: Styles.textStyleS20W400(
                                color: ColorsData.primary),
                          ),
                          SizedBox(height: 8.h),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    buildDivider(),
                    SizedBox(
                      height: 10.h,
                    ),
                    buildDrawerItem("Pay to Qcut".tr, AssetsData.paymentIcon,
                        () {
                      Get.toNamed(AppRouter.bpayToQCutPath);
                      //   context.push(AppRouter.bpayToQCutPath);
                    }),
                    SizedBox(
                      height: 10.h,
                    ),
                    buildDivider(),
                    SizedBox(
                      height: 10.h,
                    ),
                    buildDrawerItem("History".tr, AssetsData.bhistoryIcon, () {
                      Get.toNamed(AppRouter.bhistoryPath);
                    }),
                    SizedBox(
                      height: 10.h,
                    ),
                    buildDivider(),
                    buildDrawerItem("Reports".tr, AssetsData.historyIcon, () {
                      Get.toNamed(AppRouter.reportsPath);
                    }),
                    SizedBox(
                      height: 10.h,
                    ),
                    buildDivider(),
                    SizedBox(
                      height: 10.h,
                    ),
                    buildDrawerItem("Setting".tr, AssetsData.settingIcon, () {
                      Get.toNamed(AppRouter.bsettingsPath);
                    }),
                    SizedBox(
                      height: 10.h,
                    ),
                    buildDivider(),
                    SizedBox(
                      height: 10.h,
                    ),
                    buildDrawerItem(
                        "Notifications".tr, AssetsData.notificationsIcon, () {
                      Get.toNamed(AppRouter.notificationPath);
                    }),
                    SizedBox(
                      height: 10.h,
                    ),
                    buildDivider(),
                    SizedBox(
                      height: 10.h,
                    ),
                    buildDrawerItem("Contact us".tr, AssetsData.contactUsIcon,
                        () {
                      Get.toNamed(AppRouter.bconectUsPath);
                    }),
                    SizedBox(
                      height: 10.h,
                    ),
                    buildDivider(),
                    SizedBox(
                      height: 10.h,
                    ),
                    buildDrawerItem("Share".tr, AssetsData.shareIcon, () {}),
                    SizedBox(
                      height: 10.h,
                    ),
                    buildDivider(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDrawerItem(String title, String imagePath, VoidCallback? onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // 👈 makes entire row clickable
      onTap: () {
        Navigator.pop(context);
        if (onTap != null) onTap();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h),
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
                Text(
                  title,
                  style: Styles.textStyleS14W400(),
                ),
              ],
            ),
            SvgPicture.asset(
              AssetsData.rightArrowIcon,
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
