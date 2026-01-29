import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/network/api.dart';

class OtpVerificationController extends GetxController {
  // UI States
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool disposed = false.obs;

  // Text Editing Controllers
  final TextEditingController otpController = TextEditingController();

  // Timer state
  final RxInt timerSeconds = 60.obs;
  final RxBool isTimerRunning = false.obs;

  @override
  void onInit() {
    super.onInit();
    print("OtpVerificationController initialized");
    startTimer();
    otpController.text ="";// "123456"; // Constant OTP
  }

  void startTimer() {
    timerSeconds.value = 60;
    isTimerRunning.value = true;
    _runTimer();
  }

  void _runTimer() async {
    while (timerSeconds.value > 0 && isTimerRunning.value) {
      await Future.delayed(const Duration(seconds: 1));
      if (!disposed.value) {
        timerSeconds.value--;
      } else {
        break; // Stop if controller is disposed
      }
    }
    isTimerRunning.value = false;
  }

  @override
  void onClose() {
    disposed.value = true;
    isTimerRunning.value = false;
    print("OtpVerificationController onClose() called");
    otpController.dispose();
    super.onClose();
  }

  // Method to resend OTP
  Future<void> resendOtp(String phoneNumber) async {
    if (timerSeconds.value > 0) return; // Prevent resend if timer is active

    isLoading.value = true;
    try {
      // TODO: Implement resend OTP API call
      // For now, just simulate and restart timer
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay
      ShowToast.showSuccessSnackBar(message: "OTP is 123456");
      startTimer();
    } catch (e) {
      errorMessage.value = 'Error: $e';
      ShowToast.showError(message: errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Method to verify OTP
  Future<void> verifyOtp({
    required String otp,
    required String phoneNumber,
  }) async {
    isLoading.value = true;
    try {
       // Since OTP is constant "123456" for this flow, we might not need to call API here 
       // if the requirement is just to move to the next screen.
       // However, usually verify happens here. 
       // For this specific request "make otp constatnt show for user from 1 to 6",
       // and "then when reset navigate to reset password screen".
       
       // check if OTP matches 123456
       if(otp != "123456"){
           ShowToast.showError(message: "Invalid OTP");
           return;
       }

      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay
      // ShowToast.showSuccessSnackBar(message: "OTP verified successfully");
      // Navigation should be handled by the view based on success
    } catch (e) {
      errorMessage.value = 'Error: $e';
      ShowToast.showError(message: errorMessage.value);
      rethrow; // Rethrow to let view know it failed
    } finally {
      isLoading.value = false;
    }
  }
}
