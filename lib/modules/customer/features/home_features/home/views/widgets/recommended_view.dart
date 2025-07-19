import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/core/utils/widgets/custom_app_bar.dart';
import 'package:q_cut/modules/auth/views/widgets/custom_text_form.dart';
import 'package:q_cut/modules/customer/features/home_features/home/logic/home_controller.dart';
import 'package:q_cut/modules/customer/features/home_features/home/views/custom_recommended_result_list_view_item.dart';

class RecommendedView extends StatefulWidget {
  const RecommendedView({super.key});

  @override
  State<RecommendedView> createState() => _RecommendedViewState();
}

class _RecommendedViewState extends State<RecommendedView> {
  final TextEditingController _searchController = TextEditingController();
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<HomeController>();
    // Initialize with existing value if any
    _searchController.text = controller.searchBarberController.text;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Receive the barbers data passed from NearbySalonsSection
    final barbers = Get.arguments ?? [];

    return SafeArea(
        child: Scaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomAppBar(title: 'nearbySalons'.tr),
                  SizedBox(height: 10.h),
                  CustomTextFormField(
                    controller: _searchController,
                    style: Styles.textStyleS14W400(color: ColorsData.dark),
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'searchBarber'.tr,
                    fillColor: ColorsData.font,
                    onChanged: (value) {
                      controller.searchBarbers(value);
                    },
                    suffixIcon: Obx(() => controller.isSearching.value &&
                            _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              controller.searchBarbers('');
                            },
                          )
                        : const SizedBox.shrink()),
                  ),
                  SizedBox(height: 12.h),
                  const Divider(color: ColorsData.cardStrock),
                  SizedBox(height: 12.h),
                  Obx(() => Text(
                        controller.isSearching.value
                            ? "searchResults".tr
                            : "selectFromRecommended".tr,
                        style: Styles.textStyleS14W400(),
                      )),
                  SizedBox(height: 6.h),
                ],
              ),
            ),
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            // Display search results if searching, otherwise show barbers passed from arguments
            final displayedBarbers = controller.isSearching.value
                ? controller.searchResults
                : barbers;

            // Display no results message if searching with no results
            if (controller.isSearching.value &&
                displayedBarbers.isEmpty &&
                !controller.isLoading.value) {
              return SliverFillRemaining(
                child: Center(
                  child: Text(
                    "noSalonsFound".tr,
                    style: Styles.textStyleS16W500(),
                  ),
                ),
              );
            }

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                  child:
                      CustomBarberShopWideCard(barber: displayedBarbers[index]),
                ),
                childCount: displayedBarbers.length,
              ),
            );
          }),
        ],
      ),
    ));
  }
}
