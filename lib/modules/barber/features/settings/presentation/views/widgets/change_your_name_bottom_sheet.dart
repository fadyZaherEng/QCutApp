import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/auth/views/widgets/custom_text_form.dart';

class ChangeYourNameBottomSheet extends StatelessWidget {
  const ChangeYourNameBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Icon(Icons.close, size: 24.sp),
              ),
            ),
            SizedBox(height: 5.h),
            Center(
              child: SvgPicture.asset(
                height: 32.h,
                width: 24.w,
                AssetsData.profileIcon,
                colorFilter: const ColorFilter.mode(
                  ColorsData.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              "changeYourName".tr,
              style: Styles.textStyleS14W700(color: ColorsData.secondary),
            ),
            SizedBox(height: 16.h),
            CustomTextFormField(
              hintText: "enterYourNewName".tr,
              fillColor: ColorsData.font,
              style: Styles.textStyleS14W400(color: ColorsData.secondary),
            ),
            SizedBox(height: 16.h),
            CustomBigButton(textData: "confirm".tr, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
