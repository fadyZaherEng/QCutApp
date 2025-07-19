// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:q_cut/core/utils/constants/assets_data.dart';
// import 'package:q_cut/core/utils/constants/colors_data.dart';
// import 'package:q_cut/core/utils/constants/drawer_constants.dart';
// import 'package:q_cut/core/utils/styles.dart';
// import 'package:q_cut/core/utils/widgets/custom_button.dart';

// class BNotificationViewBody extends StatelessWidget {
//   const BNotificationViewBody({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding:  EdgeInsets.symmetric(horizontal: 20.w),
//       child: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8.r),
//               color: ColorsData.cardColor,
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 32.r,
//                       foregroundImage:
//                           const CachedNetworkImageProvider(DrawerConstants.defaultProfileImage),
//                       backgroundColor: ColorsData.secondary,
//                     ),
//                   SizedBox(width: 7.w,),  Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                       Text("Reminder for appointment",style: Styles.textStyleS14W700(),),
//                       Text("Your appointment is scheduled for [28 . 2 . 24],  \n[9:00 PM]. Please make sure to arrive on time.",style: Styles.textStyleS10W400(),),

//                     ],),
//                   ],
//                 ),
//               Padding(
//                 padding:  EdgeInsets.only(top: 16.h),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                   CustomButton(
//                     width: 138.w,
//                     text: "Yes", onPressed: () {

//                   },),
//                 // SizedBox(width:8.w,),

//                  CustomButton(backgroundColor: ColorsData.cardStrock,
//                     width: 138.w,
//                     text: "No", onPressed: () {

//                   },),

//                 ],),
//               ),
//               ],
//             ),
//           ),

// SizedBox(height: 16.h,),

//          Container(
//             padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8.r),
//               color: ColorsData.cardColor,
//             ),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 32.r,
//                   foregroundImage:
//                       const CachedNetworkImageProvider(DrawerConstants.defaultProfileImage),
//                   backgroundColor: ColorsData.secondary,
//                 ),
//               SizedBox(width: 7.w,),  Text("You have been accepted from \nwaiting list",style: Styles.textStyleS14W700(),),
//               ],
//             ),
//           ),
// SizedBox(height: 16.h,),

//   Container(
//             padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 20.h),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8.r),
//               color: ColorsData.cardColor,
//             ),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 26.r,
//                   foregroundImage:
// const AssetImage(AssetsData.circleQCutImage),                  backgroundColor: ColorsData.secondary,
//                 ),
//               SizedBox(width: 7.w,),  Column(crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("QCUT",style: Styles.textStyleS14W700(),),
//                   Text("Don’t Forget you r appointment at Salon tomorrow  \nfrom 8:30 pm  ton  9:00pm. ",style: Styles.textStyleS10W400(),),
//                 ],
//               ),
//               ],
//             ),
//           ),

//         ],
//       ),
//     );
//   }
// }

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
