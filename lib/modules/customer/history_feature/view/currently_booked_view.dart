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
    return Obx(() => appointments.isEmpty
        ? Center(
            child: Text(
              'No current appointments'.tr,
              style: TextStyle(fontSize: 16),
            ),
          )
        : ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index];
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
          ));
  }
}
