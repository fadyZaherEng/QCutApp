import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/localization/change_local.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_app_bar.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';

class ChangeLangugesView extends StatelessWidget {
  const ChangeLangugesView({super.key});

  @override
  Widget build(BuildContext context) {
    final LocaleController localeController =
        Get.isRegistered<LocaleController>()
            ? Get.find<LocaleController>()
            : Get.put(LocaleController(), permanent: true);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'changeLanguages'.tr,
        onPressed: () {
          Get.back();
        },
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 32.h),
            SvgPicture.asset(AssetsData.cuateImage),
            SizedBox(height: 32.h),
            Text(
              "availableLanguages".tr,
              style: Styles.textStyleS16W700(color: ColorsData.primary),
            ),
            SizedBox(height: 16.h),
            CustomBigButton(
              textData: "English",
              onPressed: () {
                localeController.changeLang("en");
              },
              isCustomStyle: Get.locale?.languageCode == 'en' ? false : true,
            ),
            SizedBox(height: 24.h),
            CustomBigButton(
              textData: "العربية",
              onPressed: () {
                localeController.changeLang("ar");
              },
              isCustomStyle: Get.locale?.languageCode == 'ar' ? false : true,
            ),
            SizedBox(height: 24.h),
            CustomBigButton(
              textData: 'hebrew'.tr,
              onPressed: () {
                localeController.changeLang("he");
              },
              isCustomStyle: Get.locale?.languageCode == 'he' ? false : true,
            ),
          ],
        ),
      ),
    );
  }
}
