class BarberStats {
  final int totalAppointments;
  final double totalIncome;
  final int workingHours;
  final int newConsumers;
  final int returningConsumers;
  final double notComeTotal;

  BarberStats({
    required this.totalAppointments,
    required this.totalIncome,
    required this.workingHours,
    required this.newConsumers,
    required this.returningConsumers,
    required this.notComeTotal,
  });

  factory BarberStats.fromJson(Map<String, dynamic> json) {
    return BarberStats(
      totalAppointments: json['totalAppointments'] ?? 0,
      totalIncome: (json['totalIncome'] ?? 0).toDouble(),
      workingHours: json['workingHours'] ?? 0,
      newConsumers: json['newConsumers'] ?? 0,
      returningConsumers: json['returningConsumers'] ?? 0,
      notComeTotal: (json['notComeTotal'] ?? 0).toDouble(),
    );
  }

  factory BarberStats.empty() {
    return BarberStats(
      totalAppointments: 0,
      totalIncome: 0,
      workingHours: 0,
      newConsumers: 0,
      returningConsumers: 0,
      notComeTotal: 0,
    );
  }
}
