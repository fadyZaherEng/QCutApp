class UserModel {
  final String fullName;
  final String phoneNumber;
  final String password;
  final String city;

  UserModel({
    required this.fullName,
    required this.phoneNumber,
    required this.password,
    required this.city,
  });

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'password': password,
      'city': city,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      password: json['password'] ?? '',
      city: json['city'] ?? '',
    );
  }
}
