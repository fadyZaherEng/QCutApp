import 'dart:convert';

class CustomerProfileResponse {
  final CustomerProfileData data;

  CustomerProfileResponse({
    required this.data,
  });

  factory CustomerProfileResponse.fromJson(Map<String, dynamic> json) {
    return CustomerProfileResponse(
      data: CustomerProfileData.fromJson(json['data']),
    );
  }
}

class CustomerProfileData {
  final OtpData otp;
  final String id;
  final String fullName;
  final String phoneNumber;
  final int createdAt;
  final bool isDeleted;
  final bool verified;
  final String city;
  final String updatedAt;
  final int v;
  final String? coverPic;
  final String? profilePic;
  final List<String> favorites;
  final List<String> favoritePhotos;
  final String? fcmToken;
  final int? hashtag;

  CustomerProfileData({
    required this.otp,
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.createdAt,
    required this.isDeleted,
    required this.verified,
    required this.city,
    required this.updatedAt,
    required this.v,
    this.coverPic,
    this.profilePic,
    required this.favorites,
    required this.favoritePhotos,
    this.fcmToken,
    this.hashtag,
  });

  factory CustomerProfileData.fromJson(Map<String, dynamic> json) {
    return CustomerProfileData(
      otp: OtpData.fromJson(json['otp']),
      id: json['_id'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      createdAt: json['createdAt'],
      isDeleted: json['isDeleted'] ?? false,
      verified: json['verified'],
      city: json['city'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      coverPic: json['coverPic'],
      profilePic: json['profilePic'],
      favorites: List<String>.from(json['favorites'] ?? []),
      favoritePhotos: List<String>.from(json['favoritePhotos'] ?? []),
      fcmToken: json['fcmToken'],
      hashtag: json['hashtag'],
    );
  }
}

class OtpData {
  final String code;
  final int expireTime;

  OtpData({
    required this.code,
    required this.expireTime,
  });

  factory OtpData.fromJson(Map<String, dynamic> json) {
    return OtpData(
      code: json['code'],
      expireTime: json['expireTime'],
    );
  }
}

class FavoriteBarber {
  final String barberId;
  final String barberShop;
  final String? profilePic;
  final String? coverPic;
  final String city;
  final List<dynamic> barberShopLocation;
  final String id;

  FavoriteBarber({
    required this.barberId,
    required this.barberShop,
    this.profilePic,
    this.coverPic,
    required this.city,
    required this.barberShopLocation,
    required this.id,
  });

  factory FavoriteBarber.fromJson(Map<String, dynamic> json) {
    return FavoriteBarber(
      barberId: json['barberId'],
      barberShop: json['barberShop'],
      profilePic: json['profilePic'],
      coverPic: json['coverPic'],
      city: json['city'],
      barberShopLocation: json['barberShopLocation'],
      id: json['_id'],
    );
  }
}
