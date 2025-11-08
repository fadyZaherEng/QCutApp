import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/services/shared_pref/shared_pref.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/core/utils/styles.dart';
import '../../../../../../../core/utils/app_router.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({super.key});

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
                onPressed: () => Navigator.pop(context, false),
              ),
            ),
            SvgPicture.asset(
              AssetsData.trashIcon,
              width: 32.w,
              height: 32.h,
              colorFilter:
                  const ColorFilter.mode(ColorsData.primary, BlendMode.srcIn),
            ),
            SizedBox(height: 16.h),
            Text(
              "Are you sure you want to delete your Account?".tr,
              style: Styles.textStyleS14W700(color: ColorsData.secondary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => showDeleteAccountBottomSheet(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsData.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: Text("Yes".tr,
                        style: Styles.textStyleS14W600(color: ColorsData.font)),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, false),
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

Future<void> showDeleteAccountBottomSheet(BuildContext context) {
  final TextEditingController reasonController = TextEditingController();

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      side: BorderSide(color: Colors.white, width: 2
      ),
    ),
    builder: (context) {
      return Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // زر الإغلاق
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const SizedBox(height: 8),

            // العنوان
              Text(
              "Why do you want to cancel the account?".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 20),

            // حقل النص
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Enter your reason...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 25),

            // زر الحذف
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  final reason = reasonController.text.trim();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  // هنا ممكن تنفذ منطق حذف الحساب
                  print("Delete account reason: $reason");
                  var response = await NetworkAPICall().deleteDataWithBody(
                    "${Variables.baseUrl}barber/me",
                    {
                      "deleteReason": reason,
                    },
                  );
                  response.statusCode == 200
                      ? {
                          Get.back(),
                          ShowToast.showSuccessSnackBar(
                            message: "Account deleted successfully",
                          ),
                          SharedPref().clearPreferences(),
                          Get.offAllNamed(AppRouter.initialPath),
                        }
                      : ShowToast.showError(
                          message: "Failed to delete account",
                        );
                },
                child:   Text(
                  "Delete account".tr,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
