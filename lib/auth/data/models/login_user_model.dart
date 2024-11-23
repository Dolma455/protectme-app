class LoginUserModel {
  final String email;
  final String password;

  LoginUserModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}
class LoginResponseModel {
  final String message;
  LoginResponseModel({
    required this.message,

  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message'] ?? '',
    );
  }
}


class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String? role;
  final double? latitude;
  final double? longitude;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.role,
    this.latitude,
    this.longitude,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      role: json['role'],
      latitude: json['latitude'] != null ? json['latitude'].toDouble() : null,
      longitude: json['longitude'] != null ? json['longitude'].toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'role': role,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class ProfileModel {
  final String message;
  final UserModel userDetails;

  ProfileModel({
    required this.message,
    required this.userDetails,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      message: json['message'] ?? '',
      userDetails: UserModel.fromJson(json['userDetails']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'userDetails': userDetails.toJson(),
    };
  }
}