import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:q_cut/core/services/shared_pref/pref_keys.dart';
import 'package:q_cut/core/services/shared_pref/shared_pref.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/modules/auth/models/auth_response_model.dart';
import 'package:q_cut/modules/auth/models/user_model.dart';
import 'package:q_cut/modules/auth/views/otp_verification_view.dart';

class AuthController extends GetxController {
  final NetworkAPICall _apiCall = NetworkAPICall();

  // Form Controllers
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController =
      //  TextEditingController(text: "+970591999999");
      //   barber
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController(text: "");
  final TextEditingController city = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController otpController = TextEditingController();

  // Form Keys
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  // UI States
  final RxBool isLoading = false.obs;
  final RxBool isSignUpSuccess = false.obs;
  final RxBool isLoginSuccess = false.obs;
  final RxString errorMessage = ''.obs;

  // User Data
  Rx<SignUpResponse?> signupResponse = Rx<SignUpResponse?>(null);
  Rx<LoginResponse?> loginResponse = Rx<LoginResponse?>(null);

  // Store userId from signup response
  final RxString userId = ''.obs;

  @override
  void onClose() {
    fullNameController.dispose();
    // phoneNumberController.dispose();
    // passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> signUp(BuildContext context) async {
    if (!signupFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final userData = UserModel(
          fullName: fullNameController.text.trim(),
          phoneNumber:
              "+972${phoneNumberController.text.trim().replaceAll('\u200E', '')}",
          password: passwordController.text,
          city: "New City");

      final requestData = {
        'userType':
            SharedPref().getBool(PrefKeys.userRole)! ? "user" : 'barber',
        'userData': userData.toJson(),
      };

      final response =
          await _apiCall.postDataAsGuest(requestData, Variables.SIGNUP);
      print(userData.toJson());

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        signupResponse.value = SignUpResponse.fromJson(responseBody);
        isSignUpSuccess.value = true;

        userId.value = responseBody['_id'] ?? '';

        if (userId.value.isEmpty) {
          errorMessage.value = 'User ID not received from server';
          ShowToast.showError(message: errorMessage.value);
          return;
        }

        ShowToast.showSuccessSnackBar(
            message: 'Account created successfully'.tr);

        Get.to(() => OtpVerificationView(userId: userId.value));
      } else {
        errorMessage.value = responseBody['message'] ?? 'Failed to sign up';
        ShowToast.showError(message: errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Network error: $e';
      Get.snackbar('Error', 'Failed to connect to server',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // Get FCM token
  Future<String> getFCMToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    return fcmToken ?? '';
  }

  Future<void> login(BuildContext context, bool isChecked) async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // Get FCM token before making the request
      final fcmToken = await getFCMToken();

      final requestData = {
        'phoneNumber':
            "+972${phoneNumberController.text.trim().replaceAll('\u200E', '')}",
        'password': passwordController.text,
        "fcmToken": fcmToken
      };
      print(requestData);

      final response =
          await _apiCall.postDataAsGuest(requestData, Variables.LOGIN);
      print(response.body);

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        loginResponse.value = LoginResponse.fromJson(responseBody);
        isLoginSuccess.value = true;
        print("=============== ${loginResponse.value!.id} ==================");
        await SharedPref().setString(PrefKeys.id, loginResponse.value!.id);
        await SharedPref()
            .setString(PrefKeys.accessToken, loginResponse.value!.accessToken);
        await SharedPref()
            .setString(PrefKeys.profilePic, loginResponse.value!.profilePic);
        await SharedPref()
            .setString(PrefKeys.coverPic, loginResponse.value!.coverPic);
        await SharedPref()
            .setString(PrefKeys.phoneNumber, loginResponse.value!.phoneNumber);
        await SharedPref()
            .setString(PrefKeys.fullName, loginResponse.value!.fullName);
        await SharedPref().setBool(PrefKeys.saveMe, isChecked);

        // You might want to show a success message

        ShowToast.showSuccessSnackBar(message: "loggedInSuccessfully".tr);

        Get.offAllNamed(AppRouter.bottomNavigationBar);
      } else {
        errorMessage.value = responseBody['message'] ?? 'Failed to login';
        ShowToast.showError(message: errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Network error: $e';
      Get.snackbar('Error', 'Failed to connect to server',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp(String otpValue, String userIdValue) async {
    isLoading.value = true;
    errorMessage.value = '';
    update(); // Update UI to show loading state

    try {
      final requestData = {"userId": userIdValue, "otp": otpValue};

      final response =
          await _apiCall.postDataAsGuest(requestData, Variables.VERIFY_OTP);

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        // Clear registration form data
        clearForm();
        ShowToast.showSuccessSnackBar(message: 'OTP verified successfully');

        // Use offAllNamed instead of direct Get.to to prevent keeping references to previous routes
        Get.offAllNamed(AppRouter.loginPath);
      } else {
        errorMessage.value = responseBody['message'] ?? 'Failed to verify OTP';
        ShowToast.showError(message: errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Network error: $e';
      Get.snackbar('Error', 'Failed to connect to server',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Similarly for resendOtp method, ensure it doesn't reference controllers directly
  Future<void> resendOtp(String userIdValue) async {
    isLoading.value = true;
    errorMessage.value = '';
    update();

    try {
      final requestData = {"userId": userIdValue};

      final response =
          await _apiCall.postDataAsGuest(requestData, Variables.baseUrl);

      final responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        ShowToast.showSuccessSnackBar(message: 'OTP resent successfully');
      } else {
        errorMessage.value = responseBody['message'] ?? 'Failed to resend OTP';
        ShowToast.showError(message: errorMessage.value);
      }
    } catch (e) {
      errorMessage.value = 'Network error: $e';
      Get.snackbar('Error', 'Failed to connect to server',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  // Update the clearForm method to be safer
  void clearForm() {
    // Only clear controllers that are definitely not in use
    fullNameController.clear();
    city.clear();
    confirmPasswordController.clear();
    // Don't reference otpController here since it might be disposed

    errorMessage.value = '';
  }
}
