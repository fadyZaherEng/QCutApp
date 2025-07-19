import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';

class BChangeLangugesViewBody extends StatelessWidget {
  const BChangeLangugesViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 32.h),
          SvgPicture.asset(AssetsData.cuateImage),
          SizedBox(height: 32.h),
          Text(
            "availableLanguages".tr,
            style: Styles.textStyleS16W700(color: ColorsData.primary),
          ),
          SizedBox(height: 16.h),
          CustomBigButton(
            textData: 'english'.tr,
            onPressed: () {
              context.push(AppRouter.loginPath);
            },
          ),
          SizedBox(height: 24.h),
          CustomBigButton(
            textData: 'arabic'.tr,
            onPressed: () {},
            isCustomStyle: true,
          ),
          SizedBox(height: 24.h),
          CustomBigButton(
            textData: 'hebrew'.tr,
            onPressed: () {},
            isCustomStyle: true,
          ),
        ],
      ),
    );
  }
}
