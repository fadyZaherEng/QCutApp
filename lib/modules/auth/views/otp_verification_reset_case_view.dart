import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/widgets/custom_app_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/auth/logic/controller/otp_verification_controller.dart';
import 'package:q_cut/modules/auth/views/functions/show_reset_password_bottom_sheet.dart';
import 'package:q_cut/modules/auth/views/functions/show_reset_phone_bottom_sheet.dart';
import 'package:q_cut/modules/auth/views/widgets/custom_pin_input.dart';

class OtpVerificationResetCaseView extends StatelessWidget {
  OtpVerificationResetCaseView({super.key});

  final GlobalKey<FormState> _otpVerificationFormKey = GlobalKey<FormState>();
  final bool resetCase = Get.arguments["isFromResetPassword"];
  final String phoneNumber = Get.arguments["phoneNumber"];

  @override
  Widget build(BuildContext context) {
    // Use GetX .put() with permanent: false to ensure proper lifecycle management
    final controller = Get.put(OtpVerificationController(), permanent: false);

    // Register for onDelete callback to detect when controller is being removed
    ever(controller.disposed, (_) {
      print("OtpVerificationController was disposed");
    });

    return Scaffold(
      appBar: CustomAppBar(title: "otpVerification".tr),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Center(
            child: Form(
              key: _otpVerificationFormKey,
              child: Column(
                children: [
                  SizedBox(height: 33.h),
                  SvgPicture.asset(AssetsData.otpVerificationImage),
                  SizedBox(height: 111.h),
                  Text(
                    'otpVerification'.tr,
                    style: Styles.textStyleS16W700(color: ColorsData.primary),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'enterOTPVerificationThatSendToYourNumber'.tr,
                    style: Styles.textStyleS14W400(),
                  ),
                  SizedBox(height: 24.h),
                  CustomPinInput(
                    controller: controller.otpController,
                    onSubmitted: (value) {
                      controller.otpController.text = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter OTP number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 111.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AssetsData.messageIcon,
                        height: 24.h,
                        width: 24.w,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'didntReceiveOTP'.tr,
                        style: Styles.textStyleS14W400(),
                      ),
                      InkWell(
                          onTap: () {
                            // Implement resend OTP
                            controller.resendOtp(phoneNumber);
                          },
                          child: Text(
                            'clickToResend'.tr,
                            style: Styles.textStyleS14W400(
                                color: ColorsData.primary),
                          )),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Obx(() => CustomBigButton(
                        textData: controller.isLoading.value
                            ? "verifying".tr
                            : "resetPassword".tr,
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                if (_otpVerificationFormKey.currentState!
                                    .validate()) {
                                  if (resetCase == false) {
                                    showResetPhoneBottomSheet(context);
                                  } else if (resetCase == true) {
                                    // Create a map with the data first, then use Get.put()
                                    final Map<String, dynamic>
                                        resetPasswordData = {
                                      "phoneNumber": phoneNumber,
                                      "otp": controller.otpController.text,
                                    };

                                    // Use put forcefully to ensure it's available
                                    Get.put<Map<String, dynamic>>(
                                        resetPasswordData,
                                        tag: "resetPasswordData",
                                        permanent: false);

                                    showResetPasswordBottomSheet(context);
                                  }
                                }
                              },
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
