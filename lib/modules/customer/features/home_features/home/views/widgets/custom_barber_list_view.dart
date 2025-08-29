
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

  CustomBarberListView({
    super.key,
    this.barbers,
    this.isRecommended = false,
  });
  List<Barber> displayBarbers = [];
  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    displayBarbers = barbers ??
        (isRecommended
            ? controller.recommendedBarbers
            : controller.nearbyBarbers);

    return SizedBox(
      height: 281 * 3.h,
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: SpinKitDoubleBounce(
            color: ColorsData.primary,
          ));
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
  // void arrangeBarbersByLocation(String selectedCity, double userLat, double userLng) {
  //   final cityBarbers = <Barber>[];
  //   final nearbyBarbers = <Barber>[];
  //
  //   for (var barber in displayBarbers) {
  //     if (barber.city?.toLowerCase() == selectedCity.toLowerCase()) {
  //       cityBarbers.add(barber);
  //     } else {
  //       // calculate distance
  //       final distance = _calculateDistance(
  //         userLat, userLng,
  //         barber.latitude, barber.longitude,
  //       );
  //       if (distance <= 4.0) {
  //         nearbyBarbers.add(barber);
  //       }
  //     }
  //   }
  //
  //   // shuffle city barbers for randomness
  //   cityBarbers.shuffle();
  //
  //   // merge lists
  //   barbers.value = [...cityBarbers, ...nearbyBarbers];
  // }
  // double _calculateDistance(
  //     double lat1, double lon1, double lat2, double lon2) {
  //   const R = 6371; // Earth radius km
  //   final dLat = (lat2 - lat1) * (3.141592653589793 / 180.0);
  //   final dLon = (lon2 - lon1) * (3.141592653589793 / 180.0);
  //
  //   final a =
  //       (sin(dLat / 2) * sin(dLat / 2)) +
  //           (cos(lat1 * (3.141592653589793 / 180.0)) *
  //               cos(lat2 * (3.141592653589793 / 180.0)) *
  //               sin(dLon / 2) * sin(dLon / 2));
  //   final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  //   return R * c;
  // }
  // Stage 3 – Integrate After City Selection
  //
  // When customer picks city in HomeView:
  //
  // Get.toNamed(AppRouter.citySelectionPath)?.then((value) {
  // if (value != null && value is String && value.isNotEmpty) {
  // // fetch all barbers first
  // homeController.getBarbers().then((_) {
  // final userLat = profileController.profileData.value?.latitude ?? 0;
  // final userLng = profileController.profileData.value?.longitude ?? 0;
  // homeController.arrangeBarbersByLocation(value, userLat, userLng);
  // });
  // }
  // });
}
