class BookingPaymentModel {
  final String serviceTitle;
  final double servicePrice;
  final double totalAmount;
  bool isCashPayment;
  bool isCreditPayment;

  BookingPaymentModel({
    required this.serviceTitle,
    required this.servicePrice,
    required this.totalAmount,
    this.isCashPayment = true,
    this.isCreditPayment = false,
  });

  void toggleCashPayment() {
    isCashPayment = !isCashPayment;
    if (isCashPayment) {
      isCreditPayment = false;
    }
  }

  void toggleCreditPayment() {
    isCreditPayment = !isCreditPayment;
    if (isCreditPayment) {
      isCashPayment = false;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'serviceTitle': serviceTitle,
      'servicePrice': servicePrice,
      'totalAmount': totalAmount,
      'paymentMethod': isCashPayment ? 'cash' : 'credit',
    };
  }
}
