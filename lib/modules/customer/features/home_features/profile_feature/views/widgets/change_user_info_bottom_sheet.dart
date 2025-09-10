import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/auth/views/widgets/custom_text_form.dart';
import 'package:q_cut/modules/customer/features/home_features/profile_feature/logic/profile_controller.dart';

class ChangeUserInfoBottomSheet extends StatelessWidget {
  final ProfileController? profileController;
  const ChangeUserInfoBottomSheet({super.key, this.profileController});

  @override
  Widget build(BuildContext context) {
    // Initialize controllers with current values
    profileController!.fullNameController.text =
        profileController!.profileData.value?.fullName ?? '';
    profileController!.emailController.text =
        profileController!.profileData.value?.phoneNumber ?? '';

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
        child: Obx(() => Column(
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
                  style: TextStyle(color: Colors.black, fontSize: 12.sp),
                  controller: profileController!.fullNameController,
                  fillColor: ColorsData.font,
                  hintText: "enterYourName".tr,
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
                  style: TextStyle(color: Colors.black, fontSize: 12.sp),
                  controller: profileController!.emailController,
                  fillColor: ColorsData.font,
                  hintText: profileController!.emailController.text.isEmpty
                      ? "(optional)"
                      : "enterYourPhoneNumber".tr,
                 ),

                SizedBox(height: 20.h),
                CustomBigButton(
                  textData: profileController!.isLoading.value
                      ? "updating".tr
                      : "confirm".tr,
                  onPressed: profileController!.isLoading.value
                      ? null
                      : () async {
                          await profileController!.updateProfile();
                          if (!profileController!.isError.value) {
                            Navigator.pop(context);
                          }
                        },
                ),
              ],
            )),
      ),
    );
  }
}
