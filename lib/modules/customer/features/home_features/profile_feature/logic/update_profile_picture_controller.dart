import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/services/shared_pref/pref_keys.dart';
import 'package:q_cut/core/services/shared_pref/shared_pref.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/main.dart';
import 'package:q_cut/modules/customer/features/settings/chat_feature/logic/upload_media.dart';

import '../../../../../../core/utils/network/api.dart';
import 'profile_controller.dart';

class UpdateProfilePictureController extends GetxController {
  final NetworkAPICall _apiCall = NetworkAPICall();
  final UploadMedia _uploadMedia = UploadMedia();
  final RxBool isLoading = false.obs;
  final RxString profileImageUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    profileImageUrl.value = profileImage;
  }

  Future<void> updateProfilePicture(File imageFile) async {
    isLoading.value = true;
    try {
      // Upload the image file
      final uploadedUrl = await _uploadMedia.uploadFile(imageFile, 'image');

      if (uploadedUrl != null) {
        // Create the payload with just the profile picture
        final Map<String, dynamic> payload = {
          'profilePic': uploadedUrl,
        };

        // Send the update request
        final response = await _apiCall.editData(
            '${Variables.baseUrl}authentication/editUser', payload);

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Update local storage
          SharedPref().removePreference(PrefKeys.profilePic);
          profileImage = uploadedUrl;
          await SharedPref().setString(PrefKeys.profilePic, uploadedUrl);

          // Update local controller state
          profileImageUrl.value = uploadedUrl;

          // Show success message
          Get.snackbar(
            'Success',
            'Profile picture updated successfully',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          reloadProfileUI();
        } else {
          Get.snackbar(
            'Error',
            'Failed to update profile picture: ${response.statusCode}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to upload image',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error updating profile picture: $e');
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void reloadProfileUI() {
    try {
      if (Get.isRegistered<ProfileController>()) {
        final profileController = Get.find<ProfileController>();
        profileController.fetchProfileData();
        profileController.update();
        Get.back();
      }
    } catch (e) {
      print('Error refreshing UI: $e');
    }
  }
}
