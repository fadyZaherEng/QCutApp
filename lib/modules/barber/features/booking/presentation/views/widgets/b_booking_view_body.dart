import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_display/views/widgets/show_how_many_consumer_bottom_sheet.dart';

class BBookingViewBody extends StatelessWidget {
  const BBookingViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Center(
            child: Text(
              "newAppointmentDetails".tr,
              style: Styles.textStyleS16W700(color: ColorsData.bodyFont),
            ),
          ),
          SizedBox(height: 16.h),
          _buildTextField("enterConsumerName".tr),
          SizedBox(height: 10.h),
          _buildTextField("enterPhoneNumber".tr),
          SizedBox(height: 16.h),
          CustomBigButton(
            textData: "quantity".tr,
            onPressed: () {
              showHowManyConsumerBottomSheet(context);
            },
          ),
          SizedBox(height: 16.h),
          Center(
            child: Text(
              "yourAvailableService".tr,
              style: Styles.textStyleS14W700(color: ColorsData.bodyFont),
            ),
          ),
          SizedBox(height: 10.h),
          // Expanded(
          //   child: GridView.builder(
          //     padding: EdgeInsets.only(bottom: 16.h),
          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //       crossAxisCount: 2,
          //       crossAxisSpacing: 12.w,
          //       mainAxisSpacing: 12.h,
          //       childAspectRatio: 0.8,
          //     ),
          //     itemCount: 6,
          //     itemBuilder: (context, index) => const BarberServiceCard(),
          //   ),
          // ),
          SizedBox(height: 10.h),
          CustomBigButton(
            textData: "continue".tr,
            height: 45.h,
            onPressed: () {
              context.push(AppRouter.bavailableAppointmentsPath);
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildTextField(String hintText) {
    return TextField(
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Styles.textStyleS14W400(color: ColorsData.bodyFont),
        filled: true,
        fillColor: ColorsData.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: ColorsData.cardStrock),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      ),
    );
  }
}
