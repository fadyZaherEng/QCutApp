import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_button.dart';

class ChangePictureDialog extends StatelessWidget {
  final bool isProfilePicture;
  final String? currentImageUrl;
  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;

  const ChangePictureDialog({
    super.key,
    required this.isProfilePicture,
    this.currentImageUrl,
    required this.onGalleryTap,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
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
            if (currentImageUrl != null)
              isProfilePicture
                  ? CircleAvatar(
                      radius: 35.r,
                      backgroundColor: ColorsData.secondary,
                      child: CircleAvatar(
                        radius: 34.r,
                        backgroundImage: const AssetImage(
                            'assets/images/default_avatar.png'),
                        foregroundImage: CachedNetworkImageProvider(
                          currentImageUrl!,
                          errorListener: (error) {
                            debugPrint("Error loading profile image: $error");
                          },
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: CachedNetworkImage(
                        imageUrl: currentImageUrl!,
                        height: 100.h,
                        width: 150.w,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: ColorsData.secondary.withOpacity(0.3),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: ColorsData.secondary.withOpacity(0.3),
                          child: const Icon(Icons.image, size: 50),
                        ),
                      ),
                    ),
            SizedBox(height: 16.h),
            Text(
              isProfilePicture
                  ? "changeYourProfilePicture".tr
                  : "changeYourCoverPhoto".tr,
              style: Styles.textStyleS14W700(color: ColorsData.secondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    textStyle: Styles.textStyleS12W600(),
                    text: "goToGallery".tr,
                    onPressed: () {
                      onGalleryTap();
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: CustomButton(
                    textStyle: Styles.textStyleS12W600(),
                    text: "takeAPicture".tr,
                    onPressed: () {
                      onCameraTap();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showChangePictureDialog(
  BuildContext context, {
  required bool isProfilePicture,
  String? currentImageUrl,
  required VoidCallback onGalleryTap,
  required VoidCallback onCameraTap,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) => ChangePictureDialog(
      isProfilePicture: isProfilePicture,
      currentImageUrl: currentImageUrl,
      onGalleryTap: onGalleryTap,
      onCameraTap: onCameraTap,
    ),
  );
}
