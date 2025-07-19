import 'package:q_cut/modules/customer/features/booking_features/select_appointment_time/model/time_slot_model.dart';

class BookingPaymentDetailsModel {
  final String serviceTitle;
  final double servicePrice;
  final double totalAmount;
  bool isCashPayment;

  // Appointment details
  final String barberName;
  final String barberImage;
  final String salonName;
  final String appointmentDate;
  final String  appointmentTime;
  final String serviceDuration;

  BookingPaymentDetailsModel({
    required this.serviceTitle,
    required this.servicePrice,
    required this.totalAmount,
    this.isCashPayment = true,
    required this.barberName,
    required this.barberImage,
    required this.salonName,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.serviceDuration,
  });

  void toggleCashPayment() {
    isCashPayment = !isCashPayment;
  }
}
