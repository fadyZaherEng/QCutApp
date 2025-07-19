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

  @override
  void onInit() {
    super.onInit();
    print("OtpVerificationController initialized");
  }

  @override
  void onClose() {
    disposed.value = true;
    print("OtpVerificationController onClose() called");
    otpController.dispose();
    super.onClose();
  }

  // Method to resend OTP
  Future<void> resendOtp(String phoneNumber) async {
    isLoading.value = true;
    try {
      // TODO: Implement resend OTP API call
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay
      ShowToast.showSuccessSnackBar(message: "OTP resent successfully");
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
      // TODO: Implement verify OTP API call
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay
      ShowToast.showSuccessSnackBar(message: "OTP verified successfully");
    } catch (e) {
      errorMessage.value = 'Error: $e';
      ShowToast.showError(message: errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
