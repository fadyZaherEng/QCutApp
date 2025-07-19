import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/auth/views/functions/validate_egyptian_phone_number.dart';
import 'package:q_cut/modules/auth/views/widgets/custom_text_form.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 75.h),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SvgPicture.asset(AssetsData.forgetPasswordImage),
                    SizedBox(
                      height: 111.h,
                    ),
                    Text(
                      'forgetPassword'.tr,
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
                      validator: (value) => validateEgyptianPhoneNumber(value!),
                    ),
                    SizedBox(
                      height: 111.h,
                    ),
                    CustomBigButton(
                      textData: "sendOTPVerification".tr,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.push(AppRouter.otpVerificationPath);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
