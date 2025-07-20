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
import 'package:q_cut/modules/customer/features/home_features/home/views/widgets/custom_home_app_bar.dart';
import 'package:q_cut/modules/customer/features/home_features/home/views/widgets/nearby_salons_section.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize HomeController when the view is built
    final homeController = Get.put(HomeController());

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
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.only(top: 9.h, left: 16.w),
                            height: 40.h,
                            decoration: BoxDecoration(
                                color: ColorsData.font,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "whatIsCity".tr,
                                style: Styles.textStyleS14W400(
                                    color: ColorsData.cardStrock),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16.w,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(AppRouter.searchForTheTimePath);
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 9.h, left: 16.w),
                            height: 40.h,
                            decoration: BoxDecoration(
                                color: ColorsData.font,
                                borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "when".tr,
                                style: Styles.textStyleS14W400(
                                    color: ColorsData.cardStrock),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  const Divider(
                    color: ColorsData.cardStrock,
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  const NearbySalonsSection(),
                  SizedBox(
                    height: 12.h,
                  ),
                  // const RecommendedSalonsSection(),
                  // SizedBox(
                  //   height: 23.h,
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
