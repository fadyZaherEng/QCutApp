import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:q_cut/core/utils/widgets/custom_app_bar.dart';
import 'package:q_cut/modules/customer/features/bookingAndPayment/view/views/widgets/book_appointment_with_payment_methods_view_body.dart';

class BookAppointmentWithPaymentMethodsView extends StatelessWidget {
  const BookAppointmentWithPaymentMethodsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "bookAppointment".tr),
      body: const BookAppointmentWithPaymentMethodsViewBody(),
    );
  }
}
