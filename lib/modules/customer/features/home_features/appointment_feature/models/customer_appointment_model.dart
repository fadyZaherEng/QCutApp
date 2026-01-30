class CustomerAppointmentResponse {
  final List<CustomerAppointment> appointments;

  CustomerAppointmentResponse({required this.appointments});

  factory CustomerAppointmentResponse.fromJson(Map<String, dynamic> json) {
    var appointmentsData = json['data'];
    List<CustomerAppointment> appointmentsList = [];

    if (appointmentsData is List) {
      appointmentsList = appointmentsData
          .map((item) => CustomerAppointment.fromJson(item))
          .toList();
    }

    return CustomerAppointmentResponse(appointments: appointmentsList);
  }
}

class CustomerAppointment {
  final String id;
  final BarberInfo barber;
  final String user;
  final String userName;
  final List<ServiceInfo> services;
  final double price;
  final int duration;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final String paymentMethod;

  CustomerAppointment({
    required this.id,
    required this.barber,
    required this.user,
    required this.userName,
    required this.services,
    required this.price,
    required this.duration,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.paymentMethod,
  });

  factory CustomerAppointment.fromJson(Map<String, dynamic> json) {
    var serviceList = (json['service'] as List)
        .map((item) => ServiceInfo.fromJson(item))
        .toList();

    return CustomerAppointment(
      id: json['_id'],
      barber: BarberInfo.fromJson(json['barber']),
      user: (json['user'] is Map) ? json['user']['_id'] : json['user'],
      userName: json['userName'],
      services: serviceList,
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : json['price'],
      duration: json['duration'],
      status: json['status'],
      startDate: _parseDate(json['startDate']),
      endDate: _parseDate(json['endDate']),
      createdAt: _parseDate(json['createdAt']),
      paymentMethod: json['paymentMethod'],
    );
  }

  static DateTime _parseDate(dynamic dateValue) {
    if (dateValue is int) {
      // Handle milliseconds timestamp
      return DateTime.fromMillisecondsSinceEpoch(
          dateValue > 9999999999 ? dateValue : dateValue * 1000);
    } else if (dateValue is String) {
      return DateTime.parse(dateValue);
    }
    return DateTime.now();
  }

  String get formattedDate {
    return '${startDate.day}/${startDate.month}/${startDate.year}';
  }

  String get formattedTime {
    final start =
        '${startDate.hour}:${startDate.minute.toString().padLeft(2, '0')}';
    final end = '${endDate.hour}:${endDate.minute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }

  String get totalConsumers {
    int total = 0;
    for (var service in services) {
      total += service.numberOfUsers;
    }
    return '$total consumer${total > 1 ? 's' : ''}';
  }

  String get serviceName {
    return services.isNotEmpty ? services.first.serviceName : "N/A";
  }
}

class BarberInfo {
  final String id;
  final String fullName;
  final String userType;
  final String city;
  final String? barberShop;
  final List<double>? locationCoordinates;

  BarberInfo({
    required this.id,
    required this.fullName,
    required this.userType,
    required this.city,
    this.barberShop,
    this.locationCoordinates,
  });

  factory BarberInfo.fromJson(Map<String, dynamic> json) {
    List<double>? coords;
    // Check if location info exists and handle both Map and List cases
    if (json['barberShopLocation'] != null) {
      if (json['barberShopLocation'] is Map &&
          json['barberShopLocation']['coordinates'] != null) {
        coords = List<double>.from(json['barberShopLocation']['coordinates']
            .map((x) => (x as num).toDouble()));
      } else if (json['barberShopLocation'] is List &&
          json['barberShopLocation'].isNotEmpty) {
        // Assuming if it's a list, the first item is the location object
        var loc = json['barberShopLocation'][0];
        if (loc is Map && loc['coordinates'] != null) {
          coords = List<double>.from(
              loc['coordinates'].map((x) => (x as num).toDouble()));
        }
      }
    }

    return BarberInfo(
      id: json['_id'],
      fullName: json['fullName'],
      userType: json['userType'],
      city: json['city'] ?? "",
      barberShop: json['barberShop'],
      locationCoordinates: coords,
    );
  }
}

class ServiceInfo {
  final String serviceId;
  final int numberOfUsers;
  final double price;
  final String serviceName;

  ServiceInfo({
    required this.serviceId,
    required this.numberOfUsers,
    required this.price,
    this.serviceName =
        "Hair style", // Default value since API doesn't provide service name
  });

  factory ServiceInfo.fromJson(Map<String, dynamic> json) {
    return ServiceInfo(
      serviceId: json['service'],
      numberOfUsers: json['numberOfUsers'],
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : json['price'],
    );
  }
  //to json
  Map<String, dynamic> toJson() {
    return {
      'service': serviceId,
      'numberOfUsers': numberOfUsers,
      'price': price,
      // 'serviceName': serviceName, // Not included as API doesn't require it
    };
  }
}
