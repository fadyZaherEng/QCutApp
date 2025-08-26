import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/network/api.dart';

class ResetPhoneController extends GetxController {
  // Text controllers
  final TextEditingController oldPhoneController = TextEditingController();
  final TextEditingController newPhoneController = TextEditingController();

  // Loading state
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;


  @override
  void onClose() {
    // Properly dispose controllers when the controller is removed from memory
    oldPhoneController.dispose();
    newPhoneController.dispose();
    super.onClose();
  }

  // Reset phone number method
  Future<void> resetPhoneNumber() async {
    if (oldPhoneController.text.isEmpty || newPhoneController.text.isEmpty) {
      errorMessage.value = 'Please fill all fields';
      return;
    }

    isLoading.value = true;

    try {
      // Implement API call for resetting phone number
      // Example:
      // final response = await apiService.resetPhone(
      //   oldPhone: oldPhoneController.text,
      //   newPhone: newPhoneController.text,
      // );

      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay

      // On success
      Get.back(); // Close bottom sheet
      ShowToast.showSuccessSnackBar(
          message: 'Phone number updated successfully');
    } catch (e) {
      errorMessage.value = 'Error: $e';
      ShowToast.showError(message: errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }
}
