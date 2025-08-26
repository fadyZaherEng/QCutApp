import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class CustomBAppointmentAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomBAppointmentAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final addressController = Get.put(AddressController());

    return Row(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AssetsData.mapPinIcon,
              width: 24.w,
              height: 24.h,
              colorFilter: const ColorFilter.mode(
                ColorsData.primary,
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: 4.w),

            /// ✅ العنوان الحالي
            Obx(() => SizedBox(
                  width: 200.w,
                  child: Text(
                    addressController.currentAddress.value,
                    style: Styles.textStyleS12W400(),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                )),
            SizedBox(width: 4.w),

            /// ⟳ زرار تحديث العنوان أو لودينج
            Obx(() => addressController.isLoading.value
                ? SizedBox(
                    width: 18.sp,
                    height: 18.sp,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ColorsData.primary,
                    ),
                  )
                : InkWell(
                    onTap: () async {
                      await addressController.getCurrentAddress();
                    },
                    child: Icon(
                      Icons.refresh,
                      size: 18.sp,
                      color: ColorsData.primary,
                    ),
                  )),

            SizedBox(width: 4.w),
          ],
        ),
        const Spacer(),
        InkWell(
            onTap: () {
              Get.toNamed(AppRouter.notificationPath);
            },
            child: SvgPicture.asset(
              AssetsData.notificationsIcon,
              width: 24,
              height: 24,
            )),
        SizedBox(width: 11.w),
        InkWell(
            onTap: () {
              Scaffold.of(context).openDrawer();
            },
            child: SvgPicture.asset(
              AssetsData.menuIcon,
              width: 24,
              height: 24,
            )),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(67.h);
}

class AddressController extends GetxController {
  RxString currentAddress = "Loading...".obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentAddress();
  }

  Future<void> getCurrentAddress() async {
    try {
      isLoading.value = true;

      // Check service
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        currentAddress.value = "Location services are disabled";
        isLoading.value = false;
        return;
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          currentAddress.value = "Permission denied";
          isLoading.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        currentAddress.value = "Permission permanently denied";
        isLoading.value = false;
        return;
      }

      // Get position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Reverse geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;
      currentAddress.value =
          "${place.street}, ${place.locality}, ${place.country}";
    } catch (e) {
      currentAddress.value = "Unable to fetch address";
    } finally {
      isLoading.value = false;
    }
  }
}
