class PaymentStats {
  final int cashPayments;
  final int visaPayments;
  final double cashPercentage;
  final double visaPercentage;

  PaymentStats({
    required this.cashPayments,
    required this.visaPayments,
    required this.cashPercentage,
    required this.visaPercentage,
  });

  factory PaymentStats.fromJson(Map<String, dynamic> json) {
    return PaymentStats(
      cashPayments: json['cashPayments'] ?? 0,
      visaPayments: json['visaPayments'] ?? 0,
      cashPercentage: (json['cashPercentage'] ?? 0).toDouble(),
      visaPercentage: (json['visaPercentage'] ?? 0).toDouble(),
    );
  }

  factory PaymentStats.empty() {
    return PaymentStats(
      cashPayments: 0,
      visaPayments: 0,
      cashPercentage: 0,
      visaPercentage: 0,
    );
  }

  int get totalPayments => cashPayments + visaPayments;
}
