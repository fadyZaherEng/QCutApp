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
import 'package:q_cut/modules/auth/views/widgets/custom_text_form.dart';

class PaymentDetailsBottomSheet extends StatelessWidget {
  const PaymentDetailsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController cardNumberController = TextEditingController();
    TextEditingController expiryDateController = TextEditingController();
    TextEditingController cvcController = TextEditingController();

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
                AssetsData.paymentIcon,
                colorFilter: const ColorFilter.mode(
                  ColorsData.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Center(
              child: Text(
                "visaMethods".tr,
                style: Styles.textStyleS14W700(color: ColorsData.secondary),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "nameOnCard".tr,
              style: Styles.textStyleS14W400(color: ColorsData.secondary),
            ),
            CustomTextFormField(
              hintText: "enterYourName".tr,
              fillColor: ColorsData.font,
              style: Styles.textStyleS14W400(color: ColorsData.secondary),
            ),
            SizedBox(height: 16.h),
            Text(
              "cardNumber".tr,
              style: Styles.textStyleS14W400(color: ColorsData.secondary),
            ),
            CustomTextFormField(
              hintText: "enterYourCardNumber".tr,
              fillColor: ColorsData.font,
              style: Styles.textStyleS14W400(color: ColorsData.secondary),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "expiryDate".tr,
                        style: Styles.textStyleS14W400(
                            color: ColorsData.secondary),
                      ),
                      CustomTextFormField(
                        hintText: "enterExpiryDate".tr,
                        fillColor: ColorsData.font,
                        style: Styles.textStyleS14W400(
                            color: ColorsData.secondary),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "cvc".tr,
                        style: Styles.textStyleS14W400(
                            color: ColorsData.secondary),
                      ),
                      CustomTextFormField(
                        hintText: "enterCvc".tr,
                        fillColor: ColorsData.font,
                        style: Styles.textStyleS14W400(
                            color: ColorsData.secondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            CustomBigButton(
              textData: "add".tr,
              onPressed: () {
                context.push(AppRouter.myProfilePath);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CreditPaymentDetailsBottomSheet extends StatelessWidget {
  const CreditPaymentDetailsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController cardNumberController = TextEditingController();
    TextEditingController expiryDateController = TextEditingController();
    TextEditingController cvcController = TextEditingController();

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
                AssetsData.paymentIcon,
                colorFilter: const ColorFilter.mode(
                  ColorsData.primary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Center(
              child: Text(
                "visaMethods".tr,
                style: Styles.textStyleS14W700(color: ColorsData.secondary),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "nameOnCard".tr,
              style: Styles.textStyleS14W400(color: ColorsData.secondary),
            ),
            CustomTextFormField(
              hintText: "enterYourName".tr,
              fillColor: ColorsData.font,
              style: Styles.textStyleS14W400(color: ColorsData.secondary),
            ),
            SizedBox(height: 16.h),
            Text(
              "cardNumber".tr,
              style: Styles.textStyleS14W400(color: ColorsData.secondary),
            ),
            CustomTextFormField(
              hintText: "enterYourCardNumber".tr,
              fillColor: ColorsData.font,
              style: Styles.textStyleS14W400(color: ColorsData.secondary),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "expiryDate".tr,
                        style: Styles.textStyleS14W400(
                            color: ColorsData.secondary),
                      ),
                      CustomTextFormField(
                        hintText: "enterExpiryDate".tr,
                        fillColor: ColorsData.font,
                        style: Styles.textStyleS14W400(
                            color: ColorsData.secondary),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "cvc".tr,
                        style: Styles.textStyleS14W400(
                            color: ColorsData.secondary),
                      ),
                      CustomTextFormField(
                        hintText: "enterCvc".tr,
                        fillColor: ColorsData.font,
                        style: Styles.textStyleS14W400(
                            color: ColorsData.secondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            CustomBigButton(
              textData: "confirm".tr,
              onPressed: () {
                context.push(AppRouter.homPath);
              },
            ),
          ],
        ),
      ),
    );
  }
}
