import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/auth/views/widgets/custom_text_form.dart';

class ChangeUserInfoBottomSheet extends StatelessWidget {
  const ChangeUserInfoBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Align(
                alignment: Alignment.topLeft,
                child: Icon(Icons.close, size: 24.sp),
              ),
            ),
            SizedBox(height: 12.h),
            SvgPicture.asset(
              height: 32.h,
              width: 24.w,
              AssetsData.profileIcon,
              colorFilter: const ColorFilter.mode(
                ColorsData.primary,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "changeYourName".tr,
                style: Styles.textStyleS14W700(color: ColorsData.secondary),
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextFormField(
              fillColor: ColorsData.font,
              hintText: "Omar Omar",
              keyboardType: TextInputType.name,
            ),
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "changeYourEmail".tr,
                style: Styles.textStyleS14W700(color: ColorsData.secondary),
              ),
            ),
            SizedBox(height: 8.h),
            CustomTextFormField(
              fillColor: ColorsData.font,
              hintText: "Rezk@gmail.com",
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20.h),
            CustomBigButton(
              textData: "confirm".tr,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
