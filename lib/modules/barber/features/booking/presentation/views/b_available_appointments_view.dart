import 'package:flutter/material.dart';
import 'package:q_cut/core/utils/widgets/custom_arrow_left.dart';
import 'package:q_cut/modules/barber/features/booking/presentation/views/widgets/b_available_appointments_view_body.dart';

class BAvailableAppointmentsView extends StatelessWidget {
  const BAvailableAppointmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const CustomArrowLeft()),
      body: const BAvailableAppointmentsViewBody(),
    );
  }
}
