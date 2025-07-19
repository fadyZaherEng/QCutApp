class BarberService {
  final String id;
  final String name;
  final String imageUrl;
  final int price;
  final int minTime;
  final int maxTime;
  final int? duration;
  final String barber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  BarberService({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.minTime,
    required this.maxTime,
    this.duration,
    required this.barber,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory BarberService.fromJson(Map<String, dynamic> json) {
    return BarberService(
      id: json['_id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      price: json['price'],
      minTime: json['minTime'],
      maxTime: json['maxTime'],
      duration: json['duration'],
      barber: json['barber'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'minTime': minTime,
      'maxTime': maxTime,
      'duration': duration,
      'barber': barber,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}

class BarberServicesResponse {
  final bool success;
  final String message;
  final List<BarberService> data;

  BarberServicesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BarberServicesResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'] ?? [];
    List<BarberService> services = dataList
        .map((serviceJson) => BarberService.fromJson(serviceJson))
        .toList();

    return BarberServicesResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? '',
      data: services,
    );
  }
}
