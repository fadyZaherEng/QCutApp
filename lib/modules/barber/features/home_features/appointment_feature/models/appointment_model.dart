import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class BarberAppointmentResponse {
  final List<BarberAppointment> appointments;

  BarberAppointmentResponse({required this.appointments});

  factory BarberAppointmentResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> appointmentsData = json['data'] ?? [];
    return BarberAppointmentResponse(
      appointments: appointmentsData
          .map((item) => BarberAppointment.fromJson(item))
          .toList(),
    );
  }
}

class BarberAppointment {
  final String id;
  final BarberInfo barber; // ✅ Barber Info بدل String
  final UserInfo user;
  final List<ServiceItem> services;
  final double price;
  final int duration;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final String paymentMethod;
  final String formattedDate;
  final String formattedTime;

  BarberAppointment({
    required this.id,
    required this.barber,
    required this.user,
    required this.services,
    required this.price,
    required this.duration,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.paymentMethod,
    required this.formattedDate,
    required this.formattedTime,
  });

  factory BarberAppointment.fromJson(Map<String, dynamic> json) {
    // ✅ Parse barber info as object
    BarberInfo barberInfo;
    if (json['barber'] != null && json['barber'] is Map) {
      barberInfo =
          BarberInfo.fromJson(Map<String, dynamic>.from(json['barber']));
    } else {
      barberInfo = BarberInfo.empty();
    }

    // ✅ Handle the nested user object
    UserInfo userInfo;
    if (json['user'] != null && json['user'] is Map) {
      userInfo = UserInfo.fromJson(json['user']);
    } else {
      userInfo = UserInfo(
        id: '',
        fullName: json['userName'] ?? 'Unknown',
        profilePic: '',
      );
    }

    // ✅ Handle the service array
    List<ServiceItem> serviceItems = [];
    if (json['service'] != null && json['service'] is List) {
      serviceItems = (json['service'] as List)
          .map((item) => ServiceItem.fromJson(item))
          .toList();
    }

    // ✅ Parse dates safely
    DateTime startDate;
    try {
      startDate = DateTime.fromMillisecondsSinceEpoch(
          json['startDate'] is int ? json['startDate'] : 0);
    } catch (_) {
      startDate = DateTime.now();
    }

    DateTime endDate;
    try {
      endDate = DateTime.fromMillisecondsSinceEpoch(
          json['endDate'] is int ? json['endDate'] : 0);
    } catch (_) {
      endDate = DateTime.now().add(Duration(minutes: json['duration'] ?? 0));
    }

    final formattedDate = DateFormat('yyyy-MM-dd').format(startDate);
    final formattedTime = DateFormat('h:mm').format(startDate);

    return BarberAppointment(
      id: json['_id'] ?? '',
      barber: barberInfo,
      user: userInfo,
      services: serviceItems,
      price: (json['price'] ?? 0).toDouble(),
      duration: json['duration'] ?? 0,
      status: json['status'] ?? 'pending',
      startDate: startDate,
      endDate: endDate,
      paymentMethod: json['paymentMethod'] ?? 'unknown',
      formattedDate: formattedDate,
      formattedTime: formattedTime,
    );
  }
}

class BarberInfo {
  final String id;
  final String fullName;
  final String userType;
  final BarberLocation? location;
  final String barberShop;

  BarberInfo({
    required this.id,
    required this.fullName,
    required this.userType,
    required this.location,
    required this.barberShop,
  });

  factory BarberInfo.fromJson(Map<String, dynamic> json) {
    return BarberInfo(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      userType: json['userType'] ?? '',
      location: json['barberShopLocation'] != null &&
              json['barberShopLocation'] is Map
          ? BarberLocation.fromJson(json['barberShopLocation'])
          : null,
      barberShop: json['barberShop'] ?? '',
    );
  }

  factory BarberInfo.empty() {
    return BarberInfo(
      id: '',
      fullName: '',
      userType: '',
      location: null,
      barberShop: '',
    );
  }
}


class BarberLocation {
  final String type;
  final List<double> coordinates;
  final String address;

  BarberLocation({
    required this.type,
    required this.coordinates,
    this.address = '',
  });

  factory BarberLocation.fromJson(Map<String, dynamic> json) {
    final coords = (json['coordinates'] as List)
        .map((c) => (c as num).toDouble())
        .toList();

    return BarberLocation(
      type: json['type'] ?? '',
      coordinates: coords,
      address: json['address'] ?? '',
    );
  }

  /// دالة Async تجيب العنوان الصحيح
  Future<String> getAddress() async {
    if (address.isNotEmpty) return address;

    if (coordinates.length != 2) return 'Address not available';

    final latitude = coordinates[1];
    final longitude = coordinates[0];

    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
        ].where((e) => e != null && e.isNotEmpty).join(', ');
      } else {
        return 'Address not available';
      }
    } catch (e) {
      print("❌ Error getting address: $e");
      return 'Address not available';
    }
  }
}

class UserInfo {
  final String id;
  final String fullName;
  final String profilePic;

  UserInfo({
    required this.id,
    required this.fullName,
    required this.profilePic,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? 'Unknown',
      profilePic: json['profilePic'] ?? '',
    );
  }
}

class ServiceItem {
  final Service service;
  final int numberOfUsers;
  final double price;
  final String id;

  ServiceItem({
    required this.service,
    required this.numberOfUsers,
    required this.price,
    required this.id,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      service: json['service'] is Map
          ? Service.fromJson(json['service'])
          : Service(id: '', name: 'Unknown', imageUrl: ''),
      numberOfUsers: json['numberOfUsers'] ?? 1,
      price: (json['price'] ?? 0).toDouble(),
      id: json['_id'] ?? '',
    );
  }
}

class Service {
  final String id;
  final String name;
  final String imageUrl;

  Service({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
