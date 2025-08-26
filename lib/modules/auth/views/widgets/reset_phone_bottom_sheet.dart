import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/auth/logic/controller/reset_phone_controller.dart';
import 'package:q_cut/modules/auth/views/widgets/custom_text_form.dart';

class ResetPhoneBottomSheet extends StatelessWidget {
  final ResetPhoneController controller;

  const ResetPhoneBottomSheet({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: double.infinity,
        height: 403.h,
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 48.h),
        decoration: BoxDecoration(
          color: ColorsData.font,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Icon(Icons.close, size: 24.sp),
                ),
              ),
              SvgPicture.asset(
                AssetsData.callIcon,
                height: 24.h,
                width: 24.w,
              ),
              SizedBox(height: 12.h),
              Text(
                "Reset Phone number",
                style: Styles.textStyleS14W700(color: ColorsData.secondary),
              ),
              SizedBox(height: 12.h),
              CustomTextFormField(
                style: Styles.textStyleS14W500(color: ColorsData.secondary),
                fillColor: ColorsData.font,
                hintText: "Enter your Phone number",
                keyboardType: TextInputType.phone,
                controller: controller.oldPhoneController,
              ),
              SizedBox(height: 12.h),
              CustomTextFormField(
                style: Styles.textStyleS14W500(color: ColorsData.secondary),
                fillColor: ColorsData.font,
                hintText: "Enter your New Phone number",
                keyboardType: TextInputType.phone,
                controller: controller.newPhoneController,
              ),
              SizedBox(height: 12.h),
              Obx(
                () => CustomBigButton(
                  textData:
                      controller.isLoading.value ? "Processing..." : "Confirm",
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.resetPhoneNumber(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BResetPhoneBottomSheet extends StatelessWidget {
  final ResetPhoneController controller;

  const BResetPhoneBottomSheet({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: double.infinity,
        height: 403.h,
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 48.h),
        decoration: BoxDecoration(
          color: ColorsData.font,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Icon(Icons.close, size: 24.sp),
                ),
              ),
              SvgPicture.asset(
                AssetsData.callIcon,
                height: 24.h,
                width: 24.w,
              ),
              SizedBox(height: 12.h),
              Text(
                "Reset Phone number",
                style: Styles.textStyleS14W700(color: ColorsData.secondary),
              ),
              SizedBox(height: 12.h),
              CustomTextFormField(
                style: Styles.textStyleS14W500(color: ColorsData.secondary),
                fillColor: ColorsData.font,
                hintText: "Enter your Phone number",
                keyboardType: TextInputType.phone,
                controller: controller.oldPhoneController,
              ),
              SizedBox(height: 12.h),
              CustomTextFormField(
                style: Styles.textStyleS14W500(color: ColorsData.secondary),
                fillColor: ColorsData.font,
                hintText: "Enter your New Phone number",
                keyboardType: TextInputType.phone,
                controller: controller.newPhoneController,
              ),
              SizedBox(height: 12.h),
              Obx(
                () => CustomBigButton(
                  textData:
                      controller.isLoading.value ? "Processing..." : "Confirm",
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.resetPhoneNumber(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
