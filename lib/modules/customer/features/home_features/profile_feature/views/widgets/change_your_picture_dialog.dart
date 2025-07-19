import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_button.dart';
import 'package:q_cut/main.dart';
import 'package:q_cut/modules/customer/features/home_features/profile_feature/logic/update_profile_picture_controller.dart';

class ChangeYourPictureDialog extends StatelessWidget {
  const ChangeYourPictureDialog({
    super.key,
    this.onImageSelected,
  });

  final Function(File)? onImageSelected;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateProfilePictureController());

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Obx(
        () => Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              controller.isLoading.value
                  ? CircularProgressIndicator()
                  : CircleAvatar(
                      radius: 25.r,
                      foregroundImage: CachedNetworkImageProvider(profileImage),
                      backgroundColor: ColorsData.secondary,
                    ),
              SizedBox(height: 16.h),
              Text(
                "Change Your Picture",
                style: Styles.textStyleS14W700(color: ColorsData.secondary),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      textStyle: Styles.textStyleS12W600(),
                      text: "Go to Gallery",
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                              final image =
                                  await _pickImage(ImageSource.gallery);
                              if (image != null) {
                                if (onImageSelected != null) {
                                  onImageSelected!(image);
                                } else {
                                  await controller.updateProfilePicture(image);
                                }
                              }
                            },
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: CustomButton(
                      textStyle: Styles.textStyleS12W600(),
                      text: "Take a picture",
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                              final image =
                                  await _pickImage(ImageSource.camera);
                              if (image != null) {
                                if (onImageSelected != null) {
                                  onImageSelected!(image);
                                } else {
                                  await controller.updateProfilePicture(image);
                                }
                              }
                            },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<File?> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    return null;
  }
}
