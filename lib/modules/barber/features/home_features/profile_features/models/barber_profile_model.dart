import '../profile_display/models/barber_profile_model.dart';

class BarberProfileModel {
  final String fullName;
  final List<String> offDay;
  final String barberShop;
  final String bankAccountNumber;
  final String instagramPage;
  final String profilePic;
  final String coverPic;
  final String city;
  final List<WorkingDay> workingDays;

  BarberProfileModel({
    required this.fullName,
    required this.offDay,
    required this.barberShop,
    required this.bankAccountNumber,
    required this.instagramPage,
    required this.profilePic,
    required this.coverPic,
    required this.city,
    required this.workingDays,
  });

  factory BarberProfileModel.fromJson(Map<String, dynamic> json) {
    return BarberProfileModel(
      fullName: json['fullName'] ?? '',
      offDay: List<String>.from(json['offDay'] ?? []),
      barberShop: json['barberShop'] ?? '',
      bankAccountNumber: json['bankAccountNumber'] ?? '',
      instagramPage: json['instagramPage'] ?? '',
      profilePic: json['profilePic'] ?? '',
      coverPic: json['coverPic'] ?? '',
      city: json['city'] ?? '',
      workingDays: (json['workingDays'] as List<dynamic>?)
              ?.map((e) => WorkingDay.fromJson(e))
              .toList() ??
          [],
    );
  }
}
