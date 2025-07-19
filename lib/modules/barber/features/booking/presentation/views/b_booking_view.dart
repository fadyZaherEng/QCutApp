import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/widgets/custom_app_bar.dart';
import 'package:q_cut/modules/barber/features/booking/presentation/views/widgets/b_booking_view_body.dart';

class BBookingView extends StatelessWidget {
  const BBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "barberServices".tr),
      body: const BBookingViewBody(),
    );
  }
}
