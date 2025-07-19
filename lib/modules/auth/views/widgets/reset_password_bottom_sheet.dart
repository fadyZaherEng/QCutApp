import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/auth/services/auth_service.dart';
import 'package:q_cut/modules/auth/views/widgets/custom_text_form.dart';
import 'package:get/get.dart';
import '../../../../core/services/shared_pref/pref_keys.dart';
import '../../../../core/services/shared_pref/shared_pref.dart';
import '../../../../core/utils/app_router.dart';

class ResetPasswordBottomSheet extends StatefulWidget {
  const ResetPasswordBottomSheet({super.key});

  @override
  State<ResetPasswordBottomSheet> createState() =>
      _ResetPasswordBottomSheetState();
}

class _ResetPasswordBottomSheetState extends State<ResetPasswordBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();

  final TextEditingController _newpasswordController = TextEditingController();

  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureOldPassword = true;

  bool _obscureConfirmNewPassword = true;
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  void _toggleOldPasswordVisibility() {
    setState(() {
      _obscureOldPassword = !_obscureOldPassword;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _obscureNewPassword = !_obscureNewPassword;
    });
  }

  void _toggleConfirmNewPasswordVisibility() {
    setState(() {
      _obscureConfirmNewPassword = !_obscureConfirmNewPassword;
    });
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Add try-catch to handle potential missing data
        Map<String, dynamic> resetPasswordData = {};
        try {
          resetPasswordData =
              Get.find<Map<String, dynamic>>(tag: "resetPasswordData");
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Error: Reset password data not found')),
            );
          }
          setState(() {
            _isLoading = false;
          });
          return;
        }

        final phoneNumber = resetPasswordData["phoneNumber"] as String?;
        final otp = resetPasswordData["otp"] as String?;

        if (phoneNumber == null || otp == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Phone number or OTP is missing')),
          );
          return;
        }

        final response = await _authService.changePassword(
          phoneNumber: phoneNumber,
          otp: otp,
          newPassword: _newpasswordController.text,
        );
        print(response.body);

        if (response.statusCode == 200 || response.statusCode == 201) {
          if (mounted) {
            ShowToast.showSuccessSnackBar(
                message: "Password changed successfully");
            Get.back();
            if (SharedPref().getBool(PrefKeys.userRole) == true) {
              SharedPref().clearPreferences();
              Get.offNamed(AppRouter.loginPath);
            } else {
              SharedPref().clearPreferences();

              Get.offNamed(AppRouter.bloginPath);
            }
          }
        } else {
          if (mounted) {
            final responseData = jsonDecode(response.body);

            ShowToast.showError(message: responseData["message"]);
            Get.back();
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: double.infinity,
        // Remove the fixed height to allow the container to resize based on content
        // height: 403.h,
        constraints: BoxConstraints(
          minHeight: 403.h,
          maxHeight: 500
              .h, // Add a max height but allow it to grow for validation errors
        ),
        padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: 40.h,
            bottom: 20.h), // Add bottom padding
        decoration: BoxDecoration(
          color: ColorsData.font,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Icon(Icons.close, size: 24.sp),
                ),
              ),
              SvgPicture.asset(
                AssetsData.resetPasswordBottomSheetIcon,
                height: 36.h,
                width: 36.w,
              ),
              SizedBox(height: 12.h),
              Text(
                "Reset Password",
                style: Styles.textStyleS14W700(color: ColorsData.secondary),
              ),
              SizedBox(height: 12.h),
              CustomTextFormField(
                style: Styles.textStyleS14W500(color: ColorsData.secondary),
                fillColor: ColorsData.font,
                controller: _oldPasswordController,
                keyboardType: TextInputType.visiblePassword,
                hintText: 'Enter Your Password',
                obscureText: _obscureOldPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                suffixIcon: InkWell(
                  onTap: _toggleOldPasswordVisibility,
                  child: Icon(
                    _obscureOldPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              CustomTextFormField(
                style: Styles.textStyleS14W500(color: ColorsData.secondary),
                fillColor: ColorsData.font,
                controller: _newpasswordController,
                keyboardType: TextInputType.visiblePassword,
                hintText: 'Enter Your New Password',
                obscureText: _obscureNewPassword,
                suffixIcon: InkWell(
                  onTap: _toggleNewPasswordVisibility,
                  child: Icon(
                    _obscureNewPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              CustomTextFormField(
                style: Styles.textStyleS14W500(color: ColorsData.secondary),
                fillColor: ColorsData.font,
                controller: _confirmNewPasswordController,
                keyboardType: TextInputType.visiblePassword,
                hintText: 'Confirm your New password',
                obscureText: _obscureConfirmNewPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  } else if (value != _newpasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                suffixIcon: InkWell(
                  onTap: _toggleConfirmNewPasswordVisibility,
                  child: Icon(
                    _obscureConfirmNewPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              CustomBigButton(
                textData: "Confirm",
                onPressed: _isLoading ? null : _changePassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BResetPasswordBottomSheet extends StatefulWidget {
  const BResetPasswordBottomSheet({super.key});

  @override
  State<BResetPasswordBottomSheet> createState() =>
      _BResetPasswordBottomSheetState();
}

class _BResetPasswordBottomSheetState extends State<BResetPasswordBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();

  final TextEditingController _newpasswordController = TextEditingController();

  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureOldPassword = true;

  bool _obscureConfirmNewPassword = true;

  void _toggleOldPasswordVisibility() {
    setState(() {
      _obscureOldPassword = !_obscureOldPassword;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _obscureNewPassword = !_obscureNewPassword;
    });
  }

  void _toggleConfirmNewPasswordVisibility() {
    setState(() {
      _obscureConfirmNewPassword = !_obscureConfirmNewPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        width: double.infinity,
        // Remove the fixed height to allow the container to resize based on content
        // height: 403.h,
        constraints: BoxConstraints(
          minHeight: 403.h,
          maxHeight: 500
              .h, // Add a max height but allow it to grow for validation errors
        ),
        padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: 40.h,
            bottom: 20.h), // Add bottom padding
        decoration: BoxDecoration(
          color: ColorsData.font,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Form(
          key: _formKey,
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
              // SizedBox(height: 12.h),
              SvgPicture.asset(
                AssetsData.resetPasswordBottomSheetIcon,
                height: 36.h,
                width: 36.w,
              ),
              SizedBox(height: 12.h),
              Text(
                "Reset Password",
                style: Styles.textStyleS14W700(color: ColorsData.secondary),
              ),
              SizedBox(height: 12.h),
              CustomTextFormField(
                style: Styles.textStyleS14W500(color: ColorsData.secondary),
                fillColor: ColorsData.font,
                controller: _oldPasswordController,
                keyboardType: TextInputType.visiblePassword,
                hintText: 'Enter Your Password',
                obscureText: _obscureOldPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                suffixIcon: InkWell(
                  onTap: _toggleOldPasswordVisibility,
                  child: Icon(
                    _obscureOldPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              CustomTextFormField(
                style: Styles.textStyleS14W500(color: ColorsData.secondary),
                fillColor: ColorsData.font,
                controller: _newpasswordController,
                keyboardType: TextInputType.visiblePassword,
                hintText: 'Enter Your New Password',
                obscureText: _obscureNewPassword,
                suffixIcon: InkWell(
                  onTap: _toggleNewPasswordVisibility,
                  child: Icon(
                    _obscureNewPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              CustomTextFormField(
                style: Styles.textStyleS14W500(color: ColorsData.secondary),
                fillColor: ColorsData.font,
                controller: _confirmNewPasswordController,
                keyboardType: TextInputType.visiblePassword,
                hintText: 'Confirm your New password',
                obscureText: _obscureConfirmNewPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  } else if (value != _newpasswordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                suffixIcon: InkWell(
                  onTap: _toggleConfirmNewPasswordVisibility,
                  child: Icon(
                    _obscureConfirmNewPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              CustomBigButton(
                textData: "Confirm",
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
