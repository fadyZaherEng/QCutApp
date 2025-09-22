import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/modules/customer/features/home_features/home/logic/home_controller.dart';
import 'package:q_cut/modules/customer/features/home_features/home/views/widgets/custom_barber_list_view.dart';

class NearbySalonsSection extends StatelessWidget {
  final bool isSearching;

  const NearbySalonsSection({
    super.key,
    this.isSearching = false,
  });

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return CustomBarberListView(
      isRecommended: false,
      isSearching: isSearching,
    );
  }
}
