import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/modules/customer/features/home/presentation/views/widgets/custom_drawer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/assets_data.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/modules/customer/features/home_features/home/logic/home_controller.dart';
import 'package:q_cut/modules/customer/features/home_features/home/models/barber_model.dart';
import 'package:q_cut/modules/customer/features/home_features/home/views/widgets/custom_home_app_bar.dart';
import 'package:q_cut/modules/customer/features/home_features/home/views/widgets/nearby_salons_section.dart';
import 'package:q_cut/modules/customer/features/home_features/profile_feature/logic/profile_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize HomeController when the view is built
    final homeController = Get.put(HomeController());
    final ProfileController profileController = Get.put(ProfileController());

    return SafeArea(
        child: Scaffold(
      drawer: CustomDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomHomeAppBar(),
                  SizedBox(
                    height: 12.h,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        AssetsData.mapPinIcon,
                        width: 24.w,
                        height: 24.h,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        profileController.profileData.value?.city ??
                            'yourLocation'.tr,
                        style: Styles.textStyleS12W400(),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      SvgPicture.asset(
                        AssetsData.downArrowIcon,
                        width: 24.w,
                        height: 24.h,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Text(
                    'startStylishJourney'.tr,
                    style: Styles.textStyleS16W700(color: ColorsData.primary),
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                   Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(AppRouter.citySelectionPath)?.then((value) {
                              if (value != null && value is String && value.isNotEmpty) {
                                homeController.getBarbersCity(city: value);
                              } else {
                                homeController.getBarbers();
                              }
                            });
                          },
                          child: Container(
                            height: 42.h,
                            decoration: BoxDecoration(
                              color: ColorsData.font,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              "where".tr,
                              style: Styles.textStyleS14W400(color: ColorsData.cardStrock),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(AppRouter.searchForTheTimePath);
                          },
                          child: Container(
                            height: 42.h, // ✅ same as "where"
                            decoration: BoxDecoration(
                              color: ColorsData.font,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              "when".tr,
                              style: Styles.textStyleS14W400(color: ColorsData.cardStrock),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12.h),
                  const NearbySalonsSection(),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

}
