class TimeSlot {
  final int? id;
  final String dayName;
  final int dayNumber;
  final DateTime startTime;
  final DateTime endTime;
  final String formattedDate;

  TimeSlot({
    this.id,
    required this.dayName,
    required this.dayNumber,
    required this.startTime,
    required this.endTime,
    required this.formattedDate,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    DateTime startTime;
    DateTime endTime;

    if (json.containsKey('startInterval')) {
      // Handle numeric timestamp
      startTime = DateTime.fromMillisecondsSinceEpoch(json['startInterval']);
      endTime = DateTime.fromMillisecondsSinceEpoch(json['endInterval']);
    } else {
      // Default handling (for unexpected data)
      startTime = DateTime.now();
      endTime = DateTime.now().add(const Duration(hours: 1));
    }

    return TimeSlot(
      id: json['id'] ?? 0,
      dayName: json['dayName'] ?? '',
      dayNumber: json['dayNumber'] ?? startTime.day,
      startTime: startTime,
      endTime: endTime,
      formattedDate: json['formattedDate'] ?? '',
    );
  }
}
