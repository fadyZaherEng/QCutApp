import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';

class   BChatBubbleForCustomer extends StatelessWidget {
  final String? text;
  final bool isVoice;
 final String profileDrawerImage =
      "https://scontent.fcai20-1.fna.fbcdn.net/v/t39.30808-6/465223480_2413999665617509_3992107229959092312_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=6ee11a&_nc_ohc=-S1A8Wc_GjQQ7kNvgHC2PsS&_nc_oc=AdhKxz3da9Lw4za8QnuJKhLZbB43Z_ecSxVr_nxqyvgPz5iufHt23qP1_Q6H_QX-VP8&_nc_zt=23&_nc_ht=scontent.fcai20-1.fna&_nc_gid=A7p7VxDzf4Qkx0o7FmsWcdx&oh=00_AYBBnZ3fkEQdEVs22CFOV-RZUhRlguKCE_GNl9SD1GhLPQ&oe=67A6C0DD";

  const BChatBubbleForCustomer({
    super.key,
     this.text,
    this.isVoice = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
       CircleAvatar(
               radius: 25.r, 
               foregroundImage: CachedNetworkImageProvider(profileDrawerImage),
               backgroundColor: ColorsData.secondary,
             ),
          SizedBox(width: 8.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 12.h),
              // constraints: BoxConstraints(maxWidth: 0.7.sw),
              decoration: BoxDecoration(
                color: ColorsData.cardColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
              ),
              child: isVoice
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
      SvgPicture.asset(height: 24.h,width: 24.w,
        AssetsData.playCircleIcon,
      
      ),                      SizedBox(width: 10.w),
                        SvgPicture.asset(height: 12.h,width: 119.w,
        AssetsData.recordingTapeIcon,
      
      ),
                      ],
                    )
                  : Text(text!,
                      style: Styles.textStyleS16W400(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}