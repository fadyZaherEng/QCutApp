import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/core/utils/styles.dart';
import 'package:q_cut/modules/customer/features/home_features/home/logic/home_controller.dart';
import 'package:q_cut/modules/customer/features/home_features/home/views/widgets/custom_barber_list_view.dart';

class RecommendedSalonsSection extends StatelessWidget {
  const RecommendedSalonsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Column(
      children: [
        Row(
          children: [
            Text(
              'recommended'.tr,
              style: Styles.textStyleS16W700(),
            ),
            Obx(() => Text(
                  '${controller.recommendedBarbers.length} ${'results'.tr}',
                  style: Styles.textStyleS14W400(color: ColorsData.primary),
                )),
            const Spacer(),
            InkWell(
              onTap: () {
                Get.toNamed(
                  AppRouter.recommendedPath,
                  arguments: controller.recommendedBarbers,
                );
              },
              child: Text(
                'seeAll'.tr,
                style: Styles.textStyleS14W400(),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 12.h,
        ),
        const CustomBarberListView(isRecommended: true),
      ],
    );
  }
}
