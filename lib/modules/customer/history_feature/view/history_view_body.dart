import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/history_controller.dart';
import 'previous_bookings_view.dart';
import 'currently_booked_view.dart';

class HistoryViewBody extends StatelessWidget {
  const HistoryViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HistoryController>();

    return TabBarView(
      children: [
        PreviousBookingsView(appointments: controller.previousAppointments),
        CurrentlyBookedView(appointments: controller.currentAppointments),
      ],
    );
  }
}
