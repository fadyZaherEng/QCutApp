import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_big_button.dart';
import 'package:q_cut/modules/barber/features/home_features/appointment_feature/models/appointment_model.dart';
import 'package:q_cut/modules/barber/features/home_features/appointment_feature/views/custom_b_drawer.dart';
import 'package:q_cut/modules/barber/features/home_features/statistics_feature/views/widgets/choose_break_days_bottom_sheet.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_display/logic/b_profile_controller.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_display/models/barber_service_model.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_display/views/widgets/custom_add_new_service_bottom_sheet.dart';
import 'package:q_cut/modules/barber/features/home_features/statistics_feature/views/widgets/custom_edit_new_service_bottom_sheet.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_display/views/widgets/show_change_your_picture_dialog.dart';
import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_display/views/widgets/show_working_days_bottom_sheet.dart';
import 'package:q_cut/modules/barber/map_search/map_search_screen.dart';
import 'package:q_cut/modules/customer/features/home_features/profile_feature/views/my_profile_view.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/barber_profile_model.dart';

class BProfileView extends StatefulWidget {
  const BProfileView({super.key});

  @override
  State<BProfileView> createState() => _BProfileViewBodyState();
}

class _BProfileViewBodyState extends State<BProfileView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Remove the tag since it can cause issues with controller finding
  final BProfileController controller = Get.put(BProfileController());

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    controller.tabController = _tabController;
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        controller.fetchGallery();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: SpinKitDoubleBounce(color: ColorsData.primary),
        );
      }

      if (controller.isError.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Failed to load profile'.tr,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: controller.fetchProfileData,
                child: Text('Retry'.tr),
              ),
            ],
          ),
        );
      }

      final profileData = controller.profileData.value;
      if (profileData == null) {
        return Center(
          child: Text('No profile data available'.tr,
              style: TextStyle(color: Colors.white)),
        );
      }

      // Handle empty data fields with defaults or placeholders
      final barberShop = profileData.barberShop.isNotEmpty
          ? profileData.barberShop
          : 'My Barber Shop'.tr;

      final location = BarberLocation(
        type: profileData.barberShopLocation.type,
        coordinates: profileData.barberShopLocation.coordinates,
      );
      final city =
          profileData.city.isNotEmpty ? profileData.city : 'Not set'.tr;

      final instagramPage = profileData.instagramPage.isNotEmpty
          ? profileData.instagramPage
          : 'Not set'.tr;

      final fullName =
          profileData.fullName.isNotEmpty ? profileData.fullName : 'Your Name';

      return RefreshIndicator(
        onRefresh: () async {
          await controller.fetchProfileData();
          if (_tabController.index == 1) {
            await controller.fetchGallery();
          }
        },
        child: Scaffold(
          key: _scaffoldKey, // 👈 عشان نتحكم في الـ Scaffold
          drawer: const CustomBDrawer(), // 👈 هنا بنضيف الـ Drawer بتاعك
          body: Column(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchProfileData();
                  if (_tabController.index == 1) {
                    await controller.fetchGallery();
                  }
                },
                child: SizedBox(
                  height: 300.h,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 250.h,
                        decoration: BoxDecoration(
                          color: ColorsData.secondary,
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            alignment: Alignment.topCenter,
                            image: CachedNetworkImageProvider(
                              profileData.coverPic,
                              errorListener: (exception) =>
                                  print('Error loading image: $exception'),
                            ),
                          ),
                        ),
                        child: profileData.coverPic.isNotEmpty
                            ? Image.network(
                                profileData.coverPic,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: ColorsData.secondary,
                                    child: Center(
                                      child: Text(
                                        "Add Cover Photo".tr,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Container(
                                color: ColorsData.secondary,
                                child: Center(
                                  child: Text(
                                    "Add Cover Photo".tr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      Positioned(
                        bottom: 24.h,
                        right: 20.w,
                        child: GestureDetector(
                          onTap: () {
                            showChooseBreakDaysBottomSheet(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: ColorsData.primary),
                              borderRadius: BorderRadius.circular(10.r),
                              color: ColorsData.font,
                            ),
                            width: 90.w,
                            height: 32.h,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  AssetsData.takeBreakIcon,
                                  height: 14.h,
                                  width: 14.w,
                                ),
                                Text(
                                  "Take break".tr,
                                  style: Styles.textStyleS13W400(
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 200.98.h,
                        left: 47.39.w,
                        child: InkWell(
                          onTap: () {
                            if (profileData.profilePic.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FullScreenImageView(
                                    imageUrl: profileData.profilePic,
                                  ),
                                ),
                              );
                            }
                          },
                          child: SizedBox(
                            width: 120.w,
                            height: 127.08.h,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: ColorsData.secondary,
                              child: CircleAvatar(
                                radius: 55,
                                backgroundImage:
                                    NetworkImage(profileData.profilePic),
                                backgroundColor: ColorsData.secondary,
                                onBackgroundImageError:
                                    (exception, stackTrace) {
                                  print(
                                      'Error loading profile image: $exception');
                                },
                                child: profileData.profilePic.isEmpty
                                    ? const Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        left: 110.w,
                        bottom: -20.h,
                        child: InkWell(
                          onTap: () {
                            showChangeYourPictureDialog(context);
                          },
                          child: MaterialButton(
                            height: 36.16748046875.h,
                            minWidth: 36.16748046875.w,
                            padding: EdgeInsets.zero,
                            shape: const CircleBorder(),
                            onPressed: () {
                              showChangeYourPictureDialog(context);
                            },
                            child: CircleAvatar(
                              radius: 18.08.r,
                              backgroundColor: ColorsData.primary,
                              child: SvgPicture.asset(
                                height: 20.h,
                                width: 20.w,
                                AssetsData.addImageIcon,
                                colorFilter: const ColorFilter.mode(
                                  ColorsData.font,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Burger Menu + Take Break
                      Positioned(
                        top: 10.h,
                        left: Get.locale?.languageCode == "ar" ? 20.w : null,
                        // 👈 RTL support
                        right: Get.locale?.languageCode == "ar" ? null : 20.w,
                        child: Row(
                          children: [
                            // Burger Menu
                            GestureDetector(
                              onTap: () {
                                // open drawer / show menu sheet
                                _scaffoldKey.currentState?.openDrawer();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: ColorsData.primary),
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: ColorsData.font,
                                ),
                                width: 40.w,
                                height: 36.h,
                                child: Icon(
                                  Icons.menu,
                                  color: Colors.black,
                                  size: 22.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 80.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    barberShop,
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: ColorsData.primary),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  width: 80.w,
                                  height: 30.h,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "NO. 1".tr,
                                        style: Styles.textStyleS13W400(
                                            color: ColorsData.primary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Divider(
                              color: ColorsData.cardStrock,
                              thickness: 1.w,
                            ),
                            SizedBox(height: 8.h),
                            _buildInfoRow(
                                AssetsData.personIcon, fullName, location),
                            SizedBox(height: 8.h),
                            InkWell(
                              onTap: () {
                                // Handle city tap if needed
                                // Future.delayed to ensure the tap is registered properly
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MapSearchScreen(
                                    initialLatitude: profileData
                                            .barberShopLocation
                                            .coordinates
                                            .isNotEmpty
                                        ? profileData
                                            .barberShopLocation.coordinates[1]
                                        : 31.0461,
                                    initialLongitude: profileData
                                            .barberShopLocation
                                            .coordinates
                                            .isNotEmpty
                                        ? profileData
                                            .barberShopLocation.coordinates[0]
                                        : 34.8516,
                                    onLocationSelected: (lat, lng, address) {
                                      setState(() {});
                                    },
                                  );
                                }));
                              },
                              child: _buildInfoRow(
                                  AssetsData.mapPinIcon, city, location,
                                  isAddress: true),
                            ),
                            SizedBox(height: 8.h),
                            InkWell(
                              onTap: () {
                                // Handle phone number tap if needed
                                launchPhoneDialer(profileData.phoneNumber);
                              },
                              child: _buildInfoRow(
                                  AssetsData.callIcon,
                                  "\u200E${profileData.phoneNumber.replaceFirst('+972', '+972  ')}",
                                  location),
                            ),
                            SizedBox(height: 8.h),
                            InkWell(
                              onTap: () {
                                // Handle Instagram tap if needed
                                try {
                                  launch(profileData.instagramPage);
                                } catch (e) {
                                  print('Could not launch Instagram: $e');
                                  // s(context, "Invalid Instagram link".tr);
                                }
                              },
                              child: _buildInfoRow(AssetsData.instagramIcon,
                                  instagramPage, location),
                            ),
                            SizedBox(height: 16.h),
                            CustomBigButton(
                              color: const Color(0xA6C59D4E),
                              textData: "workingDays".tr,
                              onPressed: () {
                                showBWorkingDaysBottomSheet(
                                    context, profileData.workingDays);
                              },
                            ),
                            SizedBox(height: 12.h),
                            CustomBigButton(
                              textData: "Edit Profile".tr,
                              onPressed: () async {
                                final result = await Get.toNamed(
                                  AppRouter.beditProfilePath,
                                  arguments: BarberProfileModel(
                                    fullName: profileData.fullName,
                                    offDay: profileData.offDay,
                                    barberShop: profileData.barberShop,
                                    bankAccountNumber:
                                        profileData.bankAccountNumber,
                                    instagramPage: profileData.instagramPage,
                                    profilePic: profileData.profilePic,
                                    coverPic: profileData.coverPic,
                                    city: profileData.city,
                                    workingDays: profileData.workingDays,
                                    barberShopLocation:
                                        profileData.barberShopLocation,
                                    phoneNumber: profileData.phoneNumber,
                                  ),
                                );

                                if (result == true) {
                                  // Profile was updated, refresh the data
                                  controller.fetchProfileData();
                                }
                              },
                            ),
                            SizedBox(height: 24.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildTabButton(
                                    "My service".tr, _tabController.index == 0),
                                _buildTabButton(
                                    "My gallery".tr, _tabController.index == 1),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            SizedBox(
                              height: 400.h,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  // Services Tab
                                  _buildServicesTab(),

                                  // Gallery Tab
                                  _buildGalleryTab(),
                                ],
                              ),
                            ),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  // New method to build services tab with API data
  Widget _buildServicesTab() {
    bool isClicked = true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${"services".tr} (${controller.totalServices})",
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 16.h),
        Obx(() {
          if (controller.isServicesLoading.value) {
            return const Center(
              child: SpinKitDoubleBounce(color: ColorsData.primary),
            );
          }

          if (controller.barberServices.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50.h),
                Text(
                  'No services available'.tr,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () {
                    if (isClicked) {
                      isClicked = false;
                      setState(() {});
                      controller.fetchBarberServices();
                      Future.delayed(const Duration(seconds: 2), () {
                        isClicked = true;
                        setState(() {});
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsData.primary,
                  ),
                  child: Text('Refresh'.tr),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.only(bottom: 24.h), // يرفع الزرار لفوق
                  child: CustomBigButton(
                    textData: "Add new service".tr,
                    onPressed: () {
                      showCustomAddNewServiceBottomSheet(context);
                    },
                  ),
                ),
              ],
            );
          }

          // When there are services, show them in a scrollable list
          return Expanded(
            child: Column(
              children: [
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      if (notification is OverscrollNotification) {
                        // ده بيخلي السحب يروح للـParent لما توصل لأول أو آخر الليست
                        return true;
                      }
                      return false;
                    },
                    child: ListView.separated(
                      shrinkWrap: true,
                      // مش AlwaysScrollable
                      itemCount: controller.barberServices.length,
                      padding: EdgeInsets.zero,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 8.h),
                      itemBuilder: (context, index) {
                        final service = controller.barberServices[index];
                        return _buildServiceItemFromData(service);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                // Add the button at the bottom, outside the ListView
                CustomBigButton(
                  textData: "Add new service".tr,
                  onPressed: () {
                    showCustomAddNewServiceBottomSheet(context);
                  },
                ),

                const SizedBox(
                  height: 58,
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildServiceItemFromData(BarberService service) {
    bool isClicked = true;
    String durationText;
    if (service.duration != null) {
      if (service.duration! > 60000) {
        durationText = "${(service.duration! / 60000).round()} min";
      } else {
        durationText = "${service.duration} min";
      }
    } else {
      int avgTime = ((service.minTime + service.maxTime) / 2).round();
      if (avgTime > 60000) {
        durationText = "${(avgTime / 60000).round()} min";
      } else {
        durationText = "$avgTime min";
      }
    }

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF494B5B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.r),
              child: CachedNetworkImage(
                imageUrl: service.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Image.asset(AssetsData.goldScissorImage),
                errorWidget: (context, url, error) =>
                    Image.asset(AssetsData.goldScissorImage),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              service.name,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "\$${service.price}",
                style: Styles.textStyleS16W500(
                  color: ColorsData.bodyFont,
                ),
              ),
              Text(
                durationText,
                style: Styles.textStyleS10W400(
                  color: ColorsData.bodyFont,
                ),
              ),
            ],
          ),
          SizedBox(width: 12.w),
          ElevatedButton(
            onPressed: () async {
              if (isClicked) {
                isClicked = false;
                setState(() {});
                showCustomEditNewServiceBottomSheet(
                  context,
                  serviceId: service.id,
                  serviceName: service.name,
                  servicePrice: service.price.toString(),
                  serviceTime: service.duration?.toString() ??
                      ((service.minTime + service.maxTime) / 2)
                          .round()
                          .toString(),
                );
                await Future.delayed(const Duration(seconds: 2), () {
                  isClicked = true;
                  setState(() {});
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB08B4F),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              minimumSize: Size.zero,
            ),
            child: Text(
              "Edit".tr,
              style: TextStyle(fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String svgIconPath, String text, BarberLocation location,
      {bool isAddress = false}) {
    return Row(
      children: [
        SvgPicture.asset(
          height: 18.h,
          width: 18.w,
          svgIconPath,
          colorFilter: const ColorFilter.mode(
            ColorsData.primary,
            BlendMode.srcIn,
          ),
        ),
        SizedBox(width: 8.w),
        if (!isAddress)
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        if (isAddress)
          FutureBuilder(
            future: location.getAddress(Get.locale?.languageCode ?? "en"),
            builder: (context, loc) {
              return Expanded(
                child: Text(
                  loc.data ?? text,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildTabButton(String text, bool isActive) {
    return GestureDetector(
      onTap: () {
        _tabController.animateTo(text == "My service".tr ? 0 : 1);
      },
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16.sp,
              color: isActive ? ColorsData.primary : Colors.white,
            ),
          ),
          if (isActive)
            Container(
              height: 2,
              width: 60.w,
              color: ColorsData.primary,
              margin: EdgeInsets.only(top: 4.h),
            ),
        ],
      ),
    );
  }

  Widget _buildGalleryTab() {
    bool isClicked = true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() => Text(
                  "${"Gallery".tr} (${controller.galleryPhotos.length})",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            Container(
              height: 28.h,
              decoration: BoxDecoration(
                border: Border.all(color: ColorsData.primary, width: 1.w),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Obx(() => TextButton.icon(
                    onPressed: controller.isUploadingPhotos.value
                        ? null
                        : () async {
                            controller.addPhotosToGallery();
                          },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(2.w),
                    ),
                    icon: controller.isUploadingPhotos.value
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: const SpinKitDoubleBounce(
                              color: ColorsData.primary,
                            ),
                          )
                        : SvgPicture.asset(
                            AssetsData.addImageIcon,
                            height: 20.h,
                            width: 20.w,
                            colorFilter: const ColorFilter.mode(
                              ColorsData.cardStrock,
                              BlendMode.srcIn,
                            ),
                          ),
                    label: Text(
                      controller.isUploadingPhotos.value
                          ? "Uploading...".tr
                          : "add photos".tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.sp,
                      ),
                    ),
                  )),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: Obx(() {
            if (controller.isGalleryLoading.value) {
              return const Center(
                child: SpinKitDoubleBounce(color: ColorsData.primary),
              );
            }

            if (controller.galleryPhotos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No photos available'.tr,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton.icon(
                      icon: Icon(Icons.add_photo_alternate),
                      label: Text('Add Photos'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsData.primary,
                      ),
                      onPressed: () async {
                        controller.addPhotosToGallery();

                        // controller.addPhotosToGallery;
                      },
                    ),
                  ],
                ),
              );
            }

            // When there are photos, show them in a grid
            return RefreshIndicator(
              onRefresh: controller.fetchGallery,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.h,
                ),
                itemCount: controller.galleryPhotos.length,
                itemBuilder: (context, index) {
                  final photo = controller.galleryPhotos[index];
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        AppRouter.imageViewPath,
                        arguments: photo,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: ColorsData.secondary,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Flexible(
                          child: CachedNetworkImage(
                            imageUrl: photo,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Container(
                              color: ColorsData.primary,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: ColorsData.secondary,
                              ),
                              child: const Icon(
                                Icons.error,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  void launchPhoneDialer(String phoneNumber) {
    //launch phone dialer with the given phone number
    try {
      launch("tel:$phoneNumber");
    } catch (e) {
      print('Could not launch phone dialer: $e');
    }
  }
}
