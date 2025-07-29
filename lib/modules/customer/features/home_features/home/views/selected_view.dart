import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/network/api.dart';
import 'package:q_cut/core/utils/network/network_helper.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/core/utils/widgets/custom_button.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_display/views/widgets/show_how_many_consumer_bottom_sheet.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_display/views/widgets/show_working_days_bottom_sheet.dart';
import 'package:q_cut/modules/customer/features/home_features/home/controllers/gallery_controller.dart';
import 'package:q_cut/modules/customer/features/home_features/home/models/barber_model.dart';

class SelectedView extends StatefulWidget {
  const SelectedView({super.key});

  @override
  State<SelectedView> createState() => _SelectedViewState();
}

class _SelectedViewState extends State<SelectedView> {
  // Add a reactive boolean variable to track favorite status
  final RxBool isFavorite = false.obs;
  late Barber barber;
  final GalleryController galleryController = Get.put(GalleryController());
  bool isClicked = true;

  @override
  void initState() {
    super.initState();
    // Delay the initialization to ensure Get.arguments is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      barber = Get.arguments as Barber;
      // Set the initial favorite status
      isFavorite.value = barber.isFavorite;
      // Fetch gallery when view is initialized
      galleryController.fetchGallery(barber.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Safely get the barber object
    if (!Get.arguments.runtimeType.toString().contains('Barber')) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    barber = Get.arguments as Barber;

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display barber's cover pic if available, otherwise use default image
                  barber.coverPic != null && barber.coverPic!.isNotEmpty
                      ? Image.network(
                          barber.coverPic!,
                          width: double.infinity,
                          height: 200.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(AssetsData.selectedViewImage),
                        )
                      : Image.asset(AssetsData.selectedViewImage),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    )),
                    padding: EdgeInsets.only(
                        top: 20.h, bottom: 30.h, left: 16.w, right: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display barber shop name with fallback
                        Text(
                          barber.barberShop ?? barber.fullName,
                          style: Styles.textStyleS14W700(),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        const Divider(),
                        SizedBox(
                          height: 18.h,
                        ),
                        // Social media and action buttons
                        Row(
                          children: [
                            // Instagram button
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(7.r),
                                  height: 30.h,
                                  width: 30.w,
                                  decoration: BoxDecoration(
                                    color: ColorsData.font,
                                    borderRadius: BorderRadius.circular(25.r),
                                  ),
                                  child: SvgPicture.asset(
                                    height: 16.h,
                                    width: 16.w,
                                    AssetsData.instagramIcon,
                                    colorFilter: const ColorFilter.mode(
                                      ColorsData.primary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  "instagram".tr,
                                  style: Styles.textStyleS14W500(),
                                ),
                              ],
                            ),
                            const Spacer(),
                            // Direction button
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(7.r),
                                  height: 30.h,
                                  width: 30.w,
                                  decoration: BoxDecoration(
                                    color: ColorsData.font,
                                    borderRadius: BorderRadius.circular(25.r),
                                  ),
                                  child: SvgPicture.asset(
                                    height: 16.h,
                                    width: 16.w,
                                    AssetsData.directionIcon,
                                    colorFilter: const ColorFilter.mode(
                                      ColorsData.primary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  "direction".tr,
                                  style: Styles.textStyleS14W500(),
                                ),
                              ],
                            ),
                            const Spacer(),
                            // Share button
                            Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(7.r),
                                  height: 30.h,
                                  width: 30.w,
                                  decoration: BoxDecoration(
                                    color: ColorsData.font,
                                    borderRadius: BorderRadius.circular(25.r),
                                  ),
                                  child: SvgPicture.asset(
                                    height: 16.h,
                                    width: 16.w,
                                    AssetsData.shareIcon,
                                    colorFilter: const ColorFilter.mode(
                                      ColorsData.primary,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Text(
                                  "share".tr,
                                  style: Styles.textStyleS14W500(),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 18.h,
                        ),
                        // Address information
                        Row(
                          children: [
                            SvgPicture.asset(
                              AssetsData.mapPinIcon,
                              width: 18.w,
                              height: 18.h,
                              colorFilter: const ColorFilter.mode(
                                ColorsData.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            // Show actual address if available
                            Expanded(
                              child: Text(
                                barber.city,
                                style: Styles.textStyleS14W500(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        // Time and distance information
                        Row(
                          children: [
                            SvgPicture.asset(
                              AssetsData.clockIcon,
                              width: 16.w,
                              height: 16.h,
                              colorFilter: const ColorFilter.mode(
                                ColorsData.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            Text(
                              '15 min   1.5 km',
                              style: Styles.textStyleS14W500(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        // Working days button
                        CustomButton(
                          height: 48.h,
                          width: 343.w,
                          textStyle: Styles.textStyleS16W700(),
                          backgroundColor: ColorsData.primary.withOpacity(0.65),
                          text: "workingDays".tr,
                          onPressed: () {
                            print(barber.id);
                            //  barber.id
                            showBWorkingDaysBottomSheet(
                                context, barber.workingDays);
                          },
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        // Gallery section with dynamic count
                        Obx(() => Row(
                              children: [
                                Text(
                                  "gallery".tr,
                                  style: Styles.textStyleS14W700(),
                                ),
                                Text(
                                  "(${galleryController.photos.length} ${"photos".tr})",
                                  style: Styles.textStyleS14W700(
                                      color: ColorsData.primary),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              )),
              // Gallery grid with API data
              Obx(() {
                if (galleryController.isLoading.value) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: SpinKitDoubleBounce(
                          color: ColorsData.primary,
                        ),
                      ),
                    ),
                  );
                }

                if (galleryController.hasError.value) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.h),
                        child: Column(
                          children: [
                            Text(galleryController.errorMessage.value),
                            SizedBox(height: 10.h),
                            ElevatedButton(
                              onPressed: () {
                                if (isClicked) {
                                  isClicked = false;
                                  setState(() {});
                                  galleryController.fetchGallery(barber.id);
                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    isClicked = true;
                                    setState(() {});
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorsData.primary,
                              ),
                              child: Text("Retry".tr,
                                  style: Styles.textStyleS14W400(
                                      color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                if (galleryController.photos.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.h, bottom: 80.h),
                        child: Column(
                          children: [
                            Icon(
                              Icons.photo_library_outlined,
                              size: 40,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "No photos available".tr,
                              style: Styles.textStyleS14W400(
                                  color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return SliverFillRemaining(
                  child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(
                        top: 0, left: 16.w, right: 17.w, bottom: 80.h),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 110.w,
                      crossAxisSpacing: 6.h,
                      mainAxisSpacing: 9.w,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            galleryController.photos[index],
                            width: 108.w,
                            height: 94.h,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 108.w,
                              height: 94.h,
                              color: Colors.grey[300],
                              child: const Center(
                                  child: Icon(Icons.broken_image,
                                      color: Colors.red)),
                            ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                width: 108.w,
                                height: 94.h,
                                color: Colors.grey[200],
                                child: Center(
                                  child: SpinKitDoubleBounce(
                                    color: ColorsData.primary,
                                    // value: loadingProgress.expectedTotalBytes !=
                                    //         null
                                    //     ? loadingProgress
                                    //             .cumulativeBytesLoaded /
                                    //         loadingProgress.expectedTotalBytes!
                                    //     : null,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                    itemCount: galleryController.photos.length,
                  ),
                );
              }),

              SliverToBoxAdapter(
                child: SizedBox(height: 70.h),
              ),
            ],
          ),
          // Book button at bottom of screen
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: CustomBigButton(
                textData: "book".tr,
                onPressed: () {
                  showHowManyConsumerBottomSheet(context, barber: barber);
                },
              ),
            ),
          ),
          // Back button at top of screen
          Positioned(
            top: 40.h,
            left: 16.w,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
          ),

          // Favorite button at top right
          Positioned(
            top: 40.h,
            right: 16.w,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Obx(() => Icon(
                      isFavorite.value ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite.value ? Colors.red : Colors.white,
                      size: 24.sp,
                    )),
                onPressed: () async {
                  if (isClicked) {
                    isClicked = false;
                    setState(() {});
                    var response = await NetworkAPICall().addData({
                      "barberId": barber.id,
                    }, "${Variables.baseUrl}favoriteForUser/toggle");

                    if (response.statusCode == 200) {
                      isFavorite.value = !isFavorite.value;
                      barber.isFavorite = isFavorite.value;
                    } else {
                      ShowToast.showError(message: "Error occurred");
                    }
                    await Future.delayed(const Duration(seconds: 2), () {
                      isClicked = true;
                      setState(() {});
                    });
                  }
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
