import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final List<Barber> displayBarbers = barbers ??
        (isRecommended
            ? controller.recommendedBarbers
            : controller.nearbyBarbers);

    return SizedBox(
      height: 281 * 3.h,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          // Determine how many rows we need
          int totalItems = displayBarbers.isEmpty ? 9 : displayBarbers.length;
          int itemsPerRow = 5;
          int numberOfRows = (totalItems / itemsPerRow).ceil();

          return Column(
            children: List.generate(numberOfRows, (rowIndex) {
              // Calculate start and end indices for each row
              final startIdx = rowIndex * itemsPerRow;
              final endIdx = (startIdx + itemsPerRow) > totalItems
                  ? totalItems
                  : startIdx + itemsPerRow;

              return SizedBox(
                height: 300.h,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, colIndex) {
                    final itemIndex = startIdx + colIndex;
                    return Container(
                      padding: EdgeInsets.symmetric(vertical: 3.h),
                      child: CustomBarberListViewItem(
                        barber: displayBarbers.length > itemIndex
                            ? displayBarbers[itemIndex]
                            : null,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(width: 8.w),
                  itemCount: displayBarbers.isEmpty
                      ? itemsPerRow
                      : (endIdx - startIdx),
                ),
              );
            }),
          );
        }
      }),
    );
  }
}
