class WorkingHoursRangeResponse {
  final String barberId;
  final List<WalkInRecord> walkIn;
  final List<WorkingHourDay> workingHoursRange;

  WorkingHoursRangeResponse({
    required this.barberId,
    required this.walkIn,
    required this.workingHoursRange,
  });

  factory WorkingHoursRangeResponse.fromJson(Map<String, dynamic> json) {
    return WorkingHoursRangeResponse(
      barberId: json['barberId'] ?? '',
      walkIn: json['walkIn'] != null
          ? List<WalkInRecord>.from(
              json['walkIn'].map((x) => WalkInRecord.fromJson(x)))
          : [],
      workingHoursRange: json['workingHoursRange'] != null
          ? List<WorkingHourDay>.from(
              json['workingHoursRange'].map((x) => WorkingHourDay.fromJson(x)))
          : [],
    );
  }
}

class WalkInRecord {
  final int startDate;
  final int endDate;
  final String id;

  WalkInRecord({
    required this.startDate,
    required this.endDate,
    required this.id,
  });

  factory WalkInRecord.fromJson(Map<String, dynamic> json) {
    return WalkInRecord(
      startDate: json['startDate'] ?? 0,
      endDate: json['endDate'] ?? 0,
      id: json['_id'] ?? '',
    );
  }

  // Get formatted date range
  String get formattedRange {
    final start = DateTime.fromMillisecondsSinceEpoch(startDate);
    final end = DateTime.fromMillisecondsSinceEpoch(endDate);
    return '${start.day}/${start.month}/${start.year} - ${end.day}/${end.month}/${end.year}';
  }
}

class WorkingHourDay {
  final int date;
  final String formattedDate;
  final String dayName;
  final bool isOffDay;
  final bool isWalkIn;
  final int startHour;
  final int endHour;

  WorkingHourDay({
    required this.date,
    required this.formattedDate,
    required this.dayName,
    required this.isOffDay,
    required this.isWalkIn,
    required this.startHour,
    required this.endHour,
  });

  factory WorkingHourDay.fromJson(Map<String, dynamic> json) {
    return WorkingHourDay(
      date: json['date'] ?? 0,
      formattedDate: json['formattedDate'] ?? '',
      dayName: json['dayName'] ?? '',
      isOffDay: json['isOffDay'] ?? false,
      isWalkIn: json['isWalkIn'] ?? false,
      startHour: json['startHour'] ?? 0,
      endHour: json['endHour'] ?? 0,
    );
  }

  // Get DateTime object from timestamp
  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(date);

  // Get formatted working hours
  String get workingHours => '$startHour:00 - $endHour:00';
}
