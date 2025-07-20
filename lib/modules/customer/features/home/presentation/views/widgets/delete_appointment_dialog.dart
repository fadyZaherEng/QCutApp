import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';

class DeleteAppointmentDialog extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;

  const DeleteAppointmentDialog(
      {super.key, required this.onYes, required this.onNo});

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
                onPressed: () {
                  onNo();
                  Get.back();
                },
              ),
            ),
            SvgPicture.asset(
              AssetsData.trashIcon,
              width: 24.w,
              height: 24.h,
              colorFilter:
                  const ColorFilter.mode(ColorsData.primary, BlendMode.srcIn),
            ),
            SizedBox(height: 16.h),
            Text(
              "areYouSureDeleteAppointment".tr,
              style: Styles.textStyleS14W700(color: ColorsData.secondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onYes();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsData.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text("Yes".tr,
                        style: Styles.textStyleS14W600(color: Colors.white)),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onNo();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsData.cardStrock,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text("No".tr,
                        style: Styles.textStyleS14W600(color: ColorsData.font)),
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
