import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/constants/colors_data.dart';
import 'package:q_cut/modules/customer/features/home_features/home/views/widgets/custom_barber_list_view_item.dart';
import 'package:q_cut/modules/customer/features/home_features/home/logic/home_controller.dart';
import 'package:q_cut/modules/customer/features/home_features/home/models/barber_model.dart';

class CustomBarberListView extends StatelessWidget {
  final List<Barber>? barbers;
  final bool isRecommended;

  const CustomBarberListView({
    super.key,
    this.barbers,
    this.isRecommended = false,
  });

  static const int itemsPerRow = 5;

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final displayBarbers = barbers ??
        (isRecommended
            ? controller.recommendedBarbers
            : controller.nearbyBarbers);

    return SizedBox(
      height: 281 * 3.h,
      child: Obx(() {
        if (controller.isLoading.value) {
          return SpinKitDoubleBounce(color: ColorsData.primary);
        }

        if (displayBarbers.isEmpty) {
          if (controller.isLoading.value) {
            return SpinKitDoubleBounce(color: ColorsData.primary);
          }

          return Text(
            "No barbers available".tr,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          );
        }

        final totalItems = displayBarbers.length;
        final numberOfRows = (totalItems / itemsPerRow).ceil();

        return Column(
          children: List.generate(numberOfRows, (rowIndex) {
            final startIdx = rowIndex * itemsPerRow;
            final endIdx =
            (startIdx + itemsPerRow > totalItems) ? totalItems : startIdx + itemsPerRow;

            final rowItems = displayBarbers.sublist(startIdx, endIdx);

            return SizedBox(
              height: 300.h,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, colIndex) {
                  final barber = rowItems[colIndex];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    child: CustomBarberListViewItem(barber: barber),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
                itemCount: rowItems.length,
              ),
            );
          }),
        );
      }),
    );
  }
}
