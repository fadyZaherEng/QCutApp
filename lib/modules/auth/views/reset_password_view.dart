import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_app_bar.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/auth/views/widgets/custom_text_form.dart';

class ResetPasswordView extends StatelessWidget {
  ResetPasswordView({super.key});

  // Changed to instance variable with unique name
  final GlobalKey<FormState> _resetPasswordFormKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "resetPassword".tr),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 65.h),
          child: Center(
            child: Form(
              key: _resetPasswordFormKey, // Using unique key here
              child: Column(
                children: [
                  SvgPicture.asset(AssetsData.resetPasswordImage),
                  SizedBox(
                    height: 111.h,
                  ),
                  Text(
                    'resetPassword'.tr,
                    style: Styles.textStyleS16W700(color: ColorsData.primary),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  Text(
                    'enterYourPhoneNumberToSendOTP'.tr,
                    style: Styles.textStyleS14W400(),
                  ),
                  SizedBox(
                    height: 24.h,
                  ),
                  CustomTextFormField(
                    keyboardType: TextInputType.phone,
                    controller: _phoneNumberController,
                    hintText: 'enterYourPhoneNumber'.tr,
                  ),
                  SizedBox(
                    height: 111.h,
                  ),
                  CustomBigButton(
                    textData: "sendOTPVerification".tr,
                    onPressed: () {
                      if (_resetPasswordFormKey.currentState!.validate()) {
                        // Updated reference
                        final NetworkAPICall apiCall = NetworkAPICall();
                        var response = apiCall.addData({
                          "phoneNumber": _phoneNumberController.text,
                        }, "${Variables.baseUrl}authentication/forget-password");
                        response.then((value) {
                          if (value.statusCode == 200) {
                            Get.toNamed(
                              AppRouter.otpVerificationResetCasePath,
                              arguments: {
                                'phoneNumber': _phoneNumberController.text,
                                'isFromResetPassword': true,
                              },
                            );
                            ShowToast.showSuccessSnackBar(
                                message: "OTP sent successfully");
                          } else if (value.statusCode == 400) {
                            ShowToast.showError(
                                message: "Invalid phone number");
                          } else if (value.statusCode == 500) {
                            ShowToast.showError(
                                message:
                                    "Server error, please try again later");
                          } else {
                            ShowToast.showError(
                                message:
                                    "An unexpected error occurred, please try again");
                          }
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
