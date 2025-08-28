import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/modules/customer/features/home/presentation/views/widgets/show_delete_appointment_dialog.dart';
import 'package:q_cut/modules/customer/history_feature/view/custom_history_delete.dart';
import '../model/customer_history_appointment.dart';

class CurrentlyBookedView extends StatelessWidget {
  final RxList<CustomerHistoryAppointment> appointments;

  const CurrentlyBookedView({
    super.key,
    required this.appointments,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // 🔥 filter only pending appointments
      final pendingAppointments = appointments
          .where((appointment) => appointment.status.toLowerCase() == "pending")
          .toList();

      if (pendingAppointments.isEmpty) {
        return Center(
          child: Text(
            'No current appointments'.tr,
            style: const TextStyle(fontSize: 16),
          ),
        );
      }

      return ListView.builder(
        itemCount: pendingAppointments.length,
        itemBuilder: (context, index) {
          final appointment = pendingAppointments[index];
          return CustomHistoryDelete(
            appointment: appointment,
            onDelete: () {
              showDeleteAppointmentDialog(
                context: context,
                onYes: () {
                  Navigator.pop(context);
                },
                onNo: () {
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      );
    });
  }
}
