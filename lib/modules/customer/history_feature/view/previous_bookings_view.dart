import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/app_router.dart';
import 'package:q_cut/modules/customer/features/home_features/home/models/barber_model.dart';
import '../model/customer_history_appointment.dart';
import 'package:q_cut/modules/customer/features/home/presentation/views/widgets/custom_booking_again_item.dart';

class PreviousBookingsView extends StatelessWidget {
  final RxList<CustomerHistoryAppointment> appointments;

  const PreviousBookingsView({
    super.key,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => appointments.isEmpty
          ? Center(child: Text('No previous appointments'.tr))
          : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) => CustomBookingAgainItem(
                appointment: appointments[index],
                onBookingAgain: () {
                  // Handle booking again
                  Get.toNamed(
                    AppRouter.selectedPath,
                    arguments: Barber(
                      id: appointments[index].barber.id,
                      fullName: appointments[index].barber.fullName,
                      phoneNumber: "",
                      userType: appointments[index].barber.userType,
                      city: "",
                      isFavorite: true,
                      status: appointments[index].status,
                      offDay: [],
                      workingDays: [],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
