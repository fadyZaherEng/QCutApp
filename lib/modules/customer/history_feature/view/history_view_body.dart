import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/modules/customer/history_feature/model/customer_history_appointment.dart';
 import 'previous_bookings_view.dart';
import 'currently_booked_view.dart';

class HistoryViewBody extends StatelessWidget {
  final RxList<CustomerHistoryAppointment> previousAppointments;
  final RxList<CustomerHistoryAppointment> currentAppointments;

  const HistoryViewBody({
    super.key,
    required this.previousAppointments,
    required this.currentAppointments,
  });


  @override
  Widget build(BuildContext context) {

    return TabBarView(
       children: [
        PreviousBookingsView(appointments: previousAppointments),
        CurrentlyBookedView(appointments: currentAppointments),
      ],
    );
  }
}
