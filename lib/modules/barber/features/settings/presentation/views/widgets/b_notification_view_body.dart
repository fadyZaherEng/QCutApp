import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/constants/drawer_constants.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';

class BNotificationViewBody extends StatelessWidget {
  const BNotificationViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          _buildNotificationCard(
            imageUrl: DrawerConstants.defaultProfileImage,
            title: "Mohamed",
            subtitle: "Mohamed Accept changing time to 9 PM to 9:30 PM",
          ),
          SizedBox(height: 12.h),
          _buildNotificationCard(
            imageUrl: DrawerConstants.defaultProfileImage,
            title: "reminderForHisJob".tr,
            subtitle: "youStartWorkingInAnHour".tr,
          ),
          SizedBox(height: 12.h),
          _buildOfferCard(),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String imageUrl,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: ColorsData.cardColor,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            foregroundImage: CachedNetworkImageProvider(imageUrl),
            backgroundColor: ColorsData.secondary,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Styles.textStyleS14W700()),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: Styles.textStyleS12W400(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: ColorsData.cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                foregroundImage: const AssetImage(AssetsData.circleQCutImage),
                backgroundColor: ColorsData.secondary,
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("qcut".tr, style: Styles.textStyleS14W700()),
                  Text("qcutSendOfferToYou".tr,
                      style: Styles.textStyleS12W400()),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          CustomBigButton(
            textData: "showOfferDetails".tr,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
