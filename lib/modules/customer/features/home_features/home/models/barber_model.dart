import 'package:q_cut/modules/barber/features/home_features/profile_features/profile_display/models/barber_profile_model.dart';

class BarbersResponse {
  final int page;
  final int limit;
  final int totalBarbers;
  final int totalPages;
  final List<Barber> barbers;

  BarbersResponse({
    required this.page,
    required this.limit,
    required this.totalBarbers,
    required this.totalPages,
    required this.barbers,
  });

  factory BarbersResponse.fromJson(Map<String, dynamic> json) {
    return BarbersResponse(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalBarbers: json['totalBarbers'] ?? 0,
      totalPages: json['totalPages'] ?? 1,
      barbers: List<Barber>.from(
          (json['barbers'] ?? []).map((x) => Barber.fromJson(x))),
    );
  }
}

class Barber {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String userType;
  final String city;
  final String status;
  final String? barberShop;
  final String? profilePic;
  final String? coverPic;
  final String? instagramPage;
  final List<String> offDay;
  final List<WorkingDay> workingDays;
  bool isFavorite;

  Barber({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.userType,
    required this.city,
    required this.isFavorite,
    required this.status,
    this.barberShop,
    this.profilePic,
    this.coverPic,
    this.instagramPage,
    required this.offDay,
    required this.workingDays,
  });

  factory Barber.fromJson(Map<String, dynamic> json) {
    return Barber(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      userType: json['userType'] ?? '', // may not exist
      city: json['city'] ?? '',
      status: json['status'] ?? '',
      barberShop: json['barberShop'], // keep nullable
      profilePic: json['profilePic'],
      coverPic: json['coverPic'],
      instagramPage: json['instagramPage'],
      isFavorite: json['isFavorite'] ?? false,
      offDay: (json['offDay'] is List)
          ? List<String>.from(json['offDay'])
          : <String>[],
      workingDays: (json['workingDays'] is List)
          ? List<WorkingDay>.from(
              json['workingDays'].map((x) => WorkingDay.fromJson(x)))
          : <WorkingDay>[],
    );
  }
}
