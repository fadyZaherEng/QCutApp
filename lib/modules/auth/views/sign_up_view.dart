import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/services/shared_pref/pref_keys.dart';
import 'package:q_cut/core/services/shared_pref/shared_pref.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/core/utils/widgets/custom_button.dart';
import 'package:q_cut/core/utils/widgets/custom_checkbox.dart';
import 'package:q_cut/modules/auth/logic/controller/auth_controller.dart';
import 'package:q_cut/modules/auth/views/functions/validate_egyptian_phone_number.dart';
import 'package:q_cut/modules/auth/views/widgets/custom_text_form.dart';
import 'package:q_cut/modules/barber/map_search/map_search_screen.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  bool isChecked = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  late AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 30.h),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(children: [
              Image.asset(
                height: 102.h,
                width: 226.w,
                AssetsData.fullQCutImage,
              ),
              SizedBox(
                height: 57.h,
              ),
              Container(
                width: 260.w,
                height: 48.h,
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: ColorsData.font,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'logIn'.tr,
                        textStyle: Styles.textStyleS14W400(
                            color: ColorsData.cardStrock, fontSize: 15.sp),
                        borderRadiusDirectional: BorderRadiusDirectional.only(
                          topStart: Radius.circular(16.r),
                          bottomStart: Radius.circular(16.r),
                        ),
                        onPressed: () {
                          Get.back();
                        },
                        backgroundColor: ColorsData.font,
                        textColor: ColorsData.cardStrock,
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        text: 'signUp'.tr,
                        borderRadiusDirectional: BorderRadiusDirectional.only(
                          topStart: Radius.circular(16.r),
                          bottomStart: Radius.circular(16.r),
                        ),
                        onPressed: () {},
                        backgroundColor: ColorsData.secondary,
                        textColor: ColorsData.primary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              Form(
                key: _authController.signupFormKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      CustomTextFormField(
                        keyboardType: TextInputType.name,
                        controller: _authController.fullNameController,
                        hintText: 'enterYourFullName'.tr,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name'.tr;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16.h),
                      CustomTextFormField(
                        keyboardType: TextInputType.number,
                        controller: _authController.phoneNumberController,
                        hintText: 'enterYourPhoneNumber'.tr,
                        validator: (value) =>
                            validateEgyptianPhoneNumber(value!),
                      ),
                      (SharedPref().getBool(PrefKeys.userRole)) == false
                          ? Column(
                              children: [
                                SizedBox(height: 16.h),
                                CustomTextFormField(
                                  //     controller: _barberShop,
                                  hintText: 'enterYourBarberShopName'.tr,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'pleaseEnterYourBarberShopName'.tr;
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16.h),
                              ],
                            )
                          : SizedBox(height: 16.h),
                      (SharedPref().getBool(PrefKeys.userRole)) == false
                          ? CustomTextFormField(
                              onTap: () {
                                // Implement location picker here
                                // Future.delayed to ensure the tap is registered properly
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MapSearchScreen(
                                    initialLatitude: 32.0853,
                                    initialLongitude: 34.7818,
                                    onLocationSelected: (lat, lng, address) {
                                      _authController.city.text = address;
                                      _authController.locationLatitude = lat;
                                      _authController.locationLongitude = lng;
                                      setState(() {});
                                    },
                                  );
                                }));
                              },
                              readOnly: true,
                              controller: _authController.city,
                              hintText: 'enterYourCity'.tr,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your City'.tr;
                                }
                                return null;
                              },
                            )
                          : SizedBox(height: 16.h),
                      (SharedPref().getBool(PrefKeys.userRole)) == false
                          ? SizedBox(height: 16.h)
                          : SizedBox.shrink(),
                      CustomTextFormField(
                        controller: _authController.passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: 'enterYourPassword'.tr,
                        obscureText: _obscurePassword,
                        suffixIcon: InkWell(
                          onTap: _togglePasswordVisibility,
                          child: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      CustomTextFormField(
                        controller: _authController.confirmPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: 'confirmYourPassword'.tr,
                        obscureText: _obscureConfirmPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password'.tr;
                          } else if (value !=
                              _authController.passwordController.text) {
                            return 'Passwords do not match'.tr;
                          }
                          return null;
                        },
                        suffixIcon: InkWell(
                          onTap: _toggleConfirmPasswordVisibility,
                          child: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          CustomCheckbox(
                            isChecked: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value;
                              });
                            },
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'iAgreeWithPrivacyPolicy'.tr,
                            style: Styles.textStyleS14W400(),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Obx(
                        () => _authController.isLoading.value
                            ? const SpinKitDoubleBounce(
                                color: ColorsData.primary,
                              )
                            : CustomBigButton(
                                textData: 'request'.tr,
                                onPressed: () {
                                  if (isChecked) {
                                    _authController.signUp(context);
                                  } else {
                                    Get.snackbar(
                                      'Error'.tr,
                                      'Please agree to Privacy & Policy'.tr,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                },
                              ),
                      ),
                      SizedBox(height: 16.h),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
