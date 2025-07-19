class AvailableTimeModel {
  final String slot;

  AvailableTimeModel({required this.slot});

  factory AvailableTimeModel.fromJson(Map<String, dynamic> json) {
    return AvailableTimeModel(
      slot: json['slot'] ?? '',
    );
  }
}

class AvailableTimesResponse {
  final List<AvailableTimeModel> availableTimes;

  AvailableTimesResponse({required this.availableTimes});

  factory AvailableTimesResponse.fromJson(Map<String, dynamic> json) {
    return AvailableTimesResponse(
      availableTimes: (json['availableTimes'] as List)
          .map((slot) => AvailableTimeModel.fromJson(slot))
          .toList(),
    );
  }
}
