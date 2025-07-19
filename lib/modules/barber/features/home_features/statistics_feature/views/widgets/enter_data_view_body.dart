import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/modules/auth/views/widgets/custom_text_form.dart';
import 'package:q_cut/modules/barber/features/home_features/statistics_feature/views/widgets/ChooseWorkingDaysBottomSheet.dart';

class EnterDataViewBody extends StatelessWidget {
  const EnterDataViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Profile Photo Selection
          Text("Select Profile Photo",
              style: Styles.textStyleS14W700(color: ColorsData.primary)),
          SizedBox(height: 16.h),
          _buildProfilePhotoSelector(),

          SizedBox(height: 24.h),

          /// Cover Photo Selection
          Text("Select Cover Photo",
              style: Styles.textStyleS14W700(color: ColorsData.primary)),
          SizedBox(height: 16.h),
          _buildCoverPhotoSelector(),

          SizedBox(height: 24.h),

          /// Personal Details
          Text("Enter Your details",
              style: Styles.textStyleS14W700(color: ColorsData.primary)),
          SizedBox(height: 16.h),

          _buildInputField("Enter your Full name", ""),
          _buildInputField("Enter your Phone number", ""),
          _buildInputField("Enter your Barber Shop", ""),
          _buildInputField("Enter your City", ""),
          _buildInputField("Enter Bank account", ""),
          _buildInputField("Enter Instagram page", ""),

          _buildNoteText("It's not necessary if you haven't"),

          /// Off Day Selection
          _buildDropdownField("Enter Your Off day", () {
            showChooseWorkingDaysBottomSheet(context);
          }),

          _buildNoteText("It's not necessary if you haven't"),

          SizedBox(height: 16.h),

          /// Confirm Button
          _buildConfirmButton(context),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  /// Profile Photo Selector Widget
  Widget _buildProfilePhotoSelector() {
    return Center(
      child: Container(
        width: 90.r,
        height: 90.r,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: ColorsData.cardStrock, width: 1),
        ),
        child: Center(
            child: SvgPicture.asset(
          AssetsData.addImageIcon,
          height: 36.h,
          width: 36.w,
        )),
      ),
    );
  }

  Widget _buildCoverPhotoSelector() {
    return Container(
      height: 130.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: ColorsData.cardStrock, width: 1),
      ),
      child: Center(
          child: SvgPicture.asset(
        AssetsData.addImageIcon,
        height: 89.h,
        width: 89.w,
      )),
    );
  }

  Widget _buildInputField(String label, String initialValue) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: CustomTextFormField(
        fillColor: Colors.transparent,
        hintText: label,
        style: Styles.textStyleS14W400(color: Colors.white),
      ),
    );
  }

  Widget _buildDropdownField(String label, void Function()? onTap) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            border: Border.all(color: ColorsData.cardStrock, width: 1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: Styles.textStyleS14W400(color: ColorsData.cardStrock)),
              const Icon(Icons.keyboard_arrow_down,
                  color: ColorsData.cardStrock),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoteText(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child:
          Text(text, style: Styles.textStyleS14W400(color: ColorsData.primary)),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorsData.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: () {},
        child: Text("Confirm",
            style: Styles.textStyleS16W600(color: Colors.white)),
      ),
    );
  }
}
