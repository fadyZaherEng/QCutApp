class SignUpResponse {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String userType;
  final String status;
  final bool verified;

  SignUpResponse({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.userType,
    required this.status,
    required this.verified,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      id: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      userType: json['userType'] ?? '',
      status: json['status'] ?? '',
      verified: json['verified'] ?? false,
    );
  }
}

class UserOffer {
  final String title;
  final int dealDateStart;
  final int dealDateEnd;
  final int qCuteSubscription;
  final int qCuteTax;
  final int freeDaysNumber;
  final String status;

  UserOffer({
    required this.title,
    required this.dealDateStart,
    required this.dealDateEnd,
    required this.qCuteSubscription,
    required this.qCuteTax,
    required this.freeDaysNumber,
    required this.status,
  });

  factory UserOffer.fromJson(Map<String, dynamic> json) {
    return UserOffer(
      title: json['title'] ?? '',
      dealDateStart: json['dealDateStart'] ?? 0,
      dealDateEnd: json['dealDateEnd'] ?? 0,
      qCuteSubscription: json['QCuteSubscription'] ?? 0,
      qCuteTax: json['QCuteTax'] ?? 0,
      freeDaysNumber: json['freeDaysNumber'] ?? 0,
      status: json['status'] ?? '',
    );
  }
}

class LoginResponse {
  final String accessToken;
  final String id;
  final UserOffer? userOffer;
  final String fullName;
  final String phoneNumber;
  final String userType;
  final String profilePic;
  final String coverPic;
  final String barberShop;

  LoginResponse({
    required this.accessToken,
    required this.id,
    this.userOffer,
    required this.fullName,
    required this.phoneNumber,
    required this.userType,
    required this.profilePic,
    required this.coverPic,
    this.barberShop = '',
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'] ?? '',
      id: json['_id'] ?? '',
      userOffer: json['userOffer'] != null
          ? UserOffer.fromJson(json['userOffer'])
          : null,
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      userType: json['userType'] ?? '',
      profilePic: json['profilePic'] ?? '',
      coverPic: json['coverPic'] ?? '',
      barberShop: json['barberShop'] ?? '',
    );
  }
}
